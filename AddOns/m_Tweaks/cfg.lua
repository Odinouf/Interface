local addon, ns = ...
local cfg = CreateFrame("Frame")

-- Configuration
cfg.AutoRollGreens = true					-- automatic 'greed' selection 
cfg.AutoAcceptDE = true					-- auctomatic disenchant confirmation for rare+ quality items
cfg.AutoRepair = true						-- auromatic repair at vendors
cfg.AutoDeclineDuel = true					-- automaticly decline duels
cfg.AutoAccceptInvite = true				-- accept invites from guild/friends
cfg.AutoInvite = false						-- automatic invite by whisper
	cfg.InviteWord = "invx"					-- pass phrase for pervious option
cfg.SellGreyJunk = true 					-- sell all the grey junk to the vendor
cfg.HideErrors = true						-- hide blizzard's default error frame; type /error to see last error
cfg.ScreenshotQuality = 10					-- set screenshots quality (1-10)
cfg.ShowSpellID = true						-- toggle spellID display in various tooltips
cfg.StyleDBM = true							-- special DeadlyBossMods stylization
cfg.StyleNugRunning = true					-- NugRunning style
cfg.EnableMountz = false					-- enable/disable universal mount macro function
cfg.MoveScoreFrameAndCaptureBar = true		-- reposition zone score frame and capture bars
	cfg.ScoreFramePosition = {"BOTTOM", "UIParent", "TOPLEFT", 100, -90}
	cfg.CaptureBarPosition = {"TOPLEFT", "UIParent", "TOPLEFT", 35, -75}
cfg.ExperienceBar = true					-- enable experience bar
	cfg.ExpHeight = 23						-- exp. bar height
	cfg.ExpWidth = 300						-- exp. bar width
	cfg.ExpAutoAdjust = true				-- automatically adjust exp. bar width for non-HD screen resolutions
	cfg.ExpClassColor = false				-- color exp. bar text into class colors
	cfg.ExpColor = {r=.9,g=.5,b=0}			-- default color for text values
	cfg.ExpPosition = {"BOTTOM", "UIParent", "TOP", 0, -19}
cfg.shoutCD = false								-- enable CD shout out module
	cfg.shoutCDlist = {							-- set CD shout out for certain spells
	{	id = 16190, 							-- spell id (mana tide totem)
		AnnounceChan = "SAY",					-- channel to announce the initial cast ("SAY","RAID","YELL","CHANNEL")
		WarnChan = "RAID",  					-- channel to send CD warning ("SAY","RAID","YELL","CHANNEL")
		WarnTime = 30,  						-- warning time in seconds before CD completion
		ChanIndex = 5							-- channel index, only needed if you set either AnnounceChan or WarnChan to "CHANNEL"
	},
	{	id = 98008,	AnnounceChan = "RAID",  	WarnChan = "RAID",  	WarnTime = 30,	ChanIndex = 5}, -- spirit link totem
	{	id = 86150,	AnnounceChan = "RAID",		WarnChan = "RAID",  	WarnTime = 30,	ChanIndex = 5}, -- guardian of ancient kings
	{	id = 47788,	AnnounceChan = "RAID",		WarnChan = "RAID",  	WarnTime = 30,	ChanIndex = 5}, -- guardian spirit
	{	id = 62618,	AnnounceChan = "RAID",		WarnChan = "RAID",  	WarnTime = 30,	ChanIndex = 5}, -- pw: barrier
	{	id = 33206,	AnnounceChan = "RAID",		WarnChan = "RAID",  	WarnTime = 30,	ChanIndex = 5}, -- pain suppression
}

if GetUnitName("player") == "Strigoy" or GetUnitName("player") == "Strig" then
	cfg.AutoAcceptDE = true
	cfg.shoutCDlist = {
		{	id = 16190,	AnnounceChan = "SAY",   	WarnChan = "CHANNEL",	WarnTime = 30,	ChanIndex = 5}, -- mana tide totem
		{	id = 98008,	AnnounceChan = "CHANNEL",  	WarnChan = "CHANNEL",  	WarnTime = 30,	ChanIndex = 5}, -- spirit link totem
		{	id = 86150,	AnnounceChan = "CHANNEL",	WarnChan = "CHANNEL",	WarnTime = 30,	ChanIndex = 5}, -- guardian of ancient kings
		{	id = 47788,	AnnounceChan = "CHANNEL",	WarnChan = "CHANNEL",	WarnTime = 30,	ChanIndex = 5}, -- guardian spirit
		{	id = 62618,	AnnounceChan = "CHANNEL",	WarnChan = "CHANNEL",	WarnTime = 30,	ChanIndex = 5}, -- pw: barrier
		{	id = 33206,	AnnounceChan = "CHANNEL",	WarnChan = "CHANNEL",	WarnTime = 30,	ChanIndex = 5}, -- pain suppression
	--	{	id = 73920,	AnnounceChan = "SAY",   	WarnChan = "SAY",   	WarnTime = 3,	ChanIndex = 5}, -- healing rain, debug
	}
end
--[[
if GetUnitName("player") == "Pyrä" then
	cfg.AutoAcceptDE = true
	cfg.shoutCDlist = {
		
	{	id = 6552,	AnnounceChan = "SAY",   	WarnChan = "SAY",   	WarnTime = 3,	ChanIndex = 5}, -- healing rain, debug
	}
end
--]]
-- Handover
ns.cfg = cfg