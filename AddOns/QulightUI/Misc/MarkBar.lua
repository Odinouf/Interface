if not Qulight["misk"].markbar == true then return end

-- Config
font = Qulight["media"].font           
fontsize = 10                     		
buttonwidth = 27    		
buttonheight = 27  
 		
AnchorMarkBar = CreateFrame("Frame","Move_MarkBar",UIParent)
AnchorMarkBar:SetPoint("TOP", UIParent, "TOP", -50, -20)
CreateAnchor(AnchorMarkBar, "Move Mark Bar", 120, 20)						

local anchor = {}
anchor = {"TOP", AnchorMarkBar}



--Background Frame
local MarkBarBG = CreateFrame("Frame", "MarkBarBackground", UIParent)
CreatePanel(MarkBarBG, buttonwidth * 4 + 15, buttonheight * 3, "BOTTOMLEFT", datarightp, "TOPLEFT", 0, 3)
MarkBarBG:SetBackdropColor(unpack(Qulight["media"].backdropcolor))
MarkBarBG:SetFrameLevel(0)
MarkBarBG:SetFrameStrata("HIGH")
MarkBarBG:ClearAllPoints()
MarkBarBG:SetPoint(unpack(anchor))
MarkBarBG:Hide()
CreateShadow(MarkBarBG)

--Change border when mouse is inside the button
local function ButtonEnter(self)
	local color = RAID_CLASS_COLORS[myclass]
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end
 
--Change border back to normal when mouse leaves button
local function ButtonLeave(self)
	self:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor))
end

-- Mark Button BG and icons
icon = CreateFrame("Button", "tmb_Icon", MarkBarBG)
mark = CreateFrame("Button", "tmb_Menu", MarkBarBG)
for i = 1, 8 do
	mark[i] = CreateFrame("Button", "tbm_Mark"..i, MarkBarBG)
	CreatePanel(mark[i], buttonwidth, buttonheight, "LEFT", MarkBarBG, "LEFT", 3, -3)
	if i == 1 then
		mark[i]:SetPoint("TOPLEFT", MarkBarBG, "TOPLEFT",  3, -3)
	elseif i == 5 then
		mark[i]:SetPoint("TOP", mark[1], "BOTTOM", 0, -3)
	else
		mark[i]:SetPoint("LEFT", mark[i-1], "RIGHT", 3, 0)
	end
	mark[i]:EnableMouse(true)
	mark[i]:SetScript("OnEnter", ButtonEnter)
	mark[i]:SetScript("OnLeave", ButtonLeave)
	mark[i]:RegisterForClicks("AnyUp")
	mark[i]:SetFrameStrata("HIGH")
	
	icon[i] = CreateFrame("Button", "icon"..i, MarkBarBG)
	icon[i]:SetNormalTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
	icon[i]:SetSize(25, 25)
	icon[i]:SetPoint("CENTER", mark[i])
	icon[i]:SetFrameStrata("HIGH")
	
	-- Set up each button
	if i == 1 then -- Skull
		mark[i]:SetScript("OnMouseUp", function() SetRaidTarget("target", 8) end)
		icon[i]:GetNormalTexture():SetTexCoord(0.75,1,0.25,0.5)
	elseif i == 2 then -- Cross
		mark[i]:SetScript("OnMouseUp", function() SetRaidTarget("target", 7) end)
		icon[i]:GetNormalTexture():SetTexCoord(0.5,0.75,0.25,0.5)
	elseif i == 3 then -- Square
		mark[i]:SetScript("OnMouseUp", function() SetRaidTarget("target", 6) end)
		icon[i]:GetNormalTexture():SetTexCoord(0.25,0.5,0.25,0.5)
	elseif i == 4 then -- Moon
		mark[i]:SetScript("OnMouseUp", function() SetRaidTarget("target", 5) end)
		icon[i]:GetNormalTexture():SetTexCoord(0,0.25,0.25,0.5)
	elseif i == 5 then -- Triangle
		mark[i]:SetScript("OnMouseUp", function() SetRaidTarget("target", 4) end)
		icon[i]:GetNormalTexture():SetTexCoord(0.75,1,0,0.25)
	elseif i == 6 then -- Diamond
		mark[i]:SetScript("OnMouseUp", function() SetRaidTarget("target", 3) end)
		icon[i]:GetNormalTexture():SetTexCoord(0.5,0.75,0,0.25)
	elseif i == 7 then -- Circle
		mark[i]:SetScript("OnMouseUp", function() SetRaidTarget("target", 2) end)
		icon[i]:GetNormalTexture():SetTexCoord(0.25,0.5,0,0.25)
	elseif i == 8 then -- Star
		mark[i]:SetScript("OnMouseUp", function() SetRaidTarget("target", 1) end)
		icon[i]:GetNormalTexture():SetTexCoord(0,0.25,0,0.25)
	end
end

local function CreateMarkerButton(name, point, relativeto, point2, x, y)
    local f = CreateFrame("Button", name, MarkBarBG, "SecureActionButtonTemplate")
    f:SetPoint(point, relativeto, point2, x, y)
    f:SetWidth(10)
    f:SetHeight(10)
	frame1px(f)
	CreateShadow(f)
    f:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
    f:SetAttribute("type", "macro")
end

--Setup Secure Buttons
CreateMarkerButton("BlueFlare", "TOPLEFT", MarkBarBG, "TOPRIGHT", 3, 0)
BlueFlare:SetAttribute("macrotext", [[
/click CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
/click DropDownList1Button1
]])
BlueFlare:SetBackdropColor(0, 0, 1)
CreateMarkerButton("GreenFlare", "TOP", BlueFlare, "BOTTOM", 0, -4)
GreenFlare:SetAttribute("macrotext", [[
/click CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
/click DropDownList1Button2
]])
GreenFlare:SetBackdropColor(0, 1, 0)
CreateMarkerButton("PurpleFlare", "TOP", GreenFlare, "BOTTOM", 0, -4)
PurpleFlare:SetAttribute("macrotext", [[
/click CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
/click DropDownList1Button3
]])
PurpleFlare:SetBackdropColor(1, 0, 1)
CreateMarkerButton("RedFlare", "TOP", PurpleFlare, "BOTTOM", 0, -4)
RedFlare:SetAttribute("macrotext", [[
/click CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
/click DropDownList1Button4
]])
RedFlare:SetBackdropColor(1, 0, 0)
CreateMarkerButton("YellowFlare", "TOP", RedFlare, "BOTTOM", 0, -4)
YellowFlare:SetAttribute("macrotext", [[
/click CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
/click DropDownList1Button5
]])
YellowFlare:SetBackdropColor(1, 1, 0)
CreateMarkerButton("ClearFlare", "TOP", YellowFlare, "BOTTOM", 0, -2)
ClearFlare:SetAttribute("macrotext", [[
/click CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
/click DropDownList1Button6
]])
ClearFlare:SetBackdropColor(.075, .075, .075)
 
-- Create Button for clear target
local ClearTargetButton = CreateFrame("Button", "ClearTargetButton", MarkBarBackground)
CreatePanel(ClearTargetButton, (buttonwidth * 4) + 9, 16, "TOPLEFT", mark[5], "BOTTOMLEFT", 0, -3)
ClearTargetButton:SetScript("OnEnter", ButtonEnter)
ClearTargetButton:SetScript("OnLeave", ButtonLeave)
ClearTargetButton:SetScript("OnMouseUp", function() SetRaidTarget("target", 0) end)
ClearTargetButton:SetFrameStrata("HIGH")

local ClearTargetButtonText = ClearTargetButton:CreateFontString("ClearTargetButtonText","OVERLAY", ClearTargetButton)
ClearTargetButtonText:SetFont(Qulight["media"].font,fontsize,"OUTLINE")
ClearTargetButtonText:SetText("Clear Target")
ClearTargetButtonText:SetPoint("CENTER")
ClearTargetButtonText:SetJustifyH("CENTER", 1, 0)


--Create toggle button
local ToggleButton = CreateFrame("Frame", "ToggleButton", UIParent)
CreatePanel(ToggleButton, 100, 16, "CENTER", UIParent, "CENTER", 0, 0)
ToggleButton:ClearAllPoints()
ToggleButton:SetPoint(unpack(anchor))
ToggleButton:EnableMouse(true)
ToggleButton:SetScript("OnEnter", ButtonEnter)
ToggleButton:SetScript("OnLeave", ButtonLeave)
CreateShadow(ToggleButton)
local ToggleButtonText = ToggleButton:CreateFontString(nil ,"OVERLAY")
ToggleButtonText:SetFont(Qulight["media"].font, fontsize)
ToggleButtonText:SetText("Mark Bar")
ToggleButtonText:SetPoint("CENTER", ToggleButton, "CENTER")
	
--Create close button
local CloseButton = CreateFrame("Frame", "CloseButton", MarkBarBackground)
CreatePanel(CloseButton, 15, 15, "TOPRIGHT", MarkBarBackground, "TOPLEFT", -3, 0)
CloseButton:EnableMouse(true)
CloseButton:SetScript("OnEnter", ButtonEnter)
CloseButton:SetScript("OnLeave", ButtonLeave)
CreateShadow(CloseButton)
local CloseButtonText = CloseButton:CreateFontString(nil, "OVERLAY")
CloseButtonText:SetFont(Qulight["media"].font, fontsize)
CloseButtonText:SetText("x")
CloseButtonText:SetPoint("CENTER", CloseButton, "CENTER")

ToggleButton:SetScript("OnMouseDown", function()
	if MarkBarBackground:IsShown() then
		MarkBarBackground:Hide()
	else
		MarkBarBackground:Show()
	end
end)
	
CloseButton:SetScript("OnMouseDown", function()
	if MarkBarBackground:IsShown() then
		MarkBarBackground:Hide()
	else
		ToggleButton:Show()
	end
end)

--Check if we are Raid Leader or Raid Officer
local function CheckRaidStatus()
	local inInstance, instanceType = IsInInstance()
	local partyMembers = GetNumPartyMembers()
 
	if not UnitInRaid("player") and partyMembers >= 1 then return true
	elseif UnitIsRaidOfficer("player") then return true
	elseif not inInstance or instanceType == "pvp" or instanceType == "arena" then return false
	end
end

--Automatically show/hide the frame if we have RaidLeader or RaidOfficer
local LeadershipCheck = CreateFrame("Frame")
LeadershipCheck:RegisterEvent("RAID_ROSTER_UPDATE")
LeadershipCheck:RegisterEvent("PARTY_MEMBERS_CHANGED")
LeadershipCheck:RegisterEvent("PLAYER_ENTERING_WORLD")
LeadershipCheck:SetScript("OnEvent", function(self, event)
	if CheckRaidStatus() then
		ToggleButton:Show()
		MarkBarBackground:Hide()
	else
		ToggleButton:Hide()
		MarkBarBackground:Hide()
	end
end)