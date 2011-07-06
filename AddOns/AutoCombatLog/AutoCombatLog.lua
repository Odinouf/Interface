local DEBUG = false

local function debug(msg)
	if (DEBUG) then
		ChatFrame1:AddMessage("AutoCombatLog:Debug::"..msg)
	end
end

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
EventFrame:SetScript("OnEvent", function(self, event, ...)
	local name, type, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic = GetInstanceInfo()
	if (type == "raid") then
		debug("Entering raid instance")
		if (LoggingCombat()) then
			debug("CombatLogging is turned ON")
		else
			debug("CombatLogging is turned OFF, turning ON")
			LoggingCombat(1)
		end
	else
		debug("Leaving raid instance")
		if (LoggingCombat()) then
			debug("CombatLogging is turned ON, turning OFF")
			LoggingCombat(0)
		else
			debug("CombatLogging is turned OFF")
		end
	end
end)