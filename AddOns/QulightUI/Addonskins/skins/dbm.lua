----------------------------------------------------------------------------------------
--	DBM skin(by Affli)
----------------------------------------------------------------------------------------
if not Qulight["addonskins"].DBM == true then return end
local forcebosshealthclasscolor = false		-- Forces BossHealth to be classcolored. Not recommended.
local croprwicons = true					-- Crops blizz shitty borders from icons in RaidWarning messages
local rwiconsize = 12						-- RaidWarning icon size. Works only if croprwicons = true
local backdrop = {
	bgFile = "Interface\\Buttons\\WHITE8x8",
	insets = {left = 0, right = 0, top = 0, bottom = 0},
}

local DBMSkin = CreateFrame("Frame")
DBMSkin:RegisterEvent("PLAYER_LOGIN")
DBMSkin:SetScript("OnEvent", function(self, event, addon)
	if IsAddOnLoaded("DBM-Core") then
		

		local SkinBossTitle = function()
			local anchor = DBMBossHealthDropdown:GetParent()
			if not anchor.styled then
				local header = {anchor:GetRegions()}
				if header[1]:IsObjectType("FontString") then
					header[1]:SetFont(Qulight["media"].font, 10, "OUTLINE")
					header[1]:SetShadowOffset(0, 0, 0, 0)
					header[1]:SetTextColor(1, 1, 1, 1)
					anchor.styled = true	
				end
				header = nil
			end
			anchor = nil
		end
		
		local SkinBoss = function()
			local count = 1
			while (_G[format("DBM_BossHealth_Bar_%d", count)]) do
				local bar = _G[format("DBM_BossHealth_Bar_%d", count)]
				local background = _G[bar:GetName().."BarBorder"]
				local progress = _G[bar:GetName().."Bar"]
				local name = _G[bar:GetName().."BarName"]
				local timer = _G[bar:GetName().."BarTimer"]
				local prev = _G[format("DBM_BossHealth_Bar_%d", count-1)]

				if (count == 1) then
					local _, anch, _ , _, _ = bar:GetPoint()
					bar:ClearAllPoints()
					if DBM_SavedOptions.HealthFrameGrowUp then
						bar:SetPoint("BOTTOM", anch, "TOP", 0, 3)
					else
						bar:SetPoint("TOP", anch, "BOTTOM", 0, -3)
					end
				else
					bar:ClearAllPoints()
					if DBM_SavedOptions.HealthFrameGrowUp then
						bar:SetPoint("BOTTOMLEFT", prev, "TOPLEFT", 0, 3)
					else
						bar:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -3)
					end
				end

				if not bar.styled then
					bar:SetScale(1)
					bar:SetHeight(19)
					frame1px(bar)
					CreateShadow(bar)
					background:SetNormalTexture(nil)
					bar.styled = true
				end	
				
				if not progress.styled then
					progress:SetStatusBarTexture(Qulight["media"].texture)
					progress:SetBackdrop(backdrop)
					progress:SetBackdropColor(r,g,b,1)
					if forcebosshealthclasscolor then
						local tslu = 0
						progress:SetStatusBarColor(r,g,b,1)
						progress:HookScript("OnUpdate", function(self, elapsed)
							tslu = tslu+ elapsed
							if tslu > 0.025 then
								self:SetStatusBarColor(r,g,b,1)
								tslu = 0
							end
						end)
					end
					progress.styled = true
				end
				progress:ClearAllPoints()
				progress:SetPoint("TOPLEFT", bar, "TOPLEFT", 2, -2)
				progress:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -2, 2)

				if not name.styled then
					name:ClearAllPoints()
					name:SetPoint("LEFT", bar, "LEFT", 4, 0)
					name:SetFont(Qulight["media"].font, 10, "OUTLINE")
					name:SetShadowOffset(0, 0, 0, 0)
					name:SetJustifyH("LEFT")
					name.styled = true
				end
				
				if not timer.styled then
					timer:ClearAllPoints()
					timer:SetPoint("RIGHT", bar, "RIGHT", -5, 0)
					timer:SetFont(Qulight["media"].font, 10, "OUTLINE")
					timer:SetShadowOffset(0, 0, 0, 0)
					timer:SetJustifyH("RIGHT")
					timer.styled = true
				end
				count = count + 1
			end
		end
		
		--hooksecurefunc(DBT, "CreateBar", SkinBars)
		hooksecurefunc(DBM.BossHealth, "Show", SkinBossTitle)
		hooksecurefunc(DBM.BossHealth, "AddBoss", SkinBoss)
		hooksecurefunc(DBM.BossHealth,"UpdateSettings",SkinBoss)
		
		DBM.RangeCheck:Show()
		DBM.RangeCheck:Hide()

		DBMRangeCheck:HookScript("OnShow", function(self)
			frame1px(self)
			CreateShadow(self)
		end)
		
		if croprwicons then
			local replace = string.gsub
			local old = RaidNotice_AddMessage
			RaidNotice_AddMessage = function(noticeFrame, textString, colorInfo)
				if textString:find(" |T") then
					textString=replace(textString,"(:12:12)",":"..rwiconsize..":"..rwiconsize..":0:0:64:64:5:59:5:59")
				end
				return old(noticeFrame, textString, colorInfo)
			end
		end
	end
end)
local UploadDBM = function()
	DBM_SavedOptions.Enabled=true
	DBM_SavedOptions.WarningIconLeft=false
	DBM_SavedOptions.WarningIconRight=false
	DBT_SavedOptions["DBM"].Scale=1
	DBT_SavedOptions["DBM"].HugeScale=1
	DBT_SavedOptions["DBM"].BarXOffset=0
	DBT_SavedOptions["DBM"].BarYOffset=5
	DBT_SavedOptions["DBM"].IconLeft=true
	DBT_SavedOptions["DBM"].ExpandUpwards=true
	DBT_SavedOptions["DBM"].Texture= "Interface\\Buttons\\WHITE8x8"
	DBT_SavedOptions["DBM"].IconRight=false
end
local pr = function(msg)
    print("|cffC495DDDBMskin|r:", tostring(msg))
end

local function rt(i) return function() return i end end
local function healthdemo()
		DBM.BossHealth:Show("Scary bosses")
		DBM.BossHealth:AddBoss(rt(25), "Algalon")
		DBM.BossHealth:AddBoss(rt(50), "Mimiron")
		DBM.BossHealth:AddBoss(rt(75), "Sindragosa")
		DBM.BossHealth:AddBoss(rt(100), "Hogger")
end
SLASH_DBMSKIN1 = "/dbmskin"
SlashCmdList["DBMSKIN"] = function(msg)
	if(msg=="apply") then
		StaticPopup_Show("APPLY_SKIN")        
	elseif(msg=="test") then
		DBM:DemoMode()
	elseif(msg=="bh")then
		healthdemo()
	else
		pr("use |cffFF0000/dbmskin apply|r to apply DBM settings.")
		pr("use |cffFF0000/dbmskin test|r to launch DBM testmode.")
		pr("use |cffFF0000/dbmskin bh|r to show test BossHealth frame")
	end
end
StaticPopupDialogs["APPLY_SKIN"] = {
	text = "We need to set some DBM options to apply Qulight UI DBM skin.\nMost of your settings will remain untouched.",
	button1 = ACCEPT,
	button2 = CANCEL,
    OnAccept = function() UploadDBM() ReloadUI() end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = true,
}