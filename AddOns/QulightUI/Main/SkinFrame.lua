if not Qulight["skinframe"].enable == true then return end

local glowTex = "Interface\\Buttons\\WHITE8x8"
local bgtexture = [=[Interface\ChatFrame\ChatFrameBackground]=]

local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/Qulight["general"].UiScale
local function scale(x)
    return mult*math.floor(x/mult+.5)
end
function Scale(x) return scale(x) end
mult = mult
local function scale(x)
    return 1*math.floor(x/1+.5)
end
function qBD(f)
	f:SetBackdrop({
		bgFile =  bgtexture,
        edgeFile = glowTex, edgeSize = mult, 
		insets = {left = mult, right = mult, top = mult, bottom = mult} 
	})
	
	f:SetBackdropColor(unpack(Qulight["media"].backdropcolor))
	f:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor))
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
function texBD(f)
	f:SetBackdrop({
		bgFile =  bgtexture,
        edgeFile = glowTex, edgeSize = mult, 
		insets = {left = mult, right = mult, top = mult, bottom = mult} 
	})
	f:SetBackdropColor(unpack(Qulight["media"].backdropcolor))
	f:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor))
	SetTex2(f)
end
local function Kill(object)
	object.Show = dummy
	object:Hide()
end
local function SetModifiedBackdrop(self)
	local color = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
	self:SetBackdropColor(color.r, color.g, color.b, 0.15)
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end
local function SetOriginalBackdrop(self)
	self:SetBackdropColor(unpack(Qulight["media"].backdropcolor))
	self:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor))
end
function qBS(f)
	local sd = CreateFrame("Frame", nil, parent)
	sd.size = size or 3
	sd.offset = offset or 0
	sd:SetBackdrop({
		edgeSize = sd.size,
	})
	sd:SetPoint("TOPLEFT", parent, -sd.size - 1 - sd.offset, sd.size + 1 + sd.offset)
	sd:SetPoint("BOTTOMRIGHT", parent, sd.size + 1 + sd.offset, -sd.size - 1 - sd.offset)
	sd:SetBackdropBorderColor(r or 0, g or 0, b or 0)
	sd:SetAlpha(alpha or 1)
end
local function SkinButton(f)

	if f:GetName() then
		local l = _G[f:GetName().."Left"]
		local m = _G[f:GetName().."Middle"]
		local r = _G[f:GetName().."Right"]
		
		
		if l then l:SetAlpha(0) end
		if m then m:SetAlpha(0) end
		if r then r:SetAlpha(0) end
	end
	
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	if f.SetDisabledTexture then
		f:SetDisabledTexture("")
	end
	texBD(f)
	f:HookScript("OnEnter", SetModifiedBackdrop)
	f:HookScript("OnLeave", SetOriginalBackdrop)
end

local Skin = CreateFrame("Frame")
Skin:RegisterEvent("ADDON_LOADED")
Skin:SetScript("OnEvent", function(self, event, addon)
	
	if addon == "Blizzard_DebugTools" then
		qBD(ScriptErrorsFrame)
		qBD(EventTraceFrame)
		_G["EventTraceTooltip"]:HookScript("OnShow", function(self) qBD(self) end)

		local texs = {
			"TopLeft",
			"TopRight",
			"Top",
			"BottomLeft",
			"BottomRight",
			"Bottom",
			"Left",
			"Right",
			"TitleBG",
			"DialogBG",
		}

		for i = 1, #texs do
			_G["ScriptErrorsFrame"..texs[i]]:SetTexture(nil)
			_G["EventTraceFrame"..texs[i]]:SetTexture(nil)
		end

		for i = 1, ScriptErrorsFrame:GetNumChildren() do
			local child = select(i, ScriptErrorsFrame:GetChildren())
			if child:GetObjectType() == "Button" and not child:GetName() then
				SkinButton(child)
			end
		end
	end
	if IsAddOnLoaded("Skinner") then return end
	
		local skins = {
			"StaticPopup1",
			"StaticPopup2",
			"StaticPopup3",
			"GameMenuFrame",
			"InterfaceOptionsFrame",
			"VideoOptionsFrame",
			"AudioOptionsFrame",
			"LFDDungeonReadyStatus",
			"BNToastFrame",
			"TicketStatusFrameButton",
			"DropDownList1MenuBackdrop",
			"DropDownList2MenuBackdrop",
			"DropDownList1Backdrop",
			"DropDownList2Backdrop",
			"LFDSearchStatus",
			"AutoCompleteBox",
			"ReadyCheckFrame",
			"GhostFrameContentsFrame",
			"ColorPickerFrame",
			"ConsolidatedBuffsTooltip",
			"LFDRoleCheckPopup",
			"ChannelPulloutBackground",
			"ChannelPulloutTab",
			"FriendsTooltip",
			"LFDDungeonReadyDialog",
			"GuildInviteFrame",
			"ChatConfigFrame",
			"RolePollPopup",
			"AddFriendFrame",
			"ChannelFrameDaughterFrame",
			"AddonSets",
			"BaudErrorFrame",
			"BaudErrorFrameListScrollBox",
			"BaudErrorFrameDetailScrollBox",
			"OpacityFrame",
		}
		local lol = {
		"StackSplitFrame",
		}
		local insetskins = {
			"InterfaceOptionsFramePanelContainer",
			"InterfaceOptionsFrameAddOns",
			"InterfaceOptionsFrameCategories",
			"InterfaceOptionsFrameTab1",
			"InterfaceOptionsFrameTab2",
			"VideoOptionsFrameCategoryFrame",
			"VideoOptionsFramePanelContainer",			
			"AudioOptionsFrameCategoryFrame",
			"AudioOptionsSoundPanel",
			"AudioOptionsSoundPanelPlayback",
			"AudioOptionsSoundPanelHardware",
			"AudioOptionsSoundPanelVolume",
			"AudioOptionsVoicePanel",
			"AudioOptionsVoicePanelTalking",
			"AudioOptionsVoicePanelBinding",
			"AudioOptionsVoicePanelListening",
			"GhostFrameContentsFrame",
			"ChatConfigCategoryFrame",
			"ChatConfigChannelSettingsLeft",
			"ChatConfigChannelSettingsClassColorLegend",
			"ChatConfigBackgroundFrame",
			"ChatConfigOtherSettingsCombat",
			"ChatConfigOtherSettingsSystem",
			"ChatConfigOtherSettingsCreature",
			"ChatConfigOtherSettingsPVP",
			"ChatConfigChatSettingsClassColorLegend",
			"ChatConfigChatSettingsLeft",
		}

		-- Reskin popup buttons
		for i = 1, 4 do
			for j = 1, 3 do
				SkinButton(_G["StaticPopup"..i.."Button"..j])
			end
			qBD(_G["StaticPopup"..i.."EditBox"])
			CreateShadow(_G["StaticPopup"..i.."EditBox"])
			_G["StaticPopup"..i.."EditBoxLeft"]:SetTexture(nil)
			_G["StaticPopup"..i.."EditBoxMid"]:SetTexture(nil)
			_G["StaticPopup"..i.."EditBoxRight"]:SetTexture(nil)
			_G["StaticPopup"..i.."EditBox"]:SetHeight(20)
			_G["StaticPopup"..i.."EditBox"]:SetTextInsets(3, 0, 0, 0)
		end
		
		for i = 1, getn(skins) do
			local frame = _G[skins[i]]
			if frame then
				qBD(_G[skins[i]])
				CreateShadow(_G[skins[i]])
			end
		end
		for i = 1, getn(lol) do
			local frame = _G[lol[i]]
			if frame then
				frame1px(_G[lol[i]])
				CreateShadow(_G[lol[i]])
			end
		end
		
		for i = 1, getn(insetskins) do
			local frame = _G[insetskins[i]]
			if frame then
				qBD(_G[insetskins[i]])
			end
		end
		
		local ChatMenus = {
			"ChatMenu",
			"EmoteMenu",
			"LanguageMenu",
			"VoiceMacroMenu",
		}
 
		for i = 1, getn(ChatMenus) do
			if _G[ChatMenus[i]] == _G["ChatMenu"] then
				_G[ChatMenus[i]]:HookScript("OnShow", function(self) qBD(self) self:ClearAllPoints() self:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", 0, 30) end)
			else
				_G[ChatMenus[i]]:HookScript("OnShow", function(self) qBD(self) end)
			end
		end
				
		-- reskin all esc/menu buttons
		local BlizzardMenuButtons = {
			"Options", 
			"SoundOptions", 
			"UIOptions", 
			"Keybindings", 
			"Macros",
			"AddonManager",
			"Ratings",
			"AddOns", 
			"Logout", 
			"Quit", 
			"Continue",
			"Help",			
			"MacOptions"
		}
		
		for i = 1, getn(BlizzardMenuButtons) do
			local MenuButtons = _G["GameMenuButton"..BlizzardMenuButtons[i]]
			if MenuButtons then
				SkinButton(MenuButtons)
				_G["GameMenuButton"..BlizzardMenuButtons[i].."Left"]:SetAlpha(0)
				_G["GameMenuButton"..BlizzardMenuButtons[i].."Middle"]:SetAlpha(0)
				_G["GameMenuButton"..BlizzardMenuButtons[i].."Right"]:SetAlpha(0)
			end
		end
		
		if IsAddOnLoaded("OptionHouse") then
			SkinButton(GameMenuButtonOptionHouse)
		end
		
		-- hide header textures and move text/buttons.
		local BlizzardHeader = {
			"GameMenuFrame",
			"ChatConfigFrame",
			"InterfaceOptionsFrame", 
			"AudioOptionsFrame", 
			"VideoOptionsFrame",
			"GhostFrameContentsFrame",			
			"ColorPickerFrame",
		}
		
		for i = 1, getn(BlizzardHeader) do
			local title = _G[BlizzardHeader[i].."Header"]			
			if title then
				title:SetTexture("")
				title:ClearAllPoints()
				if title == _G["GameMenuFrameHeader"] then
					title:SetPoint("TOP", GameMenuFrame, 0, 7)
				elseif title == _G["ColorPickerFrameHeader"] then
					title:SetPoint("TOP", ColorPickerFrame, 0, 7)
				elseif title == _G["ChatConfigFrameHeader"] then
					title:SetPoint("TOP", ChatConfigFrame, 0, 7)
				else
					title:SetPoint("TOP", BlizzardHeader[i], 0, 0)
				end
			end
		end
		
		-- here we reskin all "normal" buttons
		local BlizzardButtons = {
			"GameMenuButtonOptions",
			"GameMenuButtonSoundOptions",
			"GameMenuButtonUIOptions",
			"GameMenuButtonKeybindings",
			"GameMenuButtonMacros",
			"GameMenuButtonRatings",
			"GameMenuButtonAddOns",
			"GameMenuButtonLogout",
			"GameMenuButtonQuit",
			"GameMenuButtonContinue",
			"GameMenuButtonMacOptions",
			"GameMenuButtonOptionHouse",
			"GameMenuButtonAddonManager",
			"GameMenuButtonSettingsGUI",
			"VideoOptionsFrameOkay",
			"VideoOptionsFrameCancel",
			"VideoOptionsFrameDefaults",
			"VideoOptionsFrameApply",
			"AudioOptionsFrameOkay",
			"AudioOptionsFrameCancel",
			"InterfaceOptionsFrameTab1",
			"InterfaceOptionsFrameTab2",
			"AudioOptionsFrameDefaults",
			"InterfaceOptionsFrameDefaults",
			"InterfaceOptionsFrameOkay",
			"InterfaceOptionsFrameCancel",
			"ReadyCheckFrameYesButton",
			"ReadyCheckFrameNoButton",
			"ColorPickerOkayButton",
			"ColorPickerCancelButton",
			"BaudErrorFrameClearButton",
			"BaudErrorFrameCloseButton",
			"GuildInviteFrameJoinButton",
			"GuildInviteFrameDeclineButton",
			"LFDDungeonReadyDialogLeaveQueueButton",
			"LFDDungeonReadyDialogEnterDungeonButton",
			"ChatConfigFrameDefaultButton",
			"ChatConfigFrameOkayButton",
			"RolePollPopupAcceptButton",
			"LFDRoleCheckPopupDeclineButton",
			"LFDRoleCheckPopupAcceptButton",
			"AddFriendEntryFrameCancelButton",
			"AddFriendEntryFrameAcceptButton",
			"ChannelFrameDaughterFrameOkayButton",
			"ChannelFrameDaughterFrameCancelButton",
			"CombatLogDefaultButton",
			"AddonSet1",
			"AddonSet2",
			"AddonSet3",
			"AddonSet4",
			"AddonSet5",
			"AddonSet6",
			"StackSplitOkayButton",
			"StackSplitCancelButton",
			"InterfaceOptionsUnitFramePanelResetPartyPosition",
			"InterfaceOptionsHelpPanelResetTutorials",
			"InterfaceOptionsRaidFramePanelResetPosition",
			"btn_aLoadFrame",
			"btn2_aLoadFrame",
		}
		
		for i = 1, getn(BlizzardButtons) do
		local Buttons = _G[BlizzardButtons[i]]
			if Buttons then
				SkinButton(Buttons)
			end
		end
		
		_G["VideoOptionsFrameDefaults"]:ClearAllPoints()
		_G["VideoOptionsFrameDefaults"]:SetPoint("TOPLEFT", _G["VideoOptionsFrameCategoryFrame"], "BOTTOMLEFT", 0, -14)
		_G["VideoOptionsFrameApply"]:ClearAllPoints()
		_G["VideoOptionsFrameApply"]:SetPoint("TOPRIGHT", _G["VideoOptionsFramePanelContainer"], "BOTTOMRIGHT", 0, -14)
		_G["VideoOptionsFrameCancel"]:ClearAllPoints()
		_G["VideoOptionsFrameCancel"]:SetPoint("RIGHT", _G["VideoOptionsFrameApply"], "LEFT", -4, 0)
		_G["VideoOptionsFrameOkay"]:ClearAllPoints()
		_G["VideoOptionsFrameOkay"]:SetPoint("RIGHT", _G["VideoOptionsFrameCancel"], "LEFT", -4, 0)
		_G["AudioOptionsFrameDefaults"]:ClearAllPoints()
		_G["AudioOptionsFrameDefaults"]:SetPoint("TOPLEFT", _G["AudioOptionsFrameCategoryFrame"], "BOTTOMLEFT", 0, -14)
		_G["AudioOptionsFrameCancel"]:ClearAllPoints()
		_G["AudioOptionsFrameCancel"]:SetPoint("TOPRIGHT", _G["AudioOptionsFramePanelContainer"], "BOTTOMRIGHT", 0, -14)
		_G["AudioOptionsFrameOkay"]:ClearAllPoints()
		_G["AudioOptionsFrameOkay"]:SetPoint("RIGHT", _G["AudioOptionsFrameCancel"], "LEFT", -4, 0)
		_G["InterfaceOptionsFrameDefaults"]:ClearAllPoints()
		_G["InterfaceOptionsFrameDefaults"]:SetPoint("TOPLEFT", _G["InterfaceOptionsFrameCategories"], "BOTTOMLEFT", 0, -14)
		_G["InterfaceOptionsFrameCancel"]:ClearAllPoints()
		_G["InterfaceOptionsFrameCancel"]:SetPoint("TOPRIGHT", _G["InterfaceOptionsFramePanelContainer"], "BOTTOMRIGHT", 0, -14)
		_G["InterfaceOptionsFrameOkay"]:ClearAllPoints()
		_G["InterfaceOptionsFrameOkay"]:SetPoint("RIGHT", _G["InterfaceOptionsFrameCancel"], "LEFT", -4, 0)
		_G["ColorPickerOkayButton"]:ClearAllPoints()
		_G["ColorPickerOkayButton"]:SetPoint("BOTTOMLEFT", _G["ColorPickerFrame"], "BOTTOMLEFT", 6, 6)
		_G["ColorPickerCancelButton"]:ClearAllPoints()
		_G["ColorPickerCancelButton"]:SetPoint("BOTTOMRIGHT", _G["ColorPickerFrame"], "BOTTOMRIGHT", -6, 6)
		_G["ReadyCheckFrameYesButton"]:SetParent(_G["ReadyCheckFrame"])
		_G["ReadyCheckFrameYesButton"]:ClearAllPoints()
		_G["ReadyCheckFrameNoButton"]:SetParent(_G["ReadyCheckFrame"])
		_G["ReadyCheckFrameNoButton"]:ClearAllPoints()
		_G["ReadyCheckFrameYesButton"]:SetPoint("RIGHT", _G["ReadyCheckFrame"], "CENTER", 0, -22)
		_G["ReadyCheckFrameNoButton"]:SetPoint("LEFT", _G["ReadyCheckFrameYesButton"], "RIGHT", 6, 0)
		_G["ReadyCheckFrameText"]:SetParent(_G["ReadyCheckFrame"])
		_G["ReadyCheckFrameText"]:ClearAllPoints()
		_G["ReadyCheckFrameText"]:SetPoint("TOP", 0, -12)
		_G["ChatConfigFrameDefaultButton"]:SetWidth(125)
		_G["ChatConfigFrameDefaultButton"]:ClearAllPoints()
		_G["ChatConfigFrameDefaultButton"]:SetPoint("TOP", _G["ChatConfigCategoryFrame"], "BOTTOM", 0, -4)
		_G["CombatLogDefaultButton"]:SetWidth(125)
		_G["CombatLogDefaultButton"]:ClearAllPoints()
		_G["CombatLogDefaultButton"]:SetPoint("TOP", _G["ChatConfigCategoryFrame"], "BOTTOM", 0, -4)
		_G["ChatConfigFrameOkayButton"]:ClearAllPoints()
		_G["ChatConfigFrameOkayButton"]:SetPoint("TOPRIGHT", _G["ChatConfigBackgroundFrame"], "BOTTOMRIGHT", 0, -4)
		_G["ChannelPulloutTabText"]:ClearAllPoints()
		_G["ChannelPulloutTabText"]:SetPoint("TOP", _G["ChannelPulloutTab"], "TOP", 0, -6)
		_G["ChannelPulloutTab"]:SetHeight(20)
		_G["ChannelPullout"]:ClearAllPoints()
		_G["ChannelPullout"]:SetPoint("TOP", _G["ChannelPulloutTab"], "BOTTOM", 0, -3)
		_G["ReadyCheckListenerFrame"]:SetAlpha(0)
		_G["ReadyCheckFrame"]:HookScript("OnShow", function(self) end)
		_G["StackSplitFrame"]:GetRegions():Hide()
		_G["ChannelPulloutTabLeft"]:SetTexture(nil)
		_G["ChannelPulloutTabMiddle"]:SetTexture(nil)
		_G["ChannelPulloutTabRight"]:SetTexture(nil)
		_G["InterfaceOptionsFrameTab1"]:ClearAllPoints()
		_G["InterfaceOptionsFrameTab1"]:SetPoint("TOPLEFT", _G["InterfaceOptionsFrameCategories"], "TOPLEFT", 0, 27)
		_G["InterfaceOptionsFrameTab1"]:SetWidth(60)
		_G["InterfaceOptionsFrameTab1"].SetWidth = dummy
		_G["InterfaceOptionsFrameTab2"]:ClearAllPoints()
		_G["InterfaceOptionsFrameTab2"]:SetPoint("TOPLEFT", _G["InterfaceOptionsFrameTab1"], "TOPRIGHT", 3, 0)
		_G["InterfaceOptionsFrameTab2"]:SetWidth(112)
		_G["InterfaceOptionsFrameTab2"].SetWidth = dummy
		Kill(_G["InterfaceOptionsFrameTab1TabSpacer"])
		Kill(_G["InterfaceOptionsFrameTab2TabSpacer1"])
		Kill(_G["InterfaceOptionsFrameTab2TabSpacer2"])
		
	if addon == "Blizzard_GuildUI" then
		_G["GuildFrameTab1"]:ClearAllPoints()
		_G["GuildFrameTab1"]:SetPoint("TOPLEFT", _G["GuildFrame"], "BOTTOMLEFT", -4, 2)
	end
	
	-- DBM-GUI Frame
	if addon == "DBM-GUI" then
		qBD(_G["DBM_GUI_OptionsFrame"])
		qBD(_G["DBM_GUI_OptionsFramePanelContainer"])

		_G["DBM_GUI_OptionsFrameTab1"]:ClearAllPoints()
		_G["DBM_GUI_OptionsFrameTab1"]:SetPoint("TOPLEFT", _G["DBM_GUI_OptionsFrameBossMods"], "TOPLEFT", 10, 27)
		_G["DBM_GUI_OptionsFrameTab2"]:ClearAllPoints()
		_G["DBM_GUI_OptionsFrameTab2"]:SetPoint("TOPLEFT", _G["DBM_GUI_OptionsFrameTab1"], "TOPRIGHT", 6, 0)
		
		_G["DBM_GUI_OptionsFrameBossMods"]:HookScript("OnShow", function(self) qBD(self) end)
		_G["DBM_GUI_OptionsFrameDBMOptions"]:HookScript("OnShow", function(self) qBD(self) end)
		_G["DBM_GUI_OptionsFrameHeader"]:SetTexture("")
		_G["DBM_GUI_OptionsFrameHeader"]:ClearAllPoints()
		_G["DBM_GUI_OptionsFrameHeader"]:SetPoint("TOP", DBM_GUI_OptionsFrame, 0, 7)
		
		local dbmbskins = {
			"DBM_GUI_OptionsFrameOkay",
			"DBM_GUI_OptionsFrameTab1",
			"DBM_GUI_OptionsFrameTab2",
		}
		
		for i = 1, getn(dbmbskins) do
			local buttons = _G[dbmbskins[i]]
			if buttons then
				SkinButton(buttons)
			end
		end
	end	
		
end)