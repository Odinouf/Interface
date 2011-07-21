local mod	= DBM:NewMod(197, "DBM-Firelands", nil, 78)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 6200 $"):sub(12, -3))
mod:SetCreatureID(52571)
mod:SetModelID(37953)
mod:SetZone()
mod:SetUsedIcons(8)
mod:SetModelSound("Sound\\Creature\\FandralFlameDruid\\VO_FL_FANDRAL_GATE_INTRO_01.wav", "Sound\\Creature\\FandralFlameDruid\\VO_FL_FANDRAL_KILL_01.wav")
--Long: Well, well. I admire your tenacity. Baleroc stood guard over this keep for a thousand mortal lifetimes.
--Short: *Laughs, Burn

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS"
)

local warnAdrenaline		= mod:NewStackAnnounce(97238, 3)
local warnFury				= mod:NewStackAnnounce(97235, 3)
local warnLeapingFlames		= mod:NewTargetAnnounce(100208, 3)
local warnOrbs				= mod:NewCastAnnounce(98451, 4)

local timerSearingSeed		= mod:NewBuffActiveTimer(60, 98450)
local timerLeapingFlames	= mod:NewCDTimer(4, 100208)
local timerFlameScythe		= mod:NewCDTimer(4, 98474)

local yellLeapingFlames		= mod:NewYell(100208, nil, false)
local specWarnLeapingFlames	= mod:NewSpecialWarningMove(100208)
local specWarnSearingSeed	= mod:NewSpecialWarningMove(98450)

local soundSeed				= mod:NewSound(98450)

mod:AddBoolOption("RangeFrameSeeds", true)
mod:AddBoolOption("RangeFrameCat", false)--Diff options for each ability cause seeds strat is pretty universal, don't blow up raid, but leaps may or may not use a stack strategy, plus melee will never want it on by default.
mod:AddBoolOption("IconOnLeapingFlames", false)

local abilityCount = 0
local transforms = 0
--http://www.worldoflogs.com/reports/xesfs08iq6xdu6l9/xe/?s=6594&e=7052&x=spell+%3D+%22Flame+Scythe%22+and+fulltype+%3D+SPELL_CAST_SUCCESS+or+spellId+%3D+98476+and+fulltype+%3D+SPELL_CAST_SUCCESS+or+spell+%3D+%22Cat+Form%22+and+sourcereaction%3DREACTION_HOSTILE+or+spell+%3D+%22Scorpion+Form%22+and+sourcereaction%3DREACTION_HOSTILE
local abilityTimers = {
	[0] = 17.3,--Sometimes this is 16.7
	[1] = 13.4,--Sometimes this is 12.7 sigh. Wonder what causes this variation?
	[2] = 11,--One of the few you can count on being consistent.
	[3] = 8.6,--Really it's between 8.5 and 8.6
	[4] = 7.4,--Sometimes 8 instead of 7.3-7.4
	[5] = 7.4,--Varies from 7.3 or 7.4 as well
	[6] = 6.1,--Varies between 6 even and 6.1 even.
	[7] = 6.1,
	[8] = 4.9,
	[9] = 4.9,
	[10]= 4.9
}

function mod:LeapingFlamesTarget()
	local targetname = self:GetBossTarget(52571)
	if not targetname then return end
	warnLeapingFlames:Show(targetname)
	if self.Options.IconOnLeapingFlames then
		self:SetIcon(targetname, 8, 5)	-- 5seconds should be long enough to notice
	end
	if targetname == UnitName("player") then
		specWarnLeapingFlames:Show()
		yellLeapingFlames:Yell()
	end
end

function mod:OnCombatStart(delay)
	abilityCount = 0
	transforms = 0
end

function mod:OnCombatEnd()
	if self.Options.RangeFrameSeeds or self.Options.RangeFrameCat then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(98374) then		-- Cat Form (99574? maybe the form id for druids with staff)
		transforms = transforms + 1
		abilityCount = (self:IsDifficulty("heroic10", "heroic25") and 1) or 0
		timerFlameScythe:Cancel()
		timerLeapingFlames:Start(abilityTimers[abilityCount])
		if self.Options.RangeFrameCat then
			DBM.RangeCheck:Show(10)
		end
	elseif args:IsSpellID(98379) then	-- Scorpion Form
		transforms = transforms + 1
		abilityCount = (self:IsDifficulty("heroic10", "heroic25") and 1) or 0
		timerLeapingFlames:Cancel()
		timerFlameScythe:Start(abilityTimers[abilityCount])
		if self.Options.RangeFrameCat and not UnitDebuff("player", GetSpellInfo(98450)) then--Only hide range finder if you do not have seed.
			DBM.RangeCheck:Hide()
		end
	elseif args:IsSpellID(97238) then
		if abilityCount < (args.amount or 1) then--It means for whatever reason your mod missed some stacks, probalby a DC
			abilityCount = (args.amount or 1)--This should change your ability account to his current stack.
		end
		warnAdrenaline:Show(args.destName, args.amount or 1)
	elseif args:IsSpellID(97235) then
		warnFury:Show(args.destName, args.amount or 1)
	elseif args:IsSpellID(98450) and args:IsPlayer() then
		local _, _, _, _, _, duration, expires, _, _ = UnitDebuff("player", args.spellName)--Find out what our specific seed timer is
		specWarnSearingSeed:Schedule(expires - GetTime() - 5)	-- Show "move away" warning 5secs before explode
		soundSeed:Schedule(expires - GetTime() - 5)
		timerSearingSeed:Start(expires-GetTime())
		if self.Options.RangeFrameSeeds then
			DBM.RangeCheck:Show(12)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(98450) and args:IsPlayer() then
		if self.Options.RangeFrameSeeds then
			DBM.RangeCheck:Hide()
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(98451) then	--98451 confirmed
		warnOrbs:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(98476) then	--98476 confirmed
		abilityCount = abilityCount + 1
		local t = abilityTimers[abilityCount] or 4
		timerLeapingFlames:Start(t)
		self:ScheduleMethod(0.2, "LeapingFlamesTarget")
	elseif args:IsSpellID(98474, 100212, 100213, 100214) then	--98474, 100213 confirmed
		abilityCount = abilityCount + 1
		local t = abilityTimers[abilityCount] or 4
		timerFlameScythe:Start(t)
	end
end