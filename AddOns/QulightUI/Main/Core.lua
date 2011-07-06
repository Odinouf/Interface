----------------------------------------------------------------------------------------
-- General options   
----------------------------------------------------------------------------------------
local csf = CreateFrame("Frame")
csf:SetScript("OnEvent", function()
--SetCVar("cameraDistanceMax", 50)
--SetCVar("cameraDistanceMaxFactor", 3.4)
SetCVar("consolidateBuffs", 0)
SetCVar("ShowClassColorInNameplate", 1)
SetCVar("consolidateBuffs",0) 
SetCVar("buffDurations",1)
end)
csf:RegisterEvent("PLAYER_LOGIN")
----

AnchorFrames = {
}

local t_unlock = false

function AnchorsUnlock()
	print("UI: all frames unlocked")
	for _, v in pairs(AnchorFrames) do
		f = _G[v]
		if f and f:IsUserPlaced() then
			f.dragtexture:SetAlpha(0.7)
			f.text:SetAlpha(1)
			f:EnableMouse(true)
			f:RegisterForDrag("LeftButton")
		end
	end
end

function AnchorsLock()
	print("UI: all frames locked")
	for _, v in pairs(AnchorFrames) do
		f = _G[v]
		if f and f:IsUserPlaced() then
			f.dragtexture:SetAlpha(0)
			f.text:SetAlpha(0)
			f:EnableMouse(nil)
			f:RegisterForDrag(nil)
		end
	end
end

function AnchorsReset()
	for _, v in pairs(AnchorFrames) do
		f = _G[v]
		if f and f:IsUserPlaced() then
			f:SetUserPlaced(false)
		end
	end
	ReloadUI()
end

local function SlashCmd(cmd)
	if (cmd:match"reset") then
		AnchorsReset()
	else
		if t_unlock == false then
			t_unlock = true
			AnchorsUnlock()
		elseif t_unlock == true then
			t_unlock = false
			AnchorsLock()
		end
	end
end

SlashCmdList["ui"] = SlashCmd;
SLASH_ui1 = "/ui";

function CreateAnchor(f, text, width, height)
	f:SetScale(1)
	f:SetFrameStrata("TOOLTIP")
	f:SetScript("OnDragStart", function(s) s:StartMoving() end)
	f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
	f:SetWidth(width)
	f:SetHeight(height)
	
	local t = f:CreateTexture(nil,"OVERLAY",nil,6)
	t:SetAllPoints(f)
	t:SetTexture(0,0.6,0.6)
	t:SetAlpha(0)
	f.dragtexture = t
	
	--f:SetClampedToScreen(true)
	f:SetMovable(true)
	f:SetUserPlaced(true)
	f.dragtexture:SetAlpha(0)
	f:EnableMouse(nil)
	f:RegisterForDrag(nil)
	f:SetScript("OnEnter", nil)
	f:SetScript("OnLeave", nil)

	f.text = f:CreateFontString(nil, "OVERLAY")
	f.text:SetFont(Qulight["media"].font, 10)
	f.text:SetJustifyH("LEFT")
	f.text:SetShadowColor(0, 0, 0)
	f.text:SetShadowOffset(1, -1)
	f.text:SetAlpha(0)
	f.text:SetPoint("CENTER")
	f.text:SetText(text)

	tinsert(AnchorFrames, f:GetName())
end

----------------------------------------------------------------------------------------
-- Quest tracker(by Tukz)
----------------------------------------------------------------------------------------
AnchorWatchFrame = CreateFrame("Frame","Move_WatchFrame",UIParent)
AnchorWatchFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -150, -210)
CreateAnchor(AnchorWatchFrame, "Move watch frame", 250, 500)

WatchFrame:SetClampedToScreen(false)
WatchFrame:ClearAllPoints()
WatchFrame.ClearAllPoints = function() return end
WatchFrame:SetWidth(250)
WatchFrame:SetHeight(500)
WatchFrame:SetPoint("TOPRIGHT", AnchorWatchFrame)
WatchFrame.SetPoint = function() return end


----------------------------------------------------------------------------------------
-- Quest level(yQuestLevel by yleaf)
----------------------------------------------------------------------------------------
local function update()
	local buttons = QuestLogScrollFrame.buttons
	local numButtons = #buttons
	local scrollOffset = HybridScrollFrame_GetOffset(QuestLogScrollFrame)
	local numEntries, numQuests = GetNumQuestLogEntries()
	
	for i = 1, numButtons do
		local questIndex = i + scrollOffset
		local questLogTitle = buttons[i]
		if questIndex <= numEntries then
			local title, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily = GetQuestLogTitle(questIndex)
			if not isHeader then
				questLogTitle:SetText("[" .. level .. "] " .. title)
				QuestLogTitleButton_Resize(questLogTitle)
			end
		end
	end
end
hooksecurefunc("QuestLog_Update", update)
QuestLogScrollFrameScrollBar:HookScript("OnValueChanged", update)

----------------------------------------------------------------------------------------
-- UIScale
----------------------------------------------------------------------------------------
local QulightOnLogon = CreateFrame("Frame")
QulightOnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
QulightOnLogon:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	
		SetCVar("useUiScale", 1)
		if Qulight["general"].MultisampleProtect == true then
			SetMultisampleFormat(1)
		end
		if Qulight["general"].UiScale > 1 then Qulight["general"].UiScale = 1 end
		if Qulight["general"].UiScale < 0.64 then Qulight["general"].UiScale = 0.64 end
		SetCVar("uiScale", Qulight["general"].UiScale)
	


	print("|cFF00A2FF/ui |r - command for change all UI positions.")
	
end)


function UIScale()
	if Qulight["general"].AutoScale == true then
	Qulight["general"].UiScale = min(2, max(.64, 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")))
	end
end
UIScale()
-- pixel perfect script of custom ui scale.
local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/Qulight["general"].UiScale
local function scale(x)
    return mult*math.floor(x/mult+.5)
end
function Scale(x) return scale(x) end
mult = mult
----------------------------------------------------------------------------------------
-- Backdrop/Shadow/Glow/Border
----------------------------------------------------------------------------------------
function CreatePanel(f, w, h, a1, p, a2, x, y)
	local _, class = UnitClass("player")
	local r, g, b = RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b
	sh = scale(h)
	sw = scale(w)
	f:SetFrameLevel(1)
	f:SetHeight(sh)
	f:SetWidth(sw)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)
	f:SetBackdrop({
	  bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
      edgeFile = "Interface\\Buttons\\WHITE8x8", 
	  tile = false, tileSize = 0, edgeSize = mult, 
	  insets = { left = -mult, right = -mult, top = -mult, bottom = -mult}
	})
	f:SetBackdropColor(unpack(Qulight["media"].backdropcolor))
	f:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor))
end
local shadows = {
	edgeFile = "Interface\\AddOns\\QulightUI\\media\\Other\\glowTex", 
	edgeSize = 4,
	insets = { left = 3, right = 3, top = 3, bottom = 3 }
}
function CreateShadow(f)
	if f.shadow then return end
	local shadow = CreateFrame("Frame", nil, f)
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:SetPoint("TOPLEFT", -4, 4)
	shadow:SetPoint("BOTTOMRIGHT", 4, -4)
	shadow:SetBackdrop(shadows)
	shadow:SetBackdropColor(0, 0, 0, 0)
	shadow:SetBackdropBorderColor(0, 0, 0, 1)
	f.shadow = shadow
	return shadow
end

local function SetTex2(f, t, texture)
	f:SetBackdrop({
	  bgFile = Qulight["media"].blank, 
	  edgeFile = Qulight["media"].blank, 
	  tile = false, tileSize = 0, edgeSize = mult, 
	  insets = { left = -mult, right = -mult, top = -mult, bottom = -mult}
	})
	
	local tex = f:CreateTexture(nil, "BORDER")
	tex:SetPoint("TOPLEFT", f, "TOPLEFT", 2, -2)
	tex:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -2, 2)
	tex:SetTexture("Interface\\Addons\\QulightUI\\media\\Other\\statusbar3")
	tex:SetVertexColor(unpack(Qulight["media"].backdropcolor))
	tex:SetDrawLayer("BORDER", -8)
	f.tex = tex
	
	f:SetBackdropColor(unpack(Qulight["media"].backdropcolor))
	f:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor))
end
function frametexpx(f)
	f:SetBackdrop({
		bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = mult, 
		insets = {left = -mult, right = -mult, top = -mult, bottom = -mult} 
	})
	f:SetBackdropColor(unpack(Qulight["media"].backdropcolor))
	f:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor))
	SetTex2(f)	
end
function frame1px(f)
	f:SetBackdrop({
		bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = mult, 
		insets = {left = -mult, right = -mult, top = -mult, bottom = -mult} 
	})
	f:SetBackdropColor(unpack(Qulight["media"].backdropcolor))
	f:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor))	
end
function frame11px(f)
	f:SetBackdrop({
		bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = mult, 
		insets = {left = -mult, right = -mult, top = -mult, bottom = -mult} 
	})
	f:SetBackdropColor(unpack(Qulight["media"].backdropcolor))
	f:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor))
end
function frame1px1(f)
	f:SetBackdrop({
		bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = mult, 
		insets = {left = -mult, right = -mult, top = -mult, bottom = -mult} 
	})
	f:SetPoint("TOPLEFT", -2, 2)
	f:SetPoint("BOTTOMRIGHT", 2, -2)
	f:SetBackdropColor(unpack(Qulight["media"].backdropcolor))
	f:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor))
end
function frame1px2(f)
	f:SetBackdrop({
		bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = mult, 
		insets = {left = -mult, right = -mult, top = -mult, bottom = -mult} 
	})
	f:SetFrameLevel(31)
	f:SetPoint("TOPLEFT", 1, -1)
	f:SetPoint("BOTTOMRIGHT", -1, 1)
	f:SetBackdropColor(.1,.1,.1,0)
	f:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor))
end
function frame1px3(f)
	f:SetBackdrop({
		bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = mult, 
		insets = {left = -mult, right = -mult, top = -mult, bottom = -mult} 
	})
	f:SetBackdropColor(unpack(Qulight["media"].backdropcolor))
	f:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor))
end

--fucking icon for castbar
function frame(f)
    if f.frame==nil then
      local frame = CreateFrame("Frame", nil, f)
      frame = CreateFrame("Frame", nil, f)
      frame:SetFrameLevel(12)
      frame:SetFrameStrata(f:GetFrameStrata())
      frame:SetPoint("TOPLEFT", 4, -4)
      frame:SetPoint("BOTTOMLEFT", 4, 4)
      frame:SetPoint("TOPRIGHT", -4, -4)
      frame:SetPoint("BOTTOMRIGHT", -4, 4)
      frame:SetBackdrop( { 
        edgeFile = "Interface\\Buttons\\WHITE8x8", 
	  tile = false, tileSize = 0, edgeSize = mult, 
	  insets = { left = -mult, right = -mult, top = -mult, bottom = -mult}
      })
     
      frame:SetBackdropColor(unpack(Qulight["media"].backdropcolor))
      frame:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor))
      f.frame = frame
    end
end 
function frame123(f)
    if f.frame==nil then
      local frame = CreateFrame("Frame", nil, f)
      frame = CreateFrame("Frame", nil, f)
      frame:SetFrameLevel(2)
      frame:SetFrameStrata(f:GetFrameStrata())
      frame:SetPoint("TOPLEFT", 9, -9)
      frame:SetPoint("BOTTOMLEFT", 9, 9)
      frame:SetPoint("TOPRIGHT", -9, -9)
      frame:SetPoint("BOTTOMRIGHT", -9, 9)
      frame:SetBackdrop( {
		bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],	  
        edgeFile = "Interface\\Buttons\\WHITE8x8", 
	  tile = false, tileSize = 0, edgeSize = mult, 
	  insets = { left = -mult, right = -mult, top = -mult, bottom = -mult}
      })
	  frame:SetBackdropColor(unpack(Qulight["media"].backdropcolor))
      frame:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor))
      f.frame = frame
    end
end 
function CreateShadow1(f)
    if f.frameBD==nil then
      local frameBD = CreateFrame("Frame", nil, f)
      frameBD = CreateFrame("Frame", nil, f)
      frameBD:SetFrameLevel(1)
      frameBD:SetFrameStrata(f:GetFrameStrata())
      frameBD:SetPoint("TOPLEFT", 0, 0)
      frameBD:SetPoint("BOTTOMLEFT", 0, 0)
      frameBD:SetPoint("TOPRIGHT", 0, 0)
      frameBD:SetPoint("BOTTOMRIGHT", 0, 0)
      frameBD:SetBackdrop( { 
         edgeFile = "Interface\\AddOns\\QulightUI\\media\\Other\\glowTex", edgeSize = 4,
         insets = {left = 3, right = 3, top = 3, bottom = 3},
         tile = false, tileSize = 0,
      })
      frameBD:SetBackdropColor(0, 0, 0, 0)
      frameBD:SetBackdropBorderColor(0, 0, 0, 1)
      f.frameBD = frameBD
    end
end
function CreateShadow2(f)
    if f.frameBD==nil then
      local frameBD = CreateFrame("Frame", nil, f)
      frameBD = CreateFrame("Frame", nil, f)
      frameBD:SetFrameLevel(0)
      frameBD:SetFrameStrata(f:GetFrameStrata())
      frameBD:SetPoint("TOPLEFT", 5, -5)
      frameBD:SetPoint("BOTTOMLEFT", 5, 5)
      frameBD:SetPoint("TOPRIGHT", -5, -5)
      frameBD:SetPoint("BOTTOMRIGHT", -5, 5)
      frameBD:SetBackdrop( { 
         edgeFile = "Interface\\AddOns\\QulightUI\\media\\Other\\glowTex", edgeSize = 4,
         insets = {left = 3, right = 3, top = 3, bottom = 3},
         tile = false, tileSize = 0,
      })
      frameBD:SetBackdropColor(0, 0, 0, 0)
      frameBD:SetBackdropBorderColor(0, 0, 0, 1)
      f.frameBD = frameBD
    end
end

----------------------------------------------------------------------------------------
-- Style Zone and Coord panels for Minimap
----------------------------------------------------------------------------------------
local m_zone = CreateFrame("Frame",nil,UIParent)
CreatePanel(m_zone, 0, 16, "TOPLEFT", Minimap, "TOPLEFT", 2,-2)
m_zone:SetFrameLevel(5)
m_zone:SetFrameStrata("LOW")
CreateShadow(m_zone)
m_zone:SetPoint("TOPRIGHT",Minimap,-2,-2)
m_zone:SetBackdropColor(unpack(Qulight["media"].backdropcolor))
m_zone:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor))
m_zone:Hide()

local m_zone_text = m_zone:CreateFontString(nil,"Overlay")
m_zone_text:SetFont(Qulight["media"].font,10,"OUTLINE")
m_zone_text:SetPoint("Center",0,0)
m_zone_text:SetJustifyH("CENTER")
m_zone_text:SetJustifyV("MIDDLE")
m_zone_text:SetHeight(10)

local m_coord = CreateFrame("Frame",nil,UIParent)
CreatePanel(m_coord, 36, 16, "BOTTOM", Minimap, "BOTTOM",0,2)
m_coord:SetFrameStrata("LOW")
CreateShadow(m_coord)
m_coord:SetBackdropColor(unpack(Qulight["media"].backdropcolor))
m_coord:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor))
m_coord:Hide()	

local m_coord_text = m_coord:CreateFontString(nil,"Overlay")
m_coord_text:SetFont(Qulight["media"].font,10,"OUTLINE")
m_coord_text:SetPoint("Center",2,0)
m_coord_text:SetJustifyH("CENTER")
m_coord_text:SetJustifyV("MIDDLE")
 
Minimap:SetScript("OnEnter",function()	
	m_coord:Show()
	m_zone:Show()
end)
 
Minimap:SetScript("OnLeave",function()
	m_coord:Hide()
	m_zone:Hide()
end)
m_coord_text:SetText("00,00")
local ela = 0
local coord_Update = function(self,t)
	local inInstance, _ = IsInInstance()
	ela = ela - t
	if ela > 0 then return end
	local x,y = GetPlayerMapPosition("player")
	local xt,yt
	x = math.floor(100 * x)
	y = math.floor(100 * y)
	if x == 0 and y == 0 and not inInstance then
		SetMapToCurrentZone()
	elseif x ==0 and y==0 then
		m_coord_text:SetText(" ")	
	else
		if x < 10 then
			xt = "0"..x
		else
			xt = x
		end
		if y < 10 then
			yt = "0"..y
		else
			yt = y
		end
		m_coord_text:SetText(xt..",|r"..yt)
	end
	ela = .2
end
m_coord:SetScript("OnUpdate",coord_Update)
local zone_Update = function()
	local pvpType = GetZonePVPInfo()
	m_zone_text:SetText(strsub(GetMinimapZoneText(),1,23))
	if pvpType == "arena" then
		m_zone_text:SetTextColor(0.84, 0.03, 0.03)
	elseif pvpType == "friendly" then
		m_zone_text:SetTextColor(0.05, 0.85, 0.03)
	elseif pvpType == "contested" then
		m_zone_text:SetTextColor(0.9, 0.85, 0.05)
	elseif pvpType == "hostile" then 
		m_zone_text:SetTextColor(0.84, 0.03, 0.03)
	elseif pvpType == "sanctuary" then
		m_zone_text:SetTextColor(0.0352941, 0.58823529, 0.84705882)
	elseif pvpType == "combat" then
		m_zone_text:SetTextColor(0.84, 0.03, 0.03)
	else
		m_zone_text:SetTextColor(0.84, 0.03, 0.03)
	end
end
m_zone:RegisterEvent("PLAYER_ENTERING_WORLD")
m_zone:RegisterEvent("ZONE_CHANGED_NEW_AREA")
m_zone:RegisterEvent("ZONE_CHANGED")
m_zone:RegisterEvent("ZONE_CHANGED_INDOORS")
m_zone:SetScript("OnEvent",zone_Update) 
local a,k = CreateFrame("Frame"),4
a:SetScript("OnUpdate",function(self,t)
	k = k - t
	if k > 0 then return end
	self:Hide()
	zone_Update()
end)
do
	SetFontString = function(parent, fontName, fontHeight, fontStyle)
		local fs = parent:CreateFontString(nil, "OVERLAY")
		fs:SetFont(Qulight["media"].font, fontHeight, fontStyle)
		fs:SetJustifyH("LEFT")
		fs:SetShadowColor(0, 0, 0)
		fs:SetShadowOffset(1.25, -1.25)
		return fs
	end
end	
if Qulight["datatext"].classcolor == true then
	local classcolor = RAID_CLASS_COLORS[myclass]
	Qulight["datatext"].color = {classcolor.r,classcolor.g,classcolor.b,1}
end
local r, g, b = unpack(Qulight["datatext"].color)
qColor = ("|cff%.2x%.2x%.2x"):format(r * 255, g * 255, b * 255)
---------------------
-- Font
---------------------
local Fonts = CreateFrame("Frame", nil, UIParent)
SetFont = function(obj, font, size, style, r, g, b, sr, sg, sb, sox, soy)
	obj:SetFont(font, size, style)
	if sr and sg and sb then obj:SetShadowColor(sr, sg, sb) end
	if sox and soy then obj:SetShadowOffset(sox, soy) end
	if r and g and b then obj:SetTextColor(r, g, b)
	elseif r then obj:SetAlpha(r) end
end
Fonts:RegisterEvent("ADDON_LOADED")
Fonts:SetScript("OnEvent", function(self, event, addon)
	
	local NORMAL     =  Qulight["media"].font
	local COMBAT     =  Qulight["media"].font
	local NUMBER     =  Qulight["media"].font
	local _, editBoxFontSize, _, _, _, _, _, _, _, _ = GetChatWindowInfo(1)
	
	UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 12
	CHAT_FONT_HEIGHTS = {12, 13, 14, 15, 16, 17, 18, 19, 20}
	
	UNIT_NAME_FONT     = NORMAL
	NAMEPLATE_FONT     = NORMAL
	DAMAGE_TEXT_FONT   = COMBAT
	STANDARD_TEXT_FONT = NORMAL
	
	SetFont(GameTooltipHeader,                  NORMAL, Qulight["media"].fontsize)
	SetFont(NumberFont_OutlineThick_Mono_Small, NUMBER, Qulight["media"].fontsize, "OUTLINE")
	SetFont(NumberFont_Outline_Huge,            NUMBER, 28, "THICKOUTLINE", 28)
	SetFont(NumberFont_Outline_Large,           NUMBER, 15, "OUTLINE")
	SetFont(NumberFont_Outline_Med,             NUMBER, Qulight["media"].fontsize*1.1, "OUTLINE")
	SetFont(NumberFont_Shadow_Med,              NORMAL, Qulight["media"].fontsize+1) --chat editbox uses this   NORMAL, Qulight["media"].fontsize+1)
	SetFont(NumberFont_Shadow_Small,            NORMAL, Qulight["media"].fontsize)
	SetFont(QuestFont,                          NORMAL, Qulight["media"].fontsize)
	SetFont(QuestFont_Large,                    NORMAL, 14)
	SetFont(SystemFont_Large,                   NORMAL, 15)
	SetFont(SystemFont_Shadow_Huge1,			NORMAL, 20, "THINOUTLINE") -- Raid Warning, Boss emote frame too
	SetFont(SystemFont_Med1,                    NORMAL, Qulight["media"].fontsize)
	SetFont(SystemFont_Med3,                    NORMAL, Qulight["media"].fontsize*1.1)
	SetFont(SystemFont_OutlineThick_Huge2,      NORMAL, 20, "THICKOUTLINE")
	SetFont(SystemFont_Outline_Small,           NUMBER, Qulight["media"].fontsize, "OUTLINE")
	SetFont(SystemFont_Shadow_Large,            NORMAL, 15)
	SetFont(SystemFont_Shadow_Med1,             NORMAL, Qulight["media"].fontsize)
	SetFont(SystemFont_Shadow_Med3,             NORMAL, Qulight["media"].fontsize*1.1)
	SetFont(SystemFont_Shadow_Outline_Huge2,    NORMAL, 20, "OUTLINE")
	SetFont(SystemFont_Shadow_Small,            NORMAL, Qulight["media"].fontsize*0.9)
	SetFont(SystemFont_Small,                   NORMAL, Qulight["media"].fontsize)
	SetFont(SystemFont_Tiny,                    NORMAL, Qulight["media"].fontsize)
	SetFont(Tooltip_Med,                        NORMAL, Qulight["media"].fontsize)
	SetFont(Tooltip_Small,                      NORMAL, Qulight["media"].fontsize)
	SetFont(ZoneTextString,						NORMAL, 32, "OUTLINE")
	SetFont(SubZoneTextString,					NORMAL, 25, "OUTLINE")
	SetFont(PVPInfoTextString,					NORMAL, 22, "THINOUTLINE")
	SetFont(PVPArenaTextString,					NORMAL, 22, "THINOUTLINE")
	SetFont(CombatTextFont,                     COMBAT, 100, "THINOUTLINE") -- number here just increase the font quality.
	SetFont(InvoiceFont_Med, 					NORMAL, 13)
	SetFont(InvoiceFont_Small,					NORMAL, 10)
	SetFont(MailFont_Large, 					NORMAL, 15)
	SetFont(QuestFont_Shadow_Huge, 				NORMAL, 19)
	SetFont(QuestFont_Shadow_Small, 			NORMAL, 15)
	SetFont(ReputationDetailFont, 				NORMAL, 10)
	SetFont(SpellFont_Small, 					NORMAL, 10)
	SetFont(FriendsFont_Small, 					NORMAL, Qulight["media"].fontsize)
	SetFont(FriendsFont_Normal, 				NORMAL, Qulight["media"].fontsize)
	SetFont(FriendsFont_Large, 					NORMAL, Qulight["media"].fontsize)
	SetFont(FriendsFont_UserText, 				NORMAL, Qulight["media"].fontsize)
	
	SetFont = nil
	self:SetScript("OnEvent", nil)
	self:UnregisterAllEvents()
	self = nil
end)
---------------------
--Panels
---------------------
Anchordataleftp = CreateFrame("Frame","Move_dataleftp",UIParent)
Anchordataleftp:SetPoint("BOTTOMLEFT", bottompanel, "BOTTOMLEFT", 5, 5)
CreateAnchor(Anchordataleftp, "Move Left Data Text", 337, 13)
	
local dataleftp = CreateFrame("Frame", "DataLeftPanel", UIParent)
CreatePanel(dataleftp, 337, 13, "BOTTOMLEFT", Anchordataleftp)
CreateShadow(dataleftp)
dataleftp:SetFrameLevel(2)

Anchordatarightp = CreateFrame("Frame","Move_datarightp",UIParent)
Anchordatarightp:SetPoint("BOTTOMRIGHT", bottompanel, "BOTTOMRIGHT", -5, 5)
CreateAnchor(Anchordatarightp, "Move Right Data Text", 353, 13)

local datarightp = CreateFrame("Frame", "DataRightPanel", UIParent)
CreatePanel(datarightp, 353, 13, "BOTTOMRIGHT", Anchordatarightp)
CreateShadow(datarightp)
datarightp:SetFrameLevel(2)

Anchorchatbgdummy = CreateFrame("Frame","Move_chatbgdummy",UIParent)
Anchorchatbgdummy:SetPoint("BOTTOMLEFT", bottompanel, "BOTTOMLEFT", 5, 21)
CreateAnchor(Anchorchatbgdummy, "Move Chat", 353, 119)

local chatbgdummy = CreateFrame("Frame", "ChatBackground", UIParent)
CreatePanel(chatbgdummy, 353, 119, "BOTTOMLEFT", Anchorchatbgdummy)
CreateShadow(chatbgdummy)
	
local minimaplol = CreateFrame("Frame", "minimaplol", Minimap)
CreatePanel(minimaplol, Qulight["minimapp"].size+4, Qulight["minimapp"].size+4, "BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 2, -2)
CreateShadow(minimaplol)
minimaplol:SetFrameLevel(2)

Anchordamagelol = CreateFrame("Frame","Move_damagelol",UIParent)
Anchordamagelol:SetPoint("BOTTOMRIGHT", bottompanel, "BOTTOMRIGHT", -128, 21)
CreateAnchor(Anchordamagelol, "Move Damage Background", 230, 120)

local damagelol = CreateFrame("Frame", "damagelol", UIParent)
CreatePanel(damagelol, 230, 120, "BOTTOMRIGHT", Anchordamagelol)
CreateShadow(damagelol)
damagelol:SetFrameLevel(2)

Anchordatalefticon = CreateFrame("Frame","Move_Copy Chat",UIParent)
Anchordatalefticon:SetPoint("BOTTOMLEFT", bottompanel, "BOTTOMLEFT", 345, 5)
CreateAnchor(Anchordatalefticon, "Move Copy Chat", 13, 13)

local datalefticon = CreateFrame("Frame", "datalefticon", UIParent)
CreatePanel(datalefticon, 13, 13, "BOTTOM", Anchordatalefticon)
CreateShadow(datalefticon)
datalefticon:SetFrameLevel(2)

--[[AnchorMainActionBar = CreateFrame("Frame","Move_MainActionBar",UIParent)
AnchorMainActionBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 5)
--CreateAnchor(AnchorMainActionBar, "Main Action Bar", 300, 50)--]]


--right shapeshift area
local rightvertical = CreateFrame("Frame", "rightvertical", UIParent)
CreatePanel(rightvertical, 58, 136, "BOTTOMRIGHT", bottompanel, "BOTTOMRIGHT", -361, 5)
CreateShadow(rightvertical)
rightvertical:SetFrameLevel(2)

--left popo area
local leftvertical = CreateFrame("Frame", "leftvertical", UIParent)
CreatePanel(leftvertical, 70, 136, "BOTTOMLEFT", bottompanel, "BOTTOMLEFT", 360, 5)
CreateShadow(leftvertical)
leftvertical:SetFrameLevel(2)

--[[
--threat
local cooldowncenter = CreateFrame("Frame", "cooldowncenter", UIParent)
CreatePanel(cooldowncenter, 260, 36, "BOTTOM", bottompanel, "BOTTOM", 0, 80)
CreateShadow(cooldowncenter)
cooldowncenter:SetFrameLevel(2)--]]

-- CD
 
--[[local barbgr = CreateFrame("Frame", "barbgrActionBarBackgroundRight", UIParent)
CreatePanel(barbgr, 32, 256, "RIGHT", UIParent, "RIGHT", -5, -10)
CreateShadow(barbgr)
barbgr:SetFrameLevel(2)--]]

-- Main Bar shadow
local barbgr = CreateFrame("Frame", "barbgrActionBarBackgroundRight", UIParent)
CreatePanel(barbgr, 370, 67, "BOTTOM", UIParent, "BOTTOM", 0, 10)
CreateShadow(barbgr)
barbgr:SetFrameLevel(2)


--alternate power
PlayerPowerBarAlt:SetSize(64, 64)
PlayerPowerBarAlt:SetMovable(true)
PlayerPowerBarAlt:SetUserPlaced(true)
PlayerPowerBarAlt:ClearAllPoints()
PlayerPowerBarAlt:SetPoint("TOP",0,-100)
--

LeftDatatexts = {}
function PP(p, obj)
	if p == 1 then
		obj:SetHeight(DataLeftPanel:GetHeight())
		obj:SetPoint("LEFT", DataLeftPanel, "LEFT", 10, 0)
	elseif p == 2 then
		obj:SetHeight(DataLeftPanel:GetHeight())
		obj:SetPoint("CENTER", DataLeftPanel, "CENTER", -20, 0)
	elseif p == 3 then
		obj:SetHeight(DataLeftPanel:GetHeight())
		obj:SetPoint("RIGHT", DataLeftPanel, "RIGHT", -60, 0)
	elseif p == 4 then
		obj:SetHeight(DataRightPanel:GetHeight())
		obj:SetPoint("LEFT", DataRightPanel,"LEFT", 10, 0)
	elseif p == 5 then
		obj:SetHeight(DataRightPanel:GetHeight())
		obj:SetPoint("CENTER", DataRightPanel,"CENTER", -20, 0)
	elseif p == 6 then
		obj:SetHeight(DataRightPanel:GetHeight())
		obj:SetPoint("RIGHT", DataRightPanel,"RIGHT", -70, 0)
	elseif p == 7 then
		obj:SetHeight(DataLeftPanel:GetHeight())
		obj:SetPoint("RIGHT", DataLeftPanel,"RIGHT", -10, 0)
	elseif p == 8 then
		obj:SetHeight(DataRightPanel:GetHeight())
		obj:SetPoint("RIGHT", DataRightPanel,"RIGHT", -10, 0)
	end
end


local function TakeScreen(delay, func, ...)
local waitTable = {}
local waitFrame = CreateFrame("Frame", "WaitFrame", UIParent)
	waitFrame:SetScript("onUpdate", function (self, elapse)
		local count = #waitTable
		local i = 1
		while (i <= count) do
			local waitRecord = tremove(waitTable, i)
			local d = tremove(waitRecord, 1)
			local f = tremove(waitRecord, 1)
			local p = tremove(waitRecord, 1)
			if (d > elapse) then
				tinsert(waitTable, i, {d-elapse, f, p})
				i = i + 1
			else
				count = count - 1
				f(unpack(p))
			end
		end
	end)
	tinsert(waitTable, {delay, func, {...} })
end
local function OnEvent(...)
	TakeScreen(1, Screenshot)
end
local AchScreen = CreateFrame("Frame")
AchScreen:RegisterEvent("ACHIEVEMENT_EARNED")
AchScreen:SetScript("OnEvent", OnEvent)