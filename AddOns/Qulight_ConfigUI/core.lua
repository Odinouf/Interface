local myPlayerRealm = GetCVar("realmName")
local myPlayerName  = UnitName("player")

local ALLOWED_GROUPS = {
	["general"]=1,
	["unitframes"]=1,
	["media"]=1,
	["actionbar"]=1,
	["chatt"]=1,
	["buffdebuff"]=1,
	["addonskins"]=1,
	["datatext"]=1,
	["nameplatess"]=1,
	["togglemenu"]=1,
	["minimapp"]=1,
	["map"]=1,
	["tooltip"]=1,
	["bags"]=1,
	["loot"]=1,
	["cooldown"]=1,
	["skinframe"]=1,
	["misk"]=1,
}

--List of "Table Names" that we do not want to show in the config
local TableFilter = {
	["filter"]=1,
}

local function Local(o)
-- general
	if o == "QulightConfigUIgeneral" then o = QulightL.option_general end
	if o == "QulightConfigUIgeneralAutoScale" then o = QulightL.option_general_uiscale end
	if o == "QulightConfigUIgeneralMultisampleProtect" then o = QulightL.option_general_multisample end
	if o == "QulightConfigUIgeneralUiScale" then o = QulightL.option_general_customuiscale end
	if o == "QulightConfigUIgeneralAutoRepair" then o = QulightL.option_general_AutoRepair end
	if o == "QulightConfigUIgeneralAutoGreed" then o = QulightL.option_general_AutoGreed end													
	if o == "QulightConfigUIgeneralAutoDisenchant" then o = QulightL.option_general_AutoDisenchant end									  		  
	if o == "QulightConfigUIgeneralAutoDeclineDuels" then o = QulightL.option_general_AutoDeclineDuels end
	if o == "QulightConfigUIgeneralAutoAcceptInvite" then o = QulightL.option_general_AutoAcceptInvite end
	if o == "QulightConfigUIgeneralAutoRelease" then o = QulightL.option_general_AutoRelease end
	if o == "QulightConfigUIgeneralBlizzardsErrorFrameHiding" then o = QulightL.option_general_BlizzardsErrorFrameHiding end
	-- Unitframes
	if o == "QulightConfigUIunitframes" then o = QulightL.option_unitframes end
	if o == "QulightConfigUIunitframesenable" then o = QulightL.option_unitframes_enable end
 	if o == "QulightConfigUIunitframesHealFrames" then o = QulightL.option_unitframes_HealFrames end
	if o == "QulightConfigUIunitframesshowIndicators" then o = QulightL.option_unitframes_showIndicators end
	if o == "QulightConfigUIunitframesshowAuraWatch" then o = QulightL.option_unitframes_showAuraWatch end
	if o == "QulightConfigUIunitframesShowParty" then o = QulightL.option_unitframes_ShowParty end
	if o == "QulightConfigUIunitframesShowRaid" then o = QulightL.option_unitframes_ShowRaid end
	if o == "QulightConfigUIunitframesRaidShowSolo" then o = QulightL.option_unitframes_RaidShowSolo end
	if o == "QulightConfigUIunitframesRaidShowAllGroups" then o = QulightL.option_unitframes_RaidShowAllGroups end
	if o == "QulightConfigUIunitframesenableDebuffHighlight" then o = QulightL.option_unitframes_enableDebuffHighlight end
	if o == "QulightConfigUIunitframesshowRaidDebuffs" then o = QulightL.option_unitframes_showRaidDebuffs end
	if o == "QulightConfigUIunitframesshowtot" then o = QulightL.option_unitframes_showtot end
	if o == "QulightConfigUIunitframesshowpet" then o = QulightL.option_unitframes_showpet end
	if o == "QulightConfigUIunitframesshowfocus" then o = QulightL.option_unitframes_showfocus end
	if o == "QulightConfigUIunitframesshowfocustarget" then o = QulightL.option_unitframes_showfocustarget end
	if o == "QulightConfigUIunitframesshowBossFrames" then o = QulightL.option_unitframes_showBossFrames end
	if o == "QulightConfigUIunitframesTotemBars" then o = QulightL.option_unitframes_TotemBars end
	if o == "QulightConfigUIunitframesMTFrames" then o = QulightL.option_unitframes_MTFrames end
	if o == "QulightConfigUIunitframesArenaFrames" then o = QulightL.option_unitframes_ArenaFrames end
	if o == "QulightConfigUIunitframesReputationbar" then o = QulightL.option_unitframes_Reputationbar end
	if o == "QulightConfigUIunitframesExperiencebar" then o = QulightL.option_unitframes_Experiencebar end
	if o == "QulightConfigUIunitframesshowPlayerAuras" then o = QulightL.option_unitframes_showPlayerAuras end
	if o == "QulightConfigUIunitframesThreatBar" then o = QulightL.option_unitframes_ThreatBar end
	if o == "QulightConfigUIunitframesshowPortrait" then o = QulightL.option_unitframes_showPortrait end
	if o == "QulightConfigUIunitframesshowRunebar" then o = QulightL.option_unitframes_showRunebar end
	if o == "QulightConfigUIunitframesshowHolybar" then o = QulightL.option_unitframes_showHolybar end
	if o == "QulightConfigUIunitframesshowEclipsebar" then o = QulightL.option_unitframes_showEclipsebar end
	if o == "QulightConfigUIunitframesshowShardbar" then o = QulightL.option_unitframes_showShardbar end
	if o == "QulightConfigUIunitframesRCheckIcon" then o = QulightL.option_unitframes_RCheckIcon end
	if o == "QulightConfigUIunitframesCastbars" then o = QulightL.option_unitframes_Castbars end
	if o == "QulightConfigUIunitframesshowLFDIcons" then o = QulightL.option_unitframes_showLFDIcons end
	--media
	if o == "QulightConfigUImedia" then o = QulightL.option_media end
	if o == "QulightConfigUImediafont" then o = QulightL.option_media_font end
	if o == "QulightConfigUImediapxfont" then o = QulightL.option_media_pxfont end
	if o == "QulightConfigUImediafontsize" then o = QulightL.option_media_fontsize end
	if o == "QulightConfigUImediabordercolor" then o = QulightL.option_media_bordercolor end
	if o == "QulightConfigUImediabackdropcolor" then o = QulightL.option_media_backdropcolor end
	if o == "QulightConfigUImediatexture" then o = QulightL.option_media_texture end
	if o == "QulightConfigUImediablank" then o = QulightL.option_media_blank end
	--bags
	if o == "QulightConfigUIbags" then o = QulightL.option_bags end
	if o == "QulightConfigUIbagsEnable" then o = QulightL.option_bags_Enable end
	if o == "QulightConfigUIbagsBagBars" then o = QulightL.option_bags_BagBars end
	--datatext
	if o == "QulightConfigUIdatatext" then o = QulightL.option_datatext end
	if o == "QulightConfigUIdatatextDurability" then o = QulightL.option_datatext_Durability end
	if o == "QulightConfigUIdatatextSystem" then o = QulightL.option_datatext_System end
	if o == "QulightConfigUIdatatextGold" then o = QulightL.option_datatext_Gold end
	if o == "QulightConfigUIdatatextGuild" then o = QulightL.option_datatext_Guild end
	if o == "QulightConfigUIdatatextFriends" then o = QulightL.option_datatext_Friends end
	if o == "QulightConfigUIdatatextBags" then o = QulightL.option_datatext_Bags end
	if o == "QulightConfigUIdatatextWowtime" then o = QulightL.option_datatext_Wowtime end
	if o == "QulightConfigUIdatatexttogglemenu" then o = QulightL.option_datatext_Togglemenu end
	if o == "QulightConfigUIdatatextTime24" then o = QulightL.option_datatext_Time24 end
	if o == "QulightConfigUIdatatextLocaltime" then o = QulightL.option_datatext_Localtime end
	if o == "QulightConfigUIdatatextclasscolor" then o = QulightL.option_datatext_classcolor end
	if o == "QulightConfigUIdatatextcolor" then o = QulightL.option_datatext_color end
	--loot
	if o == "QulightConfigUIloot" then o = QulightL.option_loot end
	if o == "QulightConfigUIlootlootframe" then o = QulightL.option_loot_lootframe end
	if o == "QulightConfigUIlootrolllootframe" then o = QulightL.option_loot_rolllootframe end
	--misk

	if o == "QulightConfigUIcooldown" then o = QulightL.option_cooldown end
	if o == "QulightConfigUIcooldownenable" then o = QulightL.option_enable end
	if o == "QulightConfigUIskinframe" then o = QulightL.option_skinframe end
	if o == "QulightConfigUIskinframeenable" then o = QulightL.option_enable end		
	
	--togglemenu
	if o == "QulightConfigUItogglemenu" then o = QulightL.option_togglemenu end
	if o == "QulightConfigUItogglemenuenable" then o = QulightL.option_enable end
	if o == "QulightConfigUItogglemenubuttonwidth" then o = QulightL.option_togglemenu_buttonwidth end
	if o == "QulightConfigUItogglemenubuttonheight" then o = QulightL.option_togglemenu_buttonheight end
	if o == "QulightConfigUItogglemenuclasscolor" then o = QulightL.option_togglemenu_classcolor end
	--chat
	if o == "QulightConfigUIchatt" then o = QulightL.option_chat end
	if o == "QulightConfigUIchattenable" then o = QulightL.option_chat_enable end
	if o == "QulightConfigUIchattchatbar" then o = QulightL.option_chat_chatbar end
	if o == "QulightConfigUIchattchatframewidth" then o = QulightL.option_chat_chatframewidth end
	if o == "QulightConfigUIchattchatframeheight" then o = QulightL.option_chat_chatframeheight end
	if o == "QulightConfigUIchatteditboxwidth" then o = QulightL.option_chat_editboxwidth end
	if o == "QulightConfigUIchatteditboxheight" then o = QulightL.option_chat_editboxheight end
	if o == "QulightConfigUIchatttabtextcolor" then o = QulightL.option_chat_tabtextcolor end
	--buffdebuff
	if o == "QulightConfigUIbuffdebuff" then o = QulightL.option_buffs end
	if o == "QulightConfigUIbuffdebuffenable" then o = QulightL.option_buffs_enable end
	if o == "QulightConfigUIbuffdebufficonsize" then o = QulightL.option_buffs_iconsize end
	if o == "QulightConfigUIbuffdebufficonsizede" then o = QulightL.option_buffs_iconsizede end
	if o == "QulightConfigUIbuffdebufftimefontsize" then o = QulightL.option_buffs_timefontsize end
	if o == "QulightConfigUIbuffdebuffcountfontsize" then o = QulightL.option_buffs_countfontsize end
	if o == "QulightConfigUIbuffdebuffspacing" then o = QulightL.option_buffs_spacing end
	if o == "QulightConfigUIbuffdebuffdebuffspacing" then o = QulightL.option_buffs_debuffspacing end
	if o == "QulightConfigUIbuffdebufftimeYoffset" then o = QulightL.option_buffs_timeYoffset end
	if o == "QulightConfigUIbuffdebuffBUFFS_PER_ROW" then o = QulightL.option_buffs_BUFFS_PER_ROW end
		
	if o == "QulightConfigUItooltip" then o = QulightL.option_tooltip end
	if o == "QulightConfigUItooltipenable" then o = QulightL.option_tooltip_enable end
	if o == "QulightConfigUItooltiphidecombat" then o = QulightL.option_tooltip_hidecombat end
	if o == "QulightConfigUItooltiphidebuttons" then o = QulightL.option_tooltip_hidebuttons end
	if o == "QulightConfigUItooltiphideuf" then o = QulightL.option_tooltip_hideuf end
	if o == "QulightConfigUItooltipcursor" then o = QulightL.option_tooltip_cursor end
	
	--addonskinning
	if o == "QulightConfigUIaddonskins" then o = QulightL.option_addonsskins end
	if o == "QulightConfigUIaddonskinsDBM" then o = QulightL.option_addonsskins_DBM end
	if o == "QulightConfigUIaddonskinsPallyPower" then o = QulightL.option_addonsskins_PallyPower end
	if o == "QulightConfigUIaddonskinsSkada" then o = QulightL.option_addonsskins_Skada end
	if o == "QulightConfigUIaddonskinsRecount" then o = QulightL.option_addonsskins_Recount end
	if o == "QulightConfigUIaddonskinsOmen" then o = QulightL.option_addonsskins_Omen end
	if o == "QulightConfigUIaddonskinsKLE" then o = QulightL.option_addonsskins_KLE end	
	if o == "QulightConfigUIaddonskinsQuartz" then o = QulightL.option_addonsskins_Quartz end		
	if o == "QulightConfigUIaddonskinsBigwigs" then o = QulightL.option_addonsskins_Bigwigs end	
	--nameplates
	if o == "QulightConfigUInameplatess" then o = QulightL.option_nameplates end
	if o == "QulightConfigUInameplatessenable" then o = QulightL.option_nameplates_enable end
		
	if o == "QulightConfigUIminimapp" then o = QulightL.option_Minimap end
	if o == "QulightConfigUIminimappenable" then o = QulightL.option_Minimapenable end
	if o == "QulightConfigUIminimappsize" then o = QulightL.option_Minimapminimapsize end
	if o == "QulightConfigUImap" then o = QulightL.option_Map end
	if o == "QulightConfigUImapenable" then o = QulightL.option_mapenable end
		
	
	if o == "QulightConfigUIactionbar" then o = QulightL.option_Actionbars end
	if o == "QulightConfigUIactionbarenable" then o = QulightL.option_Actionbars_enable end
	if o == "QulightConfigUIactionbarhotkey" then o = QulightL.option_Actionbars_hotkey end
	if o == "QulightConfigUIactionbarshapeshiftmouseover" then o = QulightL.option_Actionbars_shapeshiftmouseover end
	if o == "QulightConfigUIactionbarhideshapeshift" then o = QulightL.option_Actionbars_hideshapeshift end
	if o == "QulightConfigUIactionbarbottomrows" then o = QulightL.option_Actionbars_bottomrows end
	if o == "QulightConfigUIactionbarrightbars" then o = QulightL.option_Actionbars_rightbars end
	if o == "QulightConfigUIactionbarsplitbar" then o = QulightL.option_Actionbars_splitbar end
	if o == "QulightConfigUIactionbarrightbarmouseover" then o = QulightL.option_Actionbars_rightbarmouseover end
	if o == "QulightConfigUIactionbarbuttonsize" then o = QulightL.option_Actionbars_buttonsize end
	if o == "QulightConfigUIactionbarbuttonspacing" then o = QulightL.option_Actionbars_buttonspacing end
	if o == "QulightConfigUIactionbarpetbuttonsize" then o = QulightL.option_Actionbars_petbuttonsize end
	if o == "QulightConfigUIactionbarpetbuttonspacing" then o = QulightL.option_Actionbars_petbuttonspacing end
	if o == "QulightConfigUIactionbarswaptopbottombar" then o = QulightL.option_Actionbars_swaptopbottombar end
	if o == "QulightConfigUIactionbarmacrotext" then o = QulightL.option_Actionbars_macrotext end
	if o == "QulightConfigUIactionbarverticalstance" then o = QulightL.option_Actionbars_verticalstance end
	if o == "QulightConfigUIactionbarmicrobar" then o = QulightL.option_Actionbars_microbar end
	if o == "QulightConfigUIactionbarmousemicro" then o = QulightL.option_Actionbars_mousemicro end
	
	if o == "QulightConfigUImisk" then o = QulightL.option_misk end
	if o == "QulightConfigUImiskmarkbar" then o = QulightL.option_markbar end
	if o == "QulightConfigUImiskaddonmanager" then o = QulightL.option_addonmanager end
	if o == "QulightConfigUImiskclasstimer" then o = QulightL.option_classtimer end
	if o == "QulightConfigUImiskfilger" then o = QulightL.option_filger end
	if o == "QulightConfigUImiskraidutility" then o = QulightL.option_raidutility end
	if o == "QulightConfigUImiskBuffReminderRaidBuffs" then o = QulightL.option_BuffReminderRaidBuffs end
	if o == "QulightConfigUImiskReminder" then o = QulightL.option_Reminder end
	Qulight.option = o
end

local NewButton = function(text,parent)
	
	local result = CreateFrame("Button", nil, parent)
	local label = result:CreateFontString(nil,"OVERLAY",nil)
	label:SetFont(Qulight["media"].font,10,"OUTLINE")
	label:SetText(text)
	result:SetWidth(label:GetWidth())
	result:SetHeight(label:GetHeight())
	result:SetFontString(label)

	return result
end

StaticPopupDialogs["PERCHAR"] = {
	text = QulightL.option_perchar,
	OnAccept = function() 
		if QulightConfigAllCharacters:GetChecked() then 
			QulightConfigAll[myPlayerRealm][myPlayerName] = true
		else 
			QulightConfigAll[myPlayerRealm][myPlayerName] = false
		end 	
		ReloadUI() 
	end,
	OnCancel = function() 
		QulightConfigCover:Hide()
		if QulightConfigAllCharacters:GetChecked() then 
			QulightConfigAllCharacters:SetChecked(false)
		else 
			QulightConfigAllCharacters:SetChecked(true)
		end 		
	end,
	button1 = ACCEPT,
	button2 = CANCEL,
	timeout = 0,
	whileDead = 1,
}

StaticPopupDialogs["RESET_PERCHAR"] = {
	text = QulightL.option_resetchar,
	OnAccept = function() 
		QulightConfig = QulightConfigSettings
		ReloadUI() 
	end,
	OnCancel = function() if QulightConfigUI and QulightConfigUI:IsShown() then QulightConfigCover:Hide() end end,
	button1 = ACCEPT,
	button2 = CANCEL,
	timeout = 0,
	whileDead = 1,
}

StaticPopupDialogs["RESET_ALL"] = {
	text = QulightL.option_resetall,
	OnAccept = function() 
		QulightConfigSettings = nil
		QulightConfig = nil
		ReloadUI() 
	end,
	OnCancel = function() QulightConfigCover:Hide() end,
	button1 = ACCEPT,
	button2 = CANCEL,
	timeout = 0,
	whileDead = 1,
}

-- We wanna make sure we have all needed tables when we try add values
local function SetValue(group,option,value)		
	--Determine if we should be copying our default settings to our player settings, this only happens if we're not using player settings by default
	local mergesettings
	if QulightConfig == QulightConfigSettings then
		mergesettings = true
	else
		mergesettings = false
	end

	if QulightConfigAll[myPlayerRealm][myPlayerName] == true then
		if not QulightConfig then QulightConfig = {} end	
		if not QulightConfig[group] then QulightConfig[group] = {} end
		QulightConfig[group][option] = value
	else
		--Set PerChar settings to the same as our settings if theres no per char settings
		if mergesettings == true then
			if not QulightConfig then QulightConfig = {} end	
			if not QulightConfig[group] then QulightConfig[group] = {} end
			QulightConfig[group][option] = value
		end
		
		if not QulightConfigSettings then QulightConfigSettings = {} end
		if not QulightConfigSettings[group] then QulightConfigSettings[group] = {} end
		QulightConfigSettings[group][option] = value
	end
end

local VISIBLE_GROUP = nil
local function ShowGroup(group)

	if(VISIBLE_GROUP) then
		_G["QulightConfigUI"..VISIBLE_GROUP]:Hide()
	end
	if _G["QulightConfigUI"..group] then
		local o = "QulightConfigUI"..group
		Local(o)
		_G["QulightConfigUITitle"]:SetText(Qulight.option)
		local height = _G["QulightConfigUI"..group]:GetHeight()
		_G["QulightConfigUI"..group]:Show()
		local scrollamntmax = 305
		local scrollamntmin = scrollamntmax - 10
		local max = height > scrollamntmax and height-scrollamntmin or 1
		
		if max == 1 then
			_G["QulightConfigUIGroupSlider"]:SetValue(1)
			_G["QulightConfigUIGroupSlider"]:Hide()
		else
			_G["QulightConfigUIGroupSlider"]:SetMinMaxValues(0, max)
			_G["QulightConfigUIGroupSlider"]:Show()
			_G["QulightConfigUIGroupSlider"]:SetValue(1)
		end
		_G["QulightConfigUIGroup"]:SetScrollChild(_G["QulightConfigUI"..group])
		
		local x
		if QulightConfigUIGroupSlider:IsShown() then 
			_G["QulightConfigUIGroup"]:EnableMouseWheel(true)
			_G["QulightConfigUIGroup"]:SetScript("OnMouseWheel", function(self, delta)
				if QulightConfigUIGroupSlider:IsShown() then
					if delta == -1 then
						x = _G["QulightConfigUIGroupSlider"]:GetValue()
						_G["QulightConfigUIGroupSlider"]:SetValue(x + 10)
					elseif delta == 1 then
						x = _G["QulightConfigUIGroupSlider"]:GetValue()			
						_G["QulightConfigUIGroupSlider"]:SetValue(x - 30)	
					end
				end
			end)
		else
			_G["QulightConfigUIGroup"]:EnableMouseWheel(false)
		end		
		VISIBLE_GROUP = group
	end
end

function CreateQulightConfigUI()
	
	if QulightConfigUI then
		ShowGroup("general")
		QulightConfigUI:Show()
		return
	end
			
	-- MAIN FRAME
	local QulightConfigUI = CreateFrame("Frame","QulightConfigUI",UIParent)
	QulightConfigUI:SetPoint("CENTER", UIParent, "CENTER", 90, 0)
	QulightConfigUI:SetWidth(490)
	QulightConfigUI:SetHeight(300)
	QulightConfigUI:SetFrameStrata("DIALOG")
	QulightConfigUI:SetFrameLevel(20)
	
	-- TITLE 2
	local QulightConfigUITitleBox = CreateFrame("Frame","QulightConfigUI",QulightConfigUI)
	QulightConfigUITitleBox:SetWidth(510)
	QulightConfigUITitleBox:SetHeight(21)
	QulightConfigUITitleBox:SetPoint("TOPLEFT", -10, 36)
	frame1px(QulightConfigUITitleBox)
	CreateShadow(QulightConfigUITitleBox)
	
	local title = QulightConfigUITitleBox:CreateFontString("QulightConfigUITitle", "OVERLAY")
	title:SetFont(Qulight["media"].font, 10)
	title:SetPoint("LEFT", QulightConfigUITitleBox, "LEFT", 4, 0)
	
	local qulightlolpro = CreateFrame("Frame","QulightConfigUI",QulightConfigUI)
	qulightlolpro:SetWidth(150)
	qulightlolpro:SetHeight(21)
	qulightlolpro:SetPoint("TOPLEFT", -165, 36)
	frame1px(qulightlolpro)
	CreateShadow(qulightlolpro)
	
	local qulightlolprotitle = qulightlolpro:CreateFontString("qulightlolpro", "OVERLAY")
	qulightlolprotitle:SetFont(Qulight["media"].font, 18)
	qulightlolprotitle:SetText("Qulight UI")
	qulightlolprotitle:SetPoint("CENTER")	
	
	local QulightConfigUIBG = CreateFrame("Frame","QulightConfigUI",QulightConfigUI)
	QulightConfigUIBG:SetPoint("TOPLEFT", -10, 10)
	QulightConfigUIBG:SetPoint("BOTTOMRIGHT", 10, -10)
	frame1px(QulightConfigUIBG)
	CreateShadow(QulightConfigUIBG)
	
	-- GROUP SELECTION ( LEFT SIDE )
	local groups = CreateFrame("ScrollFrame", "QulightCatagoryGroup", QulightConfigUI)
	groups:SetPoint("TOPLEFT",-155,0)
	groups:SetWidth(130)
	groups:SetHeight(300)

	local groupsBG = CreateFrame("Frame","QulightConfigUI",QulightConfigUI)
	groupsBG:SetPoint("TOPLEFT", groups, -10, 10)
	groupsBG:SetPoint("BOTTOMRIGHT", groups, 10, -10)
	frame1px(groupsBG)
	CreateShadow(groupsBG)
	
	--This is our frame we will use to prevent clicking on the config, before you choose a popup window
	local QulightConfigCover = CreateFrame("Frame", "QulightConfigCover", QulightConfigUI)
	QulightConfigCover:SetPoint("TOPLEFT", QulightCatagoryGroup, "TOPLEFT")
	QulightConfigCover:SetPoint("BOTTOMRIGHT", QulightConfigUI, "BOTTOMRIGHT")
	QulightConfigCover:SetFrameLevel(QulightConfigUI:GetFrameLevel() + 20)
	QulightConfigCover:EnableMouse(true)
	QulightConfigCover:SetScript("OnMouseDown", function(self) print(QulightL.option_makeselection) end)
	QulightConfigCover:Hide()	
		
	local slider = CreateFrame("Slider", "QulightConfigUICatagorySlider", groups)
	slider:SetPoint("TOPRIGHT", 0, 0)
	slider:SetWidth(18)
	slider:SetHeight(300)
	slider:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
	slider:SetOrientation("VERTICAL")
	slider:SetValueStep(20)
	slider:SetScript("OnValueChanged", function(self,value) groups:SetVerticalScroll(value) end)
	frame1px(slider)
	local r,g,b,a = unpack(Qulight["media"].bordercolor)
	slider:SetBackdropColor(r,g,b,0.2)
	local child = CreateFrame("Frame",nil,groups)
	child:SetPoint("TOPLEFT")
	local offset=5
	for group in pairs(ALLOWED_GROUPS) do
		local o = "QulightConfigUI"..group
		Local(o)
		local button = NewButton(Qulight.option, child)
		button:SetHeight(14)
		button:SetWidth(110)
		button:SetPoint("TOPLEFT", 5,-(offset))
		button:SetScript("OnClick", function(self) ShowGroup(group) end)		
		offset=offset+16
	end
	child:SetWidth(110)
	child:SetHeight(offset)
	--slider:SetMinMaxValues(0, (offset == 0 and 1 or offset-12*25))
	slider:SetValue(1)
	groups:SetScrollChild(child)
	
	local x
	_G["QulightCatagoryGroup"]:EnableMouseWheel(true)
	_G["QulightCatagoryGroup"]:SetScript("OnMouseWheel", function(self, delta)
		if _G["QulightConfigUICatagorySlider"]:IsShown() then
			if delta == -1 then
				x = _G["QulightConfigUICatagorySlider"]:GetValue()
				_G["QulightConfigUICatagorySlider"]:SetValue(x + 10)
			elseif delta == 1 then
				x = _G["QulightConfigUICatagorySlider"]:GetValue()			
				_G["QulightConfigUICatagorySlider"]:SetValue(x - 20)	
			end
		end
	end)
	-- GROUP SCROLLFRAME ( RIGHT SIDE)
	local group = CreateFrame("ScrollFrame", "QulightConfigUIGroup", QulightConfigUI)
	group:SetPoint("TOPLEFT",0,5)
	group:SetWidth(490)
	group:SetHeight(300)
	local slider = CreateFrame("Slider", "QulightConfigUIGroupSlider", group)
	slider:SetPoint("TOPRIGHT",0,0)
	slider:SetWidth(18)
	slider:SetHeight(300)
	slider:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
	slider:SetOrientation("VERTICAL")
	slider:SetValueStep(20)
	frame1px(slider)
	local r,g,b,a = unpack(Qulight["media"].bordercolor)
	slider:SetBackdropColor(r,g,b,0.2)
	slider:SetScript("OnValueChanged", function(self,value) group:SetVerticalScroll(value) end)
	
	for group in pairs(ALLOWED_GROUPS) do
		local frame = CreateFrame("Frame","QulightConfigUI"..group,QulightConfigUIGroup)
		frame:SetPoint("TOPLEFT")
		frame:SetWidth(290)
	
		local offset=5

		if type(Qulight[group]) ~= "table" then error(group.." GroupName not found in config table.") return end
		for option,value in pairs(Qulight[group]) do

			if type(value) == "boolean" then
				local button = CreateFrame("CheckButton", "QulightConfigUI"..group..option, frame, "InterfaceOptionsCheckButtonTemplate")
				local o = "QulightConfigUI"..group..option
				Local(o)
				_G["QulightConfigUI"..group..option.."Text"]:SetText(Qulight.option)
				_G["QulightConfigUI"..group..option.."Text"]:SetFont(Qulight["media"].font, 10)
				button:SetChecked(value)
				button:SetScript("OnClick", function(self) SetValue(group,option,(self:GetChecked() and true or false)) end)
				button:SetPoint("TOPLEFT", 5, -(offset))
				offset = offset+20
			elseif type(value) == "number" or type(value) == "string" then
				local label = frame:CreateFontString(nil,"OVERLAY",nil)
				label:SetFont(Qulight["media"].font,10)
				local o = "QulightConfigUI"..group..option
				Local(o)
				label:SetText(Qulight.option)
				label:SetWidth(370)
				label:SetHeight(18)
				label:SetJustifyH("LEFT")
				label:SetPoint("TOPLEFT", 5, -(offset))
				
				local editbox = CreateFrame("EditBox", nil, frame)
				editbox:SetAutoFocus(false)
				editbox:SetMultiLine(false)
				editbox:SetWidth(250)
				editbox:SetHeight(18)
				editbox:SetMaxLetters(255)
				editbox:SetTextInsets(3,0,0,0)
				editbox:SetBackdrop({
					bgFile = "Interface\\Buttons\\WHITE8x8", 
					tiled = false,
				})
				editbox:SetBackdropColor(0,0,0,0.5)
				editbox:SetBackdropBorderColor(0,0,0,1)
				editbox:SetFontObject(GameFontHighlight)
				editbox:SetPoint("TOPLEFT", 5, -(offset+20))
				editbox:SetText(value)
				frame1px(editbox)
				
				local okbutton = CreateFrame("Button", nil, frame)
				okbutton:SetHeight(editbox:GetHeight())
				okbutton:SetWidth(editbox:GetHeight())
				frame1px(okbutton)
				okbutton:SetPoint("LEFT", editbox, "RIGHT", 2, 0)
				
				local oktext = okbutton:CreateFontString(nil,"OVERLAY",nil)
				oktext:SetFont(Qulight["media"].font,10)
				oktext:SetText("OK")
				oktext:SetPoint("CENTER", 1, 0)
				oktext:SetJustifyH("CENTER")
				okbutton:Hide()
 
				if type(value) == "number" then
					editbox:SetScript("OnEscapePressed", function(self) okbutton:Hide() self:ClearFocus() self:SetText(value) end)
					editbox:SetScript("OnChar", function(self) okbutton:Show() end)
					editbox:SetScript("OnEnterPressed", function(self) okbutton:Hide() self:ClearFocus() SetValue(group,option,tonumber(self:GetText())) end)
					okbutton:SetScript("OnMouseDown", function(self) editbox:ClearFocus() self:Hide() SetValue(group,option,tonumber(editbox:GetText())) end)
				else
					editbox:SetScript("OnEscapePressed", function(self) okbutton:Hide() self:ClearFocus() self:SetText(value) end)
					editbox:SetScript("OnChar", function(self) okbutton:Show() end)
					editbox:SetScript("OnEnterPressed", function(self) okbutton:Hide() self:ClearFocus() SetValue(group,option,tostring(self:GetText())) end)
					okbutton:SetScript("OnMouseDown", function(self) editbox:ClearFocus() self:Hide() SetValue(group,option,tostring(editbox:GetText())) end)
				end
				offset = offset+45
			elseif type(value) == "table" and not TableFilter[option] then
				local label = frame:CreateFontString(nil,"OVERLAY",nil)
				label:SetFont(Qulight["media"].font,10)
				local o = "QulightConfigUI"..group..option
				Local(o)
				label:SetText(Qulight.option)
				label:SetWidth(370)
				label:SetHeight(18)
				label:SetJustifyH("LEFT")
				label:SetPoint("TOPLEFT", 5, -(offset))
				
				colorbuttonname = (label:GetText().."ColorPicker")
				local colorbutton = CreateFrame("Button", colorbuttonname, frame)
				colorbutton:SetHeight(18)
				colorbutton:SetWidth(60)
				frame1px(colorbutton)
				colorbutton:SetBackdropBorderColor(unpack(value))
				colorbutton:SetPoint("LEFT", label, "RIGHT", 2, 0)
				local colortext = colorbutton:CreateFontString(nil,"OVERLAY",nil)
				colortext:SetFont(Qulight["media"].font,10)
				colortext:SetText("Set Color")
				colortext:SetPoint("CENTER")
				colortext:SetJustifyH("CENTER")
				
				
				local function round(number, decimal)
					return (("%%.%df"):format(decimal)):format(number)
				end	
				
				colorbutton:SetScript("OnMouseDown", function(button) 
					if ColorPickerFrame:IsShown() then return end
					local oldr, oldg, oldb, olda = unpack(value)

					local function ShowColorPicker(r, g, b, a, changedCallback, sameCallback)
						HideUIPanel(ColorPickerFrame)
						ColorPickerFrame.button = button
						ColorPickerFrame:SetColorRGB(r,g,b)
						ColorPickerFrame.hasOpacity = (a ~= nil and a < 1)
						ColorPickerFrame.opacity = a
						ColorPickerFrame.previousValues = {oldr, oldg, oldb, olda}
						ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = changedCallback, changedCallback, sameCallback;
						ShowUIPanel(ColorPickerFrame)
					end
										
					local function ColorCallback(restore)
						-- Something change
						if restore ~= nil or button ~= ColorPickerFrame.button then return end

						local newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB()
						
						value = { newR, newG, newB, newA }
						SetValue(group,option,(value)) 
						button:SetBackdropBorderColor(newR, newG, newB, newA)	
					end
					
					local function SameColorCallback()
						value = { oldr, oldg, oldb, olda }
						SetValue(group,option,(value))
						button:SetBackdropBorderColor(oldr, oldg, oldb, olda)
					end
										
					ShowColorPicker(oldr, oldg, oldb, olda, ColorCallback, SameColorCallback)
				end)
				
				offset = offset+25
			end
		end
				
		frame:SetHeight(offset)
		frame:Hide()
	end

	local reset = NewButton(QulightL.option_reset, QulightConfigUI)
	reset:SetWidth(90)
	reset:SetHeight(18)
	reset:SetPoint("BOTTOMLEFT",-10, -33)
	reset:SetScript("OnClick", function(self) 
		QulightConfigCover:Show()
		if QulightConfigAll[myPlayerRealm][myPlayerName] == true then
			StaticPopup_Show("RESET_PERCHAR")
		else
			StaticPopup_Show("RESET_ALL")
		end
	end)
	frametexpx(reset)
	CreateShadow(reset)
	
	local close = NewButton(QulightL.option_close, QulightConfigUI)
	close:SetWidth(90)
	close:SetHeight(18)
	close:SetPoint("BOTTOMRIGHT", 10, -33)
	close:SetScript("OnClick", function(self) QulightConfigUI:Hide() end)
	frametexpx(close)
	CreateShadow(close)
	
	local load = NewButton(QulightL.option_apply, QulightConfigUI)
	load:SetHeight(18)
	load:SetWidth(90)
	load:SetPoint("LEFT", reset, "RIGHT", 15, 0)
	load:SetPoint("RIGHT", close, "LEFT", -15, 0)
	load:SetScript("OnClick", function(self) ReloadUI() end)
	frametexpx(load)
	CreateShadow(load)
	
	if QulightConfigAll then
		local button = CreateFrame("CheckButton", "QulightConfigAllCharacters", QulightConfigUITitleBox, "InterfaceOptionsCheckButtonTemplate")
		
		button:SetScript("OnClick", function(self) StaticPopup_Show("PERCHAR") QulightConfigCover:Show() end)
		
		button:SetPoint("RIGHT", QulightConfigUITitleBox, "RIGHT",-3, 0)	
		
		local label = QulightConfigAllCharacters:CreateFontString(nil,"OVERLAY",nil)
		label:SetFont(Qulight["media"].font,10)
		
		label:SetText(QulightL.option_setsavedsetttings)
		label:SetPoint("RIGHT", button, "LEFT")
		
		if QulightConfigAll[myPlayerRealm][myPlayerName] == true then
			button:SetChecked(true)
		else
			button:SetChecked(false)
		end
	end	
	
end

SlashCmdList["UICONFIG"] = CreateQulightConfigUI
SLASH_UICONFIG1 = "/config"