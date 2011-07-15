
  -- // rFilter3
  -- // zork - 2010

  --get the addon namespace
  local addon, ns = ...
  
  --object container
  local cfg = CreateFrame("Frame") 
  
  cfg.rf3_BuffList, cfg.rf3_DebuffList, cfg.rf3_CooldownList = {}, {}, {}
  
  local player_name, _ = UnitName("player")
  local _, player_class = UnitClass("player")
 -- local Posture = GetShapeshiftForm()
  
  -----------------------------
  -- CONFIG
  -----------------------------  
  
  cfg.highlightPlayerSpells = true
  cfg.updatetime            = 0.2 --how fast should the timer update itself

  if player_name == "Aksha" then
  
    --Rothars Buff List
  
    cfg.rf3_BuffList = {
      [1] = {
        spec = 1, 
        --spec got moved to bufflist, so buffs can be set up per spec 
        -- 1 is your first spec 
        -- 2 is your second spec
        -- false or nil will remove the spec tracking
        spellid = 50335, --zerk 50334
        spelllist = { --check a list instead because other classes can do the same
          [1] = 50334,
          
        },
        size = 30,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -165, y = -50},
        unit = "player",
        validate_unit = true, --only show the icon if unit is found
        ismine        = false,
        desaturate =   true,
		move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0,          
          },
        },
      },
     --[[ [2] = {
        spec = 1, 
        spellid = 61336, --survival
        spelllist = { --check a list instead because other classes can do the same
          [1] = 61336,
         
        },
        size = 30,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -165, y = -20},
        unit = "player",
        ismine = false,
        desaturate = true,
		move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0,          
          },
        },
      },
      [3] = {
        spec = nil, 
        spellid = 22812, --barskin
        size = 30,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -165, y = 10},
        unit = "player",
        ismine = true,
        desaturate = true,
		move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0,          
          },
        },
      },
      [4] = {
        spec = nil, 
        spellid = 52610, --rugissement
        size = 42, 
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -160, y = -20},
        unit = "player",
        ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0.6,          
          },
        },
      },
      
      [5] = {
        spec = nil, 
        spellid = 14202, --enrage
        size = 30, 
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 150 },
        unit = "player",
        ismine = true,
        desaturate = true,
		move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0,          
          },
        },
      },
      [6] = {
        spec = nil, 
        spellid = 81022, --rué
        size = 30, 
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 160, y = 0 },
        unit = "player",
        ismine = true,
        desaturate = true,
		move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0,          
          },
        },
      },
      [7] = {
        spec = nil, 
        spellid = 12964, --deathwish
        size = 50, 
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 190 },
        unit = "player",
        ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0,          
          },
        },
      },
--]]

	 	  	   --reminder


	  [2] = {
        spec = nil, 
        spellid = 20217, --Total Stats
		spelllist = {
          [1] = 1126, -- "Mark of the wild"
          [2] = 90363, --"Embrace of the Shale Spider"
          [3] = 20217, --"Greater Blessing of Kings",
          
        },
		size = 26, 
        pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -8, y = 100},
        unit = "player",
        --ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	   
	  [3] = {
        spec = nil, 
        spellid = 21562 ,
		spelllist = {--Total Stamina
          [1] = 469,  -- Commanding
          [2] = 6307,  -- Blood Pact
          [3] = 90364,  -- Qiraji Fortitude
		  [4] = 72590,  -- Drums of fortitude
		  [5] = 21562,  -- Fortitude
          
        },
		size = 26, 
		pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -8, y = 74},
        unit = "player",
       -- ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	 
	  [4] = {
        spec = nil, 
        spellid =  61316 ,
		spelllist = {--Total Mana
          [1] = 61316,  --"Dalaran Brilliance"
          [2] = 1459,  --"Arcane Brilliance"
         
        },
		size = 26, 
       pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -8, y = 48},
        unit = "player",
    --  ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	  
	  [5] = {
        spec = nil, 
        spellid =  19740, --Total AP
		spelllist = {--Total Stamina
          [1] = 19740, --"Blessing of Might" placing it twice because i like the icon better :D code will stop after this one is read, we want this first 
          [2] = 30808, --"Unleashed Rage"
          [3] = 19506, --Trushot
		  [4] = 19740, --"Blessing of Might"
		 -- [5] = 469, --"Command Shot"
          
        },
		size = 26, 
      pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -8, y = 22},
        unit = "player",
       -- ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	  
	  
	   [6] = {
        spec = nil, 
        spellid =  79471, --Flask
		spelllist = {
          [1] = 79471, --Agi
          [2] = 79472, --Str
          [3] = 79470, --Int
		  [4] = 94160, --Mana
		  [5] = 79469, --Stam
		  [6] = 79637, --Mixology
          
        },
		size = 26, 
       pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -8, y = -4},
        unit = "player",
       -- ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	  
	  [7] = {
        spec = nil, 
        spellid =  57111, --well feed
		size = 26, 
       pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -8, y = -30},
        unit = "player",
        ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	  
	  
	  [8] = {
        spec = nil, 
        spellid = 6673, --battle shout
        spelllist = {
          [1] = 6673,
          [2] = 57330,
          [3] = 8076,
          [4] = 93435,
        },
        size = 26,
       -- pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 100, y = 107 },
		pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -8, y = -56},
        unit            = "player",
        ismine          = false,
        desaturate      = true,
        match_spellid   = false,
        move_ingame     = false,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	  
      
    }
    


		
    --Debuff List
    
    cfg.rf3_DebuffList = {
     --[[ [1] = {
        spec = nil, 
        spellid = 91565, --lucioles
        spelllist = { --check a list instead because other classes can do the same
          [1] = 91565,
          [2] = 58567,
          [3] = 8647,
          [4] = 95467,
          [5] = 95466,
        },
        size          = 42,
        pos           = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 180, y = -20},
        unit          = "target",
        validate_unit = true, --only show the icon if unit is found
        hide_ooc      = true, --hide icon out of combat
        ismine        = false,
        desaturate    = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
      [2] = {
        spec = nil, 
        spellid = 33876, --mangle feral
        spelllist = { --check a list instead because other classes can do the same
          [1] = 33876, --cat
          [2] = 16511, 
          [3] = 46857,
		  [4] = 33878, --bear
        },
        size = 42,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 222, y = -20},
        unit = "target",
        validate_unit = true, --only show the icon if unit is found
        hide_ooc      = true, --hide icon out of combat
        ismine = false,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	  [3] = {
        spec = 1, --only in cat
        spellid = 1822, --rake
        --spelllist = { --check a list instead because other classes can do the same
        --  [1] = 33876,
        --  [2] = 16511, 
        --  [3] = 46857,
        --},
        size = 42,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 264, y = -20},
        unit = "target",
        validate_unit = true, --only show the icon if unit is found
        hide_ooc      = true, --hide icon out of combat
        ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	  [4] = {
        spec = 1, --only in cat
        spellid = 1079, --rip
        --spelllist = { --check a list instead because other classes can do the same
        --  [1] = 33876,
        --  [2] = 16511, 
        --  [3] = 46857,
        --},
        size = 42,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 306, y = -20},
        unit = "target",
        validate_unit = true, --only show the icon if unit is found
        hide_ooc      = true, --hide icon out of combat
        ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	  
	  [5] = {
        spec = 2, --only in bear
        spellid = 33745, --lacerate
        --spelllist = { --check a list instead because other classes can do the same
        --  [1] = 33876,
        --  [2] = 16511, 
        --  [3] = 46857,
        --},
        size = 42,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 306, y = -20},
        unit = "target",
        validate_unit = true, --only show the icon if unit is found
        hide_ooc      = true, --hide icon out of combat
        ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	  
	  
	  [6] = {
        spec = 2, --only in bear
        spellid = 99, --demo roar
        --spelllist = { --check a list instead because other classes can do the same
        --  [1] = 33876,
        --  [2] = 16511, 
        --  [3] = 46857,
        --},
        size = 42,
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 264, y = -20},
        unit = "target",
        validate_unit = true, --only show the icon if unit is found
        hide_ooc      = true, --hide icon out of combat
        ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	  --]]
	}
  
  --Cooldown List
    cfg.rf3_CooldownList = {
    --[[  [1] = {
        spec = nil, 
        spellid = 49376, --stampede
		pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 222, y = -50},
        size = 26,
		hide_ooc      = true, --hide icon out of combat
        desaturate = true,
		move_ingame     = true,
        alpha = {
          cooldown = {
            frame = 1,
            icon = 0.6,
          },
          no_cooldown = {
            frame = 1,
            icon = 1,          
          },
        },
      },
      
      [2] = {
        spec = nil, 
        spellid = 80965, --kick
		spelllist = { --check a list instead because other classes can do the same
          [1] = 80965,
          [2] = 80964, 
		},
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 222, y = -80},
        size = 26,
		hide_ooc      = true, --hide icon out of combat
        desaturate = true,
		move_ingame     = true,
        alpha = {
          cooldown = {
            frame = 1,
            icon = 0.6,
          },
          no_cooldown = {
            frame = 1,
            icon = 1,          
          },
        },
      },
	  --]]
	[1] = {
        spec = nil, 
        spellid = 740, --tranqui
		spelllist = { --check a list instead because other classes can do the same
          [1] = 740,
           
		},
        pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -7, y = -88},
        size = 28,
		hide_ooc      = false, --hide icon out of combat
        desaturate = true,
        alpha = {
          cooldown = {
            frame = 1,
            icon = 0.6,
          },
          no_cooldown = {
            frame = 1,
            icon = 1,          
          },
        },
      },
	  
	  
	  [2] = {
        spec = nil, 
        spellid = 29166, --innerv
		spelllist = { --check a list instead because other classes can do the same
          [1] = 29166,
           
		},
        pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -7, y = -118},
        size = 28,
		hide_ooc      = false, --hide icon out of combat
        desaturate = true,
        alpha = {
          cooldown = {
            frame = 1,
            icon = 0.6,
          },
          no_cooldown = {
            frame = 1,
            icon = 1,          
          },
        },
      },
	  
	  
	  [3] = {
        spec = nil, 
        spellid = 20484, --innerv
		spelllist = { --check a list instead because other classes can do the same
          [1] = 20484,
           
		},
        pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -7, y = -148},
        size = 28,
		hide_ooc      = false, --hide icon out of combat
        desaturate = true,
        alpha = {
          cooldown = {
            frame = 1,
            icon = 0.6,
          },
          no_cooldown = {
            frame = 1,
            icon = 1,          
          },
        },
      },
}
    
  end
  
  if player_name == "Pywa" and player_class == "SHAMAN" then
    cfg.rf3_CooldownList = {
      [1] = {
        spec = nil, 
        spellid = 20608, --Ankh
		pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -8, y = -88},
        size = 26,
		hide_ooc      = false, --hide icon out of combat
        desaturate = true,
        alpha = {
          cooldown = {
            frame = 1,
            icon = 0.6,
          },
          no_cooldown = {
            frame = 1,
            icon = 1,          
          },
        },
      },
	  
	[2] = {
        spec = nil, 
        spellid = 16190, --manatide
		spelllist = { --check a list instead because other classes can do the same
          [1] = 16190,
           
		},
        pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -8, y = -118},
        size = 28,
		hide_ooc      = false, --hide icon out of combat
        desaturate = true,
        alpha = {
          cooldown = {
            frame = 1,
            icon = 0.6,
          },
          no_cooldown = {
            frame = 1,
            icon = 1,          
          },
        },
      },
	  
	 	  	   --reminder


	  [7] = {
        spec = nil, 
        spellid = 20217, --Total Stats
		spelllist = {
          [1] = 1126, -- "Mark of the wild"
          [2] = 90363, --"Embrace of the Shale Spider"
          [3] = 20217, --"Greater Blessing of Kings",
          
        },
		size = 26, 
        pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -8, y = 100},
        unit = "player",
        --ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	   
	  [8] = {
        spec = nil, 
        spellid = 21562 ,
		spelllist = {--Total Stamina
          [1] = 469,  -- Commanding
          [2] = 6307,  -- Blood Pact
          [3] = 90364,  -- Qiraji Fortitude
		  [4] = 72590,  -- Drums of fortitude
		  [5] = 21562,  -- Fortitude
          
        },
		size = 26, 
		pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -8, y = 74},
        unit = "player",
       -- ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	 
	  [9] = {
        spec = nil, 
        spellid =  61316 ,
		spelllist = {--Total Mana
          [1] = 61316,  --"Dalaran Brilliance"
          [2] = 1459,  --"Arcane Brilliance"
         
        },
		size = 26, 
       pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -8, y = 48},
        unit = "player",
    --  ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	  
	  [10] = {
        spec = nil, 
        spellid =  19740, --Total AP
		spelllist = {--Total Stamina
          [1] = 19740, --"Blessing of Might" placing it twice because i like the icon better :D code will stop after this one is read, we want this first 
          [2] = 30808, --"Unleashed Rage"
          [3] = 19506, --Trushot
		  [4] = 19740, --"Blessing of Might"
		  --[5] = 469, --"Command Shot"
          
        },
		size = 26, 
      pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -8, y = 22},
        unit = "player",
       -- ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	  
	  
	   [11] = {
        spec = nil, 
        spellid =  79471, --Flask
		spelllist = {
          [1] = 79471, --Agi
          [2] = 79472, --Str
          [3] = 79470, --Int
		  [4] = 94160, --Mana
		  [5] = 79469, --Stam
		  [6] = 79637, --Mixology
          
        },
		size = 26, 
       pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -8, y = -4},
        unit = "player",
       -- ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	  
	  [12] = {
        spec = nil, 
        spellid =  57111, --well feed
		size = 26, 
       pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -8, y = -30},
        unit = "player",
        ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	  
	  
	  [13] = {
        spec = nil, 
        spellid = 6673, --battle shout
        spelllist = {
          [1] = 6673,
          [2] = 57330,
          [3] = 8076,
          [4] = 93435,
        },
        size = 26,
       -- pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 100, y = 107 },
		pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -8, y = -56},
        unit            = "player",
        ismine          = false,
        desaturate      = true,
        match_spellid   = false,
        move_ingame     = false,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	 }
  end
  
   if player_class == "WARRIOR" then
    --Rothars Buff List  
    cfg.rf3_BuffList = {
     --[[ [1] = {
        spec = nil, 
        spellid = 469, --commanding shout
        spelllist = {
          [1] = 469,
          [2] = 79105,
          [3] = 6307,
          [4] = 90364,
        },
        size = 26,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 130, y = 107 },
		
        unit = "player",
        validate_unit   = true,
        ismine          = false,
        desaturate      = true,
        match_spellid   = false,
        move_ingame     = false,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },--]]
      
      [1] = {
        spec            = 1, 
        spellid         = 2565, --shield block
        size            = 26, 
        pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -130, y = 138 },
        unit            = "player",
        ismine          = true,
        desaturate      = true,
        match_spellid   = false,
        move_ingame     = true,
        alpha           = {
          found = {
            frame       = 1,
            icon        = 1,
          },
          not_found = {
            frame       = 0,
            icon        = 0.6,          
          },
        },
      },
      [2] = {
        spec = 1, 
        spellid = 87096, --thunderclap dps boost
        size = 26, 
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -100, y = 138 },
        unit = "player",
        ismine = true,
        desaturate = true,
        move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0.6,          
          },
        },
      },
      [3] = {
        spec = 2, 
        spellid = 60503, --overpower
        size = 60, 
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent",x = 0, y = -100},
        unit = "player",
        ismine = true,
        desaturate = true,
        move_ingame     = false,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0,          
          },
        },
      },
	  
	  [4] = {
        spec = nil, 
        spellid = 12294, --test
        size = 42, 
        pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -160, y = 60},
        unit = "player",
        ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0.6,          
          },
        },
      },
	  
	 
	 	  	   --reminder


	  [5] = {
        spec = nil, 
        spellid = 20217, --Total Stats
		spelllist = {
          [1] = 1126, -- "Mark of the wild"
          [2] = 90363, --"Embrace of the Shale Spider"
          [3] = 20217, --"Greater Blessing of Kings",
          
        },
		size = 26, 
        pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -8, y = 100},
        unit = "player",
        --ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	   
	  [6] = {
        spec = nil, 
        spellid = 21562 ,
		spelllist = {--Total Stamina
          [1] = 469,  -- Commanding
          [2] = 6307,  -- Blood Pact
          [3] = 90364,  -- Qiraji Fortitude
		  [4] = 72590,  -- Drums of fortitude
		  [5] = 21562,  -- Fortitude
          
        },
		size = 26, 
		pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -8, y = 74},
        unit = "player",
       -- ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	 
	  [7] = {
        spec = nil, 
        spellid =  61316 ,
		spelllist = {--Total Mana
          [1] = 61316,  --"Dalaran Brilliance"
          [2] = 1459,  --"Arcane Brilliance"
         
        },
		size = 26, 
       pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -8, y = 48},
        unit = "player",
    --  ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	  
	  [8] = {
        spec = nil, 
        spellid =  19740, --Total AP
		spelllist = {--Total Stamina
          [1] = 19740, --"Blessing of Might" placing it twice because i like the icon better :D code will stop after this one is read, we want this first 
          [2] = 30808, --"Unleashed Rage"
          [3] = 19506, --Trushot
		  [4] = 19740, --"Blessing of Might"
		 -- [5] = 469, --"Command Shot"
		  
          
        },
		size = 26, 
      pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -8, y = 22},
        unit = "player",
       -- ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	  
	  
	   [9] = {
        spec = nil, 
        spellid =  79471, --Flask
		spelllist = {
          [1] = 79471, --Agi
          [2] = 79472, --Str
          [3] = 79470, --Int
		  [4] = 94160, --Mana
		  [5] = 79469, --Stam
		  [6] = 79637, --Mixology
          
        },
		size = 26, 
       pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -8, y = -4},
        unit = "player",
       -- ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	  
	  [10] = {
        spec = nil, 
        spellid =  57111, --well feed
		size = 26, 
       pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -8, y = -30},
        unit = "player",
        ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 0.6,
            icon = 0.8,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	  
	  [11] = {
        spec = nil, 
        spellid = 6673, --battle shout
        spelllist = {
          [1] = 6673,
          [2] = 57330,
          [3] = 8076,
          [4] = 93435,
        },
        size = 26,
       -- pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 100, y = 107 },
		pos = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -8, y = -56},
        unit            = "player",
        ismine          = false,
        desaturate      = true,
        match_spellid   = false,
        move_ingame     = false,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },

	  
	  
      
    }
    
    --Rothars Debuff List
    
    cfg.rf3_DebuffList = {
      [1] = {
        spec = nil, 
        spellid = 58567, --sunder armor
        spelllist = {
          [1] = 58567,
          [2] = 91565,
          [3] = 8647,
          [4] = 95467,
          [5] = 95466,
        },
        size          = 26,
        pos           = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -130, y = 107},
        unit          = "target",
        validate_unit = true,
        hide_ooc      = true,
        ismine        = false,
        desaturate    = true,
        move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	  --
	   [2] = {
        spec = nil, 
        spellid = 12294, --test
       -- spelllist = { --check a list instead because other classes can do the same

       -- },
        size          = 42,
        pos           = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 180, y = -20},
        unit          = "target",
        validate_unit = true, --only show the icon if unit is found
        hide_ooc      = true, --hide icon out of combat
        ismine        = false,
        desaturate    = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	  --
	  
	  
      [3] = {
        spec = nil, 
        spellid = 6343, --thunderclap
        spelllist = {
          [1] = 6343,
          [2] = 55095,
          [3] = 58180,
          [4] = 68055,
          [5] = 8042,
          [6] = 90315,
          [7] = 54404,
        },
        size = 26,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -100, y = 107 },
        unit = "target",
        validate_unit = true,
        hide_ooc      = true,
        ismine = false,
        desaturate = true,
        move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
      [4] = {
        spec = nil, 
        spellid = 1160, --demo shout
        spelllist = {
          [1] = 1160,
          [2] = 81130,
          [3] = 99,
          [4] = 26017,
          [5] = 702,
          [6] = 50256,
          [7] = 24423,
        },
        size = 26,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -40, y = 107 },
        unit = "target",
        validate_unit = true,
        hide_ooc      = true,
        ismine = false,
        desaturate = true,
        move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
      [5] = {
        spec = nil, 
        spellid = 772, --rend
        size = 26,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -70, y = 107 },
        unit = "target",
        validate_unit = true,
        hide_ooc      = true,
        ismine = true,
        desaturate = true,
        move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
      [6] = {
        spec            = 2, 
        spellid         = 86346, --colossus smash
        size            = 50, 
        pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -117, y = 142 },
        unit            = "target",
        validate_unit   = true,
        hide_ooc        = true,
        ismine          = true,
        desaturate      = true,
        move_ingame     = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0,          
          },
        },
      },

    }
  
  --Rothars Cooldown List
    cfg.rf3_CooldownList = {
      [1] = {
        spec = nil, 
        spellid = 100, --charge
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 70, y = 107 },
        size = 26,
        desaturate = true,
        move_ingame     = true,
        alpha = {
          cooldown = {
            frame = 1,
            icon = 0.6,
          },
          no_cooldown = {
            frame = 1,
            icon = 1,          
          },
        },
      },
      --[[
      [2] = {
        spec = nil, 
        spellid = 20252, --intercept
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 70, y = 107 },
        size = 26,
        desaturate = true,
        move_ingame     = true,
        alpha = {
          cooldown = {
            frame = 1,
            icon = 0.6,
          },
          no_cooldown = {
            frame = 1,
            icon = 1,          
          },
        },
      },
      ]]--
    }
    
  end
  
  -----------------------------
  -- HANDOVER
  -----------------------------
  
  --object container to addon namespace
  ns.cfg = cfg