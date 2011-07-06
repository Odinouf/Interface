Obituary = LibStub("AceAddon-3.0"):NewAddon("Obituary", "AceConsole-3.0", "AceEvent-3.0", "LibSink-2.0")

local bit_band = _G.bit.band
local bit_bor  = _G.bit.bor
local AFFILIATION_IN_GROUP = bit_bor(COMBATLOG_OBJECT_AFFILIATION_PARTY, COMBATLOG_OBJECT_AFFILIATION_RAID, COMBATLOG_OBJECT_AFFILIATION_MINE)
local damageTable = {};

-- default option settings
local defaults = {
    profile = {
        enable = true,
        debug = false,
        mobs = false,
        links = true,
        sinkOptions = {
			sink20OutputSink = "ChatFrame"
			}
    },
}

Obituary.options = {
    name = "Obituary",
    handler = Obituary,
    type = 'group',
    args = {
        enable = {
            type = 'toggle',
            name = 'Enable',
            desc = 'Enables/disables display of party/raid member deaths',
            set = 'SetEnable',
            get = 'GetEnable',
            width = 'half',
        },
        debug = {
            type = 'toggle',
            name = 'Debug',
            desc = 'Enables/disables Obituary debugging messages',
            set = 'SetDebug',
            get = 'GetDebug',
            hidden = true,
        },
        mobs = {
            type = 'toggle',
            name = 'Mobs',
            desc = 'Enables/disables display of mob deaths',
            set = 'SetMobs',
            get = 'GetMobs',
            width = 'half',
        },
        links = {
            type = 'toggle',
            name = 'Spell Links',
            desc = 'Enables/disables links to spells',
            set = 'SetLinks',
            get = 'GetLinks',
            width = 'half',
        },
    },
}

function Obituary:DebugPrint(message)
	if (self.db.profile.debug) then
		self:Print(message)
	end
end

function Obituary:OnInitialize()
    -- Called when the addon is loaded
    
	self.db = LibStub("AceDB-3.0"):New("ObituaryDB", defaults, "Default")
	
	self.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
    LibStub("AceConfig-3.0"):RegisterOptionsTable("Obituary", self.options, {"obituary", "obit"})
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Obituary", "Obituary")
	
	-- Add Options for LibSink-2.0
	self:SetSinkStorage(self.db.profile.sinkOptions)
	self.options.args.output = self:GetSinkAce3OptionsDataTable()

end

function Obituary:OnEnable()
	-- Called when the addon is enabled
	self:DebugPrint("Enabled.");
	
    Obituary:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function Obituary:OnDisable()
    -- Called when the addon is disabled
	self:DebugPrint("Disabled.");
end

function Obituary:COMBAT_LOG_EVENT_UNFILTERED(_, timestamp, subEvent, _, sourceGUID, sourceName, 
	sourceFlags, sourceRaidFlags, 
	destGUID, destName, destFlags, destRaidFlags, 
	...)

	if (not self.db.profile.enable) then
		return
	end
	
	if (bit_band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) == 0) then
		if (not self.db.profile.mobs) then
			if destName then
				self:DebugPrint("Ignoring event because "..destName.." is not a player character.");
			end
			return
		end
	else		
		if (bit_band(destFlags, AFFILIATION_IN_GROUP) == 0) then
			if destName then
				self:DebugPrint("Ignoring event because "..destName.." is not in my group.");
			end
			return
		end
	end

	-- Initialize values		  
	local amount = nil
	local spell = select(2, ...)
	local source = sourceName
	local crit = false
	local crush = false

	-- Extract the useful data	
	local prefix, suffix, special = strsplit("_", subEvent)
		
	if prefix == "SPELL" then
		if suffix == "DAMAGE" or special == "DAMAGE" then
			amount = select(4, ...)
			crit = select(10, ...)
			if self.db.profile.links then
				local spellId = select(1, ...)
				if spellId then
					--self:DebugPrint("Spell = "..GetSpellLink(spellId));
					spell = GetSpellLink(spellId)
				end
			end
		end
	elseif suffix == "DAMAGE" then
		if prefix == "SWING" then
			amount = select(1, ...)
			spell = "a swing"
			crit = select(7, ...)
			crush = select(9, ...)
		elseif prefix == "RANGE" then
			amount = select(4, ...)
			crit = select(10, ...)
		elseif prefix == "ENVIRONMENTAL" then
			amount = select(2, ...)
			spell = select(1, ...)
		end
	elseif prefix == "DAMAGE" and special ~= "MISSED" then
		amount = 0 - select(4, ...)
	elseif subEvent == "UNIT_DIED" then
		if UnitIsFeignDeath(destName) then
			self:DebugPrint("Ignoring reported death because "..destName.." is feigning.");
		else
			self:ReportDeath(destGUID);
		end
	end
	
	if amount then
		source = self:DecorateName(source, sourceFlags, sourceRaidFlags, sourceGUID)
		destName = self:DecorateName(destName, destFlags, destRaidFlags, destGUID)

		self:RecordDamage(destGUID, destName, amount, source, spell, crit, crush)
	end

end

function Obituary:GetColoredName(name, flags, guid)
	if (bit_band(flags, COMBATLOG_OBJECT_TYPE_PLAYER) == 0) then
		-- not a player; just use the reaction to colour
		if (bit_band(flags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0) then
			-- colour hostiles red
			return "|cffff0000"..name.."|r"
		elseif (bit_band(flags, COMBATLOG_OBJECT_REACTION_FRIENDLY) ~= 0) then
			-- colour friendlies green
			return "|cff00ff00"..name.."|r"
		end
		
		-- default to white for mobs
		return name
	else
		-- colour player names by class
		local class = self:GetClass(guid)
		local classColor = nil
		
		if class then
			classColor = RAID_CLASS_COLORS[class]
		else
			self:DebugPrint("Unknown class for "..name.." ("..guid..").");
		end
		
		if classColor then
			return format("|cff%02x%02x%02x%s|r", classColor.r*255, classColor.g*255, classColor.b*255, name)
		end
		
		-- default to grey for players
		return "|cff888888"..name.."|r"
	end
end


function Obituary:GetClass(guid)
    local locClass, engClass, locRace, engRace, gender = GetPlayerInfoByGUID(guid)
	return engClass
end


function Obituary:GetRaidMarkPrefix(unitFlags)
	local raidTarget = bit_band(unitFlags, COMBATLOG_OBJECT_RAIDTARGET_MASK);
	if ( raidTarget == 0 ) then
		return "";
	end
	local i = 1
	if ( raidTarget == COMBATLOG_OBJECT_RAIDTARGET1 ) then
		i=1
	elseif ( raidTarget == COMBATLOG_OBJECT_RAIDTARGET2 ) then
		i=2
	elseif ( raidTarget == COMBATLOG_OBJECT_RAIDTARGET3 ) then
		i=3
	elseif ( raidTarget == COMBATLOG_OBJECT_RAIDTARGET4 ) then
		i=4
	elseif ( raidTarget == COMBATLOG_OBJECT_RAIDTARGET5 ) then
		i=5
	elseif ( raidTarget == COMBATLOG_OBJECT_RAIDTARGET6 ) then
		i=6
	elseif ( raidTarget == COMBATLOG_OBJECT_RAIDTARGET7 ) then
		i=7
	elseif ( raidTarget == COMBATLOG_OBJECT_RAIDTARGET8 ) then
		i=8
	end
	return "{rt"..i.."}";
end

function Obituary:DecorateName(name, flags, raidFlags, guid)
	if not name then
		return nil
	end
	local icon = self:GetRaidMarkPrefix(raidFlags)
	return icon..self:GetColoredName(name, flags, guid)
end

function Obituary:RecordDamage(destGUID, destName, amount, sourceName, spellName, crit, crush)	
	self:DebugPrint(format("Recording %d damage to %s (%s) by %s/%s.", amount, destName, destGUID, sourceName or "unknown source", spellName or "unknown spell"));
	damageTable[destGUID] = {name=destName, amount=amount, sourceName=sourceName, spellName=spellName, crit=crit, crush=crush};
end

function Obituary:ReportDeath(destGUID)
	if(not damageTable[destGUID]) then
		return;
	end

	local lastDamage = damageTable[destGUID];
	local damageType = "";
	
	if lastDamage.crit then
		damageType = damageType.." critical";
	end
	if lastDamage.crush then
		damageType = damageType.." crushing";
	end

	local output = lastDamage.name.." was killed"
	
	if lastDamage.spellName then
		output = output.." by "..lastDamage.spellName
	end
	
	if lastDamage.sourceName then
		output = output.." from "..lastDamage.sourceName
	end
	
	-- print to the configured output
	self:Pour( format("%s (%d%s).", output, lastDamage.amount, damageType), 1.0, 1.0, 1.0)
	
	table.remove(damageTable, destGUID);
end

function Obituary:SetMobs(info, val)
	self.db.profile.mobs = val
	
	if (self.db.profile.mobs) then
		self:Print("Display of mob deaths is now enabled.");
	else
		self:Print("Display of mob deaths is now disabled.");
	end
end

function Obituary:GetMobs(info)
	return self.db.profile.mobs
end

function Obituary:SetLinks(info, val)
	self.db.profile.links = val
	
	if (self.db.profile.links) then
		self:Print("Display of spell links is now enabled.");
	else
		self:Print("Display of spell links is now disabled.");
	end
end

function Obituary:GetLinks(info)
	return self.db.profile.links
end

function Obituary:SetDebug(info, val)
	self.db.profile.debug = val
	
	if (self.db.profile.debug) then
		self:Print("Debugging messages enabled.");
	else
		self:Print("Debugging messages disabled.");
	end
end

function Obituary:GetDebug(info)
	return self.db.profile.debug
end

function Obituary:SetEnable(info, val)
	self.db.profile.enable = val
	
	if (self.db.profile.enable) then
		self:Print("Display of party/raid member deaths is now enabled.");
	else
		self:Print("Display of party/raid member deaths is now disabled.");
	end
end

function Obituary:GetEnable(info)
	return self.db.profile.enable
end