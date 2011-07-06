if not Qulight["buffdebuff"].enable == true then return end 
local addon, ns = ...

AnchorBuff = CreateFrame("Frame","Move_Buff",UIParent)
AnchorBuff:SetPoint("TOPRIGHT", UIParent, -5, -5)
CreateAnchor(AnchorBuff, "Move Buff", 300, 70)

ConsolidatedBuffs:ClearAllPoints()
ConsolidatedBuffs:SetPoint("TOPRIGHT", AnchorBuff)
ConsolidatedBuffs:SetSize(Qulight["buffdebuff"].iconsize, Qulight["buffdebuff"].iconsize)
ConsolidatedBuffs.SetPoint = nil
ConsolidatedBuffsIcon:SetTexture("Interface\\Icons\\Spell_ChargePositive")
ConsolidatedBuffsIcon:SetTexCoord(0.03,0.97,0.03,0.97)
ConsolidatedBuffsIcon:SetSize(Qulight["buffdebuff"].iconsize-2,Qulight["buffdebuff"].iconsize-2)
local h = CreateFrame("Frame")
h:SetParent(ConsolidatedBuffs)
h:SetAllPoints(ConsolidatedBuffs)
h:SetFrameLevel(30)
ConsolidatedBuffsCount:SetParent(h)
ConsolidatedBuffsCount:SetPoint("BOTTOMRIGHT")
ConsolidatedBuffsCount:SetFont(Qulight["media"].font, Qulight["buffdebuff"].countfontsize, "OUTLINE")
local CBbg = CreateFrame("Frame", nil, ConsolidatedBuffs)
CreateShadow(CBbg)
for i = 1, 3 do
	_G["TempEnchant"..i.."Border"]:Hide()
	local te 			= _G["TempEnchant"..i]
	local teicon 		= _G["TempEnchant"..i.."Icon"]
	local teduration 	= _G["TempEnchant"..i.."Duration"]
	local h = CreateFrame("Frame")
	h:SetParent(te)
	h:SetAllPoints(te)
	h:SetFrameLevel(30)
	frame1px2(h)
	CreateShadow(h)
	te:SetSize(Qulight["buffdebuff"].iconsize,Qulight["buffdebuff"].iconsize)
	teicon:SetPoint("BOTTOMRIGHT", te, -2, 2)
	teicon:SetTexCoord(.08, .92, .08, .92)
	teicon:SetPoint("TOPLEFT", te, 2, -2)
	teduration:ClearAllPoints()
	teduration:SetParent(te)
	teduration:SetVertexColor(1,1,1)
	teduration:SetPoint("CENTER", 3, 0)
	teduration:SetFont(Qulight["media"].font, Qulight["buffdebuff"].timefontsize, "OUTLINE")
	local bg = CreateFrame("Frame", nil, te)
	CreateShadow(bg)
	
end
local function CreateBuffStyle(buttonName, i, debuff)
	local buff		= _G[buttonName..i]
	local icon		= _G[buttonName..i.."Icon"]
	local border	= _G[buttonName..i.."Border"]
	local duration	= _G[buttonName..i.."Duration"]
	local count 	= _G[buttonName..i.."Count"]
	if icon and not _G[buttonName..i.."Background"] then
		local h = CreateFrame("Frame")
		h:SetParent(buff)
		h:SetAllPoints(buff)
		h:SetFrameLevel(30)
		
		icon:SetTexCoord(.08, .92, .08, .92)
		icon:SetPoint("TOPLEFT", buff, 2, -2)
		icon:SetPoint("BOTTOMRIGHT", buff, -2, 2)
		buff:SetSize(Qulight["buffdebuff"].iconsize,Qulight["buffdebuff"].iconsize)
		duration:ClearAllPoints()
		duration:SetParent(h)
		duration:SetVertexColor(1,1,1)
		duration:SetPoint("CENTER", icon, 3, 0)
		duration:SetFont(Qulight["media"].font, Qulight["buffdebuff"].timefontsize, "OUTLINE")
		local bg = CreateFrame("Frame", buttonName..i.."Background", buff)
		frame1px2(bg)
		CreateShadow(bg)
		count:SetParent(h)
		count:ClearAllPoints()
		count:SetVertexColor(1,1,1)
		count:SetPoint("BOTTOMRIGHT", 0,0)
		count:SetFont(Qulight["media"].font, Qulight["buffdebuff"].countfontsize, "OUTLINE")
	end
	if border then border:Hide() end
end

local function OverrideBuffAnchors()
	local buttonName = "BuffButton" -- c
	local buff, previousBuff, aboveBuff;
	local numBuffs = 0;
	local slack = BuffFrame.numEnchants
	local mh, _, _, oh = GetWeaponEnchantInfo()
	if ( BuffFrame.numConsolidated > 0 ) then
		slack = slack + 1;	
	end
	for i=1, BUFF_ACTUAL_DISPLAY do
		CreateBuffStyle(buttonName, i, false)
		local buff = _G[buttonName..i]
		if not ( buff.consolidated ) then	
			numBuffs = numBuffs + 1
			i = numBuffs + slack
			buff:ClearAllPoints()
			if ( (i > 1) and (mod(i, Qulight["buffdebuff"].BUFFS_PER_ROW) == 1) ) then
 				if ( i == Qulight["buffdebuff"].BUFFS_PER_ROW+1 ) then
					buff:SetPoint("TOP", ConsolidatedBuffs, "BOTTOM", 0, -2)
				else
					buff:SetPoint("TOP", aboveBuff, "BOTTOM", 0, -2)
				end
				aboveBuff = buff; 
			elseif ( i == 1 ) then
				buff:SetPoint("TOPRIGHT", AnchorBuff)
			else
				if ( numBuffs == 1 ) then
					local  mh, _, _, oh, _, _, te = GetWeaponEnchantInfo()
					if mh and oh and te and not UnitHasVehicleUI("player") then
						buff:SetPoint("TOPRIGHT", TempEnchant3, "TOPLEFT", -Qulight["buffdebuff"].spacing, 0);
					elseif ((mh and oh) or (mh and te) or (oh and te)) and not UnitHasVehicleUI("player") then
						buff:SetPoint("TOPRIGHT", TempEnchant2, "TOPLEFT", -Qulight["buffdebuff"].spacing, 0);
					elseif ((mh and not oh and not te) or (oh and not mh and not te) or (te and not mh and not oh)) and not UnitHasVehicleUI("player") then
						buff:SetPoint("TOPRIGHT", TempEnchant1, "TOPLEFT", -Qulight["buffdebuff"].spacing, 0)
					else
						buff:SetPoint("TOPRIGHT", ConsolidatedBuffs, "TOPLEFT", -Qulight["buffdebuff"].spacing, 0);
					end
				else
					buff:SetPoint("RIGHT", previousBuff, "LEFT", -Qulight["buffdebuff"].spacing, 0);
				end
			end
			previousBuff = buff
		end		
	end
end
--[[local function OverrideDebuffAnchors(buttonName, i)
	local debuff = _G[buttonName..i];
	debuff:ClearAllPoints()
end--]]

local function OverrideDebuffAnchors(buttonName, i)
	CreateBuffStyle(buttonName, i, true)
	local color
	local buffName = buttonName..i
	local dtype = select(5, UnitDebuff("player",i))   
	local debuffSlot = _G[buffName.."Border"]
	local debuff = _G[buttonName..i];
	debuff:ClearAllPoints()
	if i == 1 then
		debuff:SetPoint("CENTER", UIParent, -300, -150)
	else
		debuff:SetPoint("RIGHT", _G[buttonName..(i-1)], "LEFT", -Qulight["buffdebuff"].spacing, 0)
	end
	if (dtype ~= nil) then
		color = DebuffTypeColor[dtype]
	else
		color = DebuffTypeColor["none"]
	end
	if debuffSlot then debuffSlot:SetVertexColor(color.r * 0.6, color.g * 0.6, color.b * 0.6, 1) end
end


-- fixing the consolidated buff container sizes because the default formula is just SHIT!
local z = 0.79 
local function OverrideConsolidatedBuffsAnchors()
	ConsolidatedBuffsTooltip:SetWidth(min(BuffFrame.numConsolidated * Qulight["buffdebuff"].iconsize * z + 18, 4 * Qulight["buffdebuff"].iconsize * z + 18));
    ConsolidatedBuffsTooltip:SetHeight(floor((BuffFrame.numConsolidated + 3) / 4 ) * Qulight["buffdebuff"].iconsize * z + CONSOLIDATED_BUFF_ROW_HEIGHT * z);
end
hooksecurefunc("DebuffButton_UpdateAnchors", OverrideDebuffAnchors)
hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", OverrideBuffAnchors)
hooksecurefunc("ConsolidatedBuffs_UpdateAllAnchors", OverrideConsolidatedBuffsAnchors)
----------------------------------------------------------------------------------------
--	Tells you who cast a buff or debuff in its tooltip(CastBy by Compost)
----------------------------------------------------------------------------------------
local a, b, d = _G.GameTooltip.SetUnitAura, _G.GameTooltip.SetUnitBuff, _G.GameTooltip.SetUnitDebuff
local un, uc, uvsi, ua, uip, upc, sub = _G.UnitName, _G.UnitClass, _G.UnitVehicleSeatInfo, _G.UnitAura, _G.UnitIsPlayer, _G.UnitPlayerControlled, _G.string.sub
local co = setmetatable({}, {__index = function(t, cl)
	local c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[cl] or RAID_CLASS_COLORS[cl]
	if c then
		t[cl] = ("ff%02x%02x%02x"):format(c.r * 255, c.g * 255, c.b * 255)
	else
		t[cl] = "ffffffff"
	end
	return t[cl]
end})

local function h(o, ...)
	o(...)
	local _, uid, id, f = ...
	if o == b then
		f = "HELPFUL " .. (f or "")
	elseif o == d then
		f = "HARMFUL " .. (f or "")
	end
	local _, _, _, _, _, _, _, c = ua(uid, id, f)
	local cl, str
	if c then
		if not uip(c) and upc(c) then
			local n
			_, n = uvsi(c, 1)
			if n then
				_, cl = uc(n)
				str = ("|c%s%s|r"):format(co[cl], n)
				_, n = uvsi(c, 2)
				if n then
					_, cl = uc(n)
					str = str.." & "..("|c%s%s|r"):format(co[cl], n)
				end
			else
				local cl2, n2
				if c == "pet" then
					_, cl=uc(c);_, cl2 = uc("player");n, n2 = un(c), un("player")
				elseif sub(c, 1, 8) == "partypet" then
					id = sub(c, 9)
					_, cl = uc(c);_, cl2 = uc("party"..id);n, n2 = un(c), un("party"..id)
				elseif sub(c, 1, 7) == "raidpet" then
					id = sub(c, 8)
					_, cl = uc(c);_, cl2=uc("raid"..id);n, n2 = un(c), un("raid"..id)
				end
				if cl then
					str = ("|c%s%s|r (|c%s%s|r)"):format(co[cl], n,co[cl2], n2)
				else
					_, cl = uc(c)
					str = ("|c%s%s|r"):format(co[cl], un(c))
				end
			end
		else
			_, cl = uc(c)
			str = ("|c%s%s|r"):format(co[cl], un(c))
		end
	end
	if str then
		GameTooltip:AddLine(DONE_BY.." "..str)
		GameTooltip:Show()
	end
end

GameTooltip.SetUnitAura = function( ... )
	h( a, ... )
end

GameTooltip.SetUnitBuff = function( ... )
	h( b, ... )
end

GameTooltip.SetUnitDebuff = function( ... )
	h( d, ... )
end