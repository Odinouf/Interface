if not Qulight["nameplatess"].enable == true then return end

local TEXTURE = "Interface\\Buttons\\WHITE8x8"
local glowtex = "Interface\\AddOns\\QulightUI\\media\\Other\\dEBorderE"
local FONT = Qulight["media"].font
local FONTSIZE = 8
local FONTFLAG = "THINOUTLINE"				
local FontShadowOffset = 1						

local hpHeight = 7
local hpWidth = 89
local cbIconSize = 18
local cbHeight = 3
local cbWidth = 89
local TotemSize = 22

local showIC = true 
local hideOOC = false

local blankTex = "Interface\\Buttons\\WHITE8x8"	
local OVERLAY = [=[Interface\TargetingFrame\UI-TargetingFrame-Flash]=]

local numChildren = -1
local frames = {}

local dNamePlates = CreateFrame("Frame", nil, UIParent)
dNamePlates:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

-- totem list
local totems = {
	["Earthbind Totem"] = [[Interface\Icons\Spell_nature_strengthofearthtotem02]],
	["Tremor Totem"] = [[Interface\Icons\Spell_nature_tremortotem]],	
	["Mana Tide Totem"] = [[Interface\Icons\Spell_frost_summonwaterelemental]],	
	["Grounding Totem"] = [[Interface\Icons\Spell_nature_groundingtotem]],	
	["Stoneskin Totem"] = [[Interface\Icons\Spell_nature_stoneskintotem]],
	["Stoneclaw Totem"] = [[Interface\Icons\Spell_nature_stoneclawtotem]],
	["Strength of Earth Totem"] = [[Interface\Icons\Spell_nature_earthbindtotem]],
	["Earth Elemental Totem"] = [[Interface\Icons\Spell_nature_earthelemental_totem]],
	["Fire Elemental Totem"] = [[Interface\Icons\spell_fire_elemental_totem]],	
	["Totem of Tranquil Mind"] = [[Interface\Icons\spell_nature_brilliance]],	
	["Spirit Link Totem"] = [[Interface\Icons\spell_shaman_spiritlink]],	
	["Searing Totem"] = [[Interface\Icons\Spell_fire_searingtotem]],
	["Magma Totem"] = [[Interface\Icons\Spell_fire_selfdestruct]],
	["Frost Resistance Totem"] = [[Interface\Icons\Spell_frostresistancetotem_01]],
	["Flametongue Totem"] = [[Interface\Icons\Spell_nature_guardianward]],
	["Totem of Wrath"] = [[Interface\Icons\Spell_fire_totemofwrath]],
	["Healing Stream Totem"] = [[Interface\Icons\Inv_spear_04]],
	["Mana Spring Totem"] = [[Interface\Icons\Spell_nature_manaregentotem]],
	["Cleansing Totem"] = [[Interface\Icons\Spell nature diseasecleansingtotem]],
	["Fire Resistance Totem"] = [[Interface\Icons\Spell_fireresistancetotem_01]],
	["Windfury Totem"] = [[Interface\Icons\Spell_nature_windfury]],
	["Sentry Totem"] = [[Interface\Icons\Spell_nature_removecurse]],
	["Nature Resistance Totem"] = [[Interface\Icons\Spell nature natureresistancetotem]],
	["Wrath of Air Totem"] = [[Interface\Icons\Spell_nature_slowingtotem]],
}

-- format numbers
function round(num, idp)
  if idp and idp > 0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function CoolNumber(num)
	if(num >= 1e6) then
		return round(num/1e6,1).."m"
	elseif(num >= 1e3) then
		return round(num/1e3,1).."k"
	else
		return num
	end
end

-- hide objects
local function QueueObject(parent, object)
	parent.queue = parent.queue or {}
	parent.queue[object] = true
end

dummy = function() return end
local function HideObjects(parent)
	for object in pairs(parent.queue) do
		if(object:GetObjectType() == 'Texture') then
			object:SetTexture(nil)
			object.SetTexture = dummy
		elseif (object:GetObjectType() == 'FontString') then
			object.ClearAllPoints = dummy
			object.SetFont = dummy
			object.SetPoint = dummy
			object:Hide()
			object.Show = dummy
			object.SetText = dummy
			object.SetShadowOffset = dummy			
		else
			object:Hide()
			object.Show = dummy
		end
	end
end

-- update
local function UpdateFrame(frame)
local name = frame.oldname:GetText()
	
	-- color name by threat
	if(frame.region:IsShown()) then
		local _, val = frame.region:GetVertexColor()
		if(val > 0.7) then
			frame.name:SetTextColor(1, 1, 0)
		else
			frame.name:SetTextColor(1, 0, 0)
		end
	else
		frame.name:SetTextColor(1, 1, 1)
	end
	
	-- current health value
    local minHealth, maxHealth = frame.healthOriginal:GetMinMaxValues()
    local valueHealth = frame.healthOriginal:GetValue()
	local d =(valueHealth/maxHealth)*100

		if(d < 100) and valueHealth > 1 then
			frame.hp.value:SetText(CoolNumber(valueHealth))
		else
			frame.hp.value:SetText("")
		end

		if(d <= 35 and d >= 25) then
			frame.hp.value:SetTextColor(253/255, 238/255, 80/255)
		elseif(d < 25 and d >= 20) then
			frame.hp.value:SetTextColor(250/255, 130/255, 0/255)
		elseif(d < 20) then
			frame.hp.value:SetTextColor(200/255, 20/255, 40/255)
		else
			frame.hp.value:SetTextColor(1,1,1)
		end	
	
	-- highlight selected plate
	if(UnitName('target') and frame:GetAlpha() == 1) then
		frame.select:Show()
		if not totems[name] then
			frame.hp:SetSize(hpWidth, hpHeight)
		end
	else
		frame.select:Hide()
		if not totems[name] then
			frame.hp:SetSize(hpWidth, hpHeight)
		end		
	end		
end

local function UpdateObjects(frame)
	frame = frame:GetParent()
	local name = frame.oldname:GetText()
	
	local r, g, b = frame.level:GetTextColor()
	if(frame.boss:IsShown()) then
		frame.name:SetText('|cffff0000B|r ' .. frame.oldname:GetText())
	else
		frame.name:SetText(format('|cff%02x%02x%02x', r*255, g*255, b*255) .. tonumber(frame.level:GetText()) .. (frame.elite:IsShown() and '+' or '') .. '|r ' .. frame.oldname:GetText())
	end	
	
	-- color hp bg dependend on hp color
    local BGr, BGg, BGb = frame.hp:GetStatusBarColor()
	frame.hp.hpbg2:SetVertexColor(BGr*0.3, BGg*0.3, BGb*0.3)
	
	-- totem icon
	if totems[name] then		
		if not frame.totem then
			frame.icon:SetTexCoord(.08, .92, .08, .92)
			frame.totem = true
		end
		if frame.name ~= name then
			frame.icon:Show()
			frame.Ticon:Show()
			frame.icon:SetTexture(totems[name])
			frame.name:ClearAllPoints()
			frame.hp:ClearAllPoints()
			frame.hp:SetSize(TotemSize, hpHeight)	
			frame.hp:SetPoint('TOP', frame.icon, 'BOTTOM', 0, -2)			
		end
	else
		if frame.totem then
			frame.icon:Hide()
			frame.Ticon:Hide()
			frame.icon:SetTexture()
			frame.totem = nil
		end
		frame.hp:ClearAllPoints()
		frame.hp:SetSize(hpWidth, hpHeight)	
		frame.hp:SetPoint('CENTER', frame, 0, 8)		
		frame.name:SetPoint('BOTTOM', frame.hp, 'TOP', 0, 2)
	end
	
	frame.level:ClearAllPoints()
	HideObjects(frame)
end

local function UpdateCastbar(frame)
	frame:ClearAllPoints()
	frame:SetSize(cbWidth, cbHeight)
	frame:SetPoint('TOP', frame:GetParent().hp, 'BOTTOM', 0, -5)
	frame:GetStatusBarTexture():SetHorizTile(true)

	if(frame.shield:IsShown()) then
		frame:SetStatusBarColor(0.9, 0, 1.0, 0.6)
	end
end	
	
local OnValueChanged = function(self)
	if self.needFix then
		UpdateCastbar(self)
		self.needFix = nil
	end
end

local OnSizeChanged = function(self)
	self.needFix = true
end

local function OnHide(frame)
	frame.cb:Hide()
	frame.hasClass = nil

	frame:SetScript("OnUpdate",nil)
end
-- style
local function SkinObjects(frame)
	local hp, cb = frame:GetChildren()
	local offset = UIParent:GetScale() / hp:GetEffectiveScale()
	--local threat, hpborder, cbshield, cbborder, cbicon, overlay, oldname, level, bossicon, raidicon, elite = frame:GetRegions()
	
	local threat, hpborder, overlay, oldname, level, bossicon, raidicon, elite = frame:GetRegions()
	local _, cbborder, cbshield, cbicon = cb:GetRegions()
	
	frame.healthOriginal = hp
	
	-- health
	local hpbg = hp:CreateTexture(nil, 'BACKGROUND')
	hpbg:SetPoint('BOTTOMRIGHT', offset, -offset)
	hpbg:SetPoint('TOPLEFT', -offset, offset)
	hpbg:SetTexture(0, 0, 0)
	
	hp.hpGlow = CreateFrame("Frame", nil, hp)
	hp.hpGlow:SetPoint("TOPLEFT", hp, "TOPLEFT", -1.75, 2)
	hp.hpGlow:SetPoint("BOTTOMRIGHT", hp, "BOTTOMRIGHT", 2, -1.75)
	hp.hpGlow:SetBackdrop{edgeFile = glowtex, edgeSize = 6, insets = {left = 0, right = 0, top = 0, bottom = 0}}
	hp.hpGlow:SetBackdropColor(0, 0, 0)
	hp.hpGlow:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor))
	
    CreateShadow(hp)
	
	hp.hpbg2 = hp:CreateTexture(nil, 'BORDER')
	hp.hpbg2:SetAllPoints(hp)
	hp.hpbg2:SetTexture(blankTex)	
	
	hp:HookScript('OnShow', UpdateObjects)
	hp:SetStatusBarTexture(TEXTURE)
	frame.hp = hp
	
	hp.value = hp:CreateFontString(nil, "OVERLAY")	
	hp.value:SetFont(FONT, FONTSIZE, FONTFLAG)
	hp.value:SetPoint("LEFT", hp, "RIGHT", 5, 0)
	hp.value:SetShadowOffset(FontShadowOffset, -FontShadowOffset)
	
	-- selection highlight
	local select = frame:CreateTexture(nil, 'OVERLAY')
	select:SetAllPoints(hp)
	select:SetTexture("Interface\\AddOns\\QulightUI\\media\\Other\\highlight")
	select:SetTexCoord(0,1,1,0)
	select:SetVertexColor(1,1,1,0.4)
	select:SetBlendMode('ADD')
	select:Hide()
	frame.select = select
	
	-- cast
	local cbbg = cb:CreateTexture(nil, 'BACKGROUND')
	cbbg:SetPoint('BOTTOMRIGHT', offset, -offset)
	cbbg:SetPoint('TOPLEFT', -offset, offset)
	cbbg:SetTexture(0, 0, 0)	

	local cbbg2 = cb:CreateTexture(nil, 'BORDER')
	cbbg2:SetAllPoints(cb)
	cbbg2:SetTexture(1/3, 1/3, 1/3)

	cbicon:ClearAllPoints()
	cbicon:SetPoint("TOPRIGHT", hp, "TOPLEFT", -4, 0)		
	cbicon:SetSize(cbIconSize, cbIconSize)
	cbicon:SetTexCoord(.07, .93, .07, .93)
	
	CreateShadow(cb)
	
	local cbiconbg = cb:CreateTexture(nil, 'BACKGROUND')
	cbiconbg:SetPoint('BOTTOMRIGHT', cbicon, offset, -offset)
	cbiconbg:SetPoint('TOPLEFT', cbicon, -offset, offset)
	cbiconbg:SetTexture(0, 0, 0)
	
	cb.icon = cbicon
	cb.shield = cbshield
	cb:HookScript('OnShow', UpdateCastbar)
	cb:HookScript('OnSizeChanged', OnSizeChanged)
	cb:HookScript('OnValueChanged', OnValueChanged)	
	cb:SetStatusBarTexture(TEXTURE)
	frame.cb = cb

	-- name
	local name = hp:CreateFontString(nil, 'OVERLAY')
	name:SetFont(FONT, FONTSIZE, FONTFLAG)
	frame.oldname = oldname
	frame.name = name
	name:SetShadowOffset(FontShadowOffset, -FontShadowOffset)
	
	-- totem icon
	local icon = frame:CreateTexture(nil, "BACKGROUND")
	icon:SetPoint("CENTER", frame, 0, 28)
	icon:SetSize(TotemSize, TotemSize)
	icon:Hide()
	frame.icon = icon
	
	local Ticon = frame:CreateTexture(nil, 'BACKGROUND')
	Ticon:SetPoint('BOTTOMRIGHT', icon, offset, -offset)
	Ticon:SetPoint('TOPLEFT', icon, -offset, offset)
	Ticon:Hide()
	Ticon:SetTexture(0, 0, 0)
	frame.Ticon = Ticon
	
	-- raid icon
	raidicon:ClearAllPoints()
	raidicon:SetParent(hp)	
	raidicon:SetPoint("TOPRIGHT", hp, "TOPLEFT", -4, 0)
	raidicon:SetSize(cbIconSize, cbIconSize)
	raidicon:SetTexture("Interface\\AddOns\\QulightUI\\media\\Other\\raidicons")	
	
	frame.level = level
	frame.elite = elite
	frame.boss = bossicon	
		
	QueueObject(frame, threat)
	QueueObject(frame, hpborder)
	QueueObject(frame, cbshield)
	QueueObject(frame, cbborder)
	QueueObject(frame, overlay)
	QueueObject(frame, oldname)
	QueueObject(frame, level)
	QueueObject(frame, bossicon)
	QueueObject(frame, elite)
	
	UpdateObjects(hp)
	UpdateCastbar(cb)
	
	frame:HookScript('OnHide', OnHide)	
	frames[frame] = true
end

-- update
local select = select
local function HookFrames(...)
	for index = 1, select('#', ...) do
		local frame = select(index, ...)
		local region = frame:GetRegions()

		if(not frames[frame] and (frame:GetName() and frame:GetName():find("NamePlate%d")) and region and region:GetObjectType() == 'Texture' and region:GetTexture() == OVERLAY) then
			SkinObjects(frame)
			frame.region = region
		end
	end
end

CreateFrame('Frame'):SetScript('OnUpdate', function(self, elapsed)
	if(WorldFrame:GetNumChildren() ~= numChildren) then
		numChildren = WorldFrame:GetNumChildren()
		HookFrames(WorldFrame:GetChildren())
	end

	if(self.elapsed and self.elapsed > 0.1) then
		for frame in pairs(frames) do
			UpdateFrame(frame)
		end

		self.elapsed = 0
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end
end)

-- set some CVars
if hideOOC then
	dNamePlates:RegisterEvent("PLAYER_REGEN_ENABLED")
	function dNamePlates:PLAYER_REGEN_ENABLED()
		SetCVar("nameplateShowEnemies", 0)
	end
end

if showIC then
	dNamePlates:RegisterEvent("PLAYER_REGEN_DISABLED")
	function dNamePlates:PLAYER_REGEN_DISABLED()
		SetCVar("nameplateShowEnemies", 1)
	end
end

dNamePlates:RegisterEvent("PLAYER_ENTERING_WORLD")
function dNamePlates:PLAYER_ENTERING_WORLD()
	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("nameplateShowEnemyTotems", 1)
	SetCVar("bloatnameplates",0)	
	SetCVar("bloatthreat", 0)
	SetCVar("bloattest", 0)	
end