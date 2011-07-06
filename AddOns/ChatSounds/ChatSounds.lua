ChatSounds_Version = "0.4.1 (40200)"
ChatSounds_Player  = "player"
ChatSounds_Config  = ChatSounds_Config or {}

local ChatSounds_label = "|cffFFCC00ChatSounds|r";

local function ChatSounds_Slasher(cmd)
	if not cmd or cmd == "" then
		ChatSoundsOptionsFrame_Show(ChatSoundsOptionsFrame)
		DEFAULT_CHAT_FRAME:AddMessage(ChatSounds_label..": '/chatsounds ?' or '/chatsounds !help' for other commands.");
	elseif strlower(cmd) == "!help" or cmd == "?" then
		DEFAULT_CHAT_FRAME:AddMessage(ChatSounds_label.." ".. ChatSounds_Version);
		DEFAULT_CHAT_FRAME:AddMessage("'/chatsounds customchannel' blacklists/un-blacklists a custom channel from playing sounds");
		DEFAULT_CHAT_FRAME:AddMessage("    Useful if you have some addon joining a custom channel and spamming messages.");
		DEFAULT_CHAT_FRAME:AddMessage("'/chatsounds !list' lists the custom channels you have blacklisted if any.");
	elseif strlower(cmd) == "!list" then
		if next(ChatSounds_Config[ChatSounds_Player].Blacklist) then
			DEFAULT_CHAT_FRAME:AddMessage("ChatSounds Blacklist:")
			for k,v in pairs(ChatSounds_Config[ChatSounds_Player].Blacklist) do
				DEFAULT_CHAT_FRAME:AddMessage(k)
			end
		else
			DEFAULT_CHAT_FRAME:AddMessage(ChatSounds_label..": no blacklisted channels")
		end
	else
		cmd = strlower(cmd)
		if ChatSounds_Config[ChatSounds_Player].Blacklist[cmd] then
			ChatSounds_Config[ChatSounds_Player].Blacklist[cmd] = nil
			DEFAULT_CHAT_FRAME:AddMessage(ChatSounds_label..": ".. cmd .. " removed from Blacklist.");
		else
			ChatSounds_Config[ChatSounds_Player].Blacklist[cmd] = true
			DEFAULT_CHAT_FRAME:AddMessage(ChatSounds_label..": ".. cmd .. " added to Blacklist.");
		end
	end
end

function ChatSounds_OnLoad(self)

	-- Register Variable Loading and Chat Events.
	self:RegisterEvent("ADDON_LOADED")
-- 	self:RegisterEvent("CHAT_MSG_WHISPER")
-- 	self:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
-- 	self:RegisterEvent("CHAT_MSG_BN_WHISPER")
-- 	self:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM")
	self:RegisterEvent("CHAT_MSG_GUILD")
	self:RegisterEvent("CHAT_MSG_OFFICER")
	self:RegisterEvent("CHAT_MSG_PARTY")
	self:RegisterEvent("CHAT_MSG_PARTY_LEADER")
	self:RegisterEvent("CHAT_MSG_RAID")
	self:RegisterEvent("CHAT_MSG_RAID_LEADER")
	self:RegisterEvent("CHAT_MSG_BATTLEGROUND")
	self:RegisterEvent("CHAT_MSG_BATTLEGROUND_LEADER")
	self:RegisterEvent("CHAT_MSG_CHANNEL")
	
	-- Register Slash Command.
	SLASH_CHATSOUNDS1 = "/chatsounds"
	SlashCmdList["CHATSOUNDS"] = ChatSounds_Slasher

end

function ChatSounds_InitConfig ( )

	ChatSounds_Player = UnitName("player") .. " of " .. GetCVar("realmName")

	if (not ChatSounds_Config) then
		ChatSounds_Config = {}
	end
	if (not ChatSounds_Config[ChatSounds_Player]) then
		ChatSounds_Config[ChatSounds_Player] = {}
		ChatSounds_Config[ChatSounds_Player].ForceWhispers          = true
	end
	if (not ChatSounds_Config[ChatSounds_Player].Blacklist) then
		ChatSounds_Config[ChatSounds_Player].Blacklist = {}
	end
	if (not ChatSounds_Config[ChatSounds_Player].Incoming) then
		ChatSounds_Config[ChatSounds_Player].Incoming               				= {}
		ChatSounds_Config[ChatSounds_Player].Incoming["GUILD"]      				= "Kachink"
		ChatSounds_Config[ChatSounds_Player].Incoming["OFFICER"]    				= "Link"
		ChatSounds_Config[ChatSounds_Player].Incoming["PARTY"]      				= "Text1"
		ChatSounds_Config[ChatSounds_Player].Incoming["PARTY_LEADER"]    		= "Choo"
		ChatSounds_Config[ChatSounds_Player].Incoming["RAID"]       				= "Text2"
		ChatSounds_Config[ChatSounds_Player].Incoming["RAID_LEADER"]    		= "Choo"
		ChatSounds_Config[ChatSounds_Player].Incoming["BATTLEGROUND"]    		= "switchy"
		ChatSounds_Config[ChatSounds_Player].Incoming["BATTLEGROUND_LEADER"]= "doublehit"
		ChatSounds_Config[ChatSounds_Player].Incoming["WHISPER"]    				= "Heart"
		ChatSounds_Config[ChatSounds_Player].Incoming["BNWHISPER"]    			= "Heart"
		ChatSounds_Config[ChatSounds_Player].Incoming["GMWHISPER"] 					= "gasp"
		ChatSounds_Config[ChatSounds_Player].Incoming["CHANNEL"]						= "himetal"
	end
	if (not ChatSounds_Config[ChatSounds_Player].Outgoing) then
		ChatSounds_Config[ChatSounds_Player].Outgoing               				= {}
		ChatSounds_Config[ChatSounds_Player].Outgoing["GUILD"]      				= "pop1"
		ChatSounds_Config[ChatSounds_Player].Outgoing["OFFICER"]    				= "pop2"
		ChatSounds_Config[ChatSounds_Player].Outgoing["PARTY"]      				= "pop1"
		ChatSounds_Config[ChatSounds_Player].Outgoing["PARTY_LEADER"]    		= "pop2"
		ChatSounds_Config[ChatSounds_Player].Outgoing["RAID"]       				= "pop1"
		ChatSounds_Config[ChatSounds_Player].Outgoing["RAID_LEADER"]    		= "pop2"
		ChatSounds_Config[ChatSounds_Player].Outgoing["BATTLEGROUND"]    		= "pop1"
		ChatSounds_Config[ChatSounds_Player].Outgoing["BATTLEGROUND_LEADER"]= "pop2"
		ChatSounds_Config[ChatSounds_Player].Outgoing["WHISPER"]    				= "TellMessage"
		ChatSounds_Config[ChatSounds_Player].Outgoing["BNWHISPER"]    			= "TellMessage"
		ChatSounds_Config[ChatSounds_Player].Outgoing["CHANNEL"]						= "himetal"
	end
end

function ChatSounds_OnEvent(self, event, ...)
	
	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 = ...;
	
	if (event == "ADDON_LOADED" and arg1 == "ChatSounds" ) then

		ChatSounds_InitConfig ( );
 		hooksecurefunc("ChatFrame_OnEvent", ChatSounds_ChatFrame_OnEvent);
		-- ChatSounds are now loaded!
		DEFAULT_CHAT_FRAME:AddMessage(ChatSounds_label.." ".. ChatSounds_Version .. " are loaded.");
		self:UnregisterEvent("ADDON_LOADED");

	elseif (string.sub (event, 1, 8) == "CHAT_MSG") then
		local msgtype = string.sub (event, 10)
		if msgtype == "CHANNEL" then -- exclude afk/dnd, global channel and blacklisted custom channels messages.
			if arg6 == "AFK" or arg6 == "DND" or arg7 > 0 then return end
			if arg9 and ChatSounds_Config[ChatSounds_Player].Blacklist[strlower(arg9)] then return end
		end
		if (arg2 == UnitName ("player")) then
			ChatSounds_PlaySound (ChatSounds_Config[ChatSounds_Player].Outgoing[msgtype]);
		else
			ChatSounds_PlaySound (ChatSounds_Config[ChatSounds_Player].Incoming[msgtype]);
		end

	end
end

function ChatSounds_PlaySound (sound)
	if (not sound or not ChatSounds_Sound[sound]) then return end
	local snd = tostring(ChatSounds_Sound[sound].value)
	if snd:find("%\\") then
		PlaySoundFile(snd, "Master")
	else
		PlaySound(snd, "Master")
	end
end


function ChatSounds_ChatFrame_OnEvent (self, event, ...)
	
	local arg1, arg2 = ...;
	if (event == "CHAT_MSG_WHISPER") then
		if not ((string.sub(arg1, 1, 4) == "LVPN") or (string.sub(arg1, 1, 4) == "LVBM")) then --- Deadly Boss Mod filter
			ChatEdit_SetLastTellTarget(arg2)
	
			if (self.tellTimer and (GetTime ( ) > self.tellTimer)) or 
			   (ChatSounds_Config[ChatSounds_Player].ForceWhispers) then
			  if arg6 == "GM" then 
			  	ChatSounds_PlaySound (ChatSounds_Config[ChatSounds_Player].Incoming["GMWHISPER"])
			  else
					ChatSounds_PlaySound (ChatSounds_Config[ChatSounds_Player].Incoming["WHISPER"])
				end
			end
	
			self.tellTimer = GetTime ( ) + CHAT_TELL_ALERT_TIME
		end
	elseif (event == "CHAT_MSG_WHISPER_INFORM") then
		if not ((string.sub(arg1, 1, 4) == "LVPN") or (string.sub(arg1, 1, 4) == "LVBM")) then --- Deadly Boss Mod filter
			ChatEdit_SetLastTellTarget(arg2)
			ChatSounds_PlaySound (ChatSounds_Config[ChatSounds_Player].Outgoing["WHISPER"])
		end
	elseif (event == "CHAT_MSG_BN_WHISPER") then
		ChatEdit_SetLastTellTarget(arg2)
		if (self.tellTimer and (GetTime ( ) > self.tellTimer)) or 
		   (ChatSounds_Config[ChatSounds_Player].ForceWhispers) then
		   ChatSounds_PlaySound (ChatSounds_Config[ChatSounds_Player].Incoming["BNWHISPER"])
		end

		self.tellTimer = GetTime ( ) + CHAT_TELL_ALERT_TIME
	elseif (event == "CHAT_MSG_BN_WHISPER_INFORM") then
		ChatEdit_SetLastTellTarget(arg2)
		ChatSounds_PlaySound (ChatSounds_Config[ChatSounds_Player].Outgoing["BNWHISPER"])
	end

end