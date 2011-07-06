if not Qulight["chatt"].enable == true then return end

local Chat = CreateFrame("Frame")
local tabalpha = 1
local tabnoalpha = 0
local _G = _G
local origs = {}
local type = type
hidecombat = true

local function Kill(object)
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
	end
	object.Show = dummy
	object:Hide()
end
dummy = function() return end
for i = 1, 10 do
	local x=({_G["ChatFrame"..i.."EditBox"]:GetRegions()})
	x[9]:SetAlpha(0)
	x[10]:SetAlpha(0)
	x[11]:SetAlpha(0)
end
for i = 1, NUM_CHAT_WINDOWS do
    if ( i ~= 2 ) then
      local f = _G["ChatFrame"..i]
      local am = f.AddMessage
      f.AddMessage = function(frame, text, ...)
        return am(frame, text:gsub('|h%[(%d+)%. .-%]|h', '|h[%1]|h'), ...)
      end
    end
end 
_G.CHAT_BATTLEGROUND_GET = "|Hchannel:Battleground|h".."[BG]".."|h %s:\32"
_G.CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:Battleground|h".."[BG]".."|h %s:\32"
_G.CHAT_BN_WHISPER_INFORM_GET = "T: %s "
_G.CHAT_BN_WHISPER_GET = "F: %s "
_G.CHAT_GUILD_GET = "|Hchannel:Guild|h".."[G]".."|h %s:\32"
_G.CHAT_OFFICER_GET = "|Hchannel:o|h".."[O]".."|h %s:\32"
_G.CHAT_PARTY_GET = "|Hchannel:Party|h".."[P]".."|h %s:\32"
_G.CHAT_PARTY_GUIDE_GET = "|Hchannel:party|h".."[P]".."|h %s:\32"
_G.CHAT_PARTY_LEADER_GET = "|Hchannel:party|h".."[P]".."|h %s:\32"
_G.CHAT_RAID_GET = "|Hchannel:raid|h".."[R]".."|h %s:\32"
_G.CHAT_RAID_LEADER_GET = "|Hchannel:raid|h".."[R]".."|h %s:\32"
_G.CHAT_RAID_WARNING_GET = "[W]".." %s:\32"
_G.CHAT_SAY_GET = "%s:\32"
_G.CHAT_WHISPER_GET = "Fr".." %s:\32"
_G.CHAT_WHISPER_INFORM_GET = "To %s "
_G.CHAT_YELL_GET = "%s:\32"

_G.CHAT_FLAG_AFK = "|cffFF0000".."[AFK]".."|r "
_G.CHAT_FLAG_DND = "|cffE7E716".."[DND]".."|r "
_G.CHAT_FLAG_GM = "|cff4154F5".."[GM]".."|r "
 
_G.ERR_FRIEND_ONLINE_SS = "|Hplayer:%s|h[%s]|h ".."is now |cff298F00online|r".."!"
_G.ERR_FRIEND_OFFLINE_S = "%s ".."is now |cffff0000offline|r".."!"

Kill(FriendsMicroButton)
Kill(ChatFrameMenuButton)

if hidecombat==true then
    local EventFrame = CreateFrame("Frame");
    EventFrame:RegisterEvent("ADDON_LOADED");
    local function EventHandler(self, event, ...)
        if ... == "Blizzard_CombatLog" then
            local topbar = _G["CombatLogQuickButtonFrame_Custom"];
            if not topbar then return end
            topbar:Hide();
            topbar:HookScript("OnShow", function(self) topbar:Hide(); end);
            topbar:SetHeight(0);
        end
    end
    EventFrame:SetScript("OnEvent", EventHandler);
end
local function SetChatStyle(frame)
	local id = frame:GetID()
	local chat = frame:GetName()
	local tab = _G[chat.."Tab"]

	tab:SetAlpha(1)
	tab.SetAlpha = UIFrameFadeRemoveFrame
	
	_G[chat]:SetFading(false)
	_G[chat.."TabText"]:SetTextColor(unpack(Qulight["datatext"].color)) 
	_G[chat.."TabText"].SetTextColor = dummy
	_G[chat.."TabText"]:SetFont(Qulight["media"].font,11,"OUTLINE")
	_G[chat]:SetClampRectInsets(0,0,0,0)
	_G[chat]:SetClampedToScreen(false)
	_G[chat]:SetMinResize(371,111)
	_G[chat]:SetMinResize(371 + 1,111)
	
	for j = 1, #CHAT_FRAME_TEXTURES do
		_G[chat..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
	end
			
	Kill(_G[format("ChatFrame%sTabLeft", id)])
	Kill(_G[format("ChatFrame%sTabMiddle", id)])
	Kill(_G[format("ChatFrame%sTabRight", id)])

	Kill(_G[format("ChatFrame%sTabSelectedLeft", id)])
	Kill(_G[format("ChatFrame%sTabSelectedMiddle", id)])
	Kill(_G[format("ChatFrame%sTabSelectedRight", id)])
	
	Kill(_G[format("ChatFrame%sTabHighlightLeft", id)])
	Kill(_G[format("ChatFrame%sTabHighlightMiddle", id)])
	Kill(_G[format("ChatFrame%sTabHighlightRight", id)])

	Kill(_G[format("ChatFrame%sTabSelectedLeft", id)])
	Kill(_G[format("ChatFrame%sTabSelectedMiddle", id)])
	Kill(_G[format("ChatFrame%sTabSelectedRight", id)])

	
	tab.leftSelectedTexture:Hide()
	tab.middleSelectedTexture:Hide()
	tab.rightSelectedTexture:Hide()
	tab.leftSelectedTexture.Show = tab.leftSelectedTexture.Hide
	tab.middleSelectedTexture.Show = tab.middleSelectedTexture.Hide
	tab.rightSelectedTexture.Show = tab.rightSelectedTexture.Hide
	
	Kill(_G[format("ChatFrame%sButtonFrameUpButton", id)])
	Kill(_G[format("ChatFrame%sButtonFrameDownButton", id)])
	Kill(_G[format("ChatFrame%sButtonFrameBottomButton", id)])
	Kill(_G[format("ChatFrame%sButtonFrameMinimizeButton", id)])
	Kill(_G[format("ChatFrame%sButtonFrame", id)])

	Kill(_G[format("ChatFrame%sEditBoxFocusLeft", id)])
	Kill(_G[format("ChatFrame%sEditBoxFocusMid", id)])
	Kill(_G[format("ChatFrame%sEditBoxFocusRight", id)])

	local a, b, c = select(6, _G[chat.."EditBox"]:GetRegions()); Kill (a); Kill (b); Kill (c)
				
	_G[chat.."EditBox"]:SetAltArrowKeyMode(false)
	_G[chat.."EditBox"]:Hide()
	_G[chat.."EditBox"]:HookScript("OnEditFocusLost", function(self) self:Hide() end)
	_G[chat.."Tab"]:HookScript("OnClick", function() _G[chat.."EditBox"]:Hide() end)

	local editbox = _G["ChatFrame"..id.."EditBox"]
	local left, mid, right = select(6, editbox:GetRegions())
	left:Hide(); mid:Hide(); right:Hide()
	editbox:ClearAllPoints();
	editbox:SetPoint("BOTTOMLEFT", UIParent, 5, 5)
	editbox:SetWidth(Qulight["chatt"].editboxwidth)
	editbox:SetHeight(Qulight["chatt"].editboxheight)
	frame1px(editbox)
end
local function SetupChat(self)	
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format("ChatFrame%s", i)]
		SetChatStyle(frame)
		FCFTab_UpdateAlpha(frame)
	end

	ChatTypeInfo.WHISPER.sticky = 1
	ChatTypeInfo.BN_WHISPER.sticky = 1
	ChatTypeInfo.OFFICER.sticky = 1
	ChatTypeInfo.RAID_WARNING.sticky = 1
	ChatTypeInfo.CHANNEL.sticky = 1
end
local function SetupChatPosAndFont(self)	
	for i = 1, NUM_CHAT_WINDOWS do
		local chat = _G[format("ChatFrame%s", i)]
		local tab = _G[format("ChatFrame%sTab", i)]
		local id = chat:GetID()
		local name = FCF_GetChatWindowInfo(id)
		local point = GetChatWindowSavedPosition(id)
		local _, fontSize = FCF_GetChatWindowInfo(id)
		
		FCF_SetChatWindowFontSize(nil, chat, 11)
		
		ChatFrame1:ClearAllPoints()
		ChatFrame1:SetPoint("BOTTOMLEFT", ChatBackground, "BOTTOMLEFT", 5, 5)			
	end	
end
Chat:RegisterEvent("ADDON_LOADED")
Chat:RegisterEvent("PLAYER_ENTERING_WORLD")
Chat:SetScript("OnEvent", function(self, event, ...)
	for i = 1, NUM_CHAT_WINDOWS do
		_G["ChatFrame"..i]:SetClampRectInsets(0,0,0,0)
		_G["ChatFrame"..i]:SetWidth(Qulight["chatt"].chatframewidth)
		_G["ChatFrame"..i]:SetHeight(Qulight["chatt"].chatframeheight)
	end	
	local addon = ...
	if event == "ADDON_LOADED" then
		if addon == "Blizzard_CombatLog" then
			self:UnregisterEvent("ADDON_LOADED")
			SetupChat(self)
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		SetupChatPosAndFont(self)
		Chat:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
	if event == "PLAYER_LOGIN" then
		SetupChatPosAndFont(self)
	end
end)
local function SetupTempChat()
	local frame = FCF_GetCurrentChatFrame()
	SetChatStyle(frame)
end
hooksecurefunc("FCF_OpenTemporaryWindow", SetupTempChat)
for i = 1, NUM_CHAT_WINDOWS do
	local editBox = _G["ChatFrame"..i.."EditBox"]
	editBox:HookScript("OnTextChanged", function(self)
	   local text = self:GetText()
	   if text:len() < 5 then
		  if text:sub(1, 4) == "/tt " then
			 local unitname, realm
			 unitname, realm = UnitName("target")
			 if unitname then unitname = gsub(unitname, " ", "") end
			 if unitname and not UnitIsSameServer("player", "target") then
				unitname = unitname .. "-" .. gsub(realm, " ", "")
			 end
			 ChatFrame_SendTell((unitname or "Invalid Target"), ChatFrame1)
		  end
	   end
	end)
end
local SetItemRef_orig = SetItemRef
function ReURL_SetItemRef(link, text, button, chatFrame)
	if (strsub(link, 1, 3) == "url") then
		local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
		local url = strsub(link, 5);
		if (not ChatFrameEditBox:IsShown()) then
			ChatEdit_ActivateChat(ChatFrameEditBox)
		end
		ChatFrameEditBox:Insert(url)
		ChatFrameEditBox:HighlightText()

	else
		SetItemRef_orig(link, text, button, chatFrame)
	end
end
SetItemRef = ReURL_SetItemRef
function ReURL_AddLinkSyntax(chatstring)
	if (type(chatstring) == "string") then
		local extraspace;
		if (not strfind(chatstring, "^ ")) then
			extraspace = true;
			chatstring = " "..chatstring;
		end
		chatstring = gsub (chatstring, " www%.([_A-Za-z0-9-]+)%.(%S+)%s?", ReURL_Link("www.%1.%2"))
		chatstring = gsub (chatstring, " (%a+)://(%S+)%s?", ReURL_Link("%1://%2"))
		chatstring = gsub (chatstring, " ([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?", ReURL_Link("%1@%2%3%4"))
		chatstring = gsub (chatstring, " (%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?):(%d%d?%d?%d?%d?)%s?", ReURL_Link("%1.%2.%3.%4:%5"))
		chatstring = gsub (chatstring, " (%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%s?", ReURL_Link("%1.%2.%3.%4"))
		if (extraspace) then
			chatstring = strsub(chatstring, 2);
		end
	end
	return chatstring
end

REURL_COLOR = "16FF5D"
ReURL_Brackets = false
ReUR_CustomColor = true

function ReURL_Link(url)
	if (ReUR_CustomColor) then
		if (ReURL_Brackets) then
			url = " |cff"..REURL_COLOR.."|Hurl:"..url.."|h["..url.."]|h|r "
		else
			url = " |cff"..REURL_COLOR.."|Hurl:"..url.."|h"..url.."|h|r "
		end
	else
		if (ReURL_Brackets) then
			url = " |Hurl:"..url.."|h["..url.."]|h "
		else
			url = " |Hurl:"..url.."|h"..url.."|h "
		end
	end
	return url
end
for i=1, NUM_CHAT_WINDOWS do
	local frame = getglobal("ChatFrame"..i)
	local addmessage = frame.AddMessage
	frame.AddMessage = function(self, text, ...) addmessage(self, ReURL_AddLinkSyntax(text), ...) end
end
-----------------------------------------------------------------------------
-- Copy Chat (by Shestak)
-----------------------------------------------------------------------------
local lines = {}
local frame = nil
local editBox = nil
local isf = nil

local function CreatCopyFrame()
	frame = CreateFrame("Frame", "CopyFrame", UIParent)
	frame:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8x8",
			edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
			tile = 0, tileSize = 0, edgeSize = 1, 
			insets = { left = -1, right = -1, top = -1, bottom = -1 }
	})
	
	local tex = frame:CreateTexture(nil, "BORDER")
	tex:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
	tex:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
	tex:SetTexture("Interface\\Addons\\QulightUI\\media\\Other\\statusbar3")
	tex:SetVertexColor(unpack(Qulight["media"].backdropcolor))
	tex:SetDrawLayer("BORDER", -8)
	frame.tex = tex
	
	frame:SetBackdropColor(unpack(Qulight["media"].backdropcolor))
	frame:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor))
	frame:SetWidth(500)
	frame:SetHeight(300)
	frame:SetScale(0.9)
	frame:SetPoint("LEFT", UIParent, "LEFT", 10, 0)
	frame:Hide()
	frame:SetFrameStrata("DIALOG")
    CreateShadow(frame)

	local scrollArea = CreateFrame("ScrollFrame", "CopyScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)
	editBox = CreateFrame("EditBox", "CopyBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetWidth(500)
	editBox:SetHeight(300)
	editBox:SetScript("OnEscapePressed", function() frame:Hide() end)
	scrollArea:SetScrollChild(editBox)
	local close = CreateFrame("Button", "CopyCloseButton", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
	isf = true
end

local function GetLines(...)
	local ct = 1
	for i = select("#", ...), 1, -1 do
		local region = select(i, ...)
		if region:GetObjectType() == "FontString" then
			lines[ct] = tostring(region:GetText())
			ct = ct + 1
		end
	end
	return ct - 1
end
local function Copy(cf)
	local _, size = cf:GetFont()
	FCF_SetChatWindowFontSize(cf, cf, 0.01)
	local lineCt = GetLines(cf:GetRegions())
	local text = table.concat(lines, "\n", 1, lineCt)
	FCF_SetChatWindowFontSize(cf, cf, size)
	if not isf then CreatCopyFrame() end
	frame:Show()
	editBox:SetText(text)
	editBox:HighlightText(0)
end
function ChatCopyButtons()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G[format("ChatFrame%d",  i)]
		local button = CreateFrame("Button", format("ButtonCF%d", i), cf)
		button:SetHeight(20)
		button:SetWidth(20)
		button:SetPoint("CENTER", datalefticon, "CENTER")
			
		local buttontext = button:CreateFontString(nil,"OVERLAY",nil)
		buttontext:SetFont(Qulight["media"].font,11,"OUTLINE")
		buttontext:SetText("C")
		buttontext:SetPoint("CENTER", 1, 0)
		buttontext:SetJustifyH("CENTER")
		buttontext:SetJustifyV("CENTER")
		buttontext:SetTextColor(unpack(Qulight["datatext"].color)) 
						
		button:SetScript("OnMouseUp", function(self, btn)
			if i == 1 and btn == "RightButton" then
				ToggleFrame(ChatMenu)
			else
				Copy(cf)
			end
		end)
	end
end
ChatCopyButtons()
------------------------------------------------------------------------
--	Enhance/rewrite a Blizzard feature, chatframe mousewheel.
------------------------------------------------------------------------
local ScrollLines = 3 -- set the jump when a scroll is done !
function FloatingChatFrame_OnMouseScroll(self, delta)
	if delta < 0 then
		if IsShiftKeyDown() then
			self:ScrollToBottom()
		else
			for i = 1, ScrollLines do
				self:ScrollDown()
			end
		end
	elseif delta > 0 then
		if IsShiftKeyDown() then
			self:ScrollToTop()
		else
			for i = 1, ScrollLines do
				self:ScrollUp()
			end
		end
	end
end
if not Qulight["chatt"].chatbar == true then return end
--chatbar by AlleyKat
local chatbar =  CreateFrame("Frame",nil)
chatbar:SetPoint("TOPLEFT",ChatFrame1,"BOTTOMRIGHT",86,10)
chatbar:SetPoint("BOTTOMRIGHT",ChatFrame1,"BOTTOMRIGHT",86,10)
chatbar:SetHeight(120)

local setbutton = function(chan,tosay,s)
	local frame = CreateFrame("Frame",nil,chatbar)
	frame:SetSize(8,8)
	frame:SetBackdrop({
	bgFile = "Interface\\Buttons\\WHITE8x8", 
	edgeFile = "Interface\\Buttons\\WHITE8x8", 
	edgeSize = 1, insets = {left = 1, right = 1, top = 1, bottom = 1}})
	local r,g,b = ChatTypeInfo[chan].r,ChatTypeInfo[chan].g,ChatTypeInfo[chan].b
	frame:SetBackdropColor(r,g,b,1)
	frame:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor))
	frame:EnableMouse(true)
	frame:SetFrameLevel(5)
	frame:SetScript("OnMouseDown",function() ChatFrame_OpenChat(tosay, SELECTED_DOCK_FRAME) end)
	return frame
end
local gg = function()
	local b = {}
	local chant = {"SAY","PARTY","GUILD","RAID","YELL","BATTLEGROUND","CHANNEL1","CHANNEL2"}
	local chans = {"/s ","/p ","/g ","/raid ","/y ","/bg ","/1 ","/2 "}
	local o = chatbar:GetWidth()
	local wd
	local off
	if o < 200 then
		wd = 17
		off = -75
	else
		wd = 21
		off = -91	
	end
	for i=1, #chant do
		b[i] = setbutton(chant[i],chans[i],wd)
		if i ~= 1 then 
			b[i]:SetPoint("TOP",b[i-1],"TOP",0,9)
		else
			b[i]:SetPoint("TOP",chatbar,"TOP",off,0)
		end
	end
end
chatbar:RegisterEvent("PLAYER_ENTERING_WORLD")
chatbar:SetScript("OnEvent",function(self)
	gg()
	self:SetScript("OnEvent",nil)
	self:UnregisterAllEvents()
end)
