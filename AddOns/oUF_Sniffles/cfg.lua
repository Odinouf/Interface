-- CONFIG --

cfg = { } -- dont touch only watch

cfg = {
	-- for all units
	["classcolored"] = true, -- class colored frames?
	["owncolor"] = false, -- or do you want your color?
	["mycolor"] = {0.08, 0.08, 0.08}, -- your own color (health)
	
	["ownpowercolor"] = false, -- (power)
	["mypowercolor"] = {1, 1, 1}, -- (power)
	
	-- party
	["enableparty"] = false,
	["powerbars"] = false,
	
	["partyheight"] = 40, -- maximal height of party frame
	["partywidth"] = 40, -- maximal width of party frame
	["partyhealthwidth"] = 40, -- width of health
	["partyhealthheight"] = 40, -- height of health
	["partypowerwidth"] = 40,
	["partypowerheight"] = 4,
	
	["partyenablenames"] = true, -- enable names?
	["partynames"] = 4, -- Choose between 4, 6, 8 nameletters
	
	["partyenablethreathighlight"] = true, -- true/false for threathightlight
	
	-- raid
	["enableraid"] = false,
	["rpowerbars"] = true,
	
	["raidwidth"] = 40,
	["raidheight"] = 40,
	["raidhealthheight"] = 40,
	["raidhealthwidth"] = 40,
	["raidpowerheight"] = 4,
	["raidpowerwidth"] = 40,
	
	["enableraidnames"] = true,
	["raidnames"] = 6, -- 4,6,8
	
	["raidenablethreathighlight"] = true,
	
	-- Plug-Ins
	["enablecombatfeedtext"] = true, -- enable Combatfeed Text?
	["combatfeedtextpos"] = {"CENTER", 0, 0}, -- Position of Combatfeed Text
	
	["enableaurawatch"] = true, -- enable aura watch?
	
	["enablethreatbar"] = false, -- enable threatbar ?

	-- Positions
	["playerpos"] = {"CENTER", -400, -100},
	["targetpos"] = {"CENTER", 400, -187},
	["totpos"] = {"CENTER", 600, -187},
	["petpos"] = {"CENTER", -485, -100},
	["focuspos"] = {"LEFT", 10, 0},
	["focustargetpos"] = {"LEFT", 150, 0},
	["grouppos"] = {"RIGHT", UIParent, "LEFT", 100, 150},
	--["raidpos"] = {"CENTER", UIParent, -300, 0},
	["raidpos"] = {"TOPLEFT", UIParent, 10, -10},
	
	-- Castbar
	["enablecastbars"] = true,
	["castbarwidth"] = 230,
	["castbarheight"] = 24,
	["playercastbarpos"] = {"CENTER", UIParent, 0, 0},
	["targetcastbarpos"] = {"CENTER", 0, 127},
	["focuscastbarpos"] = {"BOTTOM", -10, 10},
	["castbarcolor"] = {1, 1, 0},
	["castbariconwidth"] = 30,
	["castbariconheight"] = 30,
}

-- [""] = ,