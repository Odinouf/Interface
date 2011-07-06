--[[
  -- oUF_Sniffles
  
  Credits:
  
  haste: for his awesome oUF and oUF Wiki :)
  Aftermathh: Castbar (oUF_Aftermathh)
  Ferous: Awesome Codes!! (oUF_Svelte)
  p3lim: Base Code (oUF_p3lim)
  coree: Some Codes of his Layout (oUF_coree)
  tukz: used his codes too (Tukui)
  wildbreath : sexy texture!
  hankthetank: sexy raidicons! (oUF_Hank)
  drakull: helped me with raid border highlight =)
  neal: !Beautycase
  
  Adrian L Lange grants anyone the right to use this work for any purpose,
  without any conditions, unless such conditions are required by law.
--]]

local _, ns = ...
local oUF = ns.oUF

local _, class = UnitClass('player')

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

function SpawnMenu(self)
	local unit = self.unit:gsub("(.)", string.upper, 1)
		if unit == "Targettarget" or unit == "focustarget" or unit == "pettarget" then return end

		if _G[unit.."FrameDropDown"] then
			ToggleDropDownMenu(1, nil, _G[unit.."FrameDropDown"], "cursor")
		elseif (self.unit:match("party")) then
			ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor")
		else
			FriendsDropDown.unit = self.unit
			FriendsDropDown.id = self.id
			FriendsDropDown.initialize = RaidFrameDropDown_Initialize
			ToggleDropDownMenu(1, nil, FriendsDropDown, "cursor")
		end
end

local function PostUpdatePower(element, unit, min, max)
	element:GetParent().Health:SetHeight(max ~= 0 and 20 or 22)
end

local PostUpdateAuraIcon
do
  local playerUnits = {
    player = true,
    pet = true,
    vehicle = true,
  }
 
  PostUpdateAuraIcon = function(self, icons, unit, icon, index, offset, filter, isDebuff)
    local texture = icon.icon
	local dur = icon.cd
	if isDebuff then
      if(playerUnits[icon.owner] or UnitIsFriend("target", "player")) then
        texture:SetDesaturated(false)
		
        dur:Show()		
      else
        texture:SetDesaturated(true)
		dur:Hide()
      end
	end
  end
end

local function PostCreateAura(element, button)
	button.cd:SetReverse()
	CreateBorder(button, 12, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1)

	local count = button.count
	count:ClearAllPoints()
	count:SetPoint("TOP", button, 0, 8)
	count:SetFont(med.font, med.fsize, med.ftags)
	count:SetVertexColor(1,1,1)
	
	button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	button.icon:SetDrawLayer('ARTWORK')
end


local function PostUpdateDebuff(element, unit, button, index)
	if(UnitIsFriend('player', unit) or button.isPlayer) then
		local _, _, _, _, type = UnitAura(unit, index, button.filter)
		local color = DebuffTypeColor[type] or DebuffTypeColor.none

		button:SetBackdropColor(color.r * 3/5, color.g * 3/5, color.b * 3/5)
		ColorBorder(button, 1, 0, 0)
		button.icon:SetDesaturated(false)
	else
		button:SetBackdropColor(0, 0, 0)
		button.icon:SetDesaturated(true)
	end
end

local UnitSpecific = {
	player = function(self)
	
	CreateBorder(self, 12, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4)
	
		local leader = self.Health:CreateTexture(nil, 'OVERLAY')
			leader:SetPoint('TOPLEFT', self, 0, 8)
			leader:SetSize(Scale(16), Scale(16))
			self.Leader = leader

		local assistant = self.Health:CreateTexture(nil, 'OVERLAY')
			assistant:SetPoint('TOPLEFT', self, 0, 8)
			assistant:SetSize(Scale(16), Scale(16))
			self.Assistant = assistant
		
		local combaticon = self.Health:CreateTexture(nil, 'OVERLAY')
			combaticon:SetPoint("TOPLEFT", self, -5, 15)
			combaticon:SetSize(Scale(30),Scale(30))
			self.Combat = combaticon
		
		-- self:SetWidth(230)
		
		 -- [[ Threat Bar

	if cfg.enablethreatbar == true then
	
		local ThreatBar = CreateFrame("StatusBar", self:GetName()..'_ThreatBar', UIParent)
		ThreatBar:SetFrameLevel(5)
		ThreatBar:SetPoint("BOTTOM", Anchorthreatbar)
		--ThreatBar:SetPoint('BOTTOM', UIParent, 0, 81)
		ThreatBar:SetWidth(365)
		ThreatBar:SetHeight(8)
		ThreatBar:SetStatusBarTexture(med.blank)
		
		ThreatBar.Text = SetFontString(ThreatBar, Qulight["media"].font, 9, "OUTLINE")
		ThreatBar.Text:SetPoint("CENTER", ThreatBar, "CENTER", 0, 1)	
		ThreatBar.bg = ThreatBar:CreateTexture(nil, 'BORDER')
		ThreatBar.bg:SetAllPoints(ThreatBar)
		ThreatBar.bg:SetTexture(0.1,0.1,0.1)	   
		ThreatBar.useRawThreat = false
		
		local h = CreateFrame("Frame", nil, ThreatBar)
		h:SetFrameLevel(4)
		h:SetPoint("TOPLEFT",-5,5)
		h:SetPoint("BOTTOMRIGHT",5,-5)
		frame1px1(h)
		CreateShadow(h)
		self.ThreatBar = ThreatBar
		
		--[[


		self.ThreatBar = CreateFrame("StatusBar", self:GetName()..'_ThreatBar', UIParent)
			self.ThreatBar:SetPoint('BOTTOM', UIParent, 0, 80)
			self.ThreatBar:SetHeight(Scale(15))
			self.ThreatBar:SetWidth(Scale(370))
			self.ThreatBar:SetStatusBarTexture(med.blank)
	
		self.ThreatBar.Text = self.ThreatBar:CreateFontString(nil, 'OVERLAY')
			self.ThreatBar.Text:SetFont(med.font, med.fsize, med.ftags)
			self.ThreatBar.Text:SetPoint('CENTER', self.ThreatBar)
			
		self.ThreatBar.bg = self.ThreatBar:CreateTexture(nil, 'BORDER')
			self.ThreatBar.bg:SetAllPoints(self.ThreatBar)
			self.ThreatBar.bg:SetTexture(0,0,0)
		
		self.ThreatBar.useRawThreat = false
		
		CreateBorder(self.ThreatBar, 12, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1)
		--]]
	end
	
	
	-- TOTEMBAR
	if class == 'SHAMAN' then
		local totems = CreateFrame('Frame', nil, self)
			totems:SetPoint('LEFT', self, 0, 1)
			totems:SetHeight(Scale(15))
			totems:SetWidth(Scale(20))
			totems.delay = 0.1
			totems.Destroy = true
		for i = 1, 4 do
			local totem = CreateFrame('StatusBar', nil, totems)
				totem:SetSize(Scale(20 / 4) , Scale(15))
				totem:SetStatusBarTexture(med.blank)
				SetBD(totem)
				totem:SetOrientation("VERTICAL")
				totem:SetFrameLevel(4)
				totem:SetMinMaxValues(0, 1)
			if (i == 1) then
				totem:SetPoint('RIGHT', totems,  4, 0)
			else
				totem:SetPoint('RIGHT', totems[i - 1], 10, 0)
			end
			local totemBG = totem:CreateTexture(nil, 'BACKGROUND')
				totemBG:SetAllPoints(totem)
				totemBG:SetTexture(med.blank)
				totem.bg = totemBG
				totem.bg.multiplier = 0.3
				totems[i] = totem
		end
		self.TotemBar = totems
		
		self:RegisterEvent('PLAYER_REGEN_ENABLED', function(self) self.TotemBar:SetAlpha(0.5) end)
		self:RegisterEvent('PLAYER_REGEN_DISABLED', function(self) self.TotemBar:SetAlpha(1) end)
		self:RegisterEvent('PLAYER_ENTERING_WORLD', function(self) self.TotemBar:SetAlpha(0.5) end)
	end
	-- Eclipse Bar
	if class == 'DRUID' then
		local eclipseBar = CreateFrame('Frame', nil)
			eclipseBar:SetPoint('TOP', self, 0, 15)
			eclipseBar:SetSize(Scale(170), Scale(6))
			SetBD(eclipseBar)

		local lunarBar = CreateFrame('StatusBar', nil, eclipseBar)
			lunarBar:SetPoint('LEFT', eclipseBar, 'LEFT', 0, 0)
			lunarBar:SetSize(Scale(170), Scale(6))
			lunarBar:SetStatusBarTexture(med.blank)
			lunarBar:SetStatusBarColor(0, .57, 1)
			eclipseBar.LunarBar = lunarBar

		local solarBar = CreateFrame('StatusBar', nil, eclipseBar)
			solarBar:SetPoint('LEFT', lunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
			solarBar:SetSize(Scale(170), Scale(6))
			solarBar:SetStatusBarTexture(med.blank)
			solarBar:SetStatusBarColor(1, .95, .41)
			eclipseBar.SolarBar = solarBar

		self.EclipseBar = eclipseBar
		
		self.EclipseBarText = self.EclipseBar.SolarBar:CreateFontString(nil, 'OVERLAY')
		self.EclipseBarText:SetPoint('CENTER', self.EclipseBar,0,10)
		self.EclipseBarText:SetFont(med.font, 24, 'THINOUTLINE')
		self.EclipseBar.PostUpdatePower = function(unit)
        if ( GetEclipseDirection() == "sun" ) then
                self.EclipseBarText:SetText("|cff4478BCStarfire!|r")
			elseif ( GetEclipseDirection() == "moon" ) then
                self.EclipseBarText:SetText("|cffE5994CWrath!|r")
			else
				self.EclipseBarText:SetText("")
			end
		end
		
		self:RegisterEvent('PLAYER_REGEN_ENABLED', function(self) self.EclipseBar:SetAlpha(0.5) end)
		self:RegisterEvent('PLAYER_REGEN_DISABLED', function(self) self.EclipseBar:SetAlpha(1) end)
		self:RegisterEvent('PLAYER_ENTERING_WORLD', function(self) self.EclipseBar:SetAlpha(0.5) end)
	end
	-- Death Knight Runes
	if class == 'DEATHKNIGHT' then
		self.Runes = CreateFrame("Frame", nil, self)
		self.Runes:SetPoint("TOP", self, 98, 15)
		self.Runes:SetSize(Scale(230/6), Scale(6))
		CreateBorder(self, 12, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4)
		self.Runes.growth = 'RIGHT'
				
		for i = 1, 6 do
			self.Runes[i] = CreateFrame("StatusBar", nil, self.Runes)
			self.Runes[i]:SetStatusBarTexture(med.blank)
			self.Runes[i]:SetSize(Scale(230/6), Scale(6))
	
			if i == 1 then
				self.Runes[i]:SetPoint("TOPLEFT", self.Runes, "TOPLEFT")
			else
				self.Runes[i]:SetPoint("RIGHT", self.Runes[i - 1], "LEFT", -1, 0)
			end
				
			self.Runes[i].bg = self.Runes[i]:CreateTexture(nil, "BACKGROUND")
			self.Runes[i].bg:SetAllPoints(self.Runes[i])
			self.Runes[i].bg:SetTexture(med.blank)
			self.Runes[i].bg.multiplier = .2
				
			self.Runes[i].bd = CreateFrame("Frame", nil, self.Runes[i])
			self.Runes[i].bd:SetPoint("TOPLEFT", self.Runes[i], "TOPLEFT", 0, 0)
			self.Runes[i].bd:SetPoint("BOTTOMRIGHT", self.Runes[i], "BOTTOMRIGHT", 0, 0)
			self.Runes[i].bd:SetFrameStrata("LOW")
			SetBD(self.Runes[i].bd)
			
		self:RegisterEvent('PLAYER_REGEN_ENABLED', function(self) self.Runes:SetAlpha(0.5) end)
		self:RegisterEvent('PLAYER_REGEN_DISABLED', function(self) self.Runes:SetAlpha(1) end)
		self:RegisterEvent('PLAYER_ENTERING_WORLD', function(self) self.Runes:SetAlpha(0.5) end)
		end
	end
		
	-- Holy Power
	if class == 'PALADIN' then
		local holypower = CreateFrame('Frame', nil, self)
			holypower:SetPoint('LEFT', self, 0, 1)
			holypower:SetSize(Scale(28), Scale(18))
			holypower:SetFrameLevel(4)

		for i = 1, MAX_HOLY_POWER do
			local holyRune = holypower:CreateTexture(nil, 'OVERLAY')
				holyRune:SetSize(Scale((28 / MAX_HOLY_POWER)), Scale(18))
				holyRune:SetTexture(med.blank)
				holyRune:SetVertexColor(1,.95,.33)

			if i > 1 then
				holyRune:SetPoint('LEFT', holypower[i - 1], 10, 0)
			else
				holyRune:SetPoint('LEFT', holypower, 4, 0)
			end

			holypower[i] = holyRune
			
			local holyBG = holypower:CreateTexture(nil, 'BACKGROUND')
				holyBG:SetAllPoints(holyRune)
				holyBG:SetTexture(med.blank)
				holyBG:SetVertexColor(0,0,0)
				holyBG.multiplier = 0.3
		end

		self.HolyPower = holypower
		
		self:RegisterEvent('PLAYER_REGEN_ENABLED', function(self) self.HolyPower:SetAlpha(0.5) end)
		self:RegisterEvent('PLAYER_REGEN_DISABLED', function(self) self.HolyPower:SetAlpha(1) end)
		self:RegisterEvent('PLAYER_ENTERING_WORLD', function(self) self.HolyPower:SetAlpha(0.5) end)
	end
	-- Warlock SoulShards
	if class == 'WARLOCK' then
		local shards = CreateFrame('Frame', nil, self)
			shards:SetPoint('LEFT', self, 5, 1)
			shards:SetSize(Scale(24), Scale(15))
			shards:SetFrameLevel(4)

		for i = 1, SHARD_BAR_NUM_SHARDS do
			local shard = shards:CreateTexture(nil, 'OVERLAY')
				shard:SetSize(Scale((8 / SHARD_BAR_NUM_SHARDS)) , Scale(15))
				shard:SetTexture(med.blank)
				shard:SetVertexColor(1,0,0)

			if i > 1 then
				shard:SetPoint('LEFT', shards[i - 1], 'RIGHT', 1, 0)
			else
				shard:SetPoint('BOTTOMLEFT', shards, 'BOTTOMLEFT', 1, 0)
			end

			shards[i] = shard
		end

		self.SoulShards = shards
		
		self:RegisterEvent('PLAYER_REGEN_ENABLED', function(self) self.SoulShards:SetAlpha(0.5) end)
		self:RegisterEvent('PLAYER_REGEN_DISABLED', function(self) self.SoulShards:SetAlpha(1) end)
		self:RegisterEvent('PLAYER_ENTERING_WORLD', function(self) self.SoulShards:SetAlpha(0.5) end)
	end
end,
	
	target = function(self)
		CreateBorder(self, 12, 1, 1, 1, 4, 4, 4, 4, 4, 4, 4, 4)

		self.Power.PostUpdate = PostUpdatePower
		
		local buffs = CreateFrame('Frame', nil, self)
			buffs:SetPoint("TOPLEFT", self, 5, 35)
			buffs:SetSize(Scale(230), Scale(24))
			buffs.num = 15
			buffs.size = Scale(24)
			buffs.spacing = 4
			buffs.initialAnchor = "LEFT"
			buffs['growth-y'] = "TOP"
			buffs.PostCreateIcon = PostCreateAura
			self.Buffs = buffs
		--[[
		local debuffs = CreateFrame('Frame', nil, self)
			debuffs.spacing = 4
			debuffs.initialAnchor = "LEFT"
			debuffs.num = 7
			debuffs.size = Scale(30)
			debuffs['growth-y'] = "RIGHT"
			debuffs:SetPoint("BOTTOMLEFT", self, 0, -50)
			debuffs:SetSize(Scale(230), Scale(debuffs.size))
			debuffs.PostCreateIcon = PostCreateAura
			debuffs.PostUpdateIcon = PostUpdateDebuff
			self.Debuffs = debuffs
			--]]
		--[[	
		local cpoints = self:CreateFontString(nil, 'OVERLAY')
			cpoints:SetFont(med.font, 24, med.ftags)
			cpoints:SetPoint('RIGHT', self, 'LEFT', -9, 0)
			cpoints:SetJustifyH('RIGHT')
			self:Tag(cpoints, '|cffffff00[cpoints]|r')
	
		CreateBorder(self, 12, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1)--]]
------------------------------
		
			local cpoints = CreateFrame("Frame", nil, self)
			cpoints:SetPoint("CENTER", Uiparent, "CENTER", 0, -200)
			cpoints:SetWidth(200)
			cpoints:SetHeight(5)
			--frame1px(cpoints)
			cpoints:SetBackdropBorderColor(0,0,0,0)
			cpoints:SetBackdropColor(0,0,0,0)
				
			for i = 1, 5 do					
				cpoints[i] = CreateFrame("StatusBar", self:GetName().."_Combo"..i, cpoints)
				cpoints[i]:SetHeight(5)					
				cpoints[i]:SetStatusBarTexture(med.blank)
				cpoints[i]:GetStatusBarTexture():SetHorizTile(false)
									
				if i == 1 then
					cpoints[i]:SetPoint("LEFT", cpoints)
				else
					cpoints[i]:SetPoint("LEFT", cpoints[i-1], "RIGHT", 1, 0)
				end
				cpoints[i]:SetAlpha(0.9)
				cpoints[i]:SetWidth((200 - 4)/5)
			end
			
			cpoints[1]:SetStatusBarColor(0.69, 0.31, 0.31)		
			cpoints[2]:SetStatusBarColor(0.69, 0.31, 0.31)
			cpoints[3]:SetStatusBarColor(0.65, 0.63, 0.35)
			cpoints[4]:SetStatusBarColor(0.65, 0.63, 0.35)
			cpoints[5]:SetStatusBarColor(0.33, 0.59, 0.33)
				
			self.CPoints = cpoints
			self.CPoints.Override = ComboDisplay
				
			cpoints.FrameBackdrop = CreateFrame("Frame", nil, cpoints[1])
			frame1px(cpoints.FrameBackdrop)
			CreateShadow(cpoints.FrameBackdrop)
			cpoints.FrameBackdrop:SetBackdropBorderColor(.2,.2,.2,1)
			cpoints.FrameBackdrop:SetPoint("TOPLEFT", cpoints, "TOPLEFT", -2, 2)
			cpoints.FrameBackdrop:SetPoint("BOTTOMRIGHT", cpoints, "BOTTOMRIGHT", 2, -2)
			cpoints.FrameBackdrop:SetFrameLevel(cpoints:GetFrameLevel() - 1)
		
		
		---------------------------
		
		local portrait = CreateFrame("PlayerModel", nil, self)
			portrait:SetFrameLevel(7)
			portrait:SetPortraitZoom(1)
			portrait:SetCamera(1)
			portrait:SetHeight(Scale(24))
			portrait:SetWidth(Scale(230))
			portrait:SetAlpha(0.5)
			portrait:SetPoint("TOPLEFT", self)
			portrait:SetPoint("BOTTOMRIGHT", self)
		
			portrait.PostUpdate = function(self) self:SetAlpha(0); self:SetAlpha(0.3); end;  -- Portrait Fix
			table.insert(self.__elements, HidePortrait);
			self.Portrait = portrait
		end,
	
	pet = function(self)
		CreateBorder(self, 12, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4)
			local health = self.Health
				health:SetHeight(Scale(24))
				health:SetPoint('TOPRIGHT')
				health:SetPoint('TOPLEFT')
			
				self:SetHeight(Scale(24))
				self:SetWidth(Scale(230/2))

	end,
	
	targettarget = function(self)	
		CreateBorder(self, 12, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4)
			local health = self.Health
				health:SetHeight(Scale(24))
				health:SetPoint('TOPRIGHT')
				health:SetPoint('TOPLEFT')
			
				self:SetHeight(Scale(24))
				self:SetWidth(Scale(230/2))
	end,
	
	focus = function(self)
		CreateBorder(self, 12, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4)
			local health = self.Health
				health:SetHeight(Scale(24))
				health:SetPoint('TOPRIGHT')
				health:SetPoint('TOPLEFT')
			
				self:SetHeight(Scale(24))
				self:SetWidth(Scale(230/2))
	end,
	
	focustarget = function(self)	
		CreateBorder(self, 12, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4)
			local health = self.Health
				health:SetHeight(Scale(24))
				health:SetPoint('TOPRIGHT')
				health:SetPoint('TOPLEFT')
			
				self:SetHeight(Scale(24))
				self:SetWidth(Scale(230/2))
	end,
}

local function Shared(self, unit)
	self.colors = oUF_colors
	
	self:RegisterForClicks("AnyUp")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	self.menu = SpawnMenu
	
	local health = CreateFrame('StatusBar', nil, self)
		health:SetStatusBarTexture(med.blank)
		
		if (cfg.classcolored == true and cfg.owncolor == false) then
			health.colorClass = true
			health.colorReaction = true
			health.colorTapping = true
		elseif (cfg.classcolored == false and cfg.owncolor == true) then
			health:SetStatusBarColor(unpack(cfg.mycolor))
		end
		
		health.frequentUpdates = true
		health.colorDisconnected = true
		health:SetPoint('CENTER',0,2)
		SetBD(health)	
		health.Smooth = true
		self.Health = health
				
	local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(0, 0, 0)
		self.Health.bg = healthBG

	local healthValue = health:CreateFontString(nil, 'OVERLAY')
		healthValue:SetPoint('RIGHT', health, -2, 1)
		healthValue:SetFont(med.font, med.fsize, med.ftags)
		healthValue:SetJustifyH('RIGHT')
		healthValue.frequentUpdates = 1/4
	
		if unit == 'target'  then
			self:Tag(healthValue, '[sniffles:health]')
		end

		if unit == 'player' then
			self:Tag(healthValue, '[perhp]%')
		end

	if(unit == 'player' or unit == 'target' or unit == 'focus') then
		local power = CreateFrame('StatusBar', nil, self)
			power:SetPoint('BOTTOMLEFT')
			power:SetPoint('BOTTOMRIGHT')
			power:SetPoint('TOP', health, 'BOTTOM', 0, -1)
			power:SetStatusBarTexture(med.blank)
			
			if (cfg.classcolored == true and cfg.ownpowercolor == false) then
				power.colorPower = true
				power.colorTapping = true
			elseif (cfg.classcolored == false and cfg.ownpowercolor == true) then
				power:SetStatusBarColor(unpack(cfg.mypowercolor))
			end
			power.colorDisconnected = true
			power.frequentUpdates = true
			SetBD(power)
			power.Smooth = true
			self.Power = power

		local powerBG = power:CreateTexture(nil, 'BORDER')
			powerBG:SetAllPoints()
			powerBG:SetTexture(0,0,0)
			powerBG.multiplier = 0.3
			self.Power.bg = powerBG
		
		if(unit == 'target') then
			local powerValue = health:CreateFontString(nil, 'OVERLAY')
				powerValue:SetPoint('LEFT', health, 2, 1)
				powerValue:SetFont(med.font, med.fsize, med.ftags)
				powerValue:SetJustifyH('LEFT')
				powerValue.frequentUpdates = 0.1
				self:Tag(powerValue, '[sniffles:power< ][sniffles:druid]')
		end
		-- ]]
		
		local raidicon = self:CreateTexture(nil, 'OVERLAY')
		
			if (unit == 'target') then
				raidicon:SetPoint("TOPLEFT", self, -60, 15)	
				raidicon:SetSize(Scale(Scale(30)), Scale(Scale(30)))
			end
			
			if(unit == 'player') then
				raidicon:SetPoint("BOTTOMLEFT", self, -10, -10)
				raidicon:SetSize(Scale(Scale(18)), Scale(Scale(18)))
			end
			
			raidicon:SetTexture("Interface\\AddOns\\oUF_Sniffles\\media\\textures\\raidicons.blp") -- thx hankthetank for texture
			self.RaidIcon = raidicon
		
		health:SetHeight(Scale(20))
		health:SetPoint('TOPRIGHT')
		health:SetPoint('TOPLEFT')
		
		self:SetWidth(Scale(230))
		self:SetHeight(Scale(24))
	end

	local name = health:CreateFontString(nil, 'OVERLAY')
		if(unit == 'target') then
			name:SetPoint('BOTTOMLEFT', self,5,-15)
		elseif (unit == 'targettarget' or unit == 'focus' or unit == 'pet' or unit == 'focustarget') then
			name:SetPoint('CENTER', self)
		end
		name:SetFont(med.font, med.fsize, med.ftags)
		name:SetJustifyH('LEFT')
		if (unit == 'target' or unit == 'focustarget' or unit == 'focus')then
			self:Tag(name, '[sniffles:name< ][|cff0090ff>rare<|r]')
		elseif (unit == 'targettarget' or unit == 'pet') then
			self:Tag(name, '[longname][|cff0090ff>rare<|r]')
		end
		
		if(unit == 'target') then
			self:Tag(name, '[sniffles:name< ][|cff0090ff>rare<|r] [level]')
		end
	
	-- Position and size
if cfg.enablecastbars == true then
	if (unit == 'target' or unit == 'player' or unit =='focus') then
		self.Castbar = CreateFrame('StatusBar', nil, self)
			self.Castbar:SetSize(Scale(cfg.castbarwidth), Scale(cfg.castbarheight))
			self.Castbar:SetStatusBarTexture(med.blank)
			self.Castbar:SetScale(1)
			self.Castbar:SetStatusBarColor(unpack(cfg.castbarcolor))
			
			if (unit == 'target') then
				--self.Castbar:SetPoint(cfg.targetcastbarpos[1], self, cfg.targetcastbarpos[2], cfg.targetcastbarpos[3])
				self.Castbar:SetPoint("CENTER", UIParent, 0, 0)
			elseif (unit == 'player') then
				--self.Castbar:SetPoint(cfg.playercastbarpos[1], self, cfg.playercastbarpos[2], cfg.playercastbarpos[3])
				self.Castbar:SetPoint("CENTER", UIParent, 0, -100)
			elseif (unit == 'focus') then
				self.Castbar:SetPoint(cfg.focuscastbarpos[1], self, cfg.focuscastbarpos[2], cfg.focuscastbarpos[3])
			end
		
			CreateBorder(self.Castbar, 12, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3)

		self.Castbar.Bg = self.Castbar:CreateTexture(nil, 'BACKGROUND')
			self.Castbar.Bg:SetAllPoints(self.Castbar)
			self.Castbar.Bg:SetTexture(med.blank)
			self.Castbar.Bg:SetVertexColor(0, 0, 0, 0.6)
		
		self.Castbar.Time = self.Castbar:CreateFontString(nil, 'ARTWORK')
			self.Castbar.Time:SetFont(med.font, med.fsize, med.ftags)
			self.Castbar.Time:SetPoint('RIGHT', self.Castbar, -7, 0)
			self.Castbar.Time:SetHeight(25)
			self.Castbar.Time:SetJustifyH('LEFT')

		self.Castbar.Text = self.Castbar:CreateFontString(nil, 'ARTWORK')
			self.Castbar.Text:SetFont(med.font, med.fsize, med.ftags)
			self.Castbar.Text:SetPoint('CENTER', self.Castbar)
			self.Castbar.Text:SetHeight(25)
			self.Castbar.Text:SetParent(self.Castbar)
			self.Castbar.Text:SetJustifyH('LEFT')

		local bgcastbaricon = CreateFrame('Frame', nil, self.Castbar)
			bgcastbaricon:SetSize(Scale(cfg.castbariconwidth), Scale(cfg.castbariconheight))
			bgcastbaricon:SetPoint('TOP', self.Castbar,0,25)
			CreateBorder(bgcastbaricon, 12, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1)
			
		local castbarIcon = bgcastbaricon:CreateTexture(nil, 'ARTWORK')
			castbarIcon:SetAllPoints(bgcastbaricon)
			castbarIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
			self.Castbar.Icon = castbarIcon
	end
end
	-- ]] Combat Feedback
	if cfg.enablecombatfeedtext == true then
		if (unit == 'player' or unit == 'target') then
			local CombatFeedbackText 
				CombatFeedbackText = health:CreateFontString(nil, 'ARTWORK')
				CombatFeedbackText:SetFont(med.font, med.fsize, med.ftags)
				CombatFeedbackText:SetPoint(cfg.combatfeedtextpos[1], cfg.combatfeedtextpos[2], cfg.combatfeedtextpos[3])
				CombatFeedbackText.colors = {
					DAMAGE = {0.69, 0.31, 0.31},
					CRUSHING = {0.69, 0.31, 0.31},
					CRITICAL = {0.69, 0.31, 0.31},
					GLANCING = {0.69, 0.31, 0.31},
					STANDARD = {0.84, 0.75, 0.65},
					IMMUNE = {0.84, 0.75, 0.65},
					ABSORB = {0.84, 0.75, 0.65},
					BLOCK = {0.84, 0.75, 0.65},
					RESIST = {0.84, 0.75, 0.65},
					MISS = {0.84, 0.75, 0.65},
					HEAL = {0.33, 0.59, 0.33},
					CRITHEAL = {0.33, 0.59, 0.33},
					ENERGIZE = {0.31, 0.45, 0.63},
					CRITENERGIZE = {0.31, 0.45, 0.63},
				}
				self.CombatFeedbackText = CombatFeedbackText		
		end
	end
	-- ]]
	
	if(UnitSpecific[unit]) then
		return UnitSpecific[unit](self)
	end
end

oUF:RegisterStyle('sniffles', Shared)
oUF:Factory(function(self)
	self:SetActiveStyle('sniffles')
	self:Spawn('player'):SetPoint(cfg.playerpos[1], cfg.playerpos[2], cfg.playerpos[3])
	self:Spawn('pet'):SetPoint(cfg.petpos[1] , cfg.petpos[2] , cfg.petpos[3])
	self:Spawn('focus'):SetPoint(cfg.focuspos[1] , cfg.focuspos[2] , cfg.focuspos[3])
	self:Spawn('target'):SetPoint(cfg.targetpos[1] , cfg.targetpos[2] , cfg.targetpos[3])
	self:Spawn('targettarget'):SetPoint(cfg.totpos[1] , cfg.totpos[2] , cfg.totpos[3])
	self:Spawn('focustarget'):SetPoint(cfg.focustargetpos[1] , cfg.focustargetpos[2] , cfg.focustargetpos[3])
end)