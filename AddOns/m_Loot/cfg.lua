  local addon, ns = ...
  local cfg = CreateFrame("Frame")

  -----------------------------
  -- MEDIA
  -----------------------------
  local MediaPath = "Interface\\AddOns\\m_Loot\\media\\"
  
  cfg.bartex =		MediaPath.."statusbar"		
  cfg.bordertex =	MediaPath.."icon_clean"	
  cfg.fontn =		"Interface\\Addons\\QulightUI\\media\\1.ttf"	
  cfg.closebtex =	MediaPath.."black-close"
  cfg.edgetex = 	"Interface\\Tooltips\\UI-Tooltip-Border"
  cfg.loottex =		"Interface\\QuestFrame\\UI-QuestLogTitleHighlight"
  
  -----------------------------
  -- CONFIG
  -----------------------------
  cfg.iconsize = 28 					-- loot frame icon's size
  cfg.roll_iconsize = 33 				-- group loot frames icon size
  cfg.position = {"RIGHT", -25, 0}  	-- roll frames positioning
  cfg.suppress_loot_spam = false			-- suppress group loot spam in chat window if detailed loot info enabled
  cfg.bar_width = 250					-- group roll bar width
  cfg.bar_height = 25					-- group roll bar height
  
  -- HANDOVER
  ns.cfg = cfg
