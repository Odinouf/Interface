-- credits : Aezay (TipTac) and Caellian for some parts of code.
if not Qulight["tooltip"].enable then return end

local Tooltip = CreateFrame("Frame", "Tooltip", UIParent)

local _G = getfenv(0)

local GameTooltip, GameTooltipStatusBar = _G["GameTooltip"], _G["GameTooltipStatusBar"]

local gsub, find, format = string.gsub, string.find, string.format

local Tooltips = {GameTooltip,ShoppingTooltip1,ShoppingTooltip2,ShoppingTooltip3,WorldMapTooltip}
local ItemRefTooltip = ItemRefTooltip

local linkTypes = {item = true, enchant = true, spell = true, quest = true, unit = true, talent = true, achievement = true, glyph = true}

local classification = {
	worldboss = "|cffAF5050Boss|r",
	rareelite = "|cffAF5050+ Rare|r",
	elite = "|cffAF5050+|r",
	rare = "|cffAF5050Rare|r",
}

local NeedBackdropBorderRefresh = true

local anchor = CreateFrame("Frame", "TooltipAnchor", UIParent)
anchor:SetSize(160, 160)
anchor:SetFrameStrata("TOOLTIP")
anchor:SetFrameLevel(20)
anchor:SetClampedToScreen(true)
anchor:SetAlpha(0)
anchor:SetPoint("TOPRIGHT", minimaplol)

AnchorTooltips = CreateFrame("Frame","Move_Tooltip",UIParent)
AnchorTooltips:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -5, 145)
CreateAnchor(AnchorTooltips, "Move tooltips", 100, 70)

frame1px(anchor)
CreateShadow(anchor)
anchor:SetBackdropBorderColor(1, 0, 0, 1)
anchor:SetMovable(true)
anchor.text = SetFontString(anchor, Qulight["media"].font, 10)
anchor.text:SetPoint("CENTER")
anchor.text:SetText("Move Tooltip")

-- Also used because on Eyefinity, SetClampedToScreen doesn't work on left and right side of screen #1
local function UpdateTooltip(self)
	local owner = self:GetOwner()
	if not owner then return end	
	local name = owner:GetName()
	
	-- fix X-offset or Y-offset
	local x = 5
	
	-- mouseover
	if self:GetAnchorType() == "ANCHOR_CURSOR" then
		-- h4x for world object tooltip border showing last border color 
		-- or showing background sometime ~blue :x		
		if NeedBackdropBorderRefresh then
			NeedBackdropBorderRefresh = false			
			self:SetBackdropColor(unpack(Qulight["media"].backdropcolor))
			if not Qulight["tooltip"].cursor then
				self:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor))
			end
		end
	elseif self:GetAnchorType() == "ANCHOR_NONE" and InCombatLockdown() and Qulight["tooltip"].hidecombat == true then
		self:Hide()
	end
			
	if self:GetAnchorType() == "ANCHOR_NONE" and TooltipAnchor then
		local point = TooltipAnchor:GetPoint()
		if point == "TOPLEFT" then
			self:ClearAllPoints()
			self:SetPoint("TOPLEFT",TooltipAnchor, "BOTTOMLEFT", 0, -x)			
		elseif point == "TOP" then
			self:ClearAllPoints()
			self:SetPoint("TOP", TooltipAnchor, "BOTTOM", 0, -x)			
		elseif point == "TOPRIGHT" then
			self:ClearAllPoints()
			self:SetPoint("BOTTOMRIGHT", AnchorTooltips)		
		elseif point == "BOTTOMLEFT" or point == "LEFT" then
			self:ClearAllPoints()
			self:SetPoint("BOTTOMLEFT", TooltipAnchor, "TOPLEFT", 0, x)		
		elseif point == "BOTTOMRIGHT" or point == "RIGHT" then
			self:ClearAllPoints()
			self:SetPoint("BOTTOMRIGHT", TooltipAnchor, "TOPRIGHT", -1, -70)
		else
			self:ClearAllPoints()
			self:SetPoint("BOTTOM", TooltipAnchor, "TOP", 0, x)		
		end
	end
end

hooksecurefunc("GameTooltip_SetDefaultAnchor", function(self, parent)
	if Qulight["tooltip"].cursor == true then
		self:SetOwner(parent, "ANCHOR_CURSOR")
	else
		self:SetOwner(parent, "ANCHOR_NONE")
	end
end)

GameTooltip:HookScript("OnUpdate", function(self, ...) UpdateTooltip(self) end)

local function Hex(color)
	return string.format('|cff%02x%02x%02x', color.r * 255, color.g * 255, color.b * 255)
end

local function GetColor(unit)
	if(UnitIsPlayer(unit) and not UnitHasVehicleUI(unit)) then
		local _, class = UnitClass(unit)
		local color = RAID_CLASS_COLORS[class]
		if not color then return end -- sometime unit too far away return nil for color :(
		local r,g,b = color.r, color.g, color.b
		return Hex(color), r, g, b	
	else
		local color = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
		if not color then return end -- sometime unit too far away return nil for color :(
		local r,g,b = color.r, color.g, color.b		
		return Hex(color), r, g, b		
	end
end

-- function to short-display HP value on StatusBar
local function ShortValue(value)
	if value >= 1e7 then
		return ('%.1fm'):format(value / 1e6):gsub('%.?0+([km])$', '%1')
	elseif value >= 1e6 then
		return ('%.2fm'):format(value / 1e6):gsub('%.?0+([km])$', '%1')
	elseif value >= 1e5 then
		return ('%.0fk'):format(value / 1e3)
	elseif value >= 1e3 then
		return ('%.1fk'):format(value / 1e3):gsub('%.?0+([km])$', '%1')
	else
		return value
	end
end

-- update HP value on status bar
GameTooltipStatusBar:SetScript("OnValueChanged", function(self, value)
	if not value then
		return
	end
	local min, max = self:GetMinMaxValues()
	
	if (value < min) or (value > max) then
		return
	end
	local _, unit = GameTooltip:GetUnit()
	
	-- fix target of target returning nil
	if (not unit) then
		local GMF = GetMouseFocus()
		unit = GMF and GMF:GetAttribute("unit")
	end

	if not self.text then
		self.text = self:CreateFontString(nil, "OVERLAY")
		local position = TooltipAnchor:GetPoint()
		if position:match("TOP") then
			self.text:SetPoint("CENTER", GameTooltipStatusBar, 0, 0)
		else
			self.text:SetPoint("CENTER", GameTooltipStatusBar, 0, 0)
		end
		
		self.text:SetFont(Qulight["media"].font, 10, "OUTLINE")
		self.text:Show()
		if unit then
			min, max = UnitHealth(unit), UnitHealthMax(unit)
			local hp = ShortValue(min).." / "..ShortValue(max)
			if UnitIsGhost(unit) then
				self.text:SetText("Ghost")
			elseif min == 0 or UnitIsDead(unit) or UnitIsGhost(unit) then
				self.text:SetText("Dead")
			else
				self.text:SetText(hp)
			end
		end
	else
		if unit then
			min, max = UnitHealth(unit), UnitHealthMax(unit)
			self.text:Show()
			local hp = ShortValue(min).." / "..ShortValue(max)
			if UnitIsGhost(unit) then
				self.text:SetText("Ghost")
			elseif min == 0 or UnitIsDead(unit) or UnitIsGhost(unit) then
				self.text:SetText("Dead")
			else
				self.text:SetText(hp)
			end
		else
			self.text:Hide()
		end
	end
end)

local healthBar = GameTooltipStatusBar
healthBar:ClearAllPoints()
healthBar:SetHeight(5)
healthBar:SetPoint("BOTTOMLEFT", healthBar:GetParent(), "TOPLEFT", 2, 5)
healthBar:SetPoint("BOTTOMRIGHT", healthBar:GetParent(), "TOPRIGHT", -2, 5)
healthBar:SetStatusBarTexture(Qulight["media"].texture)

local healthBarBG = CreateFrame("Frame", "StatusBarBG", healthBar)
healthBarBG:SetFrameLevel(healthBar:GetFrameLevel() - 1)
healthBarBG:SetPoint("TOPLEFT", -2, 2)
healthBarBG:SetPoint("BOTTOMRIGHT", 2, -2)
frame1px(healthBarBG)
CreateShadow(healthBarBG)

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	local lines = self:NumLines()
	local GMF = GetMouseFocus()
	local unit = (select(2, self:GetUnit())) or (GMF and GMF:GetAttribute("unit"))
	
	-- A mage's mirror images sometimes doesn't return a unit, this would fix it
	if (not unit) and (UnitExists("mouseover")) then
		unit = "mouseover"
	end
	
	-- Sometimes when you move your mouse quicky over units in the worldframe, we can get here without a unit
	if not unit then self:Hide() return end
	
	-- for hiding tooltip on unitframes
	if (self:GetOwner() ~= UIParent and Qulight["tooltip"].hideuf) then self:Hide() return end
	
	-- A "mouseover" unit is better to have as we can then safely say the tip should no longer show when it becomes invalid.
	if (UnitIsUnit(unit,"mouseover")) then
		unit = "mouseover"
	end

	local race = UnitRace(unit)
	local class = UnitClass(unit)
	local level = UnitLevel(unit)
	local guild = GetGuildInfo(unit)
	local name, realm = UnitName(unit)
	local crtype = UnitCreatureType(unit)
	local classif = UnitClassification(unit)
	local title = UnitPVPName(unit)
	local r, g, b = GetQuestDifficultyColor(level).r, GetQuestDifficultyColor(level).g, GetQuestDifficultyColor(level).b

	local color = GetColor(unit)	
	if not color then color = "|CFFFFFFFF" end -- just safe mode for when GetColor(unit) return nil for unit too far away

	_G["GameTooltipTextLeft1"]:SetFormattedText("%s%s%s", color, title or name, realm and realm ~= "" and " - "..realm.."|r" or "|r")

	if title then
        local text = GameTooltipTextLeft1:GetText()
        title = title:gsub(name, "")
        text = text:gsub(title, "")
        if text then GameTooltipTextLeft1:SetText(text) end
    end
	
	if(UnitIsPlayer(unit)) then
		if UnitIsAFK(unit) then
			self:AppendText((" %s"):format(CHAT_FLAG_AFK))
		elseif UnitIsDND(unit) then 
			self:AppendText((" %s"):format(CHAT_FLAG_DND))
		end

		local offset = 2
		if guild then
			_G["GameTooltipTextLeft2"]:SetFormattedText("%s", IsInGuild() and GetGuildInfo("player") == guild and "|cff0090ff"..guild.."|r" or "|cff00ff10"..guild.."|r")
			offset = offset + 1
		end

		for i= offset, lines do
			if(_G["GameTooltipTextLeft"..i]:GetText():find("^"..LEVEL)) then
				_G["GameTooltipTextLeft"..i]:SetFormattedText("|cff%02x%02x%02x%s|r %s %s%s", r*255, g*255, b*255, level > 0 and level or "??", race, color, class.."|r")
				break
			end
		end
	else
		for i = 2, lines do
			if((_G["GameTooltipTextLeft"..i]:GetText():find("^"..LEVEL)) or (crtype and _G["GameTooltipTextLeft"..i]:GetText():find("^"..crtype))) then
				if level == -1 and classif == "elite" then classif = "worldboss" end
				_G["GameTooltipTextLeft"..i]:SetFormattedText("|cff%02x%02x%02x%s|r%s %s", r*255, g*255, b*255, classif ~= "worldboss" and level ~= 0 and level or "", classification[classif] or "", crtype or "")
				break
			end
		end
	end

	local pvpLine
	for i = 1, lines do
		local text = _G["GameTooltipTextLeft"..i]:GetText()
		if text and text == PVP_ENABLED then
			pvpLine = _G["GameTooltipTextLeft"..i]
			pvpLine:SetText()
			break
		end
	end

	-- ToT line
	if UnitExists(unit.."target") and unit~="player" then
		local hex, r, g, b = GetColor(unit.."target")
		if not r and not g and not b then r, g, b = 1, 1, 1 end
		GameTooltip:AddLine(UnitName(unit.."target"), r, g, b)
	end
	
	-- Sometimes this wasn't getting reset, the fact a cleanup isn't performed at this point, now that it was moved to "OnTooltipCleared" is very bad, so this is a fix
	self.fadeOut = nil
end)
oUF_colors = setmetatable({
	tapped = {0.55, 0.57, 0.61},
	disconnected = {0.84, 0.75, 0.65},
	power = setmetatable({
		["MANA"] = {0.31, 0.45, 0.63},
		["RAGE"] = {0.69, 0.31, 0.31},
		["FOCUS"] = {0.71, 0.43, 0.27},
		["ENERGY"] = {0.65, 0.63, 0.35},
		["RUNES"] = {0.55, 0.57, 0.61},
		["RUNIC_POWER"] = {0, 0.82, 1},
		["AMMOSLOT"] = {0.8, 0.6, 0},
		["FUEL"] = {0, 0.55, 0.5},
		["POWER_TYPE_STEAM"] = {0.55, 0.57, 0.61},
		["POWER_TYPE_PYRITE"] = {0.60, 0.09, 0.17},
	}, {__index = oUF.colors.power}),
	happiness = setmetatable({
		[1] = {.69,.31,.31},
		[2] = {.65,.63,.35},
		[3] = {.33,.59,.33},
	}, {__index = oUF.colors.happiness}),
	runes = setmetatable({
			[1] = {.69,.31,.31},
			[2] = {.33,.59,.33},
			[3] = {.31,.45,.63},
			[4] = {.84,.75,.65},
	}, {__index = oUF.colors.runes}),
	reaction = setmetatable({
		[1] = { 222/255, 95/255,  95/255 }, -- Hated
		[2] = { 222/255, 95/255,  95/255 }, -- Hostile
		[3] = { 222/255, 95/255,  95/255 }, -- Unfriendly
		[4] = { 218/255, 197/255, 92/255 }, -- Neutral
		[5] = { 75/255,  175/255, 76/255 }, -- Friendly
		[6] = { 75/255,  175/255, 76/255 }, -- Honored
		[7] = { 75/255,  175/255, 76/255 }, -- Revered
		[8] = { 75/255,  175/255, 76/255 }, -- Exalted	
	}, {__index = oUF.colors.reaction}),
	class = setmetatable({
		["DEATHKNIGHT"] = { 196/255,  30/255,  60/255 },
		["DRUID"]       = { 255/255, 125/255,  10/255 },
		["HUNTER"]      = { 171/255, 214/255, 116/255 },
		["MAGE"]        = { 104/255, 205/255, 255/255 },
		["PALADIN"]     = { 245/255, 140/255, 186/255 },
		["PRIEST"]      = { 212/255, 212/255, 212/255 },
		["ROGUE"]       = { 255/255, 243/255,  82/255 },
		["SHAMAN"]      = {  41/255,  79/255, 155/255 },
		["WARLOCK"]     = { 148/255, 130/255, 201/255 },
		["WARRIOR"]     = { 199/255, 156/255, 110/255 },
	}, {__index = oUF.colors.class}),
}, {__index = oUF.colors})

local BorderColor = function(self)
	local GMF = GetMouseFocus()
	local unit = (select(2, self:GetUnit())) or (GMF and GMF:GetAttribute("unit"))
		
	local reaction = unit and UnitReaction(unit, "player")
	local player = unit and UnitIsPlayer(unit)
	local tapped = unit and UnitIsTapped(unit)
	local tappedbyme = unit and UnitIsTappedByPlayer(unit)
	local connected = unit and UnitIsConnected(unit)
	local dead = unit and UnitIsDead(unit)

	if player then
		local class = select(2, UnitClass(unit))
		local c = oUF_colors.class[class]
		r, g, b = c[1], c[2], c[3]
		healthBar:SetStatusBarColor(r, g, b)
	elseif reaction then
		local c = oUF_colors.reaction[reaction]
		r, g, b = c[1], c[2], c[3]
		healthBar:SetStatusBarColor(r, g, b)
	else
		local _, link = self:GetItem()
		local quality = link and select(3, GetItemInfo(link))
		if quality and quality >= 2 then
			local r, g, b = GetItemQualityColor(quality)
		else
			healthBar:SetStatusBarColor(unpack(Qulight["media"].bordercolor))
		end
	end
	
	-- need this
	NeedBackdropBorderRefresh = true
end

local SetStyle = function(self)
	frame1px(self)
	CreateShadow(self)
	BorderColor(self)
end

Tooltip:RegisterEvent("PLAYER_ENTERING_WORLD")
Tooltip:SetScript("OnEvent", function(self)
	for _, tt in pairs(Tooltips) do
		tt:HookScript("OnShow", SetStyle)
	end
	
	ItemRefTooltip:HookScript("OnTooltipSetItem", SetStyle)
	ItemRefTooltip:HookScript("OnShow", SetStyle)	
	frame1px(FriendsTooltip)
		
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:SetScript("OnEvent", nil)
	
	-- move health status bar if anchor is found at top
	local position = TooltipAnchor:GetPoint()
	if position:match("BOTTOM") then
		healthBar:ClearAllPoints()
		healthBar:SetPoint("TOPLEFT", healthBar:GetParent(), "BOTTOMLEFT", 2, -5)
		healthBar:SetPoint("TOPRIGHT", healthBar:GetParent(), "BOTTOMRIGHT", -2, -5)
	end
	
	-- Hide tooltips in combat for actions, pet actions and shapeshift
	if Qulight["tooltip"].hidebuttons == true then
		local CombatHideActionButtonsTooltip = function(self)
			if not IsShiftKeyDown() then
				self:Hide()
			end
		end
	 
		hooksecurefunc(GameTooltip, "SetAction", CombatHideActionButtonsTooltip)
		hooksecurefunc(GameTooltip, "SetPetAction", CombatHideActionButtonsTooltip)
		hooksecurefunc(GameTooltip, "SetShapeshift", CombatHideActionButtonsTooltip)
	end
end)

----------------------------------------------------------------------------------------
--	Average item level(AiL by havoc74)
----------------------------------------------------------------------------------------
local MINCOLOR = 0.5
local COLORINC = 0.2
local INCMOD = 0.5
local MinIL = 284
local MaxIL = 372
	
local slotName = {
	"HeadSlot",	"NeckSlot",	"ShoulderSlot",	"BackSlot",	"ChestSlot", "WristSlot", 
	"HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot",
	"Trinket0Slot",	"Trinket1Slot",	"MainHandSlot",	"SecondaryHandSlot", "RangedSlot", "AmmoSlot"
}
	
local function GetAiL(unit)
	local i, total, slot, itn
	i = 0
	total = 0
	itn = 0
	local sName, sLink, iRarity, iLevel, iMinLevel, sType, sSubType, iStackCount
	
	for i in pairs(slotName) do
		slot = GetInventoryItemLink(unit, GetInventorySlotInfo(slotName[i]))
		if (slot ~= nil) then
			itn = itn + 1
			sName, sLink, iRarity, iLevel, iMinLevel, sType, sSubType, iStackCount = GetItemInfo(slot)
			total = total + iLevel
		end
	end
	
	if (total < 1 or itn < 1) then return 0 end
	
	return floor(total / itn)
end

local function GetAiLColor(ail)
	local r, gb
	
	if (ail < MinIL) then
		r = (ail / MinIL)
		gb = r
	else
		r = MINCOLOR + ((ail / MaxIL) * INCMOD)
		gb = 1.0 - ((ail / MaxIL) * INCMOD)
	end
	
	if (r < MINCOLOR) then
		r = MINCOLOR
		gb = r
	end
	
	return r, gb
end
	
local function Setup()
	GameTooltip:HookScript("OnTooltipSetUnit", function(self, ...)
		local ail, r, gb, d
		local _, unit = GameTooltip:GetUnit()
		if (unit and CanInspect(unit)) then
			local isInspectOpen = (InspectFrame and InspectFrame:IsShown()) or (Examiner and Examiner:IsShown())
			if ((unit) and (CanInspect(unit)) and (not isInspectOpen)) then
				NotifyInspect(unit)
				ail = GetAiL(unit)
				d = GetAiL(unit) - GetAiL("player")
				r, gb = GetAiLColor(ail)
				ClearInspectPlayer(unit)
				GameTooltip:AddLine(format("|cfffed100"..STAT_AVERAGE_ITEM_LEVEL..":|r "..ail).." ("..((d > 0) and "|cff00ff00+" or "|cffff0000")..d.."|r)", r, gb, gb)
				GameTooltip:Show()
			end
		end
	end)
end
Setup()

----------------------------------------------------------------------------------------
--	Adds item icons to tooltips()
----------------------------------------------------------------------------------------
local function AddIcon(self, icon)
	if icon then
		local title = _G[self:GetName() .. "TextLeft1"]
		if title and not title:GetText():find("|T" .. icon) then
			title:SetFormattedText("|T%s:20:20:0:0:64:64:5:59:5:59:%d|t %s", icon, 20, title:GetText())
		end
	end
end

local function hookItem(tip)
	tip:HookScript("OnTooltipSetItem", function(self, ...)
		local name, link = self:GetItem()
		local icon = link and GetItemIcon(link)
		AddIcon(self, icon)
	end)
end
hookItem(_G["GameTooltip"])
hookItem(_G["ItemRefTooltip"])

local function hookSpell(tip)
	tip:HookScript("OnTooltipSetSpell", function(self, ...)
		if self:GetSpell() then
			local name, rank, icon = GetSpellInfo(self:GetSpell())
			AddIcon(self, icon)
		end
	end)
end
hookSpell(_G["GameTooltip"])
hookSpell(_G["ItemRefTooltip"])