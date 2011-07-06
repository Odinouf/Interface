Ovale.defaut["SHAMAN"] =
[[
Define(BLOODLUST 2825)
	SpellInfo(BLOODLUST cd=300)
	SpellAddBuff(BLOODLUST BLOODLUST=40)
Define(CHAINLIGHTNING 421)
	SpellInfo(CHAINLIGHTNING cd=3)
	SpellAddBuff(CHAINLIGHTNING MAELSTROMWEAPON=0)
Define(EARTHQUAKE 61882)
Define(EARTHSHOCK 8042)
	SpellInfo(EARTHSHOCK cd=6 sharedcd=shock)
	SpellAddTargetDebuff(EARTHSHOCK EARTHSHOCK=8)
Define(ELEMENTALMASTERY 16166)
	SpellInfo(ELEMENTALMASTERY cd=180)
	SpellAddBuff(ELEMENTALMASTERY ELEMENTALMASTERY=30)
Define(FERALSPIRIT 51533)
	SpellInfo(FERALSPIRIT cd=120)
Define(FIRENOVA 1535)
	SpellInfo(FIRENOVA cd=10)
Define(FLAMESHOCK 8050)
	SpellInfo(FLAMESHOCK cd=6 sharedcd=shock)
	SpellAddTargetDebuff(FLAMESHOCK FLAMESHOCK=18)
Define(FLAMETHONGWEAPON 8024)
Define(FROSTSHOCK 8056)
	SpellInfo(FROSTSHOCK cd=6 sharedcd=shock)
	SpellAddTargetDebuff(FROSTSHOCK FROSTSHOCK=8)
Define(FROSTBANDWEAPON 8033)
Define(HEROISM 32182)
	SpellInfo(HEROISM cd=300)
	SpellAddBuff(HEROISM HEROISM=40)
Define(LAVABURST 51505)
	SpellInfo(LAVABURST cd=8)
Define(LAVALASH 60103)
	SpellInfo(LAVALASH cd=10)
Define(LIGHTNINGBOLT 403)
	SpellAddBuff(LIGHTNINGBOLT MAELSTROMWEAPON=0)
Define(LIGHTNINGSHIELD 324)
	SpellAddBuff(LIGHTNINGSHIELD LIGHTNINGSHIELD=600)
Define(PRIMALSTRIKE 73899)
	SpellInfo(PRIMALSTRIKE cd=8)
Define(ROCKBITERWEAPON 8017)
Define(SHAMANISTICRAGE 30823)
	SpellInfo(SHAMANISTICRAGE cd=60)
	SpellAddBuff(SHAMANISTICRAGE SHAMANISTICRAGE=15)
Define(SPIRITWALKERSGRACE 79206)
	SpellInfo(SPIRITWALKERSGRACE cd=120)
	SpellAddBuff(SPIRITWALKERSGRACE SPIRITWALKERSGRACE=15)
Define(STORMSTRIKE 17364)
	SpellInfo(STORMSTRIKE cd=8)
	SpellAddTargetDebuff(STORMSTRIKE STORMSTRIKE=15)
Define(THUNDERSTORM 51490)
	SpellInfo(THUNDERSTORM cd=45)
Define(UNLEASHELEMENTS 73680)
	SpellInfo(UNLEASHELEMENTS cd=15)
Define(UNLEASHFLAME 73683)
	SpellInfo(UNLEASHFLAME cd=15)
	SpellAddBuff(UNLEASHFLAME UNLEASHFLAME=8)
Define(WATERSHIELD 52127)
	SpellAddBuff(WATERSHIELD WATERSHIELD=600)
Define(WINDSHEAR 57994)
	SpellInfo(WINDSHEAR cd=6)
Define(WINDFURYWEAPON 8232)

#Buff
Define(MAELSTROMWEAPON 53817)
Define(UNLEASHWIND 73681)

#Fire
Define(FIREELEMENTALTOTEM 2894)
Define(MAGMATOTEM 8190)
	SpellInfo(MAGMATOTEM cd=20)
Define(SEARINGTOTEM 3599)
	SpellInfo(SEARINGTOTEM cd=10) #Fake CD so it won't be displayed twice
Define(FLAMETHONGTOTEM 8227)

Define(TOTEMOFWRATH 30706)
#Water
Define(HEALINGSTREAMTOTEM 5394)
Define(MANASPRINGTOTEM 5675)
Define(TOTEMOFTRANQUILMIND 87718)
#Air
Define(GROUNDINGTOTEM 8177)
Define(WINDFURYTOTEM 8512)
Define(WRATHOFAIRTOTEM 3738)
#Earth
Define(STONECLAWTOTEM 5730)
Define(STONESKINTOTEM 8071)
Define(STRENGTHOFEARTHTOTEM 8075)
Define(TREMORTOTEM 8143)

ScoreSpells(LIGHTNINGSHIELD CHAINLIGHTNING FLAMESHOCK LAVABURST EARTHSHOCK LIGHTNINGBOLT
			STORMSTRIKE LAVALASH UNLEASHELEMENTS)

AddCheckBox(aoe L(AOE))
AddCheckBox(chain SpellName(CHAINLIGHTNING) default mastery=1)

AddIcon help=main mastery=1
{
	unless InCombat()
	{
		#/flametongue_weapon,weapon=main
		if WeaponEnchantExpires(mainhand 400) Spell(FLAMETHONGWEAPON)
	}
	#/lightning_shield
	if BuffExpires(LIGHTNINGSHIELD 2) Spell(LIGHTNINGSHIELD)
	
	#/unleash_elements,moving=1
	if Speed(more 0) Spell(UNLEASHELEMENTS)
	
	#/flame_shock,if=!ticking|ticks_remain<3
	if TargetDebuffExpires(FLAMESHOCK 3 mine=1) Spell(FLAMESHOCK)

	if CheckBoxOn(aoe)
	{
		Spell(EARTHQUAKE)
		if TargetDebuffPresent(FLAMESHOCK mine=1) Spell(FIRENOVA)
	}

	#/lava_burst,if=(dot.flame_shock.remains-cast_time)>=0.05
	if target.debuffExpires(FLAMESHOCK mine=1) - castTime(LAVABURST) > 0.05 Spell(LAVABURST)
	
	#/earth_shock,if=buff.lightning_shield.stack=9
	if BuffPresent(LIGHTNINGSHIELD stacks=9) Spell(EARTHSHOCK)
	#/earth_shock,if=buff.lightning_shield.stack>6&dot.flame_shock.remains>cooldown&dot.flame_shock.remains<cooldown+action.flame_shock.tick_time
	if BuffPresent(LIGHTNINGSHIELD stacks=7) and { target.debuffExpires(FLAMESHOCK mine=1) > spell(LAVABURST) }
			and { target.debuffExpires(FLAMESHOCK mine=1) < spell(LAVABURST) + timeWithHaste(3) } Spell(EARTHSHOCK)
	
	if TotemExpires(fire) Spell(SEARINGTOTEM)
	#/spiritwalkers_grace,moving=1
	#/chain_lightning,if=target.adds>2
	if CheckBoxOn(aoe) Spell(CHAINLIGHTNING)
	#/lightning_bolt
	Spell(LIGHTNINGBOLT)
}

AddIcon help=main mastery=2
{
	unless InCombat()
	{
		#/windfury_weapon,weapon=main
		if WeaponEnchantExpires(mainhand 400) Spell(WINDFURYWEAPON)
		#/flametongue_weapon,weapon=off
		if WeaponEnchantExpires(offhand 400) Spell(FLAMETHONGWEAPON)
	}
	
	#/lightning_shield
	if BuffExpires(LIGHTNINGSHIELD) Spell(LIGHTNINGSHIELD)
	
	if CheckBoxOn(aoe)
	{
		if BuffPresent(MAELSTROMWEAPON stacks=5) Spell(CHAINLIGHTNING)
		if TotemExpires(fire) Spell(MAGMATOTEM)
		if TotemPresent(fire) Spell(FIRENOVA)
		Spell(LAVALASH)
		if BuffPresent(MAELSTROMWEAPON stacks=4) Spell(CHAINLIGHTNING)
		Spell(UNLEASHELEMENTS)
		if TargetDebuffExpires(FLAMESHOCK 0 mine=1) Spell(FLAMESHOCK)
		Spell(EARTHSHOCK)
		Spell(STORMSTRIKE)
		if BuffPresent(MAELSTROMWEAPON stacks=2) Spell(CHAINLIGHTNING)
		Spell(LAVABURST)
	}
	
	if CheckBoxOff(aoe)
	{
		#/searing_totem
		if TotemExpires(fire) Spell(SEARINGTOTEM)
		#/lava_lash
		Spell(LAVALASH)
		#/lightning_bolt,if=buff.maelstrom_weapon.stack=5&buff.maelstrom_weapon.react
		if BuffPresent(MAELSTROMWEAPON stacks=5) Spell(LIGHTNINGBOLT)
		#/unleash_elements
		Spell(UNLEASHELEMENTS)
		#/flame_shock,if=!ticking|(buff.unleash_flame.up&ticks_remain<=2)
		if TargetDebuffExpires(FLAMESHOCK 0 mine=1) or {BuffPresent(UNLEASHFLAME) and TargetDebuffExpires(FLAMESHOCK 2 mine=1)}
			Spell(FLAMESHOCK)
		#/earth_shock
		Spell(EARTHSHOCK)
		#/stormstrike
		Spell(STORMSTRIKE)
		#/fire_nova
		if TargetDebuffPresent(FLAMESHOCK mine=1) Spell(FIRENOVA)
		#/lightning_bolt,if=buff.maelstrom_weapon.stack=4&buff.maelstrom_weapon.react
		if BuffPresent(MAELSTROMWEAPON stacks=4) Spell(LIGHTNINGBOLT)
	}
		
	Spell(SHAMANISTICRAGE priority=2)
	Spell(FERALSPIRIT priority=2)
}

AddIcon help=cd
{
	Spell(ELEMENTALMASTERY)
	Spell(FERALSPIRIT)
	Item(Trinket0Slot usable=1)
	Item(Trinket1Slot usable=1)
	Spell(FIREELEMENTALTOTEM)
}

AddIcon size=small help=mana
{
	if ManaPercent(less 25)
		Spell(SHAMANISTICRAGE)
	if ManaPercent(less 50)
		Spell(THUNDERSTORM)
}

AddIcon size=small
{
	Spell(HEROISM)
	Spell(BLOODLUST)	
}

]]