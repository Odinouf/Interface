if not Qulight["misk"].raidutility == true then return end

AnchorRaidUtilityPanel = CreateFrame("Frame","Move_RaidUtilityPanel",UIParent)
AnchorRaidUtilityPanel:SetPoint("TOP", UIParent, "TOP", 50, -20)
CreateAnchor(AnchorRaidUtilityPanel, "Move Raid Utility Panel", 125, 20)


local RaidUtilityPanel = CreateFrame("Frame", "RaidUtilityPanel", UIParent)
CreatePanel(RaidUtilityPanel, 125, (5)*4 + (18)*3, "TOP", AnchorRaidUtilityPanel)
local r,g,b,_ = Qulight["media"].backdropcolor
RaidUtilityPanel:SetBackdropColor(unpack(Qulight["media"].backdropcolor))
CreateShadow(RaidUtilityPanel)
RaidUtilityPanel:Hide()
 
--Check if We are Raid Leader or Raid Officer
local function CheckRaidStatus()
	local inInstance, instanceType = IsInInstance()
	if (UnitIsRaidOfficer("player")) and not (inInstance and (instanceType == "pvp" or instanceType == "arena")) then
		return true
	else
		return false
	end
end
 
--Change border when mouse is inside the button
local function ButtonEnter(self)
	local color = RAID_CLASS_COLORS[myclass]
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end
 
--Change border back to normal when mouse leaves button
local function ButtonLeave(self)
	self:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor))
end
 
--Create button for when frame is hidden
local HiddenToggleButton = CreateFrame("Button", nil, UIParent)
HiddenToggleButton:SetHeight(16)
HiddenToggleButton:SetWidth(106)
frame1px(HiddenToggleButton)
CreateShadow(HiddenToggleButton)
HiddenToggleButton:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 350, -5)
HiddenToggleButton:SetScript("OnEnter", ButtonEnter)
HiddenToggleButton:SetScript("OnLeave", ButtonLeave)
HiddenToggleButton:SetScript("OnMouseUp", function(self)
	RaidUtilityPanel:Show()
	HiddenToggleButton:Hide()
end)
 
local HiddenToggleButtonText = HiddenToggleButton:CreateFontString(nil,"OVERLAY",HiddenToggleButton)
HiddenToggleButtonText:SetFont(Qulight["media"].font,10,"OUTLINE")
HiddenToggleButtonText:SetText("Raid Utility")
HiddenToggleButtonText:SetPoint("CENTER")
HiddenToggleButtonText:SetJustifyH("CENTER")
 
--Create button for when frame is shown
local ShownToggleButton = CreateFrame("Button", nil, RaidUtilityPanel)
ShownToggleButton:SetHeight(16)
ShownToggleButton:SetWidth(RaidUtilityPanel:GetWidth() / 2.5)
frame1px(ShownToggleButton)
CreateShadow(ShownToggleButton)
ShownToggleButton:SetPoint("TOP", RaidUtilityPanel, "BOTTOM", 0, -5)
ShownToggleButton:SetScript("OnEnter", ButtonEnter)
ShownToggleButton:SetScript("OnLeave", ButtonLeave)
ShownToggleButton:SetScript("OnMouseUp", function(self)
	RaidUtilityPanel:Hide()
	HiddenToggleButton:Show()
end)
 
local ShownToggleButtonText = ShownToggleButton:CreateFontString(nil,"OVERLAY",ShownToggleButton)
ShownToggleButtonText:SetFont(Qulight["media"].font,10,"OUTLINE")
ShownToggleButtonText:SetText("Close")
ShownToggleButtonText:SetPoint("CENTER")
ShownToggleButtonText:SetJustifyH("CENTER")
 
--Disband Raid button
local DisbandRaidButton = CreateFrame("Button", nil, RaidUtilityPanel)
DisbandRaidButton:SetHeight(16)
DisbandRaidButton:SetWidth(RaidUtilityPanel:GetWidth() * 0.8)
frame1px(DisbandRaidButton)
DisbandRaidButton:SetPoint("TOP", RaidUtilityPanel, "TOP", 0, -5)
DisbandRaidButton:SetScript("OnEnter", ButtonEnter)
DisbandRaidButton:SetScript("OnLeave", ButtonLeave)
DisbandRaidButton:SetScript("OnMouseUp", function(self)
	if CheckRaidStatus() then
		StaticPopup_Show("DISBAND_RAID")
		RaidUtilityPanel:Hide()
		HiddenToggleButton:Show()
	end
end)
 
local DisbandRaidButtonText = DisbandRaidButton:CreateFontString(nil,"OVERLAY",DisbandRaidButton)
DisbandRaidButtonText:SetFont(Qulight["media"].font,10,"OUTLINE")
DisbandRaidButtonText:SetText("Disband Group")
DisbandRaidButtonText:SetPoint("CENTER")
DisbandRaidButtonText:SetJustifyH("CENTER")
 
--Role Check button
local RoleCheckButton = CreateFrame("Button", nil, RaidUtilityPanel)
RoleCheckButton:SetHeight(16)
RoleCheckButton:SetWidth(RaidUtilityPanel:GetWidth() * 0.8)
frame1px(RoleCheckButton)
RoleCheckButton:SetPoint("TOP", DisbandRaidButton, "BOTTOM", 0, -5)
RoleCheckButton:SetScript("OnEnter", ButtonEnter)
RoleCheckButton:SetScript("OnLeave", ButtonLeave)
RoleCheckButton:SetScript("OnMouseUp", function(self)
	if CheckRaidStatus() then
		InitiateRolePoll()
		RaidUtilityPanel:Hide()
		HiddenToggleButton:Show()
	end
end)
 
local RoleCheckButtonText = RoleCheckButton:CreateFontString(nil,"OVERLAY",RoleCheckButton)
RoleCheckButtonText:SetFont(Qulight["media"].font,10,"OUTLINE")
RoleCheckButtonText:SetText(ROLE_POLL)
RoleCheckButtonText:SetPoint("CENTER")
RoleCheckButtonText:SetJustifyH("CENTER")
 
--Ready Check button
local ReadyCheckButton = CreateFrame("Button", nil, RaidUtilityPanel)
ReadyCheckButton:SetHeight(16)
ReadyCheckButton:SetWidth(RoleCheckButton:GetWidth() * 0.75)
frame1px(ReadyCheckButton)
ReadyCheckButton:SetPoint("TOPLEFT", RoleCheckButton, "BOTTOMLEFT", 0, -5)
ReadyCheckButton:SetScript("OnEnter", ButtonEnter)
ReadyCheckButton:SetScript("OnLeave", ButtonLeave)
ReadyCheckButton:SetScript("OnMouseUp", function(self)
	if CheckRaidStatus() then
		DoReadyCheck()
		RaidUtilityPanel:Hide()
		HiddenToggleButton:Show()
	end
end)
 
local ReadyCheckButtonText = ReadyCheckButton:CreateFontString(nil,"OVERLAY",ReadyCheckButton)
ReadyCheckButtonText:SetFont(Qulight["media"].font,10,"OUTLINE")
ReadyCheckButtonText:SetText(READY_CHECK)
ReadyCheckButtonText:SetPoint("CENTER")
ReadyCheckButtonText:SetJustifyH("CENTER")
 
--World Marker button
local WorldMarkerButton = CreateFrame("Button", nil, RaidUtilityPanel)
WorldMarkerButton:SetHeight(18)
WorldMarkerButton:SetWidth(RoleCheckButton:GetWidth() * 0.2)
frame1px(WorldMarkerButton)
WorldMarkerButton:SetPoint("TOPRIGHT", RoleCheckButton, "BOTTOMRIGHT", 0, -5)
 
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:ClearAllPoints()
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetAllPoints(WorldMarkerButton)
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetParent(WorldMarkerButton)
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetAlpha(0)
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:HookScript("OnEnter", function()
	local color = RAID_CLASS_COLORS[myclass]
	WorldMarkerButton:SetBackdropBorderColor(color.r, color.g, color.b)
end)
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:HookScript("OnLeave", function()
	WorldMarkerButton:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor))
end)

CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck:SetPoint("RIGHT", CompactRaidFrameManagerDisplayFrameHiddenModeToggle, "TOPRIGHT", 0, 0)
CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll:SetPoint("RIGHT", CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck, "TOPRIGHT")
--Hack Complete
 
local WorldMarkerButtonTexture = WorldMarkerButton:CreateTexture(nil,"OVERLAY",nil)
WorldMarkerButtonTexture:SetTexture("Interface\\RaidFrame\\Raid-WorldPing")
WorldMarkerButtonTexture:SetPoint("TOPLEFT", WorldMarkerButton, "TOPLEFT", 1, -1)
WorldMarkerButtonTexture:SetPoint("BOTTOMRIGHT", WorldMarkerButton, "BOTTOMRIGHT", -1, 1)
 
--Automatically show/hide the frame if we have RaidLeader or RaidOfficer
local LeadershipCheck = CreateFrame("Frame")
LeadershipCheck:RegisterEvent("RAID_ROSTER_UPDATE")
LeadershipCheck:RegisterEvent("PLAYER_ENTERING_WORLD")
LeadershipCheck:SetScript("OnEvent", function(self, event)
	if CheckRaidStatus() then
		RaidUtilityPanel:Hide()
		HiddenToggleButton:Show()
	else
		HiddenToggleButton:Hide()
		RaidUtilityPanel:Hide()
	end
end)