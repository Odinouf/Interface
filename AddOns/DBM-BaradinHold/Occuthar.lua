local mod	= DBM:NewMod(140, "DBM-BaradinHold", nil, 74)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 6024 $"):sub(12, -3))
mod:SetCreatureID(52363)
mod:SetModelID(37876)
mod:SetZone()
--mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_DAMAGE"
)

local warnSearingShadows	= mod:NewSpellAnnounce(96913, 2)
local warnEyes			= mod:NewSpellAnnounce(96920, 3)

local timerSearingShadows	= mod:NewCDTimer(22, 96913)
local timerEyes			= mod:NewCDTimer(60, 96920)
local timerFocusedFire		= mod:NewCDTimer(30, 96883) -- 96884 is actual spell but has no info on tooltip

local specWarnSearingShadows	= mod:NewSpecialWarningSpell(96913, mod:IsTank())
local specWarnFocusedFire	= mod:NewSpecialWarningMove(97212)

local berserkTimer			= mod:NewBerserkTimer(300)

local spamFire = 0
function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	timerSearingShadows:Start(11-delay)
	eyesTimer:Start(30-delay)
	timerFocusedFire:Start()
	spamFire = 0
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(96920, 101006) then
		warnEyes:Show()
		timerEyes:Start()
	elseif args:IsSpellID(96913) then
		warnSearingShadows:Show()
		timerSearingShadows:Start()
		specWarnSearingShadows:Schedule(3) -- Tank switch after spell happened (could be done on SPELL_AURA_APPLIED as well, but then a spam function is needed in case more ppl get hit)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(96884, 101004) then
		timerFocusedFire:Start()
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(97212) and args:IsPlayer() and GetTime() - spamFire > 5 then
		specWarnFocusedFire:Show()
		spamFire = GetTime()
	end
end