local mod	= DBM:NewMod(193, "DBM-Firelands", nil, 78)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 6200 $"):sub(12, -3))
mod:SetCreatureID(52558)--or does 53772 die instead?didn't actually varify this fires right unit_died event yet so we'll see tonight
mod:SetModelID(38414)
mod:SetZone()
mod:SetUsedIcons()
mod:SetModelSound("Sound\\Creature\\RHYOLITH\\VO_FL_RHYOLITH_AGGRO.wav", "Sound\\Creature\\RHYOLITH\\VO_FL_RHYOLITH_KILL_02.wav")
--Long: Blah blah blah Nuisances, Nuisances :)
--Short: So Soft

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_SUMMON",
	"UNIT_HEALTH"
)

--[[
	Boss seems to have UNIT_POWER based on the direction he walks into -> InfoFrame worthy?
	Phase 2 starts @ 25%
	Flame Stomp CD in P2 = ~13secs?   (30secs in P1)
--]]

--local warnElementals		= mod:NewAnnounce("WarnElementals", 3)
local warnHeatedVolcano		= mod:NewSpellAnnounce(98493, 3)
local warnFlameStomp		= mod:NewSpellAnnounce(97282, 3, nil, mod:IsMelee())--According to journal only hits players within 20 yards of him, so melee by default?
local warnMoltenArmor		= mod:NewStackAnnounce(98255, 4, nil, mod:IsTank() or mod:IsHealer())	-- Would this be nice if we could show this in the infoFrame? (changed defaults to tanks/healers, if you aren't either it doesn't concern you unless you find shit to stand in)
local warnDrinkMagma		= mod:NewSpellAnnounce(98034, 4)	-- if you "kite" him to close to magma
local warnFragments			= mod:NewSpellAnnounce(98136, 2)
local warnShard				= mod:NewSpellAnnounce(98552, 3)
local warnMagmaFlow			= mod:NewSpellAnnounce(97225, 4)
local warnPhase2Soon		= mod:NewPrePhaseAnnounce(2, 2)
local warnPhase2			= mod:NewPhaseAnnounce(2, 3)

local specWarnMagmaFlow		= mod:NewSpecialWarningSpell(97225, nil, nil, nil, true)
local specWarnFlameStomp	= mod:NewSpecialWarningSpell(97282, false)

local timerElementals		= mod:NewTimer(22.5, "TimerElementals", 98552)
local timerHeatedVolcano	= mod:NewCDTimer(40, 98493)
local timerFlameStomp		= mod:NewNextTimer(30.5, 97282)
local timerSuperheated		= mod:NewNextTimer(10, 101305)--Add the 10 second party in later at some point if i remember to actually log it better
local timerMoltenSpew		= mod:NewNextTimer(6, 98034)	-- 6secs after Drinking Magma
local timerMagmaFlowActive	= mod:NewBuffActiveTimer(10, 97225)	-- 10 second buff volcano has, after which the magma line explodes.

local StompCountown			= mod:NewCountdown(30.5, 97282, false)

local spamAdds = 0
local phase = 1
local spamMoltenArmor = 0
local prewarnedPhase2 = false

function mod:OnCombatStart(delay)
	timerElementals:Start(21.5-delay)
	timerHeatedVolcano:Start(55-delay)
	timerFlameStomp:Start(28-delay)--Is this even right? i need a transcriptor log for fight
	StompCountown:Start(28-delay)--^^
	if self:IsDifficulty("heroic10", "heroic25") then
		timerSuperheated:Start(300-delay)--5 min on heroic
	else
		timerSuperheated:Start(360-delay)--6 min on normal
	end
	spamAdds = 0
	spamMoltenArmor = 0
	phase = 1
	prewarnedPhase2 = false
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(98255, 101157, 101158, 101159) and self:GetCIDFromGUID(args.destGUID) == 52558 and args.amount > 10 and GetTime() - spamMoltenArmor > 5 then
		warnMoltenArmor:Show(args.destName, args.amount)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(98632) and self:GetCIDFromGUID(args.destGUID) == 52558 then
		warnPhase2:Show()
		phase = 2
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(98034) then
		warnDrinkMagma:Show()
		timerMoltenSpew:Start()
	elseif args:IsSpellID(97282, 100411, 100968, 100969) then
		warnFlameStomp:Show()
		specWarnFlameStomp:Show()
		if phase == 1 then
			timerFlameStomp:Start()
			StompCountown:Start(30.5)
		else--13sec cd in phase 2
			timerFlameStomp:Start(13)
			StompCountown:Start(13)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(98493) then
		warnHeatedVolcano:Show()
		timerHeatedVolcano:Start()
	elseif args:IsSpellID(97225) then
		warnMagmaFlow:Show()
		specWarnMagmaFlow:Show()
		timerMagmaFlowActive:Start()
	end
end

function mod:SPELL_SUMMON(args)
	if args:IsSpellID(98136, 100392) and GetTime() - spamAdds > 5 then
		warnFragments:Show()
		timerElementals:Start()
		spamAdds = GetTime()
	elseif args:IsSpellID(98552) and GetTime() - spamAdds > 5 then
		warnShard:Show()
		timerElementals:Start()
		spamAdds = GetTime()
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 52558 then
		local h = UnitHealth(uId) / UnitHealthMax(uId) * 100
		if h > 35 and prewarnedPhase2 then
			prewarnedPhase2 = false
		elseif h > 28 and h < 22 and not prewarnedPhase2 then
			prewarnedPhase2 = true
			warnPhase2Soon:Show()
		end
	end
end