if not cfg.enableparty == true then return end

local _, ns = ...
local oUF = ns.oUF

-- threat highlight
local function updateThreatStatus(self, event, u)
	if (self.unit ~= u) then return end
	local s = UnitThreatSituation(u)
	if s and s > 1 then
		local r, g, b = GetThreatStatusColor(s)
		self.ThreatHlt:Show()
		self.ThreatHlt:SetVertexColor(r, g, b, 0.5)
	else
		self.ThreatHlt:Hide()
	end
end

local function Shared(self, unit)
	self.colors = oUF_colors
	self:RegisterForClicks("AnyUp")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	self.menu = SpawnMenu
	self:SetAttribute('type2', 'menu')

	self:SetAttribute('initial-height', Scale(cfg.partyheight))
	self:SetAttribute('initial-width', Scale(cfg.partywidth))
	
	local health = CreateFrame('StatusBar', nil, self)
		health:SetFrameLevel(2)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetHeight(Scale(cfg.partyhealthheight))
		health:SetWidth(Scale(cfg.partyhealthwidth))
		health.frequentUpdates = true
		health.colorDisconnected = true
		
		if cfg.classcolored == true and cfg.owncolor == false then
			health.colorClass = true
		elseif cfg.classcolored == false and cfg.owncolor == true then
			health:SetStatusBarColor(unpack(cfg.mycolor))
		end
		
		health:SetOrientation("HORIZONTAL")
		health:SetStatusBarTexture(med.blank)
		health.Smooth = true
		self.Health = health
		CreateBorder(health, 12, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1)
    
	health.bg = health:CreateTexture(nil, 'BORDER')
		health.bg:SetAllPoints(health)
		health.bg:SetTexture(med.blank)
		health.bg:SetVertexColor(.4,.4,.4)
		health.bg.multiplier = 0.3
		self.Health.bg = health.bg
	
	if cfg.powerbars == true then
		local power = CreateFrame('StatusBar', nil, self)
			power:SetFrameLevel(3)
			power:SetPoint("BOTTOMLEFT", self, 3, 3)
			power:SetPoint("BOTTOMRIGHT", self, -3, 3)
			power:SetHeight(Scale(cfg.partypowerwidth))
			power:SetWidth(Scale(cfg.partypowerheight))
			power:SetOrientation("HORIZONTAL")
			power:SetStatusBarTexture(med.blank)
			power.frequentUpdates = true
			power.colorDisconnected = true
			
			if (cfg.classcolored == true and cfg.ownpowercolor == false) then
				power.colorPower = true
				power.colorTapping = true
			elseif (cfg.classcolored == false and cfg.ownpowercolor == true) then
				power:SetStatusBarColor(unpack(cfg.mypowercolor))
			end
			power.Smooth = true
			SetBD(power)
			self.Power = power
    
			power.bg = power:CreateTexture(nil, 'BORDER')
				power.bg:SetAllPoints(power)
				power.bg:SetTexture(med.blank)
				power.bg:SetVertexColor(.4,.4,.4)
				power.bg.multiplier = 0.3
				self.Power.bg = power.bg
	end
	
	if cfg.partyenablenames == true then
		local name = health:CreateFontString(nil, 'OVERLAY')
			name:SetPoint('TOP', health,0,-2)
			name:SetFont(med.font, med.fsize, med.ftags)
			name:SetJustifyH('LEFT')
		if cfg.partynames == 4 then
			self:Tag(name, '[veryshortname]')
		elseif cfg.partynames == 6 then
			self:Tag(name, '[shortname]')
		elseif cfg.partynames == 8 then
			self:Tag(name, '[longname]')
		end		
	end

	CreateTargetBorder(self)
	self:RegisterEvent('PLAYER_TARGET_CHANGED', ChangedTarget)
	
	-- threat highlight
	if cfg.partyenablethreathighlight == true then
		local Thrt = health:CreateTexture(nil, "OVERLAY")
			Thrt:SetAllPoints(health)
			Thrt:SetTexture(med.blanky)
			Thrt:SetVertexColor(1,0,0)
			Thrt:SetBlendMode("ADD")
			Thrt:Hide()
			self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", updateThreatStatus)
			self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", updateThreatStatus)
			self.ThreatHlt = Thrt	
	end
	
    local RaidIcon = health:CreateTexture(nil, 'OVERLAY')
		RaidIcon:SetHeight(Scale(18))
		RaidIcon:SetWidth(Scale(18))
		RaidIcon:SetPoint('CENTER', self, 'TOP')
		RaidIcon:SetTexture("Interface\\AddOns\\oUF_Sniffles\\media\\textures\\raidicons.blp") -- thx hankthetank for texture
		self.RaidIcon = RaidIcon
    
    -- local LFDRole = self:CreateTexture(nil, "OVERLAY")
		-- LFDRole:SetSize(Scale(15), Scale(15))
		-- LFDRole:SetPoint("TOP", self,0,5)
		-- self.LFDRole = LFDRole
	-- Remove: "--" if you want to see the roles

	-- AuraWatch (corner icon)
	if cfg.enableaurawatch == true then
		createAuraWatch(self,unit)
	end
	
    local range = {
		insideAlpha = 1,
		outsideAlpha = 0.3
    }
    self.Range = range
end


oUF:RegisterStyle('snifflesgroup', Shared)
oUF:Factory(function(self)
oUF:SetActiveStyle("snifflesgroup")	
	local Group = self:SpawnHeader("oUF_Group", nil, "party",
        'oUF-initialConfigFunction', [[
        local header = self:GetParent()
        self:SetWidth(header:GetAttribute('initial-width'))
        self:SetHeight(header:GetAttribute('initial-height'))
        RegisterUnitWatch(self)
        ]],
        'initial-width', Scale(cfg.partywidth),
        'initial-height', Scale(cfg.partyheight),	
        "showParty", true,
        "showPlayer", true, 
        "showSolo", true,
        "yOffset", 10,
        "point", "BOTTOM",
        "groupFilter", "1",
        "groupingOrder", "1",
        "groupBy", "GROUP",
        "maxColumns", 1,
        "unitsPerColumn", 5,
        "columnSpacing", 3,
        "columnAnchorPoint", "TOP"	
	)
	Group:SetPoint(cfg.grouppos[1], cfg.grouppos[2], cfg.grouppos[3],cfg.grouppos[4] ,cfg.grouppos[5])
    Group:SetSize(Scale(cfg.partywidth),Scale(cfg.partyheight))
end)
