local addon, ns = ...
local cfg = ns.cfg
if not cfg.StyleNugRunning or not IsAddOnLoaded("NugRunning") then return end

-- props to mrruben5 for original script and idea
local font="Interface\\Addons\\QulightUI\\media\\1.ttf"
local tex="Interface\\Addons\\QulightUI\\media\\Other\\statusbar3"
local timeonleft = false
local bettertime = true
local modifyfont = true
local fontflags = {font, 11, "THINOUTLINE"}
local color = "|cffff0000"
local visualstacks = true
local visualstackwidth = 8
local maxvisualstacks = 5

local unpack = unpack
local format = format
local _

local FormatTime
do
	local day, hour, minute = 86400, 3600, 60
	function FormatTime(s)
		if s >= day then
			return format("%d%sd|r", ceil(s / day), color)
		elseif s >= hour then
			return format("%d%sh|r", ceil(s / hour), color)
		elseif s >= minute * 4 then
			return format("%d%sm|r", ceil(s / minute), color)
		elseif s >= 5 then
			return floor(s)
		end
		return format("%.1f", s)
	end
end
-- better time text; not called when "bettertime" is false
local function SetTimeText(self, _, timeDigits)
	self:SetText(FormatTime(timeDigits))
end
-- generating backdrop frame
local backdrop={
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\Buttons\\WHITE8x8",
		tile = false, tileSize = 0, edgeSize = 1, 
		insets = { left = -1, right = -1, top = -1, bottom = -1}
	}
local function gen_backdrop(ds)
	if ds then
		ds:SetBackdrop(backdrop)
		ds:SetBackdropColor(.1,.1,.1,1)
		ds:SetBackdropBorderColor(0,0,0,1)
	end
end
-- Overrule font when NugRunning updates settings; not called when "modifyfont" is false
local OrigTimerOnSettingsChanged
local function TimerOnSettingsChanged(self)
    OrigTimerOnSettingsChanged(self)
    self.timeText:SetFont(unpack(fontflags))
    self.spellText:SetFont(unpack(fontflags))
    self.stacktext:SetFont(unpack(fontflags))
end
-- Only set alpha on the bar, the icon and stacks when target is changed
local ModifyElementAlpha
do
	local _
	local elements = {"icon", "stacktext", "bar"}
	function ModifyElementAlpha(self, alpha)
		for _, elm in pairs(elements) do
			self[elm]:SetAlpha(alpha)
		end
	end
end
local TimerSetColor = function(self,r,g,b)
    self.bar:SetStatusBarColor(r,g,b)
    self.bar.bg:SetVertexColor(r*.2, g*.2, b*.2)
end
-- injecting our default settings
hooksecurefunc(NugRunning, 'PLAYER_LOGIN', function(self,event,arg1)
	--if(NRunDB_Global) and not NRunDB.set then table.wipe(NRunDB_Global) end
	if not NRunDB.set then
		table.wipe(NRunDB_Global)
		NRunDB.set = true
		NRunDB.anchor = NRunDB.anchor or {}
		NRunDB.anchor.point = NRunDB.anchor.point or "BOTTOM"
		NRunDB.anchor.parent = NRunDB.anchor.parent or "UIParent"
		NRunDB.anchor.to = NRunDB.anchor.to or "BOTTOM"
		NRunDB.anchor.x = NRunDB.anchor.x or -359
		NRunDB.anchor.y = NRunDB.anchor.y or 257
		NRunDB.growth = NRunDB.growth or "up"
		NRunDB.width = NRunDB.width or 229
		NRunDB.height = NRunDB.height or 16
		NRunDB.fontscale = NRunDB.fontscale or 1
		NRunDB.nonTargetOpacity = NRunDB.nonTargetOpacity or 0.7
		NRunDB.cooldownsEnabled = (NRunDB.cooldownsEnabled  == nil and true) or NRunDB.cooldownsEnabled
		NRunDB.spellTextEnabled = (NRunDB.spellTextEnabled == nil and true) or NRunDB.spellTextEnabled
		NRunDB.shortTextEnabled = (NRunDB.shortTextEnabled == nil and true) or NRunDB.shortTextEnabled
		NRunDB.swapTarget = (NRunDB.swapTarget == nil and true) or NRunDB.swapTarget
		NRunDB.localNames   = (NRunDB.localNames == nil and false) or NRunDB.localNames
		NRunDB.CustomSpells = NRunDB.CustomSpells or {}
		NRunDB.totems = false
		for id,opts in pairs(NRunDB.CustomSpells) do
			NugRunningConfig[id] = opts
		end
	end
	NugRunning:SetupArrange()
    NugRunning.anchor = NugRunning.CreateAnchor()
    local pos = NRunDB.anchor
    NugRunning.anchor:SetPoint(pos.point, pos.parent, pos.to, pos.x, pos.y)
	
	local up = CreateFrame"Frame"
	up:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	up:RegisterEvent("PLAYER_ENTERING_WORLD")
	up:SetScript("OnEvent", function()
		local pttree = GetPrimaryTalentTree(false, false, GetActiveTalentGroup())
		if (select(2,UnitClass("player"))=="DRUID" and pttree==1) or select(2,UnitClass("player")) == "DEATHKNIGHT" or (select(2,UnitClass("player")) == "SHAMAN" and IsAddOnLoaded("oUF_boring_totembar")) then
			NugRunning.anchor:SetPoint(pos.point, pos.parent, pos.to, pos.x, pos.y+11)
		else
			NugRunning.anchor:SetPoint(pos.point, pos.parent, pos.to, pos.x, pos.y)
		end
	end)
end)

-- Hook bar creation function
hooksecurefunc(NugRunning, 'BarFrame', function(f)
	gen_backdrop(f)
	local ic = f.icon:GetParent()
	f.icon:ClearAllPoints()
	f.icon:SetPoint("BOTTOMLEFT", ic, 1, 1)
	f.icon:SetPoint("TOPRIGHT", ic, -1, -1)
	f.bar:ClearAllPoints()
	f.bar:SetPoint('TOPRIGHT', -1, -1)
	f.bar:SetPoint('BOTTOMRIGHT', -1, 1)
	f.bar:SetStatusBarTexture(tex)
	f.bar.bg:SetTexture(tex)
	f.SetAlpha = ModifyElementAlpha
	f.SetColor = TimerSetColor
	-- Time on left
	if timeonleft then
		f.timeText:SetJustifyH("LEFT")
		f.timeText:ClearAllPoints()
		f.timeText:SetPoint("LEFT", 5, -1)
		f.spellText:ClearAllPoints()
		f.spellText:SetPoint("LEFT", f.bar)
		f.spellText:SetPoint("RIGHT", f.bar)
		f.spellText:SetWidth(f.bar:GetWidth())
	end
	-- Time formatting
	if bettertime then
		f.timeText.SetFormattedText = SetTimeText
	end
	-- font strings...
	if modifyfont then
		OrigTimerOnSettingsChanged = OrigTimerOnSettingsChanged or f.OnSettingsChanged
		f.OnSettingsChanged = TimerOnSettingsChanged
		f:OnSettingsChanged()
	end
end)