globals
//globals from LeveledCuff:
constant boolean LIBRARY_LeveledCuff=true
integer array LeveledCuff__cuffList
integer LeveledCuff__listMax= 0
        // The current position in the list
integer LeveledCuff__listPointer= 0
//endglobals from LeveledCuff
//globals from SimpleCuff:
constant boolean LIBRARY_SimpleCuff=true
integer array SimpleCuff__cuffList
integer SimpleCuff__listMax= 0
        // The current position in the list
integer SimpleCuff__listPointer= 0
//endglobals from SimpleCuff
//globals from Cuff:
constant boolean LIBRARY_Cuff=true
        // Length of a frame
constant real Cuff__loopInterval= 0.03
        // The maximum number of iterations per frame
constant integer Cuff__maxLoop= 4
//endglobals from Cuff
    // User-defined
boolean udg_DEBUG= false

    // Generated
trigger gg_trg_Cuff= null
trigger gg_trg_SimpleCuff= null
trigger gg_trg_ComplexCuff= null
trigger gg_trg_LevledCuff= null

trigger l__library_init

//JASSHelper struct globals:
constant integer si__LeveledCuff=1
integer si__LeveledCuff_F=0
integer si__LeveledCuff_I=0
integer array si__LeveledCuff_V
integer array s___LeveledCuff_cuffBuff
constant integer s___LeveledCuff_cuffBuff_size=3
integer array s__LeveledCuff_cuffBuff
integer array s___LeveledCuff_cuffAbility
constant integer s___LeveledCuff_cuffAbility_size=3
integer array s__LeveledCuff_cuffAbility
constant integer si__SimpleCuff=4
integer si__SimpleCuff_F=0
integer si__SimpleCuff_I=0
integer array si__SimpleCuff_V
integer array s__SimpleCuff_cuffBuff
integer array s__SimpleCuff_cuffAbility

endglobals


//Generated allocator of LeveledCuff
function s__LeveledCuff__allocate takes nothing returns integer
 local integer this=si__LeveledCuff_F
    if (this!=0) then
        set si__LeveledCuff_F=si__LeveledCuff_V[this]
    else
        set si__LeveledCuff_I=si__LeveledCuff_I+1
        set this=si__LeveledCuff_I
    endif
    if (this>2729) then
        return 0
    endif
    set s__LeveledCuff_cuffBuff[this]=(this-1)*3
    set s__LeveledCuff_cuffAbility[this]=(this-1)*3
    set si__LeveledCuff_V[this]=-1
 return this
endfunction

//Generated destructor of LeveledCuff
function s__LeveledCuff_deallocate takes integer this returns nothing
    if this==null then
        return
    elseif (si__LeveledCuff_V[this]!=-1) then
        return
    endif
    set si__LeveledCuff_V[this]=si__LeveledCuff_F
    set si__LeveledCuff_F=this
endfunction

//Generated allocator of SimpleCuff
function s__SimpleCuff__allocate takes nothing returns integer
 local integer this=si__SimpleCuff_F
    if (this!=0) then
        set si__SimpleCuff_F=si__SimpleCuff_V[this]
    else
        set si__SimpleCuff_I=si__SimpleCuff_I+1
        set this=si__SimpleCuff_I
    endif
    if (this>8190) then
        return 0
    endif

    set si__SimpleCuff_V[this]=-1
 return this
endfunction

//Generated destructor of SimpleCuff
function s__SimpleCuff_deallocate takes integer this returns nothing
    if this==null then
        return
    elseif (si__SimpleCuff_V[this]!=-1) then
        return
    endif
    set si__SimpleCuff_V[this]=si__SimpleCuff_F
    set si__SimpleCuff_F=this
endfunction

//library LeveledCuff:

    
        // 8192 / 3 = 2730

        function s__LeveledCuff_create takes integer ab1,integer ab2,integer ab3,integer buf1,integer buf2,integer buf3 returns integer
            local integer s= s__LeveledCuff__allocate()
            set s___LeveledCuff_cuffBuff[s__LeveledCuff_cuffBuff[s]]=buf3
            set s___LeveledCuff_cuffBuff[s__LeveledCuff_cuffBuff[s]+1]=buf1
            set s___LeveledCuff_cuffBuff[s__LeveledCuff_cuffBuff[s]+2]=buf2
            set s___LeveledCuff_cuffAbility[s__LeveledCuff_cuffAbility[s]]=ab3
            set s___LeveledCuff_cuffAbility[s__LeveledCuff_cuffAbility[s]+1]=ab1
            set s___LeveledCuff_cuffAbility[s__LeveledCuff_cuffAbility[s]+2]=ab2
            return s
        endfunction
    
    function iterateLeveledCuff takes group g returns boolean
        local unit u
        local integer currentCuff
        local integer iterator
        local boolean given
        set currentCuff=LeveledCuff__cuffList[LeveledCuff__listPointer]
        loop
            set u=FirstOfGroup(g)
            exitwhen u == null
            call GroupRemoveUnit(g, u)
            set iterator=2
            set given=false
            loop
                //call UnitRemoveAbility(u, currentCuff.cuffAbility[iterator])
                //if (not(given) and GetUnitAbilityLevel(u, currentCuff.cuffBuff[iterator]) > 0) then
                //    call UnitAddAbility(u, currentCuff.cuffAbility[iterator])
                //    set given = true
                //endif
                exitwhen iterator == 0
                set iterator=iterator - 1
            endloop
            set u=null
        endloop
        if ( LeveledCuff__listPointer < LeveledCuff__listMax ) then
            set LeveledCuff__listPointer=LeveledCuff__listPointer + 1
            return false
        else
            set LeveledCuff__listPointer=0
            return true
        endif
        return false
    endfunction
    
    function LeveledCuff_createLeveledCuff takes integer ab1,integer ab2,integer ab3,integer buf1,integer buf2,integer buf3 returns nothing
        local integer sc= s__LeveledCuff_create(ab1 , ab2 , ab3 , buf1 , buf2 , buf3)
        set LeveledCuff__cuffList[LeveledCuff__listMax]=sc
        set LeveledCuff__listMax=LeveledCuff__listMax + 1
    endfunction


//library LeveledCuff ends
//library SimpleCuff:

    

        function s__SimpleCuff_create takes integer ab,integer buf returns integer
            local integer s= s__SimpleCuff__allocate()
            set s__SimpleCuff_cuffBuff[s]=buf
            set s__SimpleCuff_cuffAbility[s]=ab
            return s
        endfunction
    
    function iterateSimpleCuff takes group g returns boolean
        local unit u
        local integer currentCuff
        set currentCuff=SimpleCuff__cuffList[SimpleCuff__listPointer]
        loop
            set u=FirstOfGroup(g)
            exitwhen u == null
            call GroupRemoveUnit(g, u)
            if ( GetUnitAbilityLevel(u, s__SimpleCuff_cuffBuff[currentCuff]) > 0 ) then
                call UnitAddAbility(u, s__SimpleCuff_cuffAbility[currentCuff])
            else
                call UnitRemoveAbility(u, s__SimpleCuff_cuffAbility[currentCuff])
            endif
            set u=null
        endloop
        if ( SimpleCuff__listPointer < SimpleCuff__listMax ) then
            set SimpleCuff__listPointer=SimpleCuff__listPointer + 1
            return false
        endif
        set SimpleCuff__listPointer=0
        return true
    endfunction
    
    function SimpleCuff_createSimpleCuff takes integer ab,integer buf returns nothing
        local integer sc= s__SimpleCuff_create(ab , buf)
        set SimpleCuff__cuffList[SimpleCuff__listMax]=sc
        set SimpleCuff__listMax=SimpleCuff__listMax + 1
    endfunction


//library SimpleCuff ends
//library Cuff:


    
    function Cuff__iterate takes nothing returns nothing
        local integer i= 0
        local group g
        loop
            set i=i + 1
            exitwhen i > Cuff__maxLoop
            set g=GetUnitsInRectAll(GetPlayableMapRect())

            // recreate unit group everytime or copy!
            // pick cuff, call iterate, switch cufftype on true
            call iterateLeveledCuff(g)

            call DestroyGroup(g)
            set g=null
        endloop
    endfunction
    
    function Cuff__initialize takes nothing returns nothing
        local trigger trig= CreateTrigger()
        call TriggerRegisterTimerEventPeriodic(trig, Cuff__loopInterval)
        call TriggerAddAction(trig, function Cuff__iterate)
    endfunction


//library Cuff ends
//===========================================================================
// 
// BaseMod
// 
//   Warcraft III map script
//   Generated by the Warcraft III World Editor
//   Date: Sun Oct 15 14:35:06 2017
//   Map Author: ForTheUnion
// 
//===========================================================================

//***************************************************************************
//*
//*  Global Variables
//*
//***************************************************************************


function InitGlobals takes nothing returns nothing
    set udg_DEBUG=false
endfunction

//***************************************************************************
//*
//*  Items
//*
//***************************************************************************

function CreateAllItems takes nothing returns nothing
    local integer itemID

    call CreateItem('I007', - 9030.0, - 11438.7)
    call CreateItem('desc', - 10057.6, - 9675.4)
    call CreateItem('desc', - 10163.5, - 9811.4)
    call CreateItem('desc', - 10064.5, - 9747.4)
    call CreateItem('desc', - 10157.6, - 9737.7)
    call CreateItem('desc', - 10154.6, - 9659.7)
    call CreateItem('desc', - 10061.1, - 9818.7)
endfunction

//***************************************************************************
//*
//*  Unit Creation
//*
//***************************************************************************

//===========================================================================
function CreateBuildingsForPlayer0 takes nothing returns nothing
    local player p= Player(0)
    local unit u
    local integer unitID
    local trigger t
    local real life

    set u=CreateUnit(p, 'n00L', - 10048.0, - 7488.0, 270.000)
    set u=CreateUnit(p, 'h00P', - 10048.0, - 7936.0, 270.000)
    set u=CreateUnit(p, 'o00D', - 9632.0, - 7520.0, 270.000)
    set u=CreateUnit(p, 'u002', - 9664.0, - 7936.0, 270.000)
    set u=CreateUnit(p, 'n00M', - 9312.0, - 7968.0, 270.000)
    set u=CreateUnit(p, 'n00O', - 9376.0, - 7456.0, 270.000)
    set u=CreateUnit(p, 'n00O', - 9376.0, - 7648.0, 270.000)
    set u=CreateUnit(p, 'n00O', - 9184.0, - 7648.0, 270.000)
    set u=CreateUnit(p, 'n00O', - 9184.0, - 7456.0, 270.000)
    set u=CreateUnit(p, 'n00O', - 8992.0, - 7456.0, 270.000)
    set u=CreateUnit(p, 'n00O', - 8992.0, - 7648.0, 270.000)
    set u=CreateUnit(p, 'n00O', - 8800.0, - 7456.0, 270.000)
    set u=CreateUnit(p, 'n00O', - 8800.0, - 7648.0, 270.000)
    set u=CreateUnit(p, 'n00O', - 8608.0, - 7456.0, 270.000)
    set u=CreateUnit(p, 'n00O', - 8608.0, - 7648.0, 270.000)
    set u=CreateUnit(p, 'n001', - 8448.0, - 7424.0, 270.000)
    set u=CreateUnit(p, 'n003', - 8960.0, - 7936.0, 270.000)
    set u=CreateUnit(p, 'n002', - 8576.0, - 7936.0, 270.000)
endfunction

//===========================================================================
function CreateUnitsForPlayer0 takes nothing returns nothing
    local player p= Player(0)
    local unit u
    local integer unitID
    local trigger t
    local real life

    set u=CreateUnit(p, 'nfsp', - 10090.3, - 9351.0, 37.170)
    call IssueImmediateOrder(u, "autodispelon")
    set u=CreateUnit(p, 'U00R', - 9072.4, - 8983.6, 270.000)
    call SetHeroLevel(u, 10, false)
    call SetUnitState(u, UNIT_STATE_MANA, 345)
    call SelectHeroSkill(u, 'A03R')
    call IssueImmediateOrder(u, "")
    call SelectHeroSkill(u, 'A053')
    call IssueImmediateOrder(u, "")
    call SelectHeroSkill(u, 'A055')
    call IssueImmediateOrder(u, "")
    call SelectHeroSkill(u, 'A056')
    call IssueImmediateOrder(u, "")
    set u=CreateUnit(p, 'N00T', - 9356.0, - 8947.9, 270.000)
    call SetHeroLevel(u, 10, false)
    call SetUnitState(u, UNIT_STATE_MANA, 360)
    set u=CreateUnit(p, 'o00K', - 9148.7, - 8784.1, 160.768)
    set u=CreateUnit(p, 'n00P', - 9908.0, - 8282.8, 94.397)
    set u=CreateUnit(p, 'n00Q', - 9789.6, - 8287.8, 133.510)
    set u=CreateUnit(p, 'o00E', - 9654.6, - 8304.9, 211.977)
    set u=CreateUnit(p, 'e003', - 9776.9, - 8206.9, 250.837)
    set u=CreateUnit(p, 'O008', - 8751.9, - 9046.7, 355.920)
    call SetHeroLevel(u, 10, false)
    call SelectHeroSkill(u, 'A016')
    call IssueImmediateOrder(u, "")
    call SelectHeroSkill(u, 'A017')
    call IssueImmediateOrder(u, "")
    call SelectHeroSkill(u, 'A018')
    call IssueImmediateOrder(u, "")
    call SelectHeroSkill(u, 'A05L')
    call IssueImmediateOrder(u, "")
    set u=CreateUnit(p, 'n004', - 8611.2, - 8316.6, 273.096)
    set u=CreateUnit(p, 'h00Q', - 9163.1, - 8299.4, 260.164)
    set u=CreateUnit(p, 'u004', - 8887.3, - 9679.5, 270.000)
    set u=CreateUnit(p, 'n007', - 8927.6, - 8271.9, 335.346)
    set u=CreateUnit(p, 'n005', - 8497.4, - 8273.8, 112.514)
    set u=CreateUnit(p, 'n006', - 8408.7, - 8305.1, 308.022)
    set u=CreateUnit(p, 'e004', - 8331.9, - 8307.5, 189.926)
    set u=CreateUnit(p, 'o00K', - 9010.1, - 8777.0, 350.420)
endfunction

//===========================================================================
function CreateBuildingsForPlayer1 takes nothing returns nothing
    local player p= Player(1)
    local unit u
    local integer unitID
    local trigger t
    local real life

    set u=CreateUnit(p, 'hhou', - 7680.0, - 14848.0, 270.000)
    set u=CreateUnit(p, 'hhou', - 7680.0, - 15104.0, 270.000)
    set u=CreateUnit(p, 'hgtw', - 7680.0, - 16320.0, 270.000)
    set u=CreateUnit(p, 'hhou', - 7680.0, - 14592.0, 270.000)
    set u=CreateUnit(p, 'hhou', - 7424.0, - 14848.0, 270.000)
    set u=CreateUnit(p, 'hhou', - 7936.0, - 14848.0, 270.000)
endfunction

//===========================================================================
function CreateUnitsForPlayer1 takes nothing returns nothing
    local player p= Player(1)
    local unit u
    local integer unitID
    local trigger t
    local real life

    set u=CreateUnit(p, 'hkni', - 10150.0, - 14569.3, 99.140)
    set u=CreateUnit(p, 'owyv', - 10403.0, - 17794.6, 111.174)
    set u=CreateUnit(p, 'hkni', - 10375.7, - 14678.2, 170.843)
    set u=CreateUnit(p, 'owyv', - 10371.4, - 18003.7, 163.910)
    set u=CreateUnit(p, 'hkni', - 10474.1, - 14931.2, 101.190)
    set life=GetUnitState(u, UNIT_STATE_LIFE)
    call SetUnitState(u, UNIT_STATE_LIFE, 0.50 * life)
    set u=CreateUnit(p, 'hgyr', - 7480.5, - 13039.5, 6.361)
    set u=CreateUnit(p, 'hgyr', - 7358.5, - 13179.9, 131.225)
    set u=CreateUnit(p, 'hgyr', - 7409.4, - 13396.4, 131.225)
    set u=CreateUnit(p, 'Hblm', - 7683.0, - 11775.8, 113.273)
    set u=CreateUnit(p, 'hgyr', - 7703.6, - 13240.7, 6.361)
    set u=CreateUnit(p, 'hgyr', - 7720.9, - 13457.7, 131.225)
    set u=CreateUnit(p, 'o002', - 10352.1, - 13268.9, 332.874)
    set u=CreateUnit(p, 'o002', - 10239.4, - 13419.4, 117.744)
    set u=CreateUnit(p, 'ospw', - 10225.5, - 16205.7, 41.035)
    call IssueImmediateOrder(u, "corporealform")
    set u=CreateUnit(p, 'ospw', - 10219.7, - 16419.8, 170.634)
    call IssueImmediateOrder(u, "corporealform")
    set u=CreateUnit(p, 'osw3', - 7364.4, - 12075.8, 330.292)
    set u=CreateUnit(p, 'osw3', - 7270.9, - 11878.1, 71.249)
    set u=CreateUnit(p, 'h00W', - 10039.7, - 11620.5, 270.000)
    set u=CreateUnit(p, 'h00W', - 10239.6, - 11620.2, 270.000)
    set u=CreateUnit(p, 'h00W', - 10448.5, - 11627.8, 270.000)
    set life=GetUnitState(u, UNIT_STATE_LIFE)
    call SetUnitState(u, UNIT_STATE_LIFE, 0.10 * life)
    set u=CreateUnit(p, 'h00W', - 9837.6, - 11620.5, 270.000)
    set u=CreateUnit(p, 'h00W', - 10038.1, - 11825.3, 270.000)
    set u=CreateUnit(p, 'h00W', - 10238.0, - 11825.0, 270.000)
    set u=CreateUnit(p, 'h00W', - 10446.9, - 11832.6, 270.000)
    set life=GetUnitState(u, UNIT_STATE_LIFE)
    call SetUnitState(u, UNIT_STATE_LIFE, 0.10 * life)
    set u=CreateUnit(p, 'h00W', - 9836.0, - 11825.3, 270.000)
    set u=CreateUnit(p, 'h00W', - 10035.5, - 12010.9, 270.000)
    set u=CreateUnit(p, 'h00W', - 10235.4, - 12010.7, 270.000)
    set u=CreateUnit(p, 'h00W', - 10444.3, - 12018.3, 270.000)
    set life=GetUnitState(u, UNIT_STATE_LIFE)
    call SetUnitState(u, UNIT_STATE_LIFE, 0.10 * life)
    set u=CreateUnit(p, 'h00W', - 9833.5, - 12010.9, 270.000)
    set u=CreateUnit(p, 'h00W', - 10026.0, - 12180.7, 270.000)
    set u=CreateUnit(p, 'h00W', - 10225.9, - 12180.4, 270.000)
    set u=CreateUnit(p, 'h00W', - 10434.8, - 12188.1, 270.000)
    set life=GetUnitState(u, UNIT_STATE_LIFE)
    call SetUnitState(u, UNIT_STATE_LIFE, 0.10 * life)
    set u=CreateUnit(p, 'h00W', - 9824.0, - 12180.7, 270.000)
endfunction

//===========================================================================
function CreateNeutralHostile takes nothing returns nothing
    local player p= Player(PLAYER_NEUTRAL_AGGRESSIVE)
    local unit u
    local integer unitID
    local trigger t
    local real life

    set u=CreateUnit(p, 'nmcf', - 7632.4, - 17860.5, 340.389)
    set u=CreateUnit(p, 'nmcf', - 7738.9, - 17940.9, 46.518)
    set u=CreateUnit(p, 'nmcf', - 7706.9, - 18026.8, 213.822)
    set u=CreateUnit(p, 'nmcf', - 7537.8, - 18008.8, 121.974)
    set u=CreateUnit(p, 'nmcf', - 7503.0, - 17933.0, 63.063)
endfunction

//===========================================================================
function CreateNeutralPassiveBuildings takes nothing returns nothing
    local player p= Player(PLAYER_NEUTRAL_PASSIVE)
    local unit u
    local integer unitID
    local trigger t
    local real life

    set u=CreateUnit(p, 'ntav', - 10048.0, - 8704.0, 270.000)
    call SetUnitColor(u, ConvertPlayerColor(0))
    set u=CreateUnit(p, 'nmrc', - 9984.0, - 9088.0, 270.000)
    call SetUnitColor(u, ConvertPlayerColor(1))
    set u=CreateUnit(p, 'ngol', - 1280.0, - 7936.0, 270.000)
    call SetResourceAmount(u, 12500)
    set u=CreateUnit(p, 'ngol', - 1280.0, - 9216.0, 270.000)
    call SetResourceAmount(u, 12500)
    set u=CreateUnit(p, 'ngol', - 1344.0, - 10560.0, 270.000)
    call SetResourceAmount(u, 12500)
endfunction

//===========================================================================
function CreateNeutralPassive takes nothing returns nothing
    local player p= Player(PLAYER_NEUTRAL_PASSIVE)
    local unit u
    local integer unitID
    local trigger t
    local real life

    set u=CreateUnit(p, 'nfro', - 10283.8, - 14984.7, 282.820)
    set u=CreateUnit(p, 'nfro', - 10198.7, - 14916.7, 282.820)
    set u=CreateUnit(p, 'nfro', - 10156.5, - 15024.1, 282.820)
endfunction

//===========================================================================
function CreatePlayerBuildings takes nothing returns nothing
    call CreateBuildingsForPlayer0()
    call CreateBuildingsForPlayer1()
endfunction

//===========================================================================
function CreatePlayerUnits takes nothing returns nothing
    call CreateUnitsForPlayer0()
    call CreateUnitsForPlayer1()
endfunction

//===========================================================================
function CreateAllUnits takes nothing returns nothing
    call CreateNeutralPassiveBuildings()
    call CreatePlayerBuildings()
    call CreateNeutralHostile()
    call CreateNeutralPassive()
    call CreatePlayerUnits()
endfunction

//***************************************************************************
//*
//*  Triggers
//*
//***************************************************************************

//===========================================================================
// Trigger: Cuff
//===========================================================================

    //TODO multiple cuffs in
// Simple Cuff
        // Max value seems to be 5, before you notice any performance impact
        // with 600 units on the field which is a realistic value even with 12 players
        // TODO adjust maxLoop per p

// Running Cuff
// Complex Cuff
// Condition Cuff//===========================================================================
// Trigger: SimpleCuff
//===========================================================================
// Trigger: LevledCuff
//===========================================================================
function InitCustomTriggers takes nothing returns nothing
    //Function not found: call InitTrig_Cuff()
    //Function not found: call InitTrig_SimpleCuff()
    //Function not found: call InitTrig_LevledCuff()
endfunction

//***************************************************************************
//*
//*  Players
//*
//***************************************************************************

function InitCustomPlayerSlots takes nothing returns nothing

    // Player 0
    call SetPlayerStartLocation(Player(0), 0)
    call SetPlayerColor(Player(0), ConvertPlayerColor(0))
    call SetPlayerRacePreference(Player(0), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(0), true)
    call SetPlayerController(Player(0), MAP_CONTROL_USER)

    // Player 1
    call SetPlayerStartLocation(Player(1), 1)
    call SetPlayerColor(Player(1), ConvertPlayerColor(1))
    call SetPlayerRacePreference(Player(1), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(1), true)
    call SetPlayerController(Player(1), MAP_CONTROL_USER)

    // Player 2
    call SetPlayerStartLocation(Player(2), 2)
    call SetPlayerColor(Player(2), ConvertPlayerColor(2))
    call SetPlayerRacePreference(Player(2), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(2), true)
    call SetPlayerController(Player(2), MAP_CONTROL_USER)

    // Player 3
    call SetPlayerStartLocation(Player(3), 3)
    call SetPlayerColor(Player(3), ConvertPlayerColor(3))
    call SetPlayerRacePreference(Player(3), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(3), true)
    call SetPlayerController(Player(3), MAP_CONTROL_USER)

    // Player 4
    call SetPlayerStartLocation(Player(4), 4)
    call SetPlayerColor(Player(4), ConvertPlayerColor(4))
    call SetPlayerRacePreference(Player(4), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(4), true)
    call SetPlayerController(Player(4), MAP_CONTROL_USER)

    // Player 5
    call SetPlayerStartLocation(Player(5), 5)
    call SetPlayerColor(Player(5), ConvertPlayerColor(5))
    call SetPlayerRacePreference(Player(5), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(5), true)
    call SetPlayerController(Player(5), MAP_CONTROL_USER)

    // Player 6
    call SetPlayerStartLocation(Player(6), 6)
    call SetPlayerColor(Player(6), ConvertPlayerColor(6))
    call SetPlayerRacePreference(Player(6), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(6), true)
    call SetPlayerController(Player(6), MAP_CONTROL_USER)

    // Player 7
    call SetPlayerStartLocation(Player(7), 7)
    call SetPlayerColor(Player(7), ConvertPlayerColor(7))
    call SetPlayerRacePreference(Player(7), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(7), true)
    call SetPlayerController(Player(7), MAP_CONTROL_USER)

endfunction

function InitCustomTeams takes nothing returns nothing
    // Force: TRIGSTR_009
    call SetPlayerTeam(Player(0), 0)
    call SetPlayerTeam(Player(1), 0)
    call SetPlayerTeam(Player(2), 0)
    call SetPlayerTeam(Player(3), 0)
    call SetPlayerTeam(Player(4), 0)
    call SetPlayerTeam(Player(5), 0)
    call SetPlayerTeam(Player(6), 0)
    call SetPlayerTeam(Player(7), 0)

endfunction

function InitAllyPriorities takes nothing returns nothing

    call SetStartLocPrioCount(0, 2)
    call SetStartLocPrio(0, 0, 6, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(0, 1, 7, MAP_LOC_PRIO_HIGH)

    call SetStartLocPrioCount(1, 2)
    call SetStartLocPrio(1, 0, 2, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(1, 1, 7, MAP_LOC_PRIO_HIGH)

    call SetStartLocPrioCount(2, 2)
    call SetStartLocPrio(2, 0, 1, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(2, 1, 3, MAP_LOC_PRIO_HIGH)

    call SetStartLocPrioCount(3, 2)
    call SetStartLocPrio(3, 0, 2, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(3, 1, 4, MAP_LOC_PRIO_HIGH)

    call SetStartLocPrioCount(4, 2)
    call SetStartLocPrio(4, 0, 3, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(4, 1, 5, MAP_LOC_PRIO_HIGH)

    call SetStartLocPrioCount(5, 2)
    call SetStartLocPrio(5, 0, 4, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(5, 1, 6, MAP_LOC_PRIO_HIGH)

    call SetStartLocPrioCount(6, 2)
    call SetStartLocPrio(6, 0, 0, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(6, 1, 5, MAP_LOC_PRIO_HIGH)

    call SetStartLocPrioCount(7, 2)
    call SetStartLocPrio(7, 0, 0, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(7, 1, 1, MAP_LOC_PRIO_HIGH)
endfunction

//***************************************************************************
//*
//*  Main Initialization
//*
//***************************************************************************

//===========================================================================
function main takes nothing returns nothing
    call SetCameraBounds(- 11008.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), - 19456.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), - 1024.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), - 7168.0 - GetCameraMargin(CAMERA_MARGIN_TOP), - 11008.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), - 7168.0 - GetCameraMargin(CAMERA_MARGIN_TOP), - 1024.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), - 19456.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
    call SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
    call NewSoundEnvironment("Default")
    call SetAmbientDaySound("SunkenRuinsDay")
    call SetAmbientNightSound("SunkenRuinsNight")
    call SetMapMusic("Music", true, 0)
    call CreateAllItems()
    call CreateAllUnits()
    call InitBlizzard()

call ExecuteFunc("jasshelper__initstructs98021125")
call ExecuteFunc("Cuff__initialize")

    set udg_DEBUG=false // INLINED!!
    call InitCustomTriggers()

endfunction

//***************************************************************************
//*
//*  Map Configuration
//*
//***************************************************************************

function config takes nothing returns nothing
    call SetMapName("TRIGSTR_010")
    call SetMapDescription("TRIGSTR_012")
    call SetPlayers(8)
    call SetTeams(8)
    call SetGamePlacement(MAP_PLACEMENT_TEAMS_TOGETHER)

    call DefineStartLocation(0, - 2048.0, - 8000.0)
    call DefineStartLocation(1, - 2048.0, - 9280.0)
    call DefineStartLocation(2, - 2112.0, - 10560.0)
    call DefineStartLocation(3, - 3008.0, - 8064.0)
    call DefineStartLocation(4, - 3136.0, - 8256.0)
    call DefineStartLocation(5, - 3264.0, - 7744.0)
    call DefineStartLocation(6, - 3328.0, - 7872.0)
    call DefineStartLocation(7, - 3264.0, - 8128.0)

    // Player setup
    call InitCustomPlayerSlots()
    call SetPlayerSlotAvailable(Player(0), MAP_CONTROL_USER)
    call SetPlayerSlotAvailable(Player(1), MAP_CONTROL_USER)
    call SetPlayerSlotAvailable(Player(2), MAP_CONTROL_USER)
    call SetPlayerSlotAvailable(Player(3), MAP_CONTROL_USER)
    call SetPlayerSlotAvailable(Player(4), MAP_CONTROL_USER)
    call SetPlayerSlotAvailable(Player(5), MAP_CONTROL_USER)
    call SetPlayerSlotAvailable(Player(6), MAP_CONTROL_USER)
    call SetPlayerSlotAvailable(Player(7), MAP_CONTROL_USER)
    call InitGenericPlayerSlots()
    call InitAllyPriorities()
endfunction




//Struct method generated initializers/callers:

function jasshelper__initstructs98021125 takes nothing returns nothing





endfunction

