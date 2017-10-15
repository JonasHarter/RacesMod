//****************************************************************************
//*
//*  Cuff
//*     Applies all created Cuff Instances to all units
//*
//****************************************************************************
library Cuff initializer Init requires Debug PopGroup Dummy

    globals
        private constant real Tic = .03125//.03125
        // Holds all the Cuffs
        private Cuff array CuffArray
        private integer CuffArrayCount = 0
        // Tracks wether the Cuff has been applied
        private hashtable CuffTable = InitHashtable()
        private integer CuffTableID = 0
        // PseudoThreading, Limits the amount of cuffs worked per intervall
        private integer PTPointer = 0
        private integer PTPointerStore = 0
        private integer PTCounter = 0
        private constant integer PTLimit = 5
    endglobals
    

    // Cuff Interface **************************************************************
    
    interface Cuff
        // Stores the level off the Cuff under the UnitID
        method storeLevel takes integer k, integer value returns nothing
        method loadLevel takes integer k returns integer
        
        // Checks wether a unit satisfies its conditions
        // If both condition and buffs are in use, conditions will be interpreted as boolean
        method getLevel takes unit u returns integer
        
        public boolean useBuffs = true
        public boolean useCondition = false
        // Alternative condition.
        method condition takes unit target returns integer defaults 0
        
        // The timer functions
        method getTimer takes nothing returns real
        method tickTimer takes nothing returns nothing
        method resetTimer takes nothing returns nothing
        
        // Runs if the buff is new on the unit
        method apply takes unit target, integer level returns nothing defaults nothing
        // Runs each interval
        method running takes unit target, integer level returns nothing defaults nothing
        // Runs if the buff is gone
        method clean takes unit target, integer level returns nothing defaults nothing
    endinterface
    
    // Cuff Abstract **************************************************************
    
    struct CuffBase extends Cuff
    
        // The buffs the xBuff binds to. Ordered by level
        private integer array boundBuffs[5]        
        private integer boundBuffsCount = 0
        method addBuff takes integer buffid returns nothing
            set boundBuffs[boundBuffsCount] = buffid
            set boundBuffsCount = boundBuffsCount + 1
        endmethod
        
        //*****
        
        method getLevel takes unit u returns integer
            local integer condition = 0
            local integer buffs = 0
            local integer i = 0
            
            // Condition
            if( useCondition )then
                set condition = .condition(u)
            endif
            
            // Bound Buffs
            if( useBuffs )then
                loop
                    exitwhen( .boundBuffs[i] == 0 )
                    if( UnitHasBuffBJ( u, .boundBuffs[i]) ) then
                        set buffs = i + 1
                    endif
                    set i = i + 1
                endloop
            endif
            
            // Return the correct value
            if( not(useBuffs) )then
                return condition
            elseif( not(useCondition) )then
                return buffs
            elseif( useCondition and useBuffs and condition > 0 )then
                return buffs
            endif
            
            return 0
        endmethod
        
        // The Timer Functions
        
        private real timeSum = 0.0
        
        method getTimer takes nothing returns real
            return timeSum
        endmethod
       
        method tickTimer takes nothing returns nothing
            set timeSum = timeSum + Tic
        endmethod
        
        method resetTimer takes nothing returns nothing
            set timeSum = timeSum + 1.0
        endmethod
        
        //*****
        
        private integer hashID
        
        method storeLevel takes integer k, integer value returns nothing
            call SaveInteger(CuffTable, k, hashID, value)
        endmethod
        
        method loadLevel takes integer k returns integer
            return LoadInteger(CuffTable, k, hashID)
        endmethod
        
        // Registers the Cuff in the global array and assigns its ID for the hash
        private method register takes nothing returns nothing
            set CuffArray[CuffArrayCount] = this
            set CuffArrayCount = CuffArrayCount + 1
            set .hashID = CuffTableID
            set CuffTableID = CuffTableID + 1
        endmethod
        
        static method create takes nothing returns thistype
            local thistype s = thistype.allocate()
            call s.register()
            return s
        endmethod   
    
    endstruct
    
    // Worker Loop *****************************************************************
    
    // Applies the effects to the buffed units
    private function Loop takes nothing returns nothing
        local unit loopUnit
        local group allUnits = GetUnitsInRectAll(GetPlayableMapRect())
        // Cuff Loop
        local integer unitKey
        // The last detected level of the Cuff
        local integer lastLevel
        local Cuff c
        local integer CuffLevel
        
        // Unit Loop
        loop
            set loopUnit = PopFirst(allUnits)
            exitwhen (loopUnit == null)
            set PTPointer = PTPointerStore
            //NoDummyHack
            /*if(isDummy(loopUnit))then
                set PTCounter = PTLimit
            endif*/
            
            // Cuff Loop
            loop
                exitwhen(PTCounter >= PTLimit)
                
                // Ready vars
                set c = CuffArray[PTPointer]
                call c.tickTimer()
                set unitKey = GetHandleId(loopUnit)
                set lastLevel = c.loadLevel(unitKey)
                set CuffLevel = c.getLevel(loopUnit)
                // Update pointers
                //call DebugMessage(I2S(PTPointer))
                set PTCounter = PTCounter + 1
                set PTPointer = PTPointer + 1
                if(PTPointer == CuffArrayCount)then
                    set PTPointer = 0
                endif
                
                // HasBuff
                if( CuffLevel != 0) then
                    // Apply
                    if( lastLevel == 0 )then
                        call c.apply(loopUnit, CuffLevel)
                        call c.storeLevel(unitKey, CuffLevel)
                        break
                    // Reapply
                    elseif( lastLevel != CuffLevel ) then
                        call c.clean(loopUnit, lastLevel)
                        call c.storeLevel(unitKey, CuffLevel)
                        call c.apply(loopUnit, CuffLevel)
                        break
                    // Running
                    elseif( lastLevel > 0 ) then
                        // Only every second
                        if( c.getTimer() >= 1.0 )then
                            call c.running(loopUnit, CuffLevel)
                            call c.resetTimer()
                            break
                        endif
                    endif
                // Clean
                elseif( lastLevel > 0) then
                    call c.clean(loopUnit, lastLevel)
                    call c.storeLevel(unitKey, 0)
                    break
                endif
            endloop // Cuff Loop End
            
            set PTCounter = 0
            set loopUnit = null
        endloop // Unit Loop End
        set PTPointerStore = PTPointer
        
        call DestroyGroup(allUnits)
        set allUnits = null
    endfunction
    
    private function UnitDeath takes nothing returns nothing
        local unit u = GetDyingUnit()
        call FlushChildHashtable(CuffTable, GetHandleId(u))
        set u = null
    endfunction
    
    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        local trigger t2 = CreateTrigger()
        
        call TriggerRegisterTimerEventPeriodic( t, Tic )
        call TriggerAddAction( t, function Loop )
        
        call TriggerRegisterAnyUnitEventBJ( t2, EVENT_PLAYER_UNIT_DEATH )
        call TriggerAddAction( t2, function UnitDeath )
        
        set t = null
        set t2 = null
    endfunction
        
endlibrary