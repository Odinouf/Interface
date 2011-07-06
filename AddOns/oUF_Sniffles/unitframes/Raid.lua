if not cfg.enableraid == true then return end

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

	self:SetAttribute('initial-height', Scale(cfg.raidheight))
	self:SetAttribute('initial-width', Scale(cfg.raidwidth))
	
	local health = CreateFrame('StatusBar', nil, self)
		health:SetFrameLevel(2)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetHeight(Scale(cfg.raidhealthheight))
		health:SetWidth(Scale(cfg.raidhealthwidth))
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
	
	if cfg.rpowerbars == true then
		local power = CreateFrame('StatusBar', nil, self)
			power:SetFrameLevel(3)
			power:SetPoint("BOTTOMLEFT", self, 3, 3)
			power:SetPoint("BOTTOMRIGHT", self, -3, 3)
			power:SetHeight(Scale(cfg.raidpowerheight))
			power:SetWidth(Scale(cfg.raidpowerwidth))
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
			
			SetBD(power)
			self.Power = power
    
    
		power.bg = power:CreateTexture(nil, 'BORDER')
			power.bg:SetAllPoints(power)
			power.bg:SetTexture(med.blank)
			power.bg:SetVertexColor(.4,.4,.4)
			power.bg.multiplier = 0.3
			self.Power.bg = power.bg
	end

	if cfg.enableraidnames == true then
		local name = health:CreateFontString(nil, 'OVERLAY')
			name:SetPoint('CENTER', health)
			name:SetFont(med.font, med.fsize, med.ftags)
			name:SetJustifyH('LEFT')
			if cfg.raidnames == 4 then
				self:Tag(name, '[veryshortname]')
			elseif cfg.raidnames == 6 then
				self:Tag(name, '[shortname]')
			elseif cfg.raidnames == 8 then
				self:Tag(name, '[longname]')
			end	
	end

	CreateTargetBorder(self)
	self:RegisterEvent('PLAYER_TARGET_CHANGED', ChangedTarget)
	
	-- threat highlight
	if cfg.raidenablethreathighlight == true then
		local Thrt = health:CreateTexture(nil, "OVERLAY")
			Thrt:SetAllPoints(health)
			Thrt:SetTexture(med.blanky)
			Thrt:SetVertexColor(1,0,0)
			Thrt:SetBlendMode("ADD")
			Thrt:Hide()
			self.ThreatHlt = Thrt	
			self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", updateThreatStatus)
			self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", updateThreatStatus)
    end
	
    local RaidIcon = health:CreateTexture(nil, 'OVERLAY')
		RaidIcon:SetHeight(Scale(18))
		RaidIcon:SetWidth(Scale(18))
		RaidIcon:SetPoint('CENTER', self, 'TOP')
		RaidIcon:SetTexture("Interface\\AddOns\\oUF_Sniffles\\media\\textures\\raidicons.blp") -- thx hankthetank for texture
		self.RaidIcon = RaidIcon
	
	local ReadyCheck = health:CreateTexture(nil, "OVERLAY")
		ReadyCheck:SetHeight(Scale(12))
		ReadyCheck:SetWidth(Scale(12))
		ReadyCheck:SetPoint('CENTER') 	
		self.ReadyCheck = ReadyCheck

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

oUF:RegisterStyle('SnifflesRaid', Shared)
oUF:Factory(function(self)
	oUF:SetActiveStyle("SnifflesRaid")	
	local raid = self:SpawnHeader("oUF_Raid", nil, "raid",
        'oUF-initialConfigFunction', [[
        local header = self:GetParent()
        self:SetWidth(header:GetAttribute('initial-width'))
        self:SetHeight(header:GetAttribute('initial-height'))
        RegisterUnitWatch(self)
        ]],
        'initial-width', Scale(cfg.raidwidth),
        'initial-height', Scale(cfg.raidheight),	
		"showPlayer", true, 
        "showSolo", true,
		"showRaid", true, 
		"xoffset", -5,
		"yOffset", -5,
		"point", "RIGHT",
		"groupFilter", "1,2,3,4,5",
		"groupingOrder", "1,2,3,4,5",
		"groupBy", "GROUP",
		"maxColumns", 5,
		"unitsPerColumn", 5,
		"columnSpacing", 3,
		"columnAnchorPoint", "BOTTOM"		
	)
	raid:SetPoint(cfg.raidpos[1],cfg.raidpos[2],cfg.raidpos[3],cfg.raidpos[4],cfg.raidpos[5])
    raid:SetSize(Scale(cfg.raidwidth),Scale(cfg.raidheight))
end)