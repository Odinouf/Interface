Qulight["media"] = {
	["font"] = [=[Interface\Addons\QulightUI\media\1.ttf]=], 			        -- main font in Qulight UI
	--["pxfont"] = "Interface\\Addons\\QulightUI\\media\\HOOG0555.ttf", 			-- main font in Qulight UI
	["pxfont"] = "Interface\\Addons\\QulightUI\\media\\1.ttf",
	["fontsize"] = 12, 														    -- Size of font 
	["bordercolor"] = { .15,.15,.15,1 }, 											-- border color of Qulight UI panels
	["backdropcolor"] = { .06,.06,.06,1 }, 										-- background color of Qulight UI panels
	["backdropfadecolor"] = { r = .07,g = .07,b = .07, a = 0.9 },
	["valuecolor"] = {r = 23/255,g = 132/255,b = 209/255},
	["texture"] = "Interface\\Addons\\QulightUI\\media\\Other\\statusbar",
	["blank"] = "Interface\\Buttons\\WHITE8x8",
}
Qulight["general"] = {
	["AutoScale"] = true,  					-- mainly enabled for users that don't want to mess with the config file
	["UiScale"] = 0.75,						-- set your value (between 0.64 and 1) of your uiscale if autoscale is off
	["MultisampleProtect"] = true,    		-- i don't recommend this because of shitty border but, voila!
	["AutoRepair"] = true,					-- automaticly repair?
	["AutoGreed"] = true,					-- automaticly greed green items?
	["AutoDisenchant"] = true,				-- automaticly dis green items?
	["AutoDeclineDuels"] = false,
	["AutoAcceptInvite"] = true,
	["AutoRelease"] = true,
	["classcolortheme"] = true,
	["sharpborders"] = false,
	["BlizzardsErrorFrameHiding"] = true,
}
Qulight["actionbar"] = {		
	["enable"] = false,                      -- enable action bars
	["hotkey"] = true,                      -- enable hotkey display because it was a lot requested
	["shapeshiftmouseover"] = false,        -- enable shapeshift or totembar on mouseover
	["rightbarmouseover"] = false,          -- enable right bars on mouse over
	["hideshapeshift"] = true,             -- hide shapeshift or totembar because it was a lot requested.
	["bottomrows"] = 2,                     -- numbers of row you want to show at the bottom (select between 1-3 only)
	["rightbars"] = 0,						-- numbers of right bar you want (0-3)
	["splitbar"] = false,					-- split the third right actionbar into two rows of 3 on the left and right side of the main actionbar
	["buttonsize"] = 22,					-- size of action buttons
	["buttonspacing"] = 3,					-- spacing of action buttons
	["petbuttonsize"] = 20,					-- size of pet/stance buttons
	["petbuttonspacing"] = 3,				-- spacing of pet/stance buttons
	["swaptopbottombar"] =false,			-- swap the main actionbar position with the bottom actionbar
	["macrotext"] = false,					-- show macro text on actionbuttons
	["verticalstance"] = true,				-- make stance bar vertical
	["microbar"] = false,					-- enable microbar display
	["mousemicro"] = false,					-- only show microbar on mouseover
}
Qulight["unitframes"] = {
	["enable"] = true,
 	["HealFrames"] = false,
    ["showAuraWatch"] = true,
	["ShowParty"] = true, 					-- show party frames (shown as 5man raid)
	["ShowRaid"] = false,					-- show raid frames
	["RaidShowSolo"] = false, 				-- show raid frames even when solo
	["RaidShowAllGroups"] = false, 			-- show raid groups 6, 7 and 8 (more than 25man raid)
	["enableDebuffHighlight"] = true, 		-- enable *dispelable* debuff highlight for raid frames
	["showRaidDebuffs"] = true, 			-- enable important debuff icons to show on raid units
	["showtot"] = true, 					-- show target of target frame
	["showpet"] = true,						-- show pet frame
	["showfocus"] = true, 					-- show focus frame
	["showfocustarget"] = true, 			-- show focus target frame
	["showBossFrames"] = true, 				-- show boss frame
	["TotemBars"] = true, 					-- show Totem Bars
	["MTFrames"] = true, 					-- show main tank frames
	["ArenaFrames"]  = true, 				-- show arena frame
	["Reputationbar"] = true, 				-- show Reputation bar
	["Experiencebar"] = true, 				-- show Experience bar
	["showPlayerAuras"] = false, 			-- use a custom player buffs/debuffs frame instead of Blizzard's default.
	["ThreatBar"] = false,
	["showPortrait"] = true,
	["showRunebar"] = true, 				-- show DK rune bar
	["showHolybar"] = true, 				-- show Paladin HolyPower bar
	["showEclipsebar"] = true, 				-- show druid Eclipse bar
	["showShardbar"] = true, 				-- show Warlock SoulShard bar
	["RCheckIcon"] = true, 					-- show raid check icon
	["Castbars"] = true, 					-- use built-in castbars
	["showLFDIcons"] = true, 				-- Show dungeon role icons in raid/party
}
Qulight["chatt"] = {				 
	["enable"] = true,
	["chatbar"] = false,
	["chatframewidth"] = 320,
	["chatframeheight"] = 115,
	["editboxwidth"] = 353,
	["editboxheight"] = 13,
}
Qulight["buffdebuff"] = {
	["enable"] = true,  
	["iconsize"] = 31, 						-- Buffs size
	["timefontsize"] = 10, 					-- Time font size
	["countfontsize"] = 10,  				-- Count font size
	["spacing"] = 3, 						-- Spacing between icons(buffs)
	["timeYoffset"] = -2, 					-- Verticall offset value for time text field
	["BUFFS_PER_ROW"] = 10,
}
Qulight["addonskins"] = {				 
	["DBM"] = true, 						-- Deadly Boss Mod skinning
	["PallyPower"] = true, 					-- Pally Power skinning
	["Skada"] = true, 						-- Skada skinning
	["Recount"] = true, 					-- Recount skinning
	["Omen"] = false, 						-- Omen skinning
	["KLE"] = true, 						-- KLE skinning
	["Quartz"] = true, 						-- Quartz skinning
	["Bigwigs"] = true, 					-- BigWigs Bossmod skinning
}
Qulight["datatext"] = {
	["Durability"] = 0,                		-- show your equipment durability on panels.
	["System"] = 1,                			-- show fps and ms on panels, and total addon memory in tooltip
	["Gold"] = 0,                			-- show your current gold on panels
	["Guild"] = 3,                			-- show number on guildmate connected on panels
	["togglemenu"] = 0,  			  		-- minimenu
	["Wowtime"] = 7,              			-- show time on panels
	["Friends"] = 2,                		-- show number of friends connected.
	["Bags"] = 5,                			-- show space used in bags on panels
	["Time24"] = true,            			-- set time to 24h format.
	["Localtime"] = true,  
	["classcolor"] = true,
	["color"] = { .7, .7, .7, 1 }, 			-- if ["classcolor"] = false,	
}
Qulight["nameplatess"] = {
	["enable"] = true,                                  -- enable nice skinned nameplates that fit into tukui
}
Qulight["togglemenu"] = {
	["enable"] = false,
	["buttonwidth"] = 98,					-- Width of menu buttons
	["buttonheight"] = 18,					-- Height of menu buttons
	["classcolor"] = true,					-- Class color buttons
}
Qulight["minimapp"] = {
	["enable"] = false,
	["size"] = 120,
}
Qulight["map"] = {
	["enable"] = false,
}
Qulight["tooltip"] = {
	["enable"] = true,                      -- true to enable this mod, false to disable
	["hidecombat"] = true,                 -- hide bottom-right tooltip when in combat
	["hidebuttons"] = true,                 -- always hide action bar buttons tooltip.
	["hideuf"] = false,                     -- hide tooltip on unitframes
	["cursor"] = false,                     -- tooltip via cursor only
}
Qulight["bags"] = {
	["Enable"] = false,
	["BagBars"] = false,	
}
Qulight["loot"] = {
	["lootframe"] = false,                  
	["rolllootframe"] = false,
}
Qulight["cooldown"] = {
	["enable"] = true,                     
}
Qulight["skinframe"] = {
	["enable"] = true,                    
}

Qulight["misk"] = {
	["addonmanager"] = true,
	["raidutility"] = true,
	["markbar"] = false,
	["filger"] = false,
	["classtimer"] = false,
	["BuffReminderRaidBuffs"] = false,
	["Reminder"] = false,
	["CooldownFlash"] = false,
}  