-- pixel perfect script of custom ui scale.
local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/UIParent:GetEffectiveScale()
local function scale(x)
    return mult*math.floor(x/mult+.5)
end

-- PIXEL PERFECT
function Scale(x) 
return scale(x)
end
mult = mult

-- BACKDROP
function SetBD(f) -- <--- BACKDROP
	f:SetBackdrop({
	  bgFile = med.blank, 
	  edgeFile = med.blanky, 
	  tile = false, tileSize = 0, edgeSize = mult, 
	  insets = { left = -mult, right = -mult, top = -mult, bottom = -mult}
	})
	f:SetBackdropColor(0,0,0)
	f:SetBackdropBorderColor(0,0,0)
end

-- Create Target Border
function CreateTargetBorder(self)
    local glowBorder = {edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1}
    self.TargetBorder = CreateFrame("Frame", nil, self)
    self.TargetBorder:SetPoint("TOPLEFT", self, "TOPLEFT", -3, 3)
    self.TargetBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 3, -3)
    self.TargetBorder:SetBackdrop(glowBorder)
    self.TargetBorder:SetFrameLevel(9)
    self.TargetBorder:SetBackdropBorderColor(.7,.7,.7,1)
    self.TargetBorder:Hide()
end
 
-- Raid Frames Target Highlight Border
function ChangedTarget(self, event, unit)
    if UnitIsUnit('target', self.unit) then
        self.TargetBorder:Show()
    else
        self.TargetBorder:Hide()
    end
end