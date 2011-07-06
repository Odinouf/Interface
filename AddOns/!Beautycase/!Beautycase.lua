--[[
    
    How to use:
    
    CreateBorder(self, borderSize, R, G, B, uL1, uL2, uR1, uR2, bL1, bL2, bR1, bR2)
	
	or 
	
	CreateBorder(self, borderSize, R, G, B, uL1)
  
    self         -> The name of your frame, It must be a frame not a texture
	borderSize   -> The size of the simple square Border. 10, 11 or 12 looks amazing
    R, G, B      -> The colors of the Border. R = Red, G = Green, B = Blue

	bR2 - DOWN
	bL2 - DOWN
	uL1 - <-- 
    bl1 - <--
	uR1 - -->
	bR1 - -->
	uL2 - UPP
	uR2 - UPP
-]]

local textureNormal = 'Interface\\AddOns\\!Beautycase\\media\\textureNormal'
local textureNormalLight = 'Interface\\AddOns\\!Beautycase\\media\\textureNormalLight'
local textureShadow = 'Interface\\AddOns\\!Beautycase\\media\\textureShadow'
local textureNormalWhite = 'Interface\\AddOns\\!Beautycase\\media\\textureNormalWhite'

function CreateBorder(self, borderSize, R, G, B, ...)
    local uL1, uL2, uR1, uR2, bL1, bL2, bR1, bR2 = ...
	
	if (uL1) then
        if (not uL2 and not uR1 and not uR2 and not bL1 and not bL2 and not bR1 and not bR2) then
            uL2, uR1, uR2, bL1, bL2, bR1, bR2 = uL1, uL1, uL1, uL1, uL1, uL1, uL1
        end
    end
    
    if (not self.HasBorder) then
        self.Border = {}
        for i = 1, 8 do
            self.Border[i] = self:CreateTexture(nil, 'OVERLAY')
            self.Border[i]:SetParent(self)
            self.Border[i]:SetTexture(textureNormal)
            self.Border[i]:SetSize(borderSize, borderSize)
            self.Border[i]:SetVertexColor(R or 1, G or 1, B or 1)
        end
        
        self.Border[1]:SetTexCoord(0, 1/3, 0, 1/3) 
        self.Border[1]:SetPoint('TOPLEFT', self, -(uL1 or 0), uL2 or 0)

        self.Border[2]:SetTexCoord(2/3, 1, 0, 1/3)
        self.Border[2]:SetPoint('TOPRIGHT', self, uR1 or 0, uR2 or 0)

        self.Border[3]:SetTexCoord(0, 1/3, 2/3, 1)
        self.Border[3]:SetPoint('BOTTOMLEFT', self, -(bL1 or 0), -(bL2 or 0))

        self.Border[4]:SetTexCoord(2/3, 1, 2/3, 1)
        self.Border[4]:SetPoint('BOTTOMRIGHT', self, bR1 or 0, -(bR2 or 0))

        self.Border[5]:SetTexCoord(1/3, 2/3, 0, 1/3)
        self.Border[5]:SetPoint('TOPLEFT', self.Border[1], 'TOPRIGHT')
        self.Border[5]:SetPoint('TOPRIGHT', self.Border[2], 'TOPLEFT')

        self.Border[6]:SetTexCoord(1/3, 2/3, 2/3, 1)
        self.Border[6]:SetPoint('BOTTOMLEFT', self.Border[3], 'BOTTOMRIGHT')
        self.Border[6]:SetPoint('BOTTOMRIGHT', self.Border[4], 'BOTTOMLEFT')

        self.Border[7]:SetTexCoord(0, 1/3, 1/3, 2/3)
        self.Border[7]:SetPoint('TOPLEFT', self.Border[1], 'BOTTOMLEFT')
        self.Border[7]:SetPoint('BOTTOMLEFT', self.Border[3], 'TOPLEFT')

        self.Border[8]:SetTexCoord(2/3, 1, 1/3, 2/3)
        self.Border[8]:SetPoint('TOPRIGHT', self.Border[2], 'BOTTOMRIGHT')
        self.Border[8]:SetPoint('BOTTOMRIGHT', self.Border[4], 'TOPRIGHT')
        
        local space
        if (borderSize >= 10) then
            space = 3
        else
            space = borderSize/3.5
        end
        
        self.Shadow = {}	   
        for i = 1, 8 do
            self.Shadow[i] = self:CreateTexture(nil, 'BORDER')
            self.Shadow[i]:SetParent(self)
            self.Shadow[i]:SetTexture(textureShadow)
            self.Shadow[i]:SetSize(borderSize, borderSize)  
            self.Shadow[i]:SetVertexColor(0, 0, 0, 8)
        end
        
        self.Shadow[1]:SetTexCoord(0, 1/3, 0, 1/3) 
        self.Shadow[1]:SetPoint('TOPLEFT', self, -(uL1 or 0)-space, (uL2 or 0)+space)

        self.Shadow[2]:SetTexCoord(2/3, 1, 0, 1/3)
        self.Shadow[2]:SetPoint('TOPRIGHT', self, (uR1 or 0)+space, (uR2 or 0)+space)

        self.Shadow[3]:SetTexCoord(0, 1/3, 2/3, 1)
        self.Shadow[3]:SetPoint('BOTTOMLEFT', self, -(bL1 or 0)-space, -(bL2 or 0)-space)

        self.Shadow[4]:SetTexCoord(2/3, 1, 2/3, 1)
        self.Shadow[4]:SetPoint('BOTTOMRIGHT', self, (bR1 or 0)+space, -(bR2 or 0)-space)

        self.Shadow[5]:SetTexCoord(1/3, 2/3, 0, 1/3)
        self.Shadow[5]:SetPoint('TOPLEFT', self.Shadow[1], 'TOPRIGHT')
        self.Shadow[5]:SetPoint('TOPRIGHT', self.Shadow[2], 'TOPLEFT')

        self.Shadow[6]:SetTexCoord(1/3, 2/3, 2/3, 1)
        self.Shadow[6]:SetPoint('BOTTOMLEFT', self.Shadow[3], 'BOTTOMRIGHT')
        self.Shadow[6]:SetPoint('BOTTOMRIGHT', self.Shadow[4], 'BOTTOMLEFT')

        self.Shadow[7]:SetTexCoord(0, 1/3, 1/3, 2/3)
        self.Shadow[7]:SetPoint('TOPLEFT', self.Shadow[1], 'BOTTOMLEFT')
        self.Shadow[7]:SetPoint('BOTTOMLEFT', self.Shadow[3], 'TOPLEFT')

        self.Shadow[8]:SetTexCoord(2/3, 1, 1/3, 2/3)
        self.Shadow[8]:SetPoint('TOPRIGHT', self.Shadow[2], 'BOTTOMRIGHT')
        self.Shadow[8]:SetPoint('BOTTOMRIGHT', self.Shadow[4], 'TOPRIGHT')
        
        self.HasBorder = true
    end
end

function CreateBorderNormal(self, borderSize, R, G, B, ...)
    local uL1, uL2, uR1, uR2, bL1, bL2, bR1, bR2 = ...
	
	if (uL1) then
        if (not uL2 and not uR1 and not uR2 and not bL1 and not bL2 and not bR1 and not bR2) then
            uL2, uR1, uR2, bL1, bL2, bR1, bR2 = uL1, uL1, uL1, uL1, uL1, uL1, uL1
        end
    end
    
    if (not self.HasBorder) then
        self.Border = {}
        for i = 1, 8 do
            self.Border[i] = self:CreateTexture(nil, 'OVERLAY')
            self.Border[i]:SetParent(self)
            self.Border[i]:SetTexture(textureNormalWhite)
            self.Border[i]:SetSize(borderSize, borderSize)
            self.Border[i]:SetVertexColor(R or 1, G or 1, B or 1)
        end
        
        self.Border[1]:SetTexCoord(0, 1/3, 0, 1/3) 
        self.Border[1]:SetPoint('TOPLEFT', self, -(uL1 or 0), uL2 or 0)

        self.Border[2]:SetTexCoord(2/3, 1, 0, 1/3)
        self.Border[2]:SetPoint('TOPRIGHT', self, uR1 or 0, uR2 or 0)

        self.Border[3]:SetTexCoord(0, 1/3, 2/3, 1)
        self.Border[3]:SetPoint('BOTTOMLEFT', self, -(bL1 or 0), -(bL2 or 0))

        self.Border[4]:SetTexCoord(2/3, 1, 2/3, 1)
        self.Border[4]:SetPoint('BOTTOMRIGHT', self, bR1 or 0, -(bR2 or 0))

        self.Border[5]:SetTexCoord(1/3, 2/3, 0, 1/3)
        self.Border[5]:SetPoint('TOPLEFT', self.Border[1], 'TOPRIGHT')
        self.Border[5]:SetPoint('TOPRIGHT', self.Border[2], 'TOPLEFT')

        self.Border[6]:SetTexCoord(1/3, 2/3, 2/3, 1)
        self.Border[6]:SetPoint('BOTTOMLEFT', self.Border[3], 'BOTTOMRIGHT')
        self.Border[6]:SetPoint('BOTTOMRIGHT', self.Border[4], 'BOTTOMLEFT')

        self.Border[7]:SetTexCoord(0, 1/3, 1/3, 2/3)
        self.Border[7]:SetPoint('TOPLEFT', self.Border[1], 'BOTTOMLEFT')
        self.Border[7]:SetPoint('BOTTOMLEFT', self.Border[3], 'TOPLEFT')

        self.Border[8]:SetTexCoord(2/3, 1, 1/3, 2/3)
        self.Border[8]:SetPoint('TOPRIGHT', self.Border[2], 'BOTTOMRIGHT')
        self.Border[8]:SetPoint('BOTTOMRIGHT', self.Border[4], 'TOPRIGHT')
        
        local space
        if (borderSize >= 10) then
            space = 3
        else
            space = borderSize/3.5
        end
        
        self.Shadow = {}	   
        for i = 1, 8 do
            self.Shadow[i] = self:CreateTexture(nil, 'BORDER')
            self.Shadow[i]:SetParent(self)
            self.Shadow[i]:SetTexture(textureShadow)
            self.Shadow[i]:SetSize(borderSize, borderSize)  
            self.Shadow[i]:SetVertexColor(0, 0, 0, 8)
        end
        
        self.Shadow[1]:SetTexCoord(0, 1/3, 0, 1/3) 
        self.Shadow[1]:SetPoint('TOPLEFT', self, -(uL1 or 0)-space, (uL2 or 0)+space)

        self.Shadow[2]:SetTexCoord(2/3, 1, 0, 1/3)
        self.Shadow[2]:SetPoint('TOPRIGHT', self, (uR1 or 0)+space, (uR2 or 0)+space)

        self.Shadow[3]:SetTexCoord(0, 1/3, 2/3, 1)
        self.Shadow[3]:SetPoint('BOTTOMLEFT', self, -(bL1 or 0)-space, -(bL2 or 0)-space)

        self.Shadow[4]:SetTexCoord(2/3, 1, 2/3, 1)
        self.Shadow[4]:SetPoint('BOTTOMRIGHT', self, (bR1 or 0)+space, -(bR2 or 0)-space)

        self.Shadow[5]:SetTexCoord(1/3, 2/3, 0, 1/3)
        self.Shadow[5]:SetPoint('TOPLEFT', self.Shadow[1], 'TOPRIGHT')
        self.Shadow[5]:SetPoint('TOPRIGHT', self.Shadow[2], 'TOPLEFT')

        self.Shadow[6]:SetTexCoord(1/3, 2/3, 2/3, 1)
        self.Shadow[6]:SetPoint('BOTTOMLEFT', self.Shadow[3], 'BOTTOMRIGHT')
        self.Shadow[6]:SetPoint('BOTTOMRIGHT', self.Shadow[4], 'BOTTOMLEFT')

        self.Shadow[7]:SetTexCoord(0, 1/3, 1/3, 2/3)
        self.Shadow[7]:SetPoint('TOPLEFT', self.Shadow[1], 'BOTTOMLEFT')
        self.Shadow[7]:SetPoint('BOTTOMLEFT', self.Shadow[3], 'TOPLEFT')

        self.Shadow[8]:SetTexCoord(2/3, 1, 1/3, 2/3)
        self.Shadow[8]:SetPoint('TOPRIGHT', self.Shadow[2], 'BOTTOMRIGHT')
        self.Shadow[8]:SetPoint('BOTTOMRIGHT', self.Shadow[4], 'TOPRIGHT')
        
        self.HasBorder = true
    end
end

function CreateBorderLight(self, borderSize, R, G, B, ...)
    local uL1, uL2, uR1, uR2, bL1, bL2, bR1, bR2 = ...
    
	if (uL1) then
        if (not uL2 and not uR1 and not uR2 and not bL1 and not bL2 and not bR1 and not bR2) then
            uL2, uR1, uR2, bL1, bL2, bR1, bR2 = uL1, uL1, uL1, uL1, uL1, uL1, uL1
        end
    end
	
    if (not self.HasBorder) then
        self.Border = {}
        for i = 1, 8 do
            self.Border[i] = self:CreateTexture(nil, 'OVERLAY')
            self.Border[i]:SetParent(self)
            self.Border[i]:SetTexture(textureNormalLight)
			self.Border[i]:SetSize(borderSize, borderSize)
            self.Border[i]:SetVertexColor(R or 1, G or 1, B or 1)
        end
        
        self.Border[1]:SetTexCoord(0, 1/3, 0, 1/3) 
        self.Border[1]:SetPoint('TOPLEFT', self, -(uL1 or 0), uL2 or 0)

        self.Border[2]:SetTexCoord(2/3, 1, 0, 1/3)
        self.Border[2]:SetPoint('TOPRIGHT', self, uR1 or 0, uR2 or 0)

        self.Border[3]:SetTexCoord(0, 1/3, 2/3, 1)
        self.Border[3]:SetPoint('BOTTOMLEFT', self, -(bL1 or 0), -(bL2 or 0))

        self.Border[4]:SetTexCoord(2/3, 1, 2/3, 1)
        self.Border[4]:SetPoint('BOTTOMRIGHT', self, bR1 or 0, -(bR2 or 0))

        self.Border[5]:SetTexCoord(1/3, 2/3, 0, 1/3)
        self.Border[5]:SetPoint('TOPLEFT', self.Border[1], 'TOPRIGHT')
        self.Border[5]:SetPoint('TOPRIGHT', self.Border[2], 'TOPLEFT')

        self.Border[6]:SetTexCoord(1/3, 2/3, 2/3, 1)
        self.Border[6]:SetPoint('BOTTOMLEFT', self.Border[3], 'BOTTOMRIGHT')
        self.Border[6]:SetPoint('BOTTOMRIGHT', self.Border[4], 'BOTTOMLEFT')

        self.Border[7]:SetTexCoord(0, 1/3, 1/3, 2/3)
        self.Border[7]:SetPoint('TOPLEFT', self.Border[1], 'BOTTOMLEFT')
        self.Border[7]:SetPoint('BOTTOMLEFT', self.Border[3], 'TOPLEFT')

        self.Border[8]:SetTexCoord(2/3, 1, 1/3, 2/3)
        self.Border[8]:SetPoint('TOPRIGHT', self.Border[2], 'BOTTOMRIGHT')
        self.Border[8]:SetPoint('BOTTOMRIGHT', self.Border[4], 'TOPRIGHT')
        
        local space
        if (borderSize >= 10) then
            space = 3
        else
            space = borderSize/3.5
        end
        
		self.Shadow = {}
        for i = 1, 8 do
            self.Shadow[i] = self:CreateTexture(nil, 'BORDER')
            self.Shadow[i]:SetParent(self)
            self.Shadow[i]:SetTexture(textureShadow)
            self.Shadow[i]:SetSize(borderSize, borderSize)  
            self.Shadow[i]:SetVertexColor(0, 0, 0, 8)
        end
        
        self.Shadow[1]:SetTexCoord(0, 1/3, 0, 1/3) 
        self.Shadow[1]:SetPoint('TOPLEFT', self, -(uL1 or 0)-space, (uL2 or 0)+space)

        self.Shadow[2]:SetTexCoord(2/3, 1, 0, 1/3)
        self.Shadow[2]:SetPoint('TOPRIGHT', self, (uR1 or 0)+space, (uR2 or 0)+space)

        self.Shadow[3]:SetTexCoord(0, 1/3, 2/3, 1)
        self.Shadow[3]:SetPoint('BOTTOMLEFT', self, -(bL1 or 0)-space, -(bL2 or 0)-space)

        self.Shadow[4]:SetTexCoord(2/3, 1, 2/3, 1)
        self.Shadow[4]:SetPoint('BOTTOMRIGHT', self, (bR1 or 0)+space, -(bR2 or 0)-space)

        self.Shadow[5]:SetTexCoord(1/3, 2/3, 0, 1/3)
        self.Shadow[5]:SetPoint('TOPLEFT', self.Shadow[1], 'TOPRIGHT')
        self.Shadow[5]:SetPoint('TOPRIGHT', self.Shadow[2], 'TOPLEFT')

        self.Shadow[6]:SetTexCoord(1/3, 2/3, 2/3, 1)
        self.Shadow[6]:SetPoint('BOTTOMLEFT', self.Shadow[3], 'BOTTOMRIGHT')
        self.Shadow[6]:SetPoint('BOTTOMRIGHT', self.Shadow[4], 'BOTTOMLEFT')

        self.Shadow[7]:SetTexCoord(0, 1/3, 1/3, 2/3)
        self.Shadow[7]:SetPoint('TOPLEFT', self.Shadow[1], 'BOTTOMLEFT')
        self.Shadow[7]:SetPoint('BOTTOMLEFT', self.Shadow[3], 'TOPLEFT')

        self.Shadow[8]:SetTexCoord(2/3, 1, 1/3, 2/3)
        self.Shadow[8]:SetPoint('TOPRIGHT', self.Shadow[2], 'BOTTOMRIGHT')
        self.Shadow[8]:SetPoint('BOTTOMRIGHT', self.Shadow[4], 'TOPRIGHT')
		
        self.HasBorder = true
    end
end

function ColorBorder(self, R, G, B)
    if (self.Border) then
        for i = 1, 8 do
            self.Border[i]:SetVertexColor(R, G, B)
        end        
    end
end