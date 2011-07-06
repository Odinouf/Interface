if not Qulight["misk"].Reminder == true then return end
ReminderBuffs = {
	PRIEST = {
		[1] = { --inner fire/will group
			["spells"] = {
				588, -- inner fire
				73413, -- inner will			
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true
		},
	},
	HUNTER = {
		[1] = { --aspects group
			["spells"] = {
				13165, -- hawk
				5118, -- cheetah
				20043, -- wild
				82661, -- fox	
			},
			["instance"] = true,
			["personal"] = true,
		},				
	},
	MAGE = {
		[1] = { --armors group
			["spells"] = {
				7302, -- frost armor
				6117, -- mage armor
				30482, -- molten armor		
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
		},		
	},
	WARLOCK = {
			[1] = { --armors group
			["spells"] = {
				28176, -- fel armor
				687, -- demon armor
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
		},
			[2] = { -- raid
			["spells"] = {
				85768, -- dark intent
		},
			["instance"] = true,
		},
	},
	PALADIN = {
		[1] = { --Seals group
			["spells"] = {
				20154, -- seal of righteousness
				20164, -- seal of justice
				20165, -- seal of insight
				31801, -- seal of truth				
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
		},
		[2] = { -- righteous fury group
			["spells"] = {
				25780, 
			},
			["role"] = "Tank",
			["instance"] = true,
			["reversecheck"] = true,
			["negate_reversecheck"] = 1, --Holy paladins use RF sometimes
		},
		[3] = { -- auras
			["spells"] = {
				465, --devo
				7294, --retr
				19746, -- conc
				19891, -- resist
			},
			["instance"] = true,
			["personal"] = true,
		},
	},
	SHAMAN = {
		[1] = { --shields group
			["spells"] = {
				52127, -- water shield
				324, -- lightning shield			
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
		},
		[2] = { --check weapons for enchants
			["weapon"] = true,
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
			["level"] = 10,
		},
	},
	WARRIOR = {
		[1] = { -- commanding Shout group
			["spells"] = {
				469, 
			},
			["negate_spells"] = {
				6307, -- Blood Pact
				90364, -- Qiraji Fortitude
				72590, -- Drums of fortitude
				21562, -- Fortitude				
			},
			["combat"] = true,
			["role"] = "Tank",
		},
		[2] = { -- battle Shout group
			["spells"] = {
				6673, 
			},
			["negate_spells"] = {
				8076, -- strength of earth
				57330, -- horn of Winter
				93435, -- roar of courage (hunter pet)						
			},
			["combat"] = true,
			["role"] = "Melee",
		},
	},
	DEATHKNIGHT = {
		[1] = { -- horn of Winter group
			["spells"] = {
				57330, 
			},
			["negate_spells"] = {
				8076, -- strength of earth totem
				6673, -- battle Shout
				93435, -- roar of courage (hunter pet)			
			},
			["combat"] = true,
		},
		[2] = { -- blood presence group
			["spells"] = {
				48263, 
			},
			["role"] = "Tank",
			["instance"] = true,	
			["reversecheck"] = true,
		},
	},
	ROGUE = { 
		[1] = { --weapons enchant group
			["weapon"] = true,
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
			["level"] = 10,
		},
	},
}
BuffReminderRaidBuffs = {
	Flask = {
		94160, --"Flask of Flowing Water"
		79469, --"Flask of Steelskin"
		79470, --"Flask of the Draconic Mind"
		79471, --"Flask of the Winds
		79472, --"Flask of Titanic Strength"
		79638, --"Flask of Enhancement-STR"
		79639, --"Flask of Enhancement-AGI"
		79640, --"Flask of Enhancement-INT"
		92679, --Flask of battle
	},
	BattleElixir = {
		--Scrolls
		89343, --Agility
		63308, --Armor 
		89347, --Int
		89342, --Spirit
		63306, --Stam
		89346, --Strength
		
		--Elixirs
		79481, --Hit
		79632, --Haste
		79477, --Crit
		79635, --Mastery
		79474, --Expertise
		79468, --Spirit
	},
	GuardianElixir = {
		79480, --Armor
		79631, --Resistance+90
	},
	Food = {
		87545, --90 STR
		87546, --90 AGI
		87547, --90 INT
		87548, --90 SPI
		87549, --90 MAST
		87550, --90 HIT
		87551, --90 CRIT
		87552, --90 HASTE
		87554, --90 DODGE
		87555, --90 PARRY
		87635, --90 EXP
		87556, --60 STR
		87557, --60 AGI
		87558, --60 INT
		87559, --60 SPI
		87560, --60 MAST
		87561, --60 HIT
		87562, --60 CRIT
		87563, --60 HASTE
		87564, --60 DODGE
		87634, --60 EXP
		87554, --Seafood Feast
	},
}
local tab = ReminderBuffs[myclass]
if not tab then return end

local function OnEvent(self, event, arg1, arg2)
	local group = tab[self.id]
	if not group.spells and not group.weapon then return end
	if not GetActiveTalentGroup() then return end
	if event == "UNIT_AURA" and arg1 ~= "player" then return end 
	if group.level and UnitLevel("player") < group.level then return end
	
	self.icon:SetTexture(nil)
	self:Hide()
	if group.negate_spells then
		for _, buff in pairs(group.negate_spells) do
			local name = GetSpellInfo(buff)
			if (name and UnitBuff("player", name)) then
				return
			end
		end
	end
	
	local hasOffhandWeapon = OffhandHasWeapon()
	local hasMainHandEnchant, _, _, hasOffHandEnchant, _, _ = GetWeaponEnchantInfo()
	if not group.weapon then
		for _, buff in pairs(group.spells) do
			local name = GetSpellInfo(buff)
			local usable, nomana = IsUsableSpell(name)
			if (usable or nomana) then
				self.icon:SetTexture(select(3, GetSpellInfo(buff)))
				break
			end			
		end
		
		if (not self.icon:GetTexture() and event == "PLAYER_LOGIN") then
			self:UnregisterAllEvents()
			self:RegisterEvent("LEARNED_SPELL_IN_TAB")
			return
		elseif (self.icon:GetTexture() and event == "LEARNED_SPELL_IN_TAB") then
			self:UnregisterAllEvents()
			self:RegisterEvent("UNIT_AURA")
			if group.combat and group.combat == true then
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
				self:RegisterEvent("PLAYER_REGEN_DISABLED")
			end
			
			if (group.instance and group.instance == true) or (group.pvp and group.pvp == true) then
				self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
			end
			
			if group.role and group.role == true then
				self:RegisterEvent("UNIT_INVENTORY_CHANGED")
			end
		end		
	else
		self:UnregisterAllEvents()
		self:RegisterEvent("UNIT_INVENTORY_CHANGED")
		
		if hasOffhandWeapon == nil then
			if hasMainHandEnchant == nil then
				self.icon:SetTexture(GetInventoryItemTexture("player", 16))
			end
		else
			if hasOffHandEnchant == nil then
				self.icon:SetTexture(GetInventoryItemTexture("player", 17))
			end
			
			if hasMainHandEnchant == nil then
				self.icon:SetTexture(GetInventoryItemTexture("player", 16))
			end
		end
		if group.combat and group.combat == true then
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
			self:RegisterEvent("PLAYER_REGEN_DISABLED")
		end
		
		if (group.instance and group.instance == true) or (group.pvp and group.pvp == true) then
			self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		end
		
		if group.role and group.role == true then
			self:RegisterEvent("UNIT_INVENTORY_CHANGED")
		end
	end
	
	local role = group.role
	local tree = group.tree
	local combat = group.combat
	local personal = group.personal
	local instance = group.instance
	local pvp = group.pvp	
	local reversecheck = group.reversecheck
	local negate_reversecheck = group.negate_reversecheck
	local canplaysound = false
	local rolepass = false
	local treepass = false
	local inInstance, instanceType = IsInInstance()
	
	if role ~= nil then
		if role == Role then
			rolepass = true
		else
			rolepass = false
		end
	else
		rolepass = true
	end
	
	if tree ~= nil then
		if tree == GetPrimaryTalentTree() then
			treepass = true
		else
			treepass = false	
		end
	else
		treepass = true
	end
	
	--Prevent user error
	if reversecheck ~= nil and (role == nil and tree == nil) then reversecheck = nil end
	
	
	
	if not group.weapon then
		if ((combat and UnitAffectingCombat("player")) or (instance and (instanceType == "party" or instanceType == "raid")) or (pvp and (instanceType == "arena" or instanceType == "pvp"))) and 
		treepass == true and rolepass == true and not (UnitInVehicle("player") and self.icon:GetTexture()) then
			for _, buff in pairs(group.spells) do
				local name = GetSpellInfo(buff)
				local _, _, icon, _, _, _, _, unitCaster, _, _, _ = UnitBuff("player", name)
				if personal and personal == true then
					if (name and icon and unitCaster == "player") then
						self:Hide()
						return
					end
				else
					if (name and icon) then
						self:Hide()
						return
					end
				end
			end
			self:Show()
			if canplaysound == true then PlaySoundFile(C["media"].warning) end		
		elseif ((combat and UnitAffectingCombat("player")) or (instance and (instanceType == "party" or instanceType == "raid"))) and 
		reversecheck == true and not (UnitInVehicle("player") and self.icon:GetTexture()) then
			if negate_reversecheck and negate_reversecheck == GetPrimaryTalentTree() then self:Hide() return end
			for _, buff in pairs(group.spells) do
				local name = GetSpellInfo(buff)
				local _, _, icon, _, _, _, _, unitCaster, _, _, _ = UnitBuff("player", name)
				if (name and icon and unitCaster == "player") then
					self:Show()
					
					return
				end			
			end			
		else
			self:Hide()
		end
	else
		if ((combat and UnitAffectingCombat("player")) or (instance and (instanceType == "party" or instanceType == "raid")) or (pvp and (instanceType == "arena" or instanceType == "pvp"))) and 
		treepass == true and rolepass == true and not (UnitInVehicle("player") and self.icon:GetTexture()) then
			
			if hasOffhandWeapon == nil then
				if hasMainHandEnchant == nil then
					self:Show()
					self.icon:SetTexture(GetInventoryItemTexture("player", 16))
					
					return
				end
			else			
				if hasMainHandEnchant == nil or hasOffHandEnchant == nil then	
					self:Show()
					if hasMainHandEnchant == nil then
						self.icon:SetTexture(GetInventoryItemTexture("player", 16))
					else
						self.icon:SetTexture(GetInventoryItemTexture("player", 17))
					end
					
					
					return
				end
			end
			self:Hide()
			return	
		else
			self:Hide()
			return
		end	
	end
end

for i=1, #tab do
	local frame = CreateFrame("Frame", "ReminderFrame"..i, UIParent)
	CreatePanel(frame, 40, 40, "CENTER", UIParent, "CENTER", 0, 200)
	frame:SetFrameLevel(1)
	frame.id = i
	frame.icon = frame:CreateTexture(nil, "OVERLAY")
	frame.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	frame.icon:SetPoint("CENTER")
	frame.icon:SetWidth(36)
	frame.icon:SetHeight(36)
	frame:Hide()
	CreateShadow(frame)
	frame:RegisterEvent("UNIT_AURA")
	frame:RegisterEvent("PLAYER_LOGIN")
	frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
	frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	frame:RegisterEvent("UNIT_ENTERING_VEHICLE")
	frame:RegisterEvent("UNIT_ENTERED_VEHICLE")
	frame:RegisterEvent("UNIT_EXITING_VEHICLE")
	frame:RegisterEvent("UNIT_EXITED_VEHICLE")
	frame:SetScript("OnEvent", OnEvent)
	frame:SetScript("OnUpdate", function(self, elapsed)
		if not self.icon:GetTexture() then
			self:Hide()
		end
	end)
	frame:SetScript("OnShow", function(self)
		if not self.icon:GetTexture() then
			self:Hide()
		end	
	end)
end