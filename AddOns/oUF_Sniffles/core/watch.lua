--[[
		This file is for adding of deleting a spellID for a specific encounter on Grid layout
		or enemy cooldown in Arena displayed on screen.
		
		The best way to add or delete spell is to go at www.wowhead.com, search for a spell :
		Example : Incinerate Flesh from Lord Jaraxxus -> http://www.wowhead.com/?spell=67049
		Take the number ID at the end of the URL, and add it to the list
		
		That's it, That's all! 
		
		Tukz
]]-- 
	--------------------------------------------------------------------------------------------
	-- THE AURAWATCH FUNCTION ITSELF. HERE BE DRAGONS!
	--------------------------------------------------------------------------------------------

local _, myclass = UnitClass('player')
	
countOffsets = {
		TOPLEFT = {6*1, 1},
		TOPRIGHT = {-6*1, 1},
		BOTTOMLEFT = {6*1, 1},
		BOTTOMRIGHT = {-6*1, 1},
		LEFT = {6*1, 1},
		RIGHT = {-6*1, 1},
		TOP = {0, 0},
		BOTTOM = {0, 0},
}

function CreateAuraWatchIcon(self, icon)
		SetBD(icon)
		icon.icon:SetPoint("TOPLEFT", 1, -1)
		icon.icon:SetPoint("BOTTOMRIGHT",-1,1)
		icon.icon:SetTexCoord(.08, .92, .08, .92)
		icon.icon:SetDrawLayer("ARTWORK")
		if (icon.cd) then
			icon.cd:SetReverse()
		end
		icon.overlay:SetTexture()
	end

function createAuraWatch(self, unit)
		local auras = CreateFrame("Frame", nil, self)
		auras:SetPoint("TOPLEFT", self.Health, 2, -2)
		auras:SetPoint("BOTTOMRIGHT", self.Health, -2, 2)
		auras.presentAlpha = 1
		auras.missingAlpha = 0
		auras.icons = {}
		auras.PostCreateIcon = CreateAuraWatchIcon
		auras.hideCooldown = true

		local buffs = {}

		if (buffids["ALL"]) then
			for key, value in pairs(buffids["ALL"]) do
				tinsert(buffs, value)
			end
		end

		if (buffids[myclass]) then
			for key, value in pairs(buffids[myclass]) do
				tinsert(buffs, value)
			end
		end

		-- "Cornerbuffs"
		if (buffs) then
			for key, spell in pairs(buffs) do
				local icon = CreateFrame("Frame", nil, auras)
				icon.spellID = spell[1]
				icon.anyUnit = spell[4]
				icon:SetWidth(Scale(6*1))
				icon:SetHeight(Scale(6*1))
				icon:SetPoint(spell[2], 0, 0)

				local tex = icon:CreateTexture(nil, "OVERLAY")
				tex:SetAllPoints(icon)
				tex:SetTexture(med.blanky)
				if (spell[3]) then
					tex:SetVertexColor(unpack(spell[3]))
				else
					tex:SetVertexColor(0.8, 0.8, 0.8)
				end

				local count = icon:CreateFontString(nil, "OVERLAY")
				count:SetFont(med.font, 8*1, "THINOUTLINE")
				count:SetPoint("CENTER", unpack(countOffsets[spell[2]]))
				icon.count = count

				auras.icons[spell[1]] = icon
			end
		end
		
		self.AuraWatch = auras
end

	-- Classbuffs { spell ID, position [, {r,g,b,a}][, anyUnit] }
	-- For oUF_AuraWatch
do
	buffids = {
		PRIEST = {
				{6788, "TOPLEFT", {1, 0, 0}, true}, -- Weakened Soul
				{33076, "TOPRIGHT", {0.2, 0.7, 0.2}}, -- Prayer of Mending
				{139, "BOTTOMLEFT", {0.4, 0.7, 0.2}}, -- Renew
				{17, "BOTTOMRIGHT", {0.81, 0.85, 0.1}, true}, -- Power Word: Shield
			},
			DRUID = {
				{774, "TOPLEFT", {0.8, 0.4, 0.8}}, -- Rejuvenation
				{8936, "TOPRIGHT", {0.2, 0.8, 0.2}}, -- Regrowth
				{33763, "BOTTOMLEFT", {0.4, 0.8, 0.2}}, -- Lifebloom
				{48438, "BOTTOMRIGHT", {0.8, 0.4, 0}}, -- Wild Growth
			},
			PALADIN = {
				{53563, "TOPLEFT", {0.7, 0.3, 0.7}}, -- Beacon of Light
			},
			SHAMAN = {
				{61295, "TOPLEFT", {0.7, 0.3, 0.7}}, -- Riptide 
				{51945, "TOPRIGHT", {0.2, 0.7, 0.2}}, -- Earthliving
				{16177, "BOTTOMLEFT", {0.4, 0.7, 0.2}}, -- Ancestral Fortitude
				{974, "BOTTOMRIGHT", {0.7, 0.4, 0}}, -- Earth Shield
			},
			ALL = {
				{14253, "RIGHT", {0, 1, 0}}, -- Abolish Poison
				{23333, "LEFT", {1, 0, 0}}, -- Warsong flag xD
			},
		}
end