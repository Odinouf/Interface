local addon, ns = ...
local cfg = CreateFrame("Frame")
 
cfg.font = "Interface\\Addons\\QulightUI\\media\\1.ttf"	-- font
cfg.fontsize = 11					-- font size
cfg.fontstyle = "OUTLINE"			-- font style

cfg.frame1_pos = {"CENTER", "UIParent", "CENTER", -220, 0}	-- incoming healing frame position
cfg.frame2_pos = {"CENTER", "UIParent", "CENTER", -250, 0}	-- incoming damage frame position
cfg.frame3_pos = {"RIGHT", "UIParent", "RIGHT", -43, -90}	-- outgoing damage/healing frame position

cfg.show_damage = true				-- enable outgoing damage combat text display
cfg.show_healing = true				-- enable outgoing healing combat text display

cfg.time_to_fade = 6				-- time till text disappears
cfg.show_icons = true				-- enable icons display for outgoing damage/healing frame
cfg.iconsize = 20					-- icon size
cfg.show_overhealing = true			-- display outgoing overhealing in a specific format 'EFFECTIVE_HEALING (OVERHEALING)'

cfg.heal_threshold = 1				-- the minimum ammount of healing done to display
cfg.damage_threshold = 1			-- the minimum ammount of damage done to display
cfg.heal_threshold_85 = 4000		-- different healing threshold for level 85 players
cfg.damage_threshold_85 = 5000		-- different damage threshold for level 85 players

cfg.merge_aoe_spam = true			-- merge multiple damage/healing events happening simultaniously in a single message
cfg.merge_aoe_time = 3				-- set the delay in seconds for calculating merged values 
									-- (0 means that only events that happened at exactly the same time will be merged)

ns.cfg = cfg