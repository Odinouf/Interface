if not Qulight["togglemenu"].enable == true then return end
                   
hovercolor = {0,.8,1,1}

local addons = {
	["Recount"] = function()
        ToggleFrame(Recount.MainWindow)
        Recount.RefreshMainWindow()
    end,
    
    ["Skada"] = function()
        Skada:ToggleWindow()
    end,
    
    ["GatherMate2"] = function()
        GatherMate2.db.profile["showMinimap"] = not GatherMate2.db.profile["showMinimap"]
        GatherMate2.db.profile["showWorldMap"] = not GatherMate2.db.profile["showWorldMap"]
        GatherMate2:GetModule("Config"):UpdateConfig()
    end,
    
    ["AtlasLoot"] = function()
        ToggleFrame(AtlasLootDefaultFrame)
    end,
    
    ["Omen"] = function()
        ToggleFrame(Omen.Anchor)
    end,
    
    ["DXE"] = function()
        _G.DXE:ToggleConfig()
    end,
    
    ["DBM-Core"] = function()
        DBM:LoadGUI()
    end,
	
    ["EPGPz"] = function()
        EPGP:ToggleUI()
    end,
	
    ["TinyDPS"] = function()
        ToggleFrame(tdpsFrame)
    end,
    
    ["Qulight_ConfigUI"] = function()
       CreateQulightConfigUI()
    end,
		
    ["Panda"] = function()
        ToggleFrame(PandaPanel)
    end,

    ["PallyPower"] = function()
        ToggleFrame(PallyPowerFrame)
    end,

    ["ACP"] = function()
        ToggleFrame(ACP_AddonList)
    end,

    ["ScrollMaster"] = function()
        LibStub("AceAddon-3.0"):GetAddon("ScrollMaster").GUI:OpenFrame(1)
    end,
}

local MenuBG = CreateFrame("Frame", "MenuBackground", UIParent)
CreatePanel(MenuBG, Qulight["togglemenu"].buttonwidth + 10, Qulight["togglemenu"].buttonheight * 5 + 18, "TOP", UIParent, "TOP", 0, -300)
MenuBG:SetFrameLevel(0)
CreateShadow(MenuBG)
MenuBG:Hide()
 
local AddonBG = CreateFrame("Frame", "AddOnBackground", UIParent)
CreatePanel(AddonBG, Qulight["togglemenu"].buttonwidth + 10, 1, "TOP", MenuBG, "TOP", 0, 0)
AddonBG:SetFrameLevel(0)
CreateShadow(AddonBG)
AddonBG:Hide()

local DataText = CreateFrame("Frame")
DataText:EnableMouse(true)
DataText:SetFrameStrata("BACKGROUND")
DataText:SetFrameLevel(3)
local Text  = DataRightPanel:CreateFontString(nil, "OVERLAY")
Text:SetFont(Qulight["media"].font, 10)
PP(Qulight["datatext"].togglemenu, Text)
Text:SetText("Menu")
DataText:SetAllPoints(Text)
DataText:SetScript("OnMouseDown", function()
	ToggleFrame(MenuBackground)
	if AddOnBackground:IsShown() then AddOnBackground:Hide() end
end)

if Qulight["togglemenu"].classcolor == true then
	local classcolor = RAID_CLASS_COLORS[myclass]
	hovercolor = {classcolor.r,classcolor.g,classcolor.b,1}
end

menu = CreateFrame("Button", "Menu", MenuBG) -- Main buttons
for i = 1, 5 do
	menu[i] = CreateFrame("Button", "Menu"..i, MenuBG)
	CreatePanel(menu[i], Qulight["togglemenu"].buttonwidth, Qulight["togglemenu"].buttonheight, "BOTTOM", MenuBG, "BOTTOM", 0, 3)
	if i == 1 then
		menu[i]:SetPoint("BOTTOM", MenuBG, "BOTTOM", 0, 3)
	else
		menu[i]:SetPoint("BOTTOM", menu[i-1], "TOP", 0, 3)
	end
	menu[i]:EnableMouse(true)
	menu[i]:HookScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(hovercolor)) end)
	menu[i]:HookScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor)) end)
	menu[i]:RegisterForClicks("AnyUp")
	Text = menu[i]:CreateFontString(nil, "LOW")
	Text:SetFont(Qulight["media"].font, Qulight["media"].fontsize)
	Text:SetPoint("CENTER", menu[i], 0, 0)
 
	if i == 1 then -- KeyRing
		Text:SetText("KeyRing")
		menu[i]:SetScript("OnMouseUp", function() ToggleKeyRing() end)	
	elseif i == 2 then -- Reload UI
		Text:SetText("Reload UI")
		menu[i]:SetScript("OnClick", function() ReloadUI() end)
	elseif i == 3 then -- Calendar
		Text:SetText("Calendar")
		menu[i]:SetScript("OnMouseUp", function() ToggleCalendar() end)
	elseif i == 4 then -- AddOns
		Text:SetText("AddOns")
		menu[i]:SetScript("OnMouseUp", function() ToggleFrame(AddOnBackground); ToggleFrame(MenuBackground); end)
	elseif i == 5 then -- Close Menu
		Text:SetText("Close Menu")
		menu[i]:SetScript("OnMouseUp", function() MenuBG:Hide() AddOnBackground:Hide() end)
	end
end

local returnbutton = CreateFrame("Button", "AddonMenuReturnButton", AddonBG)
CreatePanel(returnbutton, Qulight["togglemenu"].buttonwidth, Qulight["togglemenu"].buttonheight, "TOP", AddonBG, "TOP", 0, -3)
returnbutton:EnableMouse(true)
returnbutton:HookScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(hovercolor)) end)
returnbutton:HookScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor)) end)
returnbutton:RegisterForClicks("AnyUp")
returnbutton:SetFrameLevel(1)
Text = returnbutton:CreateFontString(nil, "LOW")
Text:SetFont(Qulight["media"].font, Qulight["media"].fontsize)
Text:SetPoint("CENTER", returnbutton, 0, 0)
Text:SetText("Return")
returnbutton:SetScript("OnMouseUp", function() ToggleFrame(AddOnBackground); ToggleFrame(MenuBackground); end)

addonmenu = CreateFrame("Button", "AddonMenu", AddonBG)	-- AddOn page buttons
addonmenu[1] = returnbutton

for key, value in pairs(addons) do
	if IsAddOnLoaded(key) then
		local menuitem = CreateFrame("Button", "AddonMenu"..(#addonmenu + 1), AddonBG)
		CreatePanel(menuitem, Qulight["togglemenu"].buttonwidth, Qulight["togglemenu"].buttonheight, "TOP", addonmenu[#addonmenu], "BOTTOM", 0, -3)
		menuitem:EnableMouse(true)
		menuitem:HookScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(hovercolor)) end)
		menuitem:HookScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(Qulight["media"].bordercolor))end)
		menuitem:RegisterForClicks("AnyUp")
		menuitem:SetFrameLevel(1)
		Text = menuitem:CreateFontString(nil, "LOW")
		Text:SetFont(Qulight["media"].font, Qulight["media"].fontsize)
		Text:SetPoint("CENTER", menuitem, 0, 0)
		Text:SetText(key)
		menuitem:SetScript("OnMouseUp", value)
		addonmenu[#addonmenu + 1] = menuitem
	end
end

AddonBG:SetHeight((#addonmenu * Qulight["togglemenu"].buttonheight) + ((#addonmenu + 1) * 3))