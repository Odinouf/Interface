local mod	= DBM:NewMod(198, "DBM-Firelands", nil, 78)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 6218 $"):sub(12, -3))
mod:SetCreatureID(52409)
mod:SetModelID(37875)
mod:SetZone()
mod:SetUsedIcons(7, 8)
mod:SetModelSound("Sound\\Creature\\RAGNAROS\\VO_FL_RAGNAROS_AGGRO.wav", "Sound\\Creature\\RAGNAROS\\VO_FL_RAGNAROS_KILL_03.wav")
--Long: blah blah blah (didn't feel like transcribing it)
--Short: This is my realm

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_DAMAGE",
	"UNIT_DIED",
	"UNIT_HEALTH",
	"UNIT_AURA"
)

local warnHandRagnaros		= mod:NewSpellAnnounce(98237, 3, nil, mod:IsMelee())--Phase 1 only ability
local warnWrathRagnaros		= mod:NewSpellAnnounce(98263, 3, nil, mod:IsRanged())--Phase 1 only ability
local warnBurningWound		= mod:NewStackAnnounce(99399, 3, nil, mod:IsTank() or mod:IsHealer())
local warnMoltenSeed		= mod:NewSpellAnnounce(98520, 4)--Phase 2 only ability
local warnLivingMeteor		= mod:NewSpellAnnounce(99268, 4)--Phase 3 only ability
local warnSplittingBlow		= mod:NewAnnounce("warnSplittingBlow", 3, 100877)
local warnEngulfingFlame	= mod:NewAnnounce("warnEngulfingFlame", 4, 99171)
local warnBlazingHeat		= mod:NewTargetAnnounce(100460, 4)--Second transition adds ability.
local warnMagmaTrap			= mod:NewTargetAnnounce(98164, 3)--Second transition adds ability.
local warnPhase2Soon		= mod:NewPrePhaseAnnounce(2, 3)
local warnPhase3Soon		= mod:NewPrePhaseAnnounce(3, 3)

local specWarnSplittingBlow	= mod:NewSpecialWarningSpell(100877)
local specWarnMoltenSeed	= mod:NewSpecialWarningSpell(98520, nil, nil, nil, true)
local specWarnBlazingHeat	= mod:NewSpecialWarningYou(100460)
local specWarnMagmaTrap		= mod:NewSpecialWarningMove(98164)
local yellMagmaTrap			= mod:NewYell(98164)--May Return false tank yells
local specWarnEngulfing		= mod:NewSpecialWarningMove(99171)
local specWarnMeteor		= mod:NewSpecialWarningYou(99849)
local specWarnWorldofFlames	= mod:NewSpecialWarningSpell(100171, nil, nil, nil, true)
local specWarnBurningWound	= mod:NewSpecialWarningStack(99399, mod:IsTank(), 4)

local timerMagmaTrap		= mod:NewCDTimer(25, 98164)		-- Phase 1 only ability
local timerSulfurasSmash	= mod:NewCDTimer(40, 98710)		-- might even be a "next" timer
local timerHandRagnaros		= mod:NewCDTimer(25, 98237, nil, mod:IsMelee())-- might even be a "next" timer
local timerWrathRagnaros	= mod:NewNextTimer(12, 98263, nil, mod:IsRanged())--It's always 12 seconds after smash.
local timerBurningWound		= mod:NewTargetTimer(20, 99399, nil, mod:IsTank() or mod:IsHealer())
local timerFlamesCD			= mod:NewCDTimer(40, 99171)
local timerMoltenSeedCD		= mod:NewCDTimer(63, 98520)--60 seconds from last seed going off, but 63 from first.
local timerMoltenSeed		= mod:NewBuffActiveTimer(10, 98520)
local timerLivingMeteorCD	= mod:NewCDTimer(45, 99268)
local timerPhaseSons		= mod:NewTimer(45, "TimerPhaseSons", 99014)	-- lasts 45secs or till all sons are dead

local berserkTimer			= mod:NewBerserkTimer(1080)

local soundBlazingHeat		= mod:NewSound(100460)

mod:AddBoolOption("RangeFrame", true)
mod:AddBoolOption("BlazingHeatIcons", true)
mod:AddBoolOption("InfoFrame", true)

local wrathRagSpam = 0
local lastMeteor = 0
local sonsDied = 0
local phase = 1
local prewarnedPhase2 = false
local prewarnedPhase3 = false
local phase2Started = false
local phase3Started = false
local blazingHeatIcon = 8
local seedsActive = false
local seedsWarned = false
local meteorWarned = false
local meteorTarget = GetSpellInfo(99849)

local function showRangeFrame()
	if mod.Options.RangeFrame then
		if phase == 1 and mod:IsRanged() then
			DBM.RangeCheck:Show(6)--For wrath of rag, only for ranged.
		elseif phase == 2 then
			DBM.RangeCheck:Show(6)--For seeds
		elseif phase == 3 then
			DBM.RangeCheck:Show(5)--For meteors
		end
	end
end

local function hideRangeFrame()
	if mod.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

local function clearSeedsActive()
	seedsActive = false
	seedsWarned = false
end

local function warnSeeds()
	seedsWarned = true
	warnMoltenSeed:Show()
	specWarnMoltenSeed:Show()
	timerMoltenSeed:Start()
	timerMoltenSeedCD:Start()
end


local function TransitionEnded()
	timerPhaseSons:Cancel()
	if phase == 2 and not phase2Started then
		phase2Started = true
		timerFlamesCD:Start(43)
		timerMoltenSeedCD:Start(26)
		if mod:IsDifficulty("heroic10", "heroic25") then
			specWarnMoltenSeed:Schedule(26)--^^
			timerMoltenSeed:Schedule(26)--^^
		end
		timerSulfurasSmash:Start(18)--18-20sec after last son dies (or 45second push)
		showRangeFrame()--Range 6 for seeds
	elseif phase == 3 and not phase3Started then
		phase3Started = true
		showRangeFrame()--Range 5 for meteors (should it be 8 instead?) Conflicting tooltip information.
		timerFlamesCD:Start(32)
		timerLivingMeteorCD:Start()
		if mod.Options.InfoFrame then--This is probably the best way to do it without spam. Does not show in combat log, only unitdebuff/unit_aura will probaby work. will have to find a way to give personal warnings without spam later.
			DBM.InfoFrame:SetHeader(L.MeteorTargets)
			DBM.InfoFrame:Show(6, "playerbaddebuff", 99849)--Maybe need more then 6? 8 or 10 if things go real shitty heh.
		end
	end
end

function mod:MagmaTrapTarget()
	local targetname = self:GetBossTarget(52409)
	if not targetname then return end
	warnMagmaTrap:Show(targetname)
	if targetname == UnitName("player") then
		specWarnMagmaTrap:Show()
		yellMagmaTrap:Yell()
	end
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	timerMagmaTrap:Start(16-delay)
	timerSulfurasSmash:Start(30-delay)
	wrathRagSpam = 0
	lastMeteor = 0
	sonsDied = 0
	phase = 1
	prewarnedPhase2 = false
	prewarnedPhase3 = false
	blazingHeatIcon = 8
	phase2Started = false
	phase3Started = false
	seedsActive = false
	meteorWarned = false
	seedsWarned = false
	showRangeFrame()
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(99399, 101238, 101239, 101240) then
		warnBurningWound:Show(args.destName, args.amount or 1)
		if (args.amount or 0) >= 4 and args:IsPlayer() then
			specWarnBurningWound:Show(args.amount)
		end
		timerBurningWound:Start(args.destName)
	elseif args:IsSpellID(100171, 100190) then--World of Flames, heroic trigger for engulfing flames. CD timing is not known for this on heroic yet. Assumed same as normal for now.
		specWarnWorldofFlames:Show()
		if phase == 3 then
			timerFlamesCD:Start(30)--30 second CD in phase 3
		else
			timerFlamesCD:Start()--40 second CD in phase 2
		end
	end
end		
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(98710, 100890, 100891, 100892) then
		if phase == 1 then
			timerSulfurasSmash:Start(30)--30 second cd in phase 1.
			timerWrathRagnaros:Start()
		else
			timerSulfurasSmash:Start()
		end
	elseif args:IsSpellID(98951, 98952, 98953, 100877) or args:IsSpellID(100878, 100879, 100880, 100881) or args:IsSpellID(100882, 100883, 100884, 100885) then--This has 12 spellids, 1 for each possible location for hammer.
		sonsDied = 0
		phase = phase + 1
		timerMagmaTrap:Cancel()
		timerSulfurasSmash:Cancel()
		timerHandRagnaros:Cancel()
		timerWrathRagnaros:Cancel()
		hideRangeFrame()
		if self:IsDifficulty("heroic10", "heroic25") then
			timerPhaseSons:Start(60)--Longer on heroic
			self:Schedule(60, TransitionEnded)
		else
			timerPhaseSons:Start(45)
			self:Schedule(45, TransitionEnded)
		end
		specWarnSplittingBlow:Show()
		--Middle: 98952 (10N), 100877 (25N) (Guessed: 100878, 100879)
		--East: 98953 (10N), 100880 (25N) (Guessed: 100881, 100882)
		--West: 98951 (10N), 100883 (25N) (Guessed: 100884, 100885)
		if args:IsSpellID(98952, 100877) then--Middle
			warnSplittingBlow:Show(args.spellName, L.Middle)
		elseif args:IsSpellID(98953, 100880) then--East
			warnSplittingBlow:Show(args.spellName, L.East)
		elseif args:IsSpellID(98951, 100883) then--West
			warnSplittingBlow:Show(args.spellName, L.West)
		end
	elseif args:IsSpellID(99172, 100175) or args:IsSpellID(99235, 100178) or args:IsSpellID(99236, 100181) then--Another scripted spell with a ton of spellids based on location of room. heroic purposely excluded do to different mechanic linked to World of Flames that will be used instead.
		if phase == 3 then
			timerFlamesCD:Start(30)--30 second CD in phase 3
		else
			timerFlamesCD:Start()--40 second CD in phase 2
		end
		--North: 99172 (10N), 100175 (25N)
		--Middle: 99235 (10N), 100178 (25N)
		--South: 99236 (10N), 100181 (25N)
		if args:IsSpellID(99172, 100175) then--North
			warnEngulfingFlame:Show(args.spellName, L.North)
			if self:IsMelee() or seedsActive then--Always warn melee classes if it's in melee (duh), warn everyone if seeds are active since 90% of strats group up in melee
				specWarnEngulfing:Show()
			end
		elseif args:IsSpellID(99235, 100178) then--Middle
			warnEngulfingFlame:Show(args.spellName, L.Middle)
		elseif args:IsSpellID(99236, 100181) then--South
			warnEngulfingFlame:Show(args.spellName, L.South)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(98237, 100383, 100384, 100387) and not args:IsSrcTypePlayer() then -- can be stolen which triggers a new SPELL_CAST_SUCCESS event...
		warnHandRagnaros:Show()
		timerHandRagnaros:Start()
	elseif args:IsSpellID(98164) then	--98164 confirmed
		timerMagmaTrap:Start()
		self:ScheduleMethod(0.2, "MagmaTrapTarget")--guessed speed, he definitely targets trap person, may need to change scan rate though.
	elseif args:IsSpellID(98263, 100113, 100114, 100115) and GetTime() - wrathRagSpam >= 4 then
		wrathRagSpam = GetTime()
		warnWrathRagnaros:Show()
	elseif args:IsSpellID(100460, 100981, 100982, 100983) then	-- Blazing heat, drycoded.
		warnBlazingHeat:Show(args.destName)
		if args:IsPlayer() then
			specWarnBlazingHeat:Show()
			soundBlazingHeat:Play()
		end
		if self.Options.BlazingHeatIcons then
			self:SetIcon(args.destName, blazingHeatIcon, 8)
			if blazingHeatIcon == 8 then-- Alternate icons, they are cast too far apart to sort in a table or do icons at once, and there are 2 adds up so we need to do it this way.
				blazingHeatIcon = 7
			else
				blazingHeatIcon = 8
			end
		end
	elseif args:IsSpellID(99268) and GetTime() - lastMeteor >= 4 then
		lastMeteor = GetTime()
		warnLivingMeteor:Show()
		timerLivingMeteorCD:Start()
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(98498, 100579, 100580, 100581) and not seedsActive then--trigger spell 98495 doesn't show in combat log :\. This only fires if players are not spread properly but is most accurate detection of cast.
		seedsActive = true
		self:Unschedule(warnSeeds)--Cancel scheduled one if it hasn't fired yet, this damage event is more precise timing (although it shouldn't happen if people play right, if it does, might as well use it to warn right away)
		if not seedsWarned then--Check to see if scheduled function already went off, if it did already lets not spam.
			warnSeeds()
		end
		self:Schedule(63, warnSeeds)--Schedule next one off this event, no reason to fire Molten inferno event too.
		self:Schedule(15, clearSeedsActive)--Clear active/warned seeds after they have all blown up.
	elseif args:IsSpellID(98518, 100252, 100253, 100254) and not seedsActive then--Molten Inferno. This is seed exploding at end, we use it to schedule warnings for next one if no one took damage from seeds since this damage cannot be avoided and is 100% gonna trigger.
		seedsActive = true
		self:Schedule(53, warnSeeds)
		self:Schedule(5, clearSeedsActive)--Clear active/warned seeds after they have all blown up.
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 53140 then
		sonsDied = sonsDied + 1
		if sonsDied >= 8 then
			self:Unschedule(TransitionEnded)
			TransitionEnded()
		end
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 52409 then
		local h = UnitHealth(uId) / UnitHealthMax(uId) * 100
		if h > 80 and prewarnedPhase2 then
			prewarnedPhase2 = false
		elseif h > 72 and h < 75 and not prewarnedPhase2 then
			prewarnedPhase2 = true
			warnPhase2Soon:Show()
		elseif h > 50 and prewarnedPhase3 then
			prewarnedPhase3 = false
		elseif h > 42 and h < 45 and not prewarnedPhase3 then
			prewarnedPhase3 = true
			warnPhase3Soon:Show()
		end
	end
end

function mod:UNIT_AURA(uId)
	if uId ~= "player" then return end
	if UnitDebuff("player", meteorTarget) and not meteorWarned then--Warn you that you have a meteor
		specWarnMeteor:Show()
		meteorWarned = true
	elseif not UnitDebuff("player", meteorTarget) and meteorWarned then--reset warned status if you don't have debuff
		meteorWarned = false
	end
end