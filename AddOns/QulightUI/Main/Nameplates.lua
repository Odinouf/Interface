if not Qulight["nameplate"].enable == true then return end

function UIScale()
	if Qulight["general"].AutoScale == true then
	Qulight["general"].UiScale = min(2, max(.64, 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")))
	end
end
UIScale()
-- pixel perfect script of custom ui scale.
local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/Qulight["general"].UiScale
local function scale(x)
    return mult*math.floor(x/mult+.5)
end
function Scale(x) return scale(x) end
mult = mult

local TEXTURE = "Interface\\Buttons\\WHITE8x8"
local FONT = Qulight["media"].font
local FONTSIZE = 8
local FONTFLAG = "THINOUTLINE"
	
local hpHeight = 12
local hpWidth = Qulight["nameplate"].width
local iconSize = 25		--Size of all Icons, RaidIcon/ClassIcon/Castbar Icon
local cbHeight = 5
local cbWidth = Qulight["nameplate"].width
local blankTex = Qulight["media"].blank
local OVERLAY = [=[Interface\TargetingFrame\UI-TargetingFrame-Flash]=]

local numChildren = -1
local frames = {}
local noscalemult = mult * Qulight["general"].UiScale

--Change defaults if we are showing health text or not
if Qulight["nameplate"].showhealth ~= true then
	hpHeight = 7
	iconSize = 20
end

local NamePlates = CreateFrame("Frame", nil, UIParent)
NamePlates:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

local function QueueObject(parent, object)
	parent.queue = parent.queue or {}
	parent.queue[object] = true
end

local function HideObjects(parent)
	for object in pairs(parent.queue) do
		if(object:GetObjectType() == 'Texture') then
			object:SetTexture(nil)
			object.SetTexture = dummy
		elseif (object:GetObjectType() == 'FontString') then
			object.ClearAllPoints = dummy
			object.SetFont = dummy
			object.SetPoint = dummy
			object:Hide()
			object.Show = dummy
			object.SetText = dummy
			object.SetShadowOffset = dummy
		else
			object:Hide()
			object.Show = dummy
		end
	end
end

--Create a fake backdrop frame using textures
local function CreateVirtualFrame(parent, point)
	if point == nil then point = parent end
	
	if point.backdrop then return end
	parent.backdrop = parent:CreateTexture(nil, "BORDER")
	parent.backdrop:SetDrawLayer("BORDER", -8)
	parent.backdrop:SetPoint("TOPLEFT", point, "TOPLEFT", -noscalemult*3, noscalemult*3)
	parent.backdrop:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", noscalemult*3, -noscalemult*3)
	parent.backdrop:SetTexture(0, 0, 0, 1)

	parent.backdrop2 = parent:CreateTexture(nil, "BORDER")
	parent.backdrop2:SetDrawLayer("BORDER", -7)
	parent.backdrop2:SetAllPoints(point)
	parent.backdrop2:SetTexture(unpack(Qulight["media"].backdropcolor))	
	
	parent.bordertop = parent:CreateTexture(nil, "BORDER")
	parent.bordertop:SetPoint("TOPLEFT", point, "TOPLEFT", -noscalemult*2, noscalemult*2)
	parent.bordertop:SetPoint("TOPRIGHT", point, "TOPRIGHT", noscalemult*2, noscalemult*2)
	parent.bordertop:SetHeight(noscalemult)
	parent.bordertop:SetTexture(unpack(Qulight["media"].bordercolor))	
	parent.bordertop:SetDrawLayer("BORDER", -7)
	
	parent.borderbottom = parent:CreateTexture(nil, "BORDER")
	parent.borderbottom:SetPoint("BOTTOMLEFT", point, "BOTTOMLEFT", -noscalemult*2, -noscalemult*2)
	parent.borderbottom:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", noscalemult*2, -noscalemult*2)
	parent.borderbottom:SetHeight(noscalemult)
	parent.borderbottom:SetTexture(unpack(Qulight["media"].bordercolor))	
	parent.borderbottom:SetDrawLayer("BORDER", -7)
	
	parent.borderleft = parent:CreateTexture(nil, "BORDER")
	parent.borderleft:SetPoint("TOPLEFT", point, "TOPLEFT", -noscalemult*2, noscalemult*2)
	parent.borderleft:SetPoint("BOTTOMLEFT", point, "BOTTOMLEFT", noscalemult*2, -noscalemult*2)
	parent.borderleft:SetWidth(noscalemult)
	parent.borderleft:SetTexture(unpack(Qulight["media"].bordercolor))	
	parent.borderleft:SetDrawLayer("BORDER", -7)
	
	parent.borderright = parent:CreateTexture(nil, "BORDER")
	parent.borderright:SetPoint("TOPRIGHT", point, "TOPRIGHT", noscalemult*2, noscalemult*2)
	parent.borderright:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", -noscalemult*2, -noscalemult*2)
	parent.borderright:SetWidth(noscalemult)
	parent.borderright:SetTexture(unpack(Qulight["media"].bordercolor))	
	parent.borderright:SetDrawLayer("BORDER", -7)	
end

local function SetVirtualBorder(parent, r, g, b)
	parent.bordertop:SetTexture(r, g, b)
	parent.borderbottom:SetTexture(r, g, b)
	parent.borderleft:SetTexture(r, g, b)
	parent.borderright:SetTexture(r, g, b)
end


--Create our Aura Icons
local function CreateAuraIcon(parent)
	local button = CreateFrame("Frame",nil,parent)
	button:SetWidth(20)
	button:SetHeight(20)
	
	button.bg = button:CreateTexture(nil, "BACKGROUND")
	button.bg:SetTexture(unpack(Qulight["media"].backdropcolor))
	button.bg:SetAllPoints(button)
	
	button.bord = button:CreateTexture(nil, "BORDER")
	button.bord:SetTexture(unpack(Qulight["media"].bordercolor))
	button.bord:SetPoint("TOPLEFT",button,"TOPLEFT", noscalemult,-noscalemult)
	button.bord:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-noscalemult,noscalemult)
	
	button.bg2 = button:CreateTexture(nil, "ARTWORK")
	button.bg2:SetTexture(unpack(Qulight["media"].backdropcolor))
	button.bg2:SetPoint("TOPLEFT",button,"TOPLEFT", noscalemult*2,-noscalemult*2)
	button.bg2:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-noscalemult*2,noscalemult*2)	
	
	button.icon = button:CreateTexture(nil, "OVERLAY")
	button.icon:SetPoint("TOPLEFT",button,"TOPLEFT", noscalemult*3,-noscalemult*3)
	button.icon:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-noscalemult*3,noscalemult*3)
	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	button.cd = CreateFrame("Cooldown",nil,button)
	button.cd:SetAllPoints(button)
	button.cd:SetReverse(true)
	button.count = button:CreateFontString(nil,"OVERLAY")
	button.count:SetFont(FONT,7,FONTFLAG)
	button.count:SetShadowColor(0, 0, 0, 0.4)
	button.count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 2)
	return button
end

--Update an Aura Icon
local function UpdateAuraIcon(button, unit, index, filter)
	local name,_,icon,count,debuffType,duration,expirationTime,_,_,_,spellID = UnitAura(unit,index,filter)
	
	button.icon:SetTexture(icon)
	button.cd:SetCooldown(expirationTime-duration,duration)
	button.expirationTime = expirationTime
	button.duration = duration
	button.spellID = spellID
	if count > 1 then 
		button.count:SetText(count)
	else
		button.count:SetText("")
	end
	button.cd:SetScript("OnUpdate", function(self) if not button.cd.timer then self:SetScript("OnUpdate", nil) return end button.cd.timer.text:SetFont(FONT,8,FONTFLAG) button.cd.timer.text:SetShadowColor(0, 0, 0, 0.4) end)
	button:Show()
end
-- Target/Arena Frames/ Nameplates use these
DebuffWhiteList = {
	-- Death Knight
		[GetSpellInfo(47476)] = true, --strangulate
		[GetSpellInfo(49203)] = true, --hungering cold
	-- Druid
		[GetSpellInfo(33786)] = true, --Cyclone
		[GetSpellInfo(2637)] = true, --Hibernate
		[GetSpellInfo(339)] = true, --Entangling Roots
		[GetSpellInfo(80964)] = true, --Skull Bash
		[GetSpellInfo(78675)] = true, --Solar Beam
	-- Hunter
		[GetSpellInfo(3355)] = true, --Freezing Trap Effect
		--[GetSpellInfo(60210)] = true, --Freezing Arrow Effect
		[GetSpellInfo(1513)] = true, --scare beast
		[GetSpellInfo(19503)] = true, --scatter shot
		[GetSpellInfo(34490)] = true, --silence shot
	-- Mage
		[GetSpellInfo(31661)] = true, --Dragon's Breath
		[GetSpellInfo(61305)] = true, --Polymorph
		[GetSpellInfo(18469)] = true, --Silenced - Improved Counterspell
		[GetSpellInfo(122)] = true, --Frost Nova
		[GetSpellInfo(55080)] = true, --Shattered Barrier
		[GetSpellInfo(82691)] = true, --Ring of Frost
	-- Paladin
		[GetSpellInfo(20066)] = true, --Repentance
		[GetSpellInfo(10326)] = true, --Turn Evil
		[GetSpellInfo(853)] = true, --Hammer of Justice
	-- Priest
		[GetSpellInfo(605)] = true, --Mind Control
		[GetSpellInfo(64044)] = true, --Psychic Horror
		[GetSpellInfo(8122)] = true, --Psychic Scream
		[GetSpellInfo(9484)] = true, --Shackle Undead
		[GetSpellInfo(15487)] = true, --Silence
	-- Rogue
		[GetSpellInfo(2094)] = true, --Blind
		[GetSpellInfo(1776)] = true, --Gouge
		[GetSpellInfo(6770)] = true, --Sap
		[GetSpellInfo(18425)] = true, --Silenced - Improved Kick
	-- Shaman
		[GetSpellInfo(51514)] = true, --Hex
		[GetSpellInfo(3600)] = true, --Earthbind
		[GetSpellInfo(8056)] = true, --Frost Shock
		[GetSpellInfo(63685)] = true, --Freeze
		[GetSpellInfo(39796)] = true, --Stoneclaw Stun
	-- Warlock
		[GetSpellInfo(710)] = true, --Banish
		[GetSpellInfo(6789)] = true, --Death Coil
		[GetSpellInfo(5782)] = true, --Fear
		[GetSpellInfo(5484)] = true, --Howl of Terror
		[GetSpellInfo(6358)] = true, --Seduction
		[GetSpellInfo(30283)] = true, --Shadowfury
		[GetSpellInfo(89605)] = true, --Aura of Foreboding
	-- Warrior
		[GetSpellInfo(20511)] = true, --Intimidating Shout
	-- Racial
		[GetSpellInfo(25046)] = true, --Arcane Torrent
		[GetSpellInfo(20549)] = true, --War Stomp
	--PVE
}
--Filter auras on nameplate, and determine if we need to update them or not.
local function OnAura(frame, unit)
	if not frame.icons or not frame.unit then return end
	local i = 1
	for index = 1,40 do
		if i > 5 then return end
		local match
		local name,_,_,_,_,duration,_,caster,_,_,spellid = UnitAura(frame.unit,index,"HARMFUL")
		
		if Qulight["nameplate"].trackauras == true then
			if caster == "player" then match = true end
		end
		
		if Qulight["nameplate"].trackccauras == true then
			if DebuffWhiteList[name] then match = true end
		end
		
		if duration and match == true then
			if not frame.icons[i] then frame.icons[i] = CreateAuraIcon(frame) end
			local icon = frame.icons[i]
			if i == 1 then icon:SetPoint("RIGHT",frame.icons,"RIGHT") end
			if i ~= 1 and i <= 5 then icon:SetPoint("RIGHT", frame.icons[i-1], "LEFT", -2, 0) end
			i = i + 1
			UpdateAuraIcon(icon, frame.unit, index, "HARMFUL")
		end
	end
	for index = i, #frame.icons do frame.icons[index]:Hide() end
end

--Color the castbar depending on if we can interrupt or not, 
--also resize it as nameplates somehow manage to resize some frames when they reappear after being hidden
local function UpdateCastbar(frame)
	frame:ClearAllPoints()
	frame:SetSize(cbWidth, cbHeight)
	frame:SetPoint('TOP', frame:GetParent().hp, 'BOTTOM', 0, -8)
	frame:GetStatusBarTexture():SetHorizTile(true)
	if(frame.shield:IsShown()) then
		frame:SetStatusBarColor(0.78, 0.25, 0.25, 1)
	end
end	

--Determine whether or not the cast is Channelled or a Regular cast so we can grab the proper Cast Name
local function UpdateCastText(frame, curValue)
	local minValue, maxValue = frame:GetMinMaxValues()
	
	if UnitChannelInfo("target") then
		frame.time:SetFormattedText("%.1f ", curValue)
		frame.name:SetText(select(1, (UnitChannelInfo("target"))))
	end
	
	if UnitCastingInfo("target") then
		frame.time:SetFormattedText("%.1f ", maxValue - curValue)
		frame.name:SetText(select(1, (UnitCastingInfo("target"))))
	end
end

--Sometimes castbar likes to randomly resize
local OnValueChanged = function(self, curValue)
	UpdateCastText(self, curValue)
	if self.needFix then
		UpdateCastbar(self)
		self.needFix = nil
	end
end

--Sometimes castbar likes to randomly resize
local OnSizeChanged = function(self)
	self.needFix = true
end

--We need to reset everything when a nameplate it hidden, this is so theres no left over data when a nameplate gets reshown for a differant mob.
local function OnHide(frame)
	frame.hp:SetStatusBarColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
	frame.overlay:Hide()
	frame.cb:Hide()
	frame.unit = nil
	frame.threatStatus = nil
	frame.guid = nil
	frame.hasClass = nil
	frame.isFriendly = nil
	frame.hp.rcolor = nil
	frame.hp.gcolor = nil
	frame.hp.bcolor = nil
	if frame.icons then
		for _,icon in ipairs(frame.icons) do
			icon:Hide()
		end
	end	
	
	frame:SetScript("OnUpdate",nil)
end

--Color Nameplate
local function Colorize(frame)
	local r,g,b = frame.healthOriginal:GetStatusBarColor()
	
	for class, color in pairs(RAID_CLASS_COLORS) do
		local r, g, b = floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100
		if RAID_CLASS_COLORS[class].r == r and RAID_CLASS_COLORS[class].g == g and RAID_CLASS_COLORS[class].b == b then
			frame.hasClass = true
			frame.isFriendly = false
			frame.hp:SetStatusBarColor(unpack(oUF_colors.class[class]))
			return
		end
	end
	
	if g+b == 0 then -- hostile
		r,g,b = .5,.06,.06
		frame.isFriendly = false
	elseif r+b == 0 then -- friendly npc
		r,g,b = unpack(oUF_colors.power["MANA"])
		frame.isFriendly = true
	elseif r+g > 1.95 then -- neutral
		r,g,b = unpack(oUF_colors.reaction[4])
		frame.isFriendly = false
	elseif r+g == 0 then -- friendly player
		r,g,b = unpack(oUF_colors.reaction[5])
		frame.isFriendly = true
	else -- enemy player
		frame.isFriendly = false
	end
	frame.hasClass = false
	
	frame.hp:SetStatusBarColor(r,g,b)
end

--HealthBar OnShow, use this to set variables for the nameplate, also size the healthbar here because it likes to lose it's
--size settings when it gets reshown
local function UpdateObjects(frame)
	local frame = frame:GetParent()
	
	local r, g, b = frame.hp:GetStatusBarColor()	
	
	--Have to reposition this here so it doesnt resize after being hidden
	frame.hp:ClearAllPoints()
	frame.hp:SetSize(hpWidth, hpHeight)	
	frame.hp:SetPoint('TOP', frame, 'TOP', 0, -15)
	frame.hp:GetStatusBarTexture():SetHorizTile(true)
	
	frame.hp:SetMinMaxValues(frame.healthOriginal:GetMinMaxValues())
	frame.hp:SetValue(frame.healthOriginal:GetValue())
	CreateShadow(frame.hp)
	
	--Colorize Plate
	Colorize(frame)
	frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor = frame.hp:GetStatusBarColor()
	frame.hp.hpbg:SetTexture(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor, 0.25)
	SetVirtualBorder(frame.hp, unpack(Qulight["media"].bordercolor))
	if Qulight["nameplate"].enhancethreat == true then
		frame.hp.name:SetTextColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
	end
	
	--Set the name text
	frame.hp.name:SetText(frame.hp.oldname:GetText())
	
	frame.overlay:ClearAllPoints()
	frame.overlay:SetAllPoints(frame.hp)
	
	--Setup level text
	if Qulight["nameplate"].skinlvl == true then
		local level, elite, mylevel = tonumber(frame.hp.oldlevel:GetText()), frame.hp.elite:IsShown(), UnitLevel("player")
		frame.hp.level:ClearAllPoints()
		
		frame.hp.level:SetPoint("RIGHT", frame.hp, "LEFT", -1, 0)
		
		
		frame.hp.level:SetTextColor(frame.hp.oldlevel:GetTextColor())
		if frame.hp.boss:IsShown() then
			frame.hp.level:SetText("??")
			frame.hp.level:SetTextColor(0.8, 0.05, 0)
			frame.hp.level:Show()
		elseif not elite and level == mylevel then
			frame.hp.level:Hide()
		else
			frame.hp.level:SetText(level..(elite and "+" or ""))
			frame.hp.level:Show()
		end
	end
	
	frame.overlay:ClearAllPoints()
	frame.overlay:SetAllPoints(frame.hp)
	
	
	-- Aura tracking
	if Qulight["nameplate"].trackauras == true or Qulight["nameplate"].trackccauras == true then
		if frame.icons then return end
		frame.icons = CreateFrame("Frame",nil,frame)
		frame.icons:SetPoint("BOTTOMRIGHT",frame.hp,"TOPRIGHT", 0, FONTSIZE+5)
		frame.icons:SetWidth(20 + hpWidth)
		frame.icons:SetHeight(25)
		frame.icons:SetFrameLevel(frame.hp:GetFrameLevel()+2)
		frame:RegisterEvent("UNIT_AURA")
		frame:HookScript("OnEvent", OnAura)
	end	
	HideObjects(frame)
end

--This is where we create most 'Static' objects for the nameplate, it gets fired when a nameplate is first seen.
local function SkinObjects(frame)
	local oldhp, cb = frame:GetChildren()
	local threat, hpborder, overlay, oldname, oldlevel, bossicon, raidicon, elite = frame:GetRegions()
	local _, cbborder, cbshield, cbicon = cb:GetRegions()

	--Health Bar
	frame.healthOriginal = oldhp
	local hp = CreateFrame("Statusbar", nil, frame)
	hp:SetFrameLevel(oldhp:GetFrameLevel())
	hp:SetFrameStrata(oldhp:GetFrameStrata())
	hp:SetStatusBarTexture(TEXTURE)
	CreateVirtualFrame(hp)
	
	--Create Level
	if Qulight["nameplate"].skinlvl == true then
		hp.level = hp:CreateFontString(nil, "OVERLAY")
		hp.level:SetFont(FONT, FONTSIZE, FONTFLAG)
		hp.level:SetShadowColor(0, 0, 0, 0.4)
		hp.level:SetTextColor(1, 1, 1)
		hp.level:SetShadowOffset(mult, -mult)	
		hp.oldlevel = oldlevel
		hp.boss = bossicon
		hp.elite = elite
	end

	--Create Health Text
	if Qulight["nameplate"].showhealth == true then
		hp.value = hp:CreateFontString(nil, "OVERLAY")	
		hp.value:SetFont(FONT, FONTSIZE, FONTFLAG)
		hp.value:SetShadowColor(0, 0, 0, 0.4)
		hp.value:SetPoint("CENTER", hp)
		hp.value:SetTextColor(1,1,1)
		hp.value:SetShadowOffset(mult, -mult)
	end
	
	--Create Name Text
	hp.name = hp:CreateFontString(nil, 'OVERLAY')
	hp.name:SetPoint('BOTTOMLEFT', hp, 'TOPLEFT', -10, 3)
	hp.name:SetPoint('BOTTOMRIGHT', hp, 'TOPRIGHT', 10, 3)
	hp.name:SetFont(FONT, FONTSIZE, FONTFLAG)
	hp.name:SetShadowColor(0, 0, 0, 0.4)
	hp.name:SetShadowOffset(mult, -mult)
	hp.oldname = oldname

	hp.hpbg = hp:CreateTexture(nil, 'BORDER')
	hp.hpbg:SetAllPoints(hp)
	hp.hpbg:SetTexture(1,1,1,0.25) 		
	
	hp:HookScript('OnShow', UpdateObjects)
	frame.hp = hp
	
	--Cast Bar
	cb:SetStatusBarTexture(TEXTURE)
	CreateVirtualFrame(cb)
	CreateShadow(cb)
	--Create Cast Time Text
	cb.time = cb:CreateFontString(nil, "ARTWORK")
	cb.time:SetPoint("RIGHT", cb, "LEFT", -1, 0)
	cb.time:SetFont(FONT, FONTSIZE, FONTFLAG)
	cb.time:SetShadowColor(0, 0, 0, 0.4)
	cb.time:SetTextColor(1, 1, 1)
	cb.time:SetShadowOffset(mult, -mult)

	--Create Cast Name Text
	cb.name = cb:CreateFontString(nil, "ARTWORK")
	cb.name:SetPoint("TOP", cb, "BOTTOM", 0, -3)
	cb.name:SetFont(FONT, FONTSIZE, FONTFLAG)
	cb.name:SetTextColor(1, 1, 1)
	cb.name:SetShadowColor(0, 0, 0, 0.4)
	cb.name:SetShadowOffset(mult, -mult)		
	
	--Setup CastBar Icon
	cbicon:ClearAllPoints()
	cbicon:SetPoint("TOPLEFT", hp, "TOPRIGHT", 8, 0)		
	cbicon:SetSize(iconSize, iconSize)
	cbicon:SetTexCoord(.07, .93, .07, .93)
	cbicon:SetDrawLayer("OVERLAY")
	cb.icon = cbicon
	CreateVirtualFrame(cb, cb.icon)

	cb.shield = cbshield
	cbshield:ClearAllPoints()
	cbshield:SetPoint("TOP", cb, "BOTTOM")
	cb:HookScript('OnShow', UpdateCastbar)
	cb:HookScript('OnSizeChanged', OnSizeChanged)
	cb:HookScript('OnValueChanged', OnValueChanged)			
	frame.cb = cb
	
	--Highlight
	overlay:SetTexture(1,1,1,0.15)
	overlay:SetAllPoints(hp)	
	frame.overlay = overlay

	--Reposition and Resize RaidIcon
	raidicon:ClearAllPoints()
	raidicon:SetPoint("BOTTOM", hp, "TOP", 0, 8)
	raidicon:SetSize(iconSize*1.1, iconSize*1.1)
	raidicon:SetTexture("Interface\\Addons\\QulightUI\\media\\Other\\raidicons")	
	frame.raidicon = raidicon
	
	--Hide Old Stuff
	QueueObject(frame, oldhp)
	QueueObject(frame, oldlevel)
	QueueObject(frame, threat)
	QueueObject(frame, hpborder)
	QueueObject(frame, cbshield)
	QueueObject(frame, cbborder)
	QueueObject(frame, oldname)
	QueueObject(frame, bossicon)
	QueueObject(frame, elite)
	
	UpdateObjects(hp)
	UpdateCastbar(cb)
	
	frame:HookScript('OnHide', OnHide)
	frames[frame] = true
	frame.QulightPlate = true
end

local goodR, goodG, goodB = 75/255, 175/255, 76/255
local badR, badG, badB = 0.78, 0.25, 0.25
local transitionR, transitionG, transitionB = 218/255, 197/255, 92/255
local transitionR2, transitionG2, transitionB2 = 240/255, 154/255, 17/255
local function UpdateThreat(frame, elapsed)
	frame.hp:Show()
	if frame.hasClass == true then return end
	
	if Qulight["nameplate"].enhancethreat ~= true then
		if(frame.region:IsShown()) then
			local _, val = frame.region:GetVertexColor()
			if(val > 0.7) then
				SetVirtualBorder(frame.hp, transitionR, transitionG, transitionB)
			else
				SetVirtualBorder(frame.hp, badR, badG, badB)
			end
		else
			SetVirtualBorder(frame.hp, unpack(Qulight["media"].bordercolor))
		end
	else
		if not frame.region:IsShown() then
			if InCombatLockdown() and frame.isFriendly ~= true then
				--No Threat
				if Role == "Tank" then
					frame.hp:SetStatusBarColor(badR, badG, badB)
					frame.hp.hpbg:SetTexture(badR, badG, badB, 0.25)
					frame.threatStatus = "BAD"
				else
					frame.hp:SetStatusBarColor(goodR, goodG, goodB)
					frame.hp.hpbg:SetTexture(goodR, goodG, goodB, 0.25)
					frame.threatStatus = "GOOD"
				end		
			else
				--Set colors to their original, not in combat
				frame.hp:SetStatusBarColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
				frame.hp.hpbg:SetTexture(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor, 0.25)
				frame.threatStatus = nil
			end
		else
			--Ok we either have threat or we're losing/gaining it
			local r, g, b = frame.region:GetVertexColor()
			if g + b == 0 then
				--Have Threat
				if Role == "Tank" then
					frame.hp:SetStatusBarColor(goodR, goodG, goodB)
					frame.hp.hpbg:SetTexture(goodR, goodG, goodB, 0.25)
					frame.threatStatus = "GOOD"
				else
					frame.hp:SetStatusBarColor(badR, badG, badB)
					frame.hp.hpbg:SetTexture(badR, badG, badB, 0.25)
					frame.threatStatus = "BAD"
				end
			else
				--Losing/Gaining Threat
				if Role == "Tank" then
					if frame.threatStatus == "GOOD" then
						--Losing Threat
						frame.hp:SetStatusBarColor(transitionR2, transitionG2, transitionB2)	
						frame.hp.hpbg:SetTexture(transitionR2, transitionG2, transitionB2, 0.25)				
					else
						--Gaining Threat
						frame.hp:SetStatusBarColor(transitionR, transitionG, transitionB)	
						frame.hp.hpbg:SetTexture(transitionR, transitionG, transitionB, 0.25)	
					end
				else
					if frame.threatStatus == "GOOD" then
						--Losing Threat
						frame.hp:SetStatusBarColor(transitionR, transitionG, transitionB)	
						frame.hp.hpbg:SetTexture(transitionR, transitionG, transitionB, 0.25)				
					else
						--Gaining Threat
						frame.hp:SetStatusBarColor(transitionR2, transitionG2, transitionB2)	
						frame.hp.hpbg:SetTexture(transitionR2, transitionG2, transitionB2, 0.25)	
					end				
				end
			end
		end
	end
end

PlateBlacklist = {
	--Shaman Totems
	["Earth Elemental Totem"] = true,
	["Fire Elemental Totem"] = true,
	["Fire Resistance Totem"] = true,
	["Flametongue Totem"] = true,
	["Frost Resistance Totem"] = true,
	["Healing Stream Totem"] = true,
	["Magma Totem"] = true,
	["Mana Spring Totem"] = true,
	["Nature Resistance Totem"] = true,
	["Searing Totem"] = true,
	["Stoneclaw Totem"] = true,
	["Stoneskin Totem"] = true,
	["Strength of Earth Totem"] = true,
	["Windfury Totem"] = true,
	["Totem of Wrath"] = true,
	["Wrath of Air Totem"] = true,

	--Army of the Dead
	["Army of the Dead Ghoul"] = true,

	--Hunter Trap
	["Venomous Snake"] = true,
	["Viper"] = true,
	
	--Misc
	["Lava Parasite"] = true,

	--Test
	--["Unbound Seer"] = true,
}
--Create our blacklist for nameplates, so prevent a certain nameplate from ever showing
local function CheckBlacklist(frame, ...)
	if PlateBlacklist[frame.hp.name:GetText()] then
		frame:SetScript("OnUpdate", function() end)
		frame.hp:Hide()
		frame.cb:Hide()
		frame.overlay:Hide()
		frame.hp.oldlevel:Hide()
	end
end
--When becoming intoxicated blizzard likes to re-show the old level text, this should fix that
local function HideDrunkenText(frame, ...)
	if frame and frame.hp.oldlevel and frame.hp.oldlevel:IsShown() then
		frame.hp.oldlevel:Hide()
	end
end

--Force the name text of a nameplate to be behind other nameplates unless it is our target
local function AdjustNameLevel(frame, ...)
	if UnitName("target") == frame.hp.name:GetText() and frame:GetAlpha() == 1 then
		frame.hp.name:SetDrawLayer("OVERLAY")
	else
		frame.hp.name:SetDrawLayer("BORDER")
	end
end

--Health Text, also border coloring for certain plates depending on health
local function ShowHealth(frame, ...)
	-- show current health value
	local minHealth, maxHealth = frame.healthOriginal:GetMinMaxValues()
	local valueHealth = frame.healthOriginal:GetValue()
	local d =(valueHealth/maxHealth)*100
	
	--Match values
	frame.hp:SetValue(valueHealth - 1)	--Bug Fix 4.1
	frame.hp:SetValue(valueHealth)	
	
	if Qulight["nameplate"].showhealth == true then
		frame.hp.value:SetText(ShortValue(valueHealth).." - "..(string.format("%d%%", math.floor((valueHealth/maxHealth)*100))))
	end
			
	--Setup frame shadow to change depending on enemy players health, also setup targetted unit to have white shadow
	if frame.hasClass == true or frame.isFriendly == true then
		if(d <= 50 and d >= 20) then
			SetVirtualBorder(frame.hp, 1, 1, 0)
		elseif(d < 20) then
			SetVirtualBorder(frame.hp, 1, 0, 0)
		else
			SetVirtualBorder(frame.hp, unpack(Qulight["media"].bordercolor))
		end
	elseif (frame.hasClass ~= true and frame.isFriendly ~= true) and Qulight["nameplate"].enhancethreat == true then
		SetVirtualBorder(frame.hp, unpack(Qulight["media"].bordercolor))
	end
end

--Scan all visible nameplate for a known unit.
local function CheckUnit_Guid(frame, ...)
	--local numParty, numRaid = GetNumPartyMembers(), GetNumRaidMembers()
	if UnitExists("target") and frame:GetAlpha() == 1 and UnitName("target") == frame.hp.name:GetText() then
		frame.guid = UnitGUID("target")
		frame.unit = "target"
		OnAura(frame, "target")
	elseif frame.overlay:IsShown() and UnitExists("mouseover") and UnitName("mouseover") == frame.hp.name:GetText() then
		frame.guid = UnitGUID("mouseover")
		frame.unit = "mouseover"
		OnAura(frame, "mouseover")
	else
		frame.unit = nil
	end	
end

--Update settings for nameplate to match config
local function CheckSettings(frame, ...)
	--Width
	if frame.hp:GetWidth() ~= Qulight["nameplate"].width then
		frame.hp:SetWidth(Qulight["nameplate"].width)
		hpWidth = Qulight["nameplate"].width
	end
end

--Attempt to match a nameplate with a GUID from the combat log
local function MatchGUID(frame, destGUID, spellID)
	if not frame.guid then return end
	if frame.guid == destGUID then
		for _,icon in ipairs(frame.icons) do 
			if icon.spellID == spellID then 
				icon:Hide() 
			end 
		end
	end
end

--Run a function for all visible nameplates, we use this for the blacklist, to check unitguid, and to hide drunken text
local function ForEachPlate(functionToRun, ...)
	for frame in pairs(frames) do
		if frame:IsShown() then
			functionToRun(frame, ...)
		end
	end
end

--Check if the frames default overlay texture matches blizzards nameplates default overlay texture
local select = select
local function HookFrames(...)
	for index = 1, select('#', ...) do
		local frame = select(index, ...)
		local region = frame:GetRegions()
		
		if(not frames[frame] and (frame:GetName() and frame:GetName():find("NamePlate%d")) and region and region:GetObjectType() == 'Texture' and region:GetTexture() == OVERLAY) then
			SkinObjects(frame)
			frame.region = region
		end
	end
end

--Core right here, scan for any possible nameplate frames that are Children of the WorldFrame
CreateFrame('Frame'):SetScript('OnUpdate', function(self, elapsed)
	if(WorldFrame:GetNumChildren() ~= numChildren) then
		numChildren = WorldFrame:GetNumChildren()
		HookFrames(WorldFrame:GetChildren())
	end

	if(self.elapsed and self.elapsed > 0.2) then
		ForEachPlate(UpdateThreat, self.elapsed)
		ForEachPlate(AdjustNameLevel)
		self.elapsed = 0
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end
	
	ForEachPlate(ShowHealth)
	ForEachPlate(CheckBlacklist)
	ForEachPlate(HideDrunkenText)
	ForEachPlate(CheckUnit_Guid)
	ForEachPlate(CheckSettings)
end)

function NamePlates:COMBAT_LOG_EVENT_UNFILTERED(_, event, ...)
	if event == "SPELL_AURA_REMOVED" then
		local _, sourceGUID, _, _, _, destGUID, _, _, _, spellID = ...
		
		if sourceGUID == UnitGUID("player") then
			ForEachPlate(MatchGUID, destGUID, spellID)
		end
	end
end

--Only show nameplates when in combat
if Qulight["nameplate"].combat == true then
	NamePlates:RegisterEvent("PLAYER_REGEN_ENABLED")
	NamePlates:RegisterEvent("PLAYER_REGEN_DISABLED")
	
	function NamePlates:PLAYER_REGEN_ENABLED()
		SetCVar("nameplateShowEnemies", 0)
	end

	function NamePlates:PLAYER_REGEN_DISABLED()
		SetCVar("nameplateShowEnemies", 1)
	end
end

NamePlates:RegisterEvent("PLAYER_ENTERING_WORLD")
function NamePlates:PLAYER_ENTERING_WORLD()
	if Qulight["nameplate"].combat == true then
		if InCombatLockdown() then
			SetCVar("nameplateShowEnemies", 1)
		else
			SetCVar("nameplateShowEnemies", 0)
		end
	end
	
	if Qulight["nameplate"].enable == true and Qulight["nameplate"].enhancethreat == true then
		SetCVar("threatWarning", 3)
	end
	
	SetCVar("bloatthreat", 0)
	SetCVar("bloattest", 0)
	SetCVar("bloatnameplates", 0)
	
end