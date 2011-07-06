Ovale.defaut["DRUID"] =
[[
Define(BARKSKIN 22812)
	SpellInfo(BARKSKIN cd=60)
	SpellAddBuff(BARKSKIN BARKSKIN=12)
Define(BERSERK 50334) #cat+bear cd buff
	SpellInfo(BERSERK cd=180)
Define(CLAW 16827) #cat no positionning
	SpellInfo(CLAW combo=1 mana=25)
Define(DEMOROAR 99) #bear
	SpellAddTargetDebuff(DEMOROAR DEMOROAR=30)
Define(ENRAGE 5229) #bear
	SpellInfo(ENRAGE cd=60)
Define(FAERIEFIRE 770) #moonkin
	SpellAddTargetDebuff(FAERIEFIRE FAERIEFIREDEBUFF=300)
Define(FAERIEFERAL 16857) #bear+cat
	SpellAddTargetDebuff(FAERIEFERAL FAERIEFIREDEBUFF=300)
Define(FEROCIOUSBITE 22568) #cat finish 35-70 mana
	SpellInfo(FEROCIOUSBITE combo=-5 mana=70)
Define(FORCEOFNATURE 33831) #moonkin cd
	SpellInfo(FORCEOFNATURE cd=180)
Define(FRENZIEDREGENERATION 22842) #bear
	SpellInfo(FRENZIEDREGENERATION cd=180)
	SpellAddBuff(FRENZIEDREGENERATION FRENZIEDREGENERATION=20)
Define(INNERVATE 29166)
	SpellInfo(INNERVATE cd=180)
	SpellAddBuff(INNERVATE INNERVATE=10)
Define(INSECTSWARM 5570) #moonkin
	SpellAddTargetDebuff(INSECTSWARM INSECTSWARM=12)
Define(LACERATE 33745) #bear bleed*3
	SpellInfo(LACERATE mana=15)
	SpellAddTargetDebuff(LACERATE LACERATE=15)
Define(MANGLECAT 33876) #cat bleed+debuff
	SpellInfo(MANGLECAT combo=1 mana=35)
	SpellAddTargetDebuff(MANGLECAT MANGLECAT=60)
Define(MANGLEBEAR 33878) #bear bleed+debuff
	SpellInfo(MANGLEBEAR cd=6 mana=15)
	SpellAddTargetDebuff(MANGLEBEAR MANGLEBEAR=60)
Define(MAUL 6807) #bear
	SpellInfo(MAUL cd=3 mana=30)
Define(MOONFIRE 8921) #moonkin
	SpellAddTargetDebuff(MOONFIRE MOONFIRE=12)
Define(PULVERIZE 80313) #bear after lacerate*3
	SpellInfo(PULVERIZE mana=15)
	SpellAddTargetDebuff(PULVERIZE LACERATE=0)
Define(RAKE 1822) #cat bleed
	SpellInfo(RAKE combo=1 mana=35)
	SpellAddTargetDebuff(RAKE RAKE=9)
Define(RAVAGE 6785) #cat behind+(prowling or stampede)
	SpellInfo(RAVAGE combo=1 mana=60)
	SpellAddBuff(RAVAGE STAMPEDE=0)
Define(RIP 1079) #cat bleed
	SpellInfo(RIP combo=-5 duration=16 resetcounter=ripshreds)
	SpellInfo(RIP glyph=GLYPHOFSHRED addduration=6)
	SpellAddTargetDebuff(RIP RIP=16)
Define(SAVAGEROAR 52610) #cat damage buff
	SpellInfo(SAVAGEROAR combo=-5 mana=25)
	SpellAddBuff(SAVAGEROAR SAVAGEROAR=9)
Define(SHRED 5221) #cat behind
	SpellInfo(SHRED mana=40 combo=1 inccounter=ripshreds)
Define(STARFALL 48505) #moonkin cd aoe
	SpellInfo(STARFALL cd=90)
	SpellAddBuff(STARFALL STARFALL=10)
Define(STARFIRE 2912) #moonkin
	SpellInfo(STARFIRE eclipse=20)
Define(STARSURGE 78674) #moonkin 15 lunar+solar
	SpellInfo(STARSURGE cd=15 starsurge=15)
	SpellAddBuff(STARSURGE SHOOTINGSTARS=0)
Define(SUNFIRE 93402)
	SpellAddTargetDebuff(SUNFIRE SUNFIRE=12)
Define(SURVIVALINSTINCTS 61336) #cat+bear surv cd
	SpellInfo(SURVIVALINSTINCTS cd=180)
	SpellAddBuff(SURVIVALINSTINCTS SURVIVALINSTINCTS=12)
Define(SWIPEBEAR 779) #bear aoe
	SpellInfo(SWIPEBEAR cd=6)
Define(SWIPECAT 62078) #cat aoe
Define(THRASH 77758) #bear aoe bleed
	SpellInfo(THRASH cd=6 mana=25)
	SpellAddTargetDebuff(THRASH THRASH=6)
Define(TIGERSFURY 5217) #cat buff
	SpellInfo(TIGERSFURY cd=30)
	SpellAddBuff(TIGERSFURY TIGERSFURY=6)
Define(TYPHOON 50516)
	SpellInfo(TYPHOON cd=20)
Define(WRATH 5176) #moonkin
	SpellInfo(WRATH eclipse=-13)

#Glyphs
Define(GLYPHOFSHRED 54815)

#Buff
Define(CLEARCASTING 16870)
Define(ECLIPSELUNAR 48518) #Increased by wrath
Define(ECLIPSESOLAR 48517) #Increased by starfire
Define(SHOOTINGSTARS 93400)
Define(STAMPEDE 81022)
Define(FAERIEFIREDEBUFF 91565)
Define(STRENGTHOFTHEPANTHER 90166) #feral T11 4-pieces bonus
Define(ASTRALALIGNMENT 90164) #balance T11 4-pieces bonus

AddCheckBox(multi L(AOE))
AddCheckBox(lucioles SpellName(FAERIEFIRE) default)
AddCheckBox(mangle SpellName(MANGLECAT) default mastery=2)
AddCheckBox(demo SpellName(DEMOROAR) default mastery=2)
AddCheckBox(shred SpellName(SHRED) default mastery=2)

ScoreSpells(FAERIEFERAL DEMOROAR MANGLEBEAR LACERATE SAVAGEROAR RIP 
		MANGLECAT RAKE SHRED FEROCIOUSBITE INSECTSWARM MOONFIRE
		WRATH STARFIRE STARSURGE SUNFIRE PULVERIZE MAUL
		CLAW)

AddIcon help=main mastery=1
{
	#/faerie_fire,if=debuff.faerie_fire.stack<3&!(debuff.sunder_armor.up|debuff.expose_armor.up)
	if CheckBoxOn(lucioles) and TargetDebuffExpires(FAERIEFIREDEBUFF 3 mine=1 stacks=3) and TargetDebuffExpires(lowerarmor 2 mine=0) and TargetDeadIn(more 15)
		Spell(FAERIEFIRE nored=1)

	if Speed(more 0)
	{
		#/typhoon,moving=1
		Spell(TYPHOON)
		if BuffPresent(SHOOTINGSTARS) Spell(STARSURGE)
		if TargetDebuffExpires(INSECTSWARM 4 mine=1) and TargetDeadIn(more 6)
			Spell(INSECTSWARM)
		if BuffPresent(ECLIPSESOLAR)
			Spell(SUNFIRE)
		Spell(MOONFIRE)
	}
	
	#/insect_swarm,if=ticks_remain<2|(dot.insect_swarm.remains<4&buff.solar_eclipse.up&eclipse<15)";
	if TargetDebuffExpires(INSECTSWARM 2 mine=1) or {TargetDebuffExpires(INSECTSWARM 4 mine=1) and 
			BuffPresent(ECLIPSESOLAR) and Eclipse(less 15)}
			Spell(INSECTSWARM nored=1)  

	if BuffPresent(ASTRALALIGNMENT)
	{
		#/starsurge,if=buff.t11_4pc_caster.up
		Spell(STARSURGE)
		#/starfire,if=buff.t11_4pc_caster.up&buff.lunar_eclipse.up
		if BuffPresent(ECLIPSELUNAR) Spell(STARFIRE)
		#/wrath,if=buff.t11_4pc_caster.up
		Spell(WRATH)
	}
	
    #action_list_str += "/wild_mushroom_detonate,moving=1,if=buff.wild_mushroom.stack=3";
    #action_list_str += "/wild_mushroom_detonate,moving=0,if=buff.wild_mushroom.stack>0&buff.solar_eclipse.up";

	if TargetDeadIn(more 6)	and BuffExpires(ASTRALALIGNMENT)
	{
		#/sunfire,if=(!ticking|ticks_remain<2|(dot.sunfire.remains<4&buff.solar_eclipse.up&eclipse<15))&!dot.moonfire.remains>0";
        if BuffPresent(ECLIPSESOLAR) and {TargetDebuffExpires(SUNFIRE 2 mine=1) or {TargetDebuffExpires(SUNFIRE 4 mine=1) and Eclipse(less 15)}}
				and TargetDebuffExpires(MOONFIRE 0 mine=1)
			Spell(SUNFIRE nored=1)
		
		#/moonfire,if=(!ticking|ticks_remain<2|(dot.moonfire.remains<4&buff.lunar_eclipse.up&eclipse>-20))
		if BuffExpires(ECLIPSELUNAR 0) and {TargetDebuffExpires(MOONFIRE 2 mine=1) or {TargetDebuffExpires(MOONFIRE 4 mine=1) and Eclipse(more -20)}}
				and TargetDebuffExpires(SUNFIRE 0 mine=1)
			Spell(MOONFIRE nored=1)
	}
		
	#/starsurge,if=!((eclipse<=-87&eclipse_dir=-1)|(eclipse>=80&eclipse_dir=1))
	unless {Eclipse(less -88) and BuffExpires(ECLIPSELUNAR)} or {Eclipse(more 79) and BuffExpires(ECLIPSESOLAR)}
		Spell(STARSURGE)
		
	#/innervate,if=mana_pct<50
	if ManaPercent(less 50) Spell(INNERVATE)
	
	#The following lines should not be useful for Ovale
	#/starfire,if=eclipse_dir=1&eclipse<80
	#/starfire,prev=wrath,if=eclipse_dir=-1&eclipse<-87
    #/wrath,if=eclipse_dir=-1&eclipse>=-87";
    #/wrath,prev=starfire,if=eclipse_dir=1&eclipse>=80";

	#/starfire,if=eclipse_dir=1
	if BuffPresent(ECLIPSELUNAR) or Eclipse(equal -100) Spell(STARFIRE)
	#/wrath,if=eclipse_dir=-1
	if BuffPresent(ECLIPSESOLAR) or Eclipse(equal 100) Spell(WRATH)
	if Eclipse(more 0) Spell(STARFIRE)
	if Eclipse(less 0) Spell(WRATH)
	#/starfire
	Spell(STARFIRE)
}

AddIcon help=cd mastery=1
{
	#/starfall,if=buff.lunar_eclipse.up&buff.t11_4pc_caster.down
	if BuffPresent(ECLIPSELUNAR) and BuffExpires(ASTRALALIGNMENT) Spell(STARFALL)
	#/treants,time>=5
	if TimeInCombat(more 5) Spell(FORCEOFNATURE)
	Item(Trinket0Slot usable=1)
	Item(Trinket1Slot usable=1)
}
		
AddIcon help=main mastery=2
{
	if Stance(1) # bear
	{
		#/mangle_bear
		Spell(MANGLEBEAR)
		#/demoralizing_roar,if=!debuff.demoralizing_roar.up
		if CheckBoxOn(demo) and TargetDebuffExpires(lowerphysicaldamage 2)
			Spell(DEMOROAR)
		#/lacerate,if=!ticking
		if TargetDebuffExpires(LACERATE 0) Spell(LACERATE)
		#/thrash
		Spell(THRASH)
		if CheckBoxOn(multi) Spell(SWIPEBEAR)
		#/pulverize,if=buff.lacerate.stack=3&buff.pulverize.remains<=2
		if TargetDebuffPresent(LACERATE stacks=3) and BuffExpires(PULVERIZE 2) Spell(PULVERIZE)
		#/lacerate,if=buff.lacerate.stack<3
		if TargetDebuffExpires(LACERATE 4 stacks=3)	Spell(LACERATE)
		#/faerie_fire_feral
		if CheckBoxOn(lucioles) and TargetDebuffExpires(lowerarmor 2 mine=0) and TargetDebuffExpires(FAERIEFIREDEBUFF 3 stacks=3)
			Spell(FAERIEFERAL)
	}

	if Stance(3) # cat
	{
		#tigers_fury,if=energy<=26
		if Mana(less 27) Spell(TIGERSFURY)
	
		#mangle_cat,if=set_bonus.tier11_4pc_melee&(buff.t11_4pc_melee.stack<3|buff.t11_4pc_melee.remains<3)
		if ArmorSetParts(T11 more 3) and BuffExpires(STRENGTHOFTHEPANTHER 3 stacks=3) Spell(MANGLECAT)
		
		#faerie_fire_feral,if=debuff.faerie_fire.stack<3|!(debuff.sunder_armor.up|debuff.expose_armor.up)
		if CheckBoxOn(lucioles) and	TargetDebuffExpires(lowerarmor 0 mine=0) and TargetDebuffExpires(FAERIEFIREDEBUFF 2 stacks=3) and TargetDeadIn(more 15)
			Spell(FAERIEFERAL)
		
		#mangle_cat,if=debuff.mangle.remains<=2&(!debuff.mangle.up|debuff.mangle.remains>=0.0)
		if TargetDebuffExpires(bleed 0) and CheckBoxOn(mangle)
			Spell(MANGLECAT)
			
		#ravage,if=buff.stampede_cat.up&buff.stampede_cat.remains<=1
		if BuffPresent(STAMPEDE) and BuffExpires(STAMPEDE 1) Spell(RAVAGE)
		
		#berserk,if=time_to_max_energy>=2.0&!buff.tigers_fury.up&cooldown.tigers_fury.remains>15
		if 2s before Mana(more 99) and BuffExpires(TIGERSFURY) and 15s before Spell(TIGERSFURY) Spell(BERSERK)
		
		#ferocious_bite,if=buff.combo_points.stack>=1&dot.rip.ticking&dot.rip.remains<=1&target.health_pct<=25
		if ComboPoints(more 0) and TargetDebuffPresent(RIP mine=1) and TargetDebuffExpires(RIP 1 mine=1) and TargetLifePercent(less 25)
			Spell(FEROCIOUSBITE)
		
		#ferocious_bite,if=buff.combo_points.stack>=5&dot.rip.ticking&target.health_pct<=25
		if ComboPoints(more 4) and TargetDebuffPresent(RIP mine=1) and TargetLifePercent(less 25)
			Spell(FEROCIOUSBITE)
		
		#rip,if=buff.combo_points.stack>=5&target.time_to_die>=6&dot.rip.remains<2.0&(buff.berserk.up|dot.rip.remains<=cooldown.tigers_fury.remains)
		if ComboPoints(more 4) and TargetDeadIn(more 6) and TargetDebuffExpires(RIP 2 mine=1) and 
				{BuffPresent(BERSERK) or {target.debuffExpires(RIP mine=1)<spell(TIGERSFURY)}}
			Spell(RIP)
			
		#rake,if=target.time_to_die>=8.5&buff.tigers_fury.up&dot.rake.remains<9.0&(!dot.rake.ticking|dot.rake.multiplier<multiplier)
		#not sure what this multiplier is
		if TargetDeadIn(more 8.5) and BuffPresent(TIGERSFURY) and TargetDebuffExpires(RAKE 0 mine=1)
			Spell(RAKE)
		#rake,if=target.time_to_die>=dot.rake.remains&dot.rake.remains<3.0&(buff.berserk.up|energy>=71|(cooldown.tigers_fury.remains+0.8)>=dot.rake.remains)
		if {target.timeToDie()>target.debuffExpires(RAKE mine=1)} and TargetDebuffExpires(RAKE 3 mine=1) and {BuffPresent(BERSERK) or Mana(more 70) or
				{{spell(TIGERSFURY)+0.8}>target.debuffExpires(RAKE mine=1)}}
			Spell(RAKE)
		
		#shred,if=buff.omen_of_clarity.react
		if BuffPresent(CLEARCASTING) Spell(SHRED)
		
		#savage_roar,if=buff.combo_points.stack>=1&buff.savage_roar.remains<=1
		if ComboPoints(more 0) and BuffExpires(SAVAGEROAR 1) Spell(SAVAGEROAR)
		
		#savage_roar,if=target.time_to_die>=9&buff.combo_points.stack>=5&dot.rip.ticking&dot.rip.remains<=12&@(dot.rip.remains-buff.savage_roar.remains)<=3
		if TargetDeadIn(more 9) and ComboPoints(more 4) and TargetDebuffPresent(RIP mine=1) and TargetDebuffExpires(RIP 12 mine=1)
				and {{target.debuffExpires(RIP mine=1) - buffExpires(SAVAGEROAR)}<3}
			Spell(SAVAGEROAR)
		
		#ferocious_bite,if=(target.time_to_die<=4&buff.combo_points.stack>=5)|target.time_to_die<=1
		if {TargetDeadIn(less 4) and ComboPoints(more 4)} or {TargetDeadIn(less 1) and ComboPoints(more 0)} Spell(FEROCIOUSBITE)
		#/ferocious_bite,if=buff.combo_points.stack>=5&dot.rip.remains>=14.0&buff.savage_roar.remains>=10.0
		if ComboPoints(more 4) and TargetDebuffPresent(RIP 14 mine=1) and BuffPresent(SAVAGEROAR 10) Spell(FEROCIOUSBITE)
		#shred,extend_rip=1,if=dot.rip.ticking&dot.rip.remains<=4&target.health_pct>25
		if Glyph(GLYPHOFSHRED) and Counter(ripshreds less 3) and TargetDebuffPresent(RIP mine=1) and TargetDebuffExpires(RIP 4 mine=1) and TargetLifePercent(more 25) Spell(SHRED)

		#ravage,if=buff.stampede_cat.up&!buff.omen_of_clarity.react&buff.tigers_fury.up
		if BuffPresent(STAMPEDE) and BuffExpires(CLEARCASTING) and BuffPresent(TIGERSFURY) Spell(RAVAGE)
		Spell(SHRED)
	}
}

AddIcon help=offgcd mastery=2
{
	#/maul,if=rage>=75
	if Stance(1) and Mana(more 74) Spell(MAUL)
}

AddIcon help=cd mastery=2
{
	#unless BuffPresent(TIGERSFURY) Spell(BERSERK)
	Item(Trinket0Slot usable=1)
	Item(Trinket1Slot usable=1)
}

]]
