﻿if GetLocale() ~= "koKR" then return end
local L

--------------------------
--  Halfus Wyrmbreaker  --
--------------------------
--L= DBM:GetModLocalization(156)
L = DBM:GetModLocalization("HalfusWyrmbreaker")

L:SetGeneralLocalization({
	name =	"할푸스 웜브레이커"
})

L:SetWarningLocalization({
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
	ShowDrakeHealth		= "풀려난 용의 체력 프레임 보기\n(보스 HP 프레임 보기가 활성화 되어 있어야 함)"
})

L:SetMiscLocalization({
})

---------------------------
--  Valiona & Theralion  --
---------------------------
--L= DBM:GetModLocalization(157)
L = DBM:GetModLocalization("ValionaTheralion")

L:SetGeneralLocalization({
	name =	"발리오나와 테랄리온"
})

L:SetWarningLocalization({
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
	TBwarnWhileBlackout		= "$spell:86788 이 활성화 중 일때 $spell:92898 경고 보기",
	TwilightBlastArrow		= "당신 근처에 $spell:92898이 시전된 경우 DBM 화살표 보기",
	RangeFrame				= "거리 프레임 보기(10m)",
	BlackoutShieldFrame		= "보스 체력 프레임과 함께 $spell:92878의 치유 바 보기",
	BlackoutIcon			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(92878),
	EngulfingIcon			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(86622)
})

L:SetMiscLocalization{
	Trigger1				= "들이쉽니다!",
	BlackoutTarget			= "의식 상실: %s"
}

----------------------------------
--  Twilight Ascendant Council  --
----------------------------------
--L= DBM:GetModLocalization(158)
L = DBM:GetModLocalization("AscendantCouncil")

L:SetGeneralLocalization({
	name =	"승천 의회"
})

L:SetWarningLocalization({
	specWarnBossLow			= "%s 체력 30%% 이하 - 곧 다음 단계!",
	SpecWarnGrounded		= "접지 받으세요!",
	SpecWarnSearingWinds	= "소용돌이 치는 바람 받으세요!"
})

L:SetTimerLocalization({
	timerTransition			= "전환 단계"
})

L:SetOptionLocalization({
	specWarnBossLow			= "보스의 체력이 30% 이하로 내려갈 경우 특수 경고 보기",
	SpecWarnGrounded		= "$spell:83581 디버프가 없을 경우, 특수 경고 보기(~10초 전)",
	SpecWarnSearingWinds	= "$spell:83500 디버프가 없을 경우, 특수 경고 보기(~10초 전)",
	timerTransition			= "전환 단계 타이머 보기",
	RangeFrame				= "거리 프레임이 필요하게 될 경우 자동으로 보기",
	yellScrewed				= "$spell:83099와 $spell:92307의 영향을 동시에 받을경우 외치기",
	InfoFrame				= "$spell:83581 또는 $spell:83500 디버프 없음에 대한 정보 프레임 보기",
	HeartIceIcon			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(82665),
	BurningBloodIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(82660),
	LightningRodIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(83099),
	GravityCrushIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(84948),
	FrostBeaconIcon			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(92307),
	StaticOverloadIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(92067),
	GravityCoreIcon			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(92075)
})

L:SetMiscLocalization({
	Quake			= "발밑의 땅이 불길하게 우르릉거립니다...",
	Thundershock	= "주변의 공기가 에너지로 진동합니다...",
	Switch			= "우리가 상대하겠다!",--"We will handle them!" comes 3 seconds after this one
	Phase3			= "꽤나 인상적이었다만...",--"BEHOLD YOUR DOOM!" is about 13 seconds after	
	Ignacious		= "이그니시우스",
	Feludius		= "펠루디우스",
	Arion			= "아리온",
	Terrastra		= "테라스트라",
	Monstrosity		= "엘레멘티움 괴물",
	Kill			= "이럴 수가...",
	blizzHatesMe	= "봉화랑 벼락 막대 같이 걸렸어요! 비켜주세요!",
	WrongDebuff		= "%s 없음"
})

----------------
--  Cho'gall  --
----------------
--L= DBM:GetModLocalization(167)
L = DBM:GetModLocalization("Chogall")

L:SetGeneralLocalization({
	name =	"초갈"
})

L:SetWarningLocalization({
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
	CorruptingCrashArrow	= "당신 근처에 $spell:93178이 시전 된 경우 DBM 화살표 보기",
	InfoFrame				= "$spell:81701 정보 프레임 보기",
	RangeFrame				= "$spell:82235의 영항을 받을시 거리 프레임(5m) 보기",
	SetIconOnWorship		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(91317),
	SetIconOnCreature		= "어둠에 물든 창조물에 전술 목표 아이콘 설정"
})

L:SetMiscLocalization({
	Bloodlevel				= "오염된 피"
})

----------------
--  Sinestra  --
----------------
--L= DBM:GetModLocalization(168)
L = DBM:GetModLocalization("Sinestra")

L:SetGeneralLocalization({
	name =   "시네스트라"
})

L:SetWarningLocalization({
	WarnDragon			= "새끼용 추가",
	WarnOrbSoon			= "%d초 후 구슬!",
	WarnEggWeaken		= "황혼 껍질 사라짐",
	SpecWarnOrbs		= "곧 구슬! 조심하세요!",
	warnWrackJump		= "%s 전이 : >%s<",
	warnAggro			= "위협 수준 획득(구슬 예상 대상) : >%s<",
	SpecWarnAggroOnYou	= "위협 수준 획득함! 구슬 조심하세요!",
	SpecWarnEggWeaken	= "황혼 껍질 사라짐 - 알 극딜!",
	SpecWarnEggShield	= "황혼 껍질 재생성!"
})

L:SetTimerLocalization({
	TimerDragon        	= "다음 새끼용 추가",
	TimerEggWeakening 	= "황혼 껍질 제거",
	TimerEggWeaken		= "황혼 껍질 재생성",
	TimerOrbs			= "구슬 쿨다운"
})	

L:SetOptionLocalization({
	WarnDragon       	= "새끼용 추가 경고 보기",
	WarnOrbSoon			= "구슬 카운트 다운 경고 보기 (5초 전부터, 1초 마다)\n(예상 경보이며, 정확하지 않을 수 있습니다.)",
	WarnEggWeaken    	= "$spell:87654 제거 사전 경고 보기",
	warnWrackJump		= "$spell:92955 전이 경고 보기",
	warnAggro			= "구슬 생성시 위협 수준이 있는 대상 알리기 (구슬 예상 대상)",
	SpecWarnAggroOnYou	= "구슬 생성시 당신이 위협 수준을 획득한 경우 특수 경고 보기\n(구슬 대상일 가능성이 높습니다.)",
	SpecWarnOrbs		= "구슬 특수 경고 보기 (예상 경보이며, 정확하지 않을 수 있습니다.)",
	SpecWarnEggWeaken	= "$spell:87654 사라짐 특수 경고 보기",
	SpecWarnEggShield	= "$spell:87654의 재생성 특수 경고 보기",
	TimerDragon        	= "다음 새끼용 등장 타이머 보기",
	TimerEggWeakening  	= "$spell:87654 사라짐 타이머 보기",
	TimerEggWeaken		= "$spell:87654 재생성 타이머 보기",
	TimerOrbs			= "구슬 쿨다운 타이머 보기 (예상 시간이며, 정확하지 않을 수 있습니다.)",
	SetIconOnOrbs		= "구슬 생성시 위협 수준이 있는 대상에게 전술 목표 아이콘 설정하기\n(구슬 대상일 가능성이 높습니다.)",
	OrbsCountdown		= "구슬 카운트 다운 소리 재생",
	InfoFrame			= "위협 수준 획득 대상 정보 프레임 보기 (구슬 대상자 후보)"
})

L:SetMiscLocalization({
	YellDragon		= "얘들아, 먹어치워라",
	YellEgg			= "이게 약해지는 걸로 보이느냐? 멍청한 놈!",
	HasAggro		= "위협 수준 있음"
})

-------------------------------------
--  The Bastion of Twilight Trash  --
-------------------------------------
L = DBM:GetModLocalization("BoTrash")

L:SetGeneralLocalization({
	name =	"황혼의 요새 일반몹"
})

L:SetWarningLocalization({
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
})

L:SetMiscLocalization({
})