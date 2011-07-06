-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
local _G = getfenv(0)

local math = _G.math
local table = _G.table

local pairs = _G.pairs
local setmetatable = _G.setmetatable
local tonumber = _G.tonumber
local tostring = _G.tostring
local unpack = _G.unpack

-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local LibStub = _G.LibStub

local Archy = LibStub("AceAddon-3.0"):NewAddon("Archy", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0", "LibSink-2.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Archy", false)

local ldb = LibStub("LibDataBroker-1.1"):NewDataObject("Archy", {
	type = "data source",
	icon = "Interface\\Icons\\trade_archaeology",
	iconCoords = { 0.075, 0.925, 0.075, 0.925 },
	text = "Archy",
})
local LDBI = LibStub("LibDBIcon-1.0")
local astrolabe = _G.DongleStub("Astrolabe-1.0")
local qtip = LibStub("LibQTip-1.0")
local lsm = LibStub("LibSharedMedia-3.0")

if not lsm then
	_G.LoadAddOn("LibSharedMedia-3.0")
	lsm = LibStub("LibSharedMedia-3.0", true)
end

local DEFAULT_LSM_FONT = "Arial Narrow"
if lsm then
	if not lsm:IsValid("font", DEFAULT_LSM_FONT) then
		DEFAULT_LSM_FONT = lsm:GetDefault("font")
	end
end

_G["Archy"] = Archy
Archy.version = _G.GetAddOnMetadata("Archy", "Version")

-----------------------------------------------------------------------
-- Constants
-----------------------------------------------------------------------
local MAX_ARCHAEOLOGY_RANK = 525
local SITES_PER_CONTINENT = 4
local SURVEY_SPELL_ID = 80451

local DIG_SITES = private.dig_sites

-- Populated later.
local ARTIFACT_NAME_TO_RACE_ID_MAP = {}

-----------------------------------------------------------------------
-- Variables
-----------------------------------------------------------------------
local db
local rank, maxRank
local confirmArgs
local raceDataLoaded = false
local archRelatedBagUpdate = false
local keystoneLootRaceID
local playerContinent
local siteStats
local blacklisted_sites
local zoneData, raceData, artifacts, digsites = {}, {}, {}, {}
local tomtomPoint, tomtomActive, tomtomExists, tomtomFrame, tomtomSite
local distanceIndicatorActive = false

local nearestSite
local lastSite = {}

local playerPosition = {
	map = 0,
	level = 0,
	x = 0,
	y = 0
}

local survey_location = {
	map = 0,
	level = 0,
	x = 0,
	y = 0
}

local artifactSolved = {
	raceId = 0,
	name = ""
}

local continentMapToID = {}
local mapFileToID = {}
local mapIDToZone = {}
local mapIDToZoneName = {}
local zoneIDToName = {}
local raceNameToID = {}
local keystoneIDToRaceID = {}
local minimapSize = {}

local Arrow_OnUpdate, POI_OnEnter, POI_OnLeave, GetArchaeologyRank, SolveRaceArtifact
local ClearTomTomPoint, UpdateTomTomPoint, RefreshTomTom
local RefreshBlobInfo, MinimapBlobSetPositionAndSize, UpdateSiteBlobs
local UpdateMinimapEdges, UpdateMinimapPOIs
local AnnounceNearestSite, ResetPositions, UpdateRaceArtifact, ToggleDistanceIndicator
local inCombat = false
local TrapWorldMouse

local digsiteFrame = {}
local distanceIndicatorFrame = {}
local racesFrame = {}

--[[ Archy variables ]] --
Archy.NearestSite = nearestSite
Archy.PlayerPosition = playerPosition
Archy.RaceData = raceData
Archy.ZoneData = zoneData
Archy.CurrentSites = digsites
Archy.CurrentArtifacts = artifacts


--[[ Default profile values ]] --
local defaults = {
	profile = {
		general = {
			enabled = true,
			show = true,
			stealthMode = false,
			icon = { hide = false },
			locked = false,
			confirmSolve = true,
			showSkillBar = true,
			sinkOptions = {},
			easyCast = false,
			autoLoot = true,
			theme = "Graphical",
		},
		artifact = {
			show = true,
			position = { "TOPRIGHT", "TOPRIGHT", -200, -425 },
			anchor = "TOPRIGHT",
			positionX = 100,
			positionY = -300,
			scale = 0.75,
			alpha = 1,
			filter = true,
			announce = true,
			keystoneAnnounce = true,
			ping = true,
			keystonePing = true,
			blacklist = {},
			autofill = {},
			style = "Compact",
			borderAlpha = 1,
			bgAlpha = 0.5,
			font = { name = "Friz Quadrata TT", size = 14, shadow = true, outline = "", color = { r = 1, g = 1, b = 1, a = 1 } },
			fragmentFont = { name = "Friz Quadrata TT", size = 14, shadow = true, outline = "", color = { r = 1, g = 1, b = 1, a = 1 } },
			keystoneFont = { name = "Friz Quadrata TT", size = 12, shadow = true, outline = "", color = { r = 1, g = 1, b = 1, a = 1 } },
			fragmentBarColors = {
				["Normal"] = { r = 1, g = 0.5, b = 0 },
				["Solvable"] = { r = 0, g = 1, b = 0 },
				["Rare"] = { r = 0, g = 0.4, b = 0.8 },
				["AttachToSolve"] = { r = 1, g = 1, b = 0 },
				["FirstTime"] = { r = 1, g = 1, b = 1 },
			},
			fragmentBarTexture = "Blizzard Parchment",
			borderTexture = "Blizzard Dialog Gold",
			backgroundTexture = "Blizzard Parchment",
		},
		digsite = {
			show = true,
			position = { "TOPRIGHT", "TOPRIGHT", -200, -200 },
			anchor = "TOPRIGHT",
			positionX = 400,
			positionY = -300,
			scale = 0.75,
			alpha = 1,
			style = "Extended",
			sortByDistance = true,
			announceNearest = true,
			distanceIndicator = {
				enabled = true,
				green = 40,
				yellow = 80,
				position = { "CENTER", "CENTER", 0, 0 },
				anchor = "TOPLEFT",
				undocked = false,
				showSurveyButton = true,
				font = { name = "Friz Quadrata TT", size = 16, shadow = false, outline = "OUTLINE", color = { r = 1, g = 1, b = 1, a = 1 } },
			},
			filterLDB = false,
			borderAlpha = 1,
			bgAlpha = 0.5,
			font = { name = "Friz Quadrata TT", size = 18, shadow = true, outline = "", color = { r = 1, g = 1, b = 1, a = 1 } },
			zoneFont = { name = "Friz Quadrata TT", size = 14, shadow = true, outline = "", color = { r = 1, g = 0.82, b = 0, a = 1 } },
			minimal = {
				showDistance = false,
				showZone = false,
				showDigCounter = true,
			},
			borderTexture = "Blizzard Dialog Gold",
			backgroundTexture = "Blizzard Parchment",
		},
		minimap = {
			show = true,
			nearest = true,
			fragmentNodes = true,
			fragmentIcon = "CyanDot",
			fragmentColorBySurveyDistance = true,
			blob = false,
			zoneBlob = false,
			blobAlpha = 0.25,
			blobDistance = 400,
			useBlobDistance = true,
		},
		tomtom = {
			enabled = true,
			distance = 125,
			ping = true,
		},
	},
}

--[[ Keybinds ]]
BINDING_HEADER_ARCHY = "Archy"
BINDING_NAME_OPTIONS = L["BINDING_NAME_OPTIONS"]
BINDING_NAME_TOGGLE = L["BINDING_NAME_TOGGLE"]
BINDING_NAME_SOLVE = L["BINDING_NAME_SOLVE"]
BINDING_NAME_SOLVE_WITH_KEYSTONES = L["BINDING_NAME_SOLVESTONE"]
BINDING_NAME_ARTIFACTS = L["BINDING_NAME_ARTIFACTS"]
BINDING_NAME_DIGSITES = L["BINDING_NAME_DIGSITES"]

--[[ Config Options ]] --
local fragmentIconValues = {
	["CyanDot"] = L["Light Blue Dot"],
	["Cross"] = L["Cross"],
}
local frameAnchorOptions = {
	["TOPLEFT"] = L["Top Left"],
	["TOPRIGHT"] = L["Top Right"],
	["BOTTOMRIGHT"] = L["Bottom Right"],
	["BOTTOMLEFT"] = L["Bottom Left"],
}
local outlines = {
	[""] = _G.NONE,
	["OUTLINE"] = L["Outline"],
	["THICKOUTLINE"] = L["Thick Outline"],
}
local archyThemes = {
	["Graphical"] = L["Graphical"],
	["Minimal"] = L["Minimal"],
}

local generalOptions = {
	type = "group",
	order = 1,
	name = _G.GENERAL_LABEL,
	desc = L["General Options"],
	args = {
		desc = {
			order = 0,
			type = "description",
			name = "Archy",
		},
		show = {
			order = 1,
			name = L["Show Archy"],
			desc = L["Toggle the display of Archy"],
			type = "toggle",
			get = function()
				return db.general.show
			end,
			set = function(_, value)
				db.general.show = value
				Archy:ConfigUpdated()
			end,
		},
		reset = {
			order = 2,
			name = L["Reset Positions"],
			desc = L["Reset the window positions to defaults"],
			type = "execute",
			func = function()
				ResetPositions()
			end,
		},
		lock = {
			order = 3,
			name = L["Lock Positions"],
			desc = L["Locks the windows so they cannot be repositioned by accident"],
			type = "toggle",
			get = function()
				return db.general.locked
			end,
			set = function(_, value)
				db.general.locked = value
				Archy:ConfigUpdated()
			end,
			width = "double"
		},
		icon = {
			order = 4,
			name = L["Hide Minimap Button"],
			desc = L["Toggles the display of the Minimap Icon"],
			type = "toggle",
			get = function()
				return db.general.icon.hide
			end,
			set = function(k, v)
				db.general.icon.hide = v
				if db.general.icon.hide then
					LDBI:Hide("Archy")
				else
					LDBI:Show("Archy")
				end
			end,
			width = "double"
		},
		archyTheme = {
			order = 5,
			type = "select",
			name = L["Style"],
			desc = L["The style of display for Archy.  This will reload your UI after selecting"],
			get = function() return db.general.theme end,
			set = function(_, value)
				db.general.theme = value
				_G.ReloadUI()
			end,
			values = archyThemes,
		},
		easyCast = {
			order = 6,
			name = L["Enable EasyCast"],
			desc = L["Double right-click on the screen to cast Survey.  This is experimental and may interfere with other addons with similar functionality when enabled."],
			type = "toggle",
			get = function() return db.general.easyCast end,
			set = function(_, value)
				db.general.easyCast = value
				Archy:ConfigUpdated()
			end,
			width = "full",
		},
		autoLoot = {
			order = 7,
			name = L["AutoLoot Fragments and Key Stones"],
			desc = L["Enable the addon to auto-loot fragments and key stones for you."],
			type = "toggle",
			get = function() return db.general.autoLoot end,
			set = function(_, value)
				db.general.autoLoot = value
				Archy:ConfigUpdated()
			end,
			width = "full",
		},
	},
}

local artifactOptions = {
	order = 2,
	type = "group",
	childGroups = "tab",
	name = L["Artifacts"],
	desc = L["Artifact Options"],
	args = {
		options = {
			name = _G.GENERAL_LABEL,
			order = 0,
			type = "group",
			args = {
				desc = {
					order = 0,
					type = "description",
					name = L["Control various aspects of the Artifact options"],
				},
				show = {
					order = 1,
					type = "toggle",
					name = _G.SHOW,
					desc = L["Toggles the display of the Artifacts list"],
					get = function() return db.artifact.show end,
					set = function(_, value)
						db.artifact.show = value
						Archy:ConfigUpdated('artifact')
					end,
				},
				filter = {
					order = 2,
					type = "toggle",
					name = L["Filter by Continent"],
					desc = L["Filter the Artifact list by races on the continent"],
					get = function() return db.artifact.filter end,
					set = function(_, value)
						db.artifact.filter = value
						Archy:ConfigUpdated('artifact')
					end,
					disabled = function() return not db.artifact.show end,
				},
				announce = {
					order = 3,
					type = "toggle",
					name = L["Announce when solvable"],
					desc = L["Announce in the chat window when an artifact can be solved with fragments"],
					get = function() return db.artifact.announce end,
					set = function(_, value)
						db.artifact.announce = value
						Archy:ConfigUpdated('artifact')
					end,
				},
				keystoneAnnounce = {
					order = 4,
					type = "toggle",
					name = L["Include key stones"],
					desc = L["Announce in the chat window when an artifact can be solved with fragments and key stones"],
					get = function() return db.artifact.keystoneAnnounce end,
					set = function(_, value)
						db.artifact.keystoneAnnounce = value
						Archy:ConfigUpdated('artifact')
					end,
					disabled = function() return not db.artifact.announce end,
				},
				ping = {
					order = 5,
					type = "toggle",
					name = L["Play sound when solvable"],
					desc = L["Play a sound when an artifact can be solved with fragments"],
					get = function() return db.artifact.ping end,
					set = function(_, value)
						db.artifact.ping = value
						Archy:ConfigUpdated('artifact')
					end,
				},
				keystonePing = {
					order = 6,
					type = "toggle",
					name = L["Include key stones"],
					desc = L["Play a sound when an artifact can be solved with fragments and key stones"],
					get = function() return db.artifact.keystonePing end,
					set = function(_, value)
						db.artifact.keystonePing = value
						Archy:ConfigUpdated('artifact')
					end,
					disabled = function() return not db.artifact.ping end,
				},
				confirmSolve = {
					order = 6.5,
					type = "toggle",
					name = L["Confirm solves near skill cap"],
					desc = L["Ask for confirmation when your skill nears the cap.  When enabled, no confirmation is needed for Illustrious Archaeologists."],
					get = function() return db.general.confirmSolve end,
					set = function(_, value)
						db.general.confirmSolve = value
						Archy:ConfigUpdated()
					end,
					width = "full",
				},
				showSkillBar = {
					order = 7,
					name = L["Show Archaeology Skill"],
					desc = L["Show your Archaeology skill on the Artifacts list header"],
					type = "toggle",
					get = function() return db.general.showSkillBar end,
					set = function(_, value)
						db.general.showSkillBar = value
						Archy:ConfigUpdated()
					end,
					width = "double",
				},
			},
		},
		blacklist = {
			order = 1,
			type = "group",
			name = L["Blacklist"],
			args = {
				desc = {
					order = 0,
					type = "description",
					name = L["Allows you to blacklist races from being used by Archy"],
				},
				races = {
					order = 1,
					type = "multiselect",
					tristate = false,
					name = _G.RACES,
					desc = L["Select races to blacklist"],
					values = function()
						local races = {}
						for rid, race in pairs(raceData) do
							races[rid] = race.name
						end
						return races
					end,
					get = function(info, key) return db.artifact.blacklist[key] end,
					set = function(info, key, value)
						db.artifact.blacklist[key] = value
						Archy:ConfigUpdated('artifact')
					end,
					width = "full",
				},
			},
		},
		autofill = {
			order = 2,
			type = "group",
			name = L["AutoFill Key Stones"],
			args = {
				desc = {
					order = 0,
					type = "description",
					name = L["Allows Archy to autofill key stones as you receive them for you on the races you specify"],
				},
				races = {
					order = 1,
					type = "multiselect",
					tristate = false,
					name = _G.RACES,
					desc = L["Select races to autofill"],
					values = function()
						local races = {}
						for rid, race in pairs(raceData) do
							races[rid] = race.name
						end
						return races
					end,
					get = function(info, key) return db.artifact.autofill[key] end,
					set = function(info, key, value)
						db.artifact.autofill[key] = value
						Archy:ConfigUpdated('artifact', 'autofill')
					end,
					width = "full",
				},
			},
		},
		frameOptions = {
			order = 4,
			type = "group",
			name = L["Frame Options"],
			--            guiInline = true,
			args = {
				scale = {
					order = 7,
					type = "range",
					name = L["Size"],
					desc = L["Set how large the Artifacts list is"],
					min = 0.25,
					max = 4,
					step = 0.01,
					bigStep = 0.05,
					get = function() return db.artifact.scale end,
					set = function(_, value)
						db.artifact.scale = value
						Archy:ConfigUpdated('artifact')
					end,
				},
				alpha = {
					order = 8,
					type = "range",
					name = _G.OPACITY,
					desc = L["Set how transparent or opaque the Artifacts list is"],
					min = 0,
					max = 1,
					step = 0.01,
					bigStep = 0.05,
					get = function() return db.artifact.alpha end,
					set = function(_, value)
						db.artifact.alpha = value
						Archy:ConfigUpdated('artifact')
					end,
				},
				anchor = {
					order = 9,
					type = "select",
					name = L["Anchor"],
					desc = L["The corner of the Artifacts list that the frame will grow from."],
					get = function() return db.artifact.anchor end,
					set = function(_, value)
						db.artifact.anchor = value
						Archy:SaveFramePosition(racesFrame)
					end,
					values = frameAnchorOptions,
				},
				space = {
					order = 12,
					type = "description",
					name = "",
				},
				borderAlpha = {
					order = 13,
					type = "range",
					name = L["Border Opacity"],
					desc = L["Set how transparent or opaque the border for the Artifacts list is"],
					min = 0,
					max = 1,
					step = 0.01,
					bigStep = 0.05,
					get = function() return db.artifact.borderAlpha end,
					set = function(_, value)
						db.artifact.borderAlpha = value
						Archy:ConfigUpdated('artifact')
					end,
				},
				bgAlpha = {
					order = 14,
					type = "range",
					name = L["Background Opacity"],
					desc = L["Set how transparent or opaque the background for the Artifacts list is"],
					min = 0,
					max = 1,
					step = 0.01,
					bigStep = 0.05,
					get = function() return db.artifact.bgAlpha end,
					set = function(_, value)
						db.artifact.bgAlpha = value
						Archy:ConfigUpdated('artifact')
					end,
				},
				borderTexture = {
					order = 13.5,
					type = "select",
					name = L["Border Texture"],
					desc = L["Set the texture used by the frame border"],
					dialogControl = "LSM30_Border",
					values = lsm:HashTable(lsm.MediaType.BORDER),
					get = function() return db.artifact.borderTexture end,
					set = function(_, value)
						db.artifact.borderTexture = value
						Archy:ConfigUpdated('artifact')
					end,
				},
				backgroundTexture = {
					order = 14.5,
					type = "select",
					name = L["Background Texture"],
					desc = L["Set the texture used by the frame background"],
					dialogControl = "LSM30_Border",
					values = lsm:HashTable(lsm.MediaType.BACKGROUND),
					get = function() return db.artifact.backgroundTexture end,
					set = function(_, value)
						db.artifact.backgroundTexture = value
						Archy:ConfigUpdated('artifact')
					end,
				},
				fragmentBarTexture = {
					order = 20,
					type = "select",
					name = L["Progress Bar Texture"],
					desc = L["Set the texture used by the progress bars"],
					dialogControl = "LSM30_Statusbar",
					values = lsm:HashTable(lsm.MediaType.STATUSBAR),
					get = function() return db.artifact.fragmentBarTexture end,
					set = function(_, value)
						db.artifact.fragmentBarTexture = value
						Archy:ConfigUpdated('artifact')
					end,
				},
			},
		},
		fontOptions = {
			name = L["Font Options"],
			order = 5,
			type = "group",
			args = {
				mainFontOptions = {
					order = 1,
					type = "group",
					name = L["Main Font Options"],
					guiInline = true,
					args = {
						fontName = {
							order = 1,
							type = "select",
							dialogControl = 'LSM30_Font',
							name = L["Font"],
							desc = L["The font that will be used"],
							values = _G.AceGUIWidgetLSMlists.font,
							get = function() return db.artifact.font.name end,
							set = function(_, value)
								db.artifact.font.name = value
								Archy:ConfigUpdated('artifact')
							end,
						},
						fontSize = {
							order = 2,
							type = "range",
							name = _G.FONT_SIZE,
							desc = L["Control the font size"],
							min = 4,
							max = 30,
							step = 1,
							get = function() return db.artifact.font.size end,
							set = function(_, value)
								db.artifact.font.size = value
								Archy:ConfigUpdated('artifact')
							end,
						},
						fontOutline = {
							order = 3,
							type = "select",
							name = L["Font Outline"],
							desc = L["The outline of the font"],
							values = outlines,
							get = function() return db.artifact.font.outline end,
							set = function(_, value)
								db.artifact.font.outline = value
								Archy:ConfigUpdated('artifact')
							end,
						},
						fontShadow = {
							order = 4,
							type = "toggle",
							name = L["Font Shadow"],
							desc = L["Toggles if the font will have a shadow"],
							get = function() return db.artifact.font.shadow end,
							set = function(_, value)
								db.artifact.font.shadow = value
								Archy:ConfigUpdated('artifact')
							end,
						},
						fontColor = {
							type = "color",
							order = 5,
							name = L["Font Color"],
							desc = L["The color of the font"],
							hasAlpha = true,
							get = function(info)
								return db.artifact.font.color.r, db.artifact.font.color.g, db.artifact.font.color.b, db.artifact.font.color.a
							end,
							set = function(info, r, g, b, a)
								db.artifact.font.color.r = r
								db.artifact.font.color.g = g
								db.artifact.font.color.b = b
								db.artifact.font.color.a = a
								Archy:ConfigUpdated('artifact')
							end,
						},
					},
				},
				fragmentFontOptions = {
					order = 2,
					type = "group",
					name = L["Fragment Font Options"],
					guiInline = true,
					disabled = function() return (db.general.theme ~= "Graphical") end,
					args = {
						fontName = {
							order = 1,
							type = "select",
							dialogControl = 'LSM30_Font',
							name = L["Font"],
							desc = L["The font that will be used"],
							values = _G.AceGUIWidgetLSMlists.font,
							get = function() return db.artifact.fragmentFont.name end,
							set = function(_, value)
								db.artifact.fragmentFont.name = value
								Archy:ConfigUpdated('artifact')
							end,
						},
						fontSize = {
							order = 2,
							type = "range",
							name = _G.FONT_SIZE,
							desc = L["Control the font size"],
							min = 4,
							max = 30,
							step = 1,
							get = function() return db.artifact.fragmentFont.size end,
							set = function(_, value)
								db.artifact.fragmentFont.size = value
								Archy:ConfigUpdated('artifact')
							end,
						},
						fontOutline = {
							order = 3,
							type = "select",
							name = L["Font Outline"],
							desc = L["The outline of the font"],
							values = outlines,
							get = function() return db.artifact.fragmentFont.outline end,
							set = function(_, value)
								db.artifact.fragmentFont.outline = value
								Archy:ConfigUpdated('artifact')
							end,
						},
						fontShadow = {
							order = 4,
							type = "toggle",
							name = L["Font Shadow"],
							desc = L["Toggles if the font will have a shadow"],
							get = function() return db.artifact.fragmentFont.shadow end,
							set = function(_, value)
								db.artifact.fragmentFont.shadow = value
								Archy:ConfigUpdated('artifact')
							end,
						},
						fontColor = {
							type = "color",
							order = 5,
							name = L["Font Color"],
							desc = L["The color of the font"],
							hasAlpha = true,
							get = function(info)
								return db.artifact.fragmentFont.color.r, db.artifact.fragmentFont.color.g, db.artifact.fragmentFont.color.b, db.artifact.fragmentFont.color.a
							end,
							set = function(info, r, g, b, a)
								db.artifact.fragmentFont.color.r = r
								db.artifact.fragmentFont.color.g = g
								db.artifact.fragmentFont.color.b = b
								db.artifact.fragmentFont.color.a = a
								Archy:ConfigUpdated('artifact')
							end,
						},
					},
				},
				keystoneFontOptions = {
					order = 3,
					type = "group",
					name = L["Key Stone Font Options"],
					guiInline = true,
					disabled = function() return (db.general.theme ~= "Graphical") end,
					args = {
						fontName = {
							order = 1,
							type = "select",
							dialogControl = 'LSM30_Font',
							name = L["Font"],
							desc = L["The font that will be used"],
							values = _G.AceGUIWidgetLSMlists.font,
							get = function() return db.artifact.keystoneFont.name end,
							set = function(_, value)
								db.artifact.keystoneFont.name = value
								Archy:ConfigUpdated('artifact')
							end,
						},
						fontSize = {
							order = 2,
							type = "range",
							name = _G.FONT_SIZE,
							desc = L["Control the font size"],
							min = 4,
							max = 30,
							step = 1,
							get = function() return db.artifact.keystoneFont.size end,
							set = function(_, value)
								db.artifact.keystoneFont.size = value
								Archy:ConfigUpdated('artifact')
							end,
						},
						fontOutline = {
							order = 3,
							type = "select",
							name = L["Font Outline"],
							desc = L["The outline of the font"],
							values = outlines,
							get = function() return db.artifact.keystoneFont.outline end,
							set = function(_, value)
								db.artifact.keystoneFont.outline = value
								Archy:ConfigUpdated('artifact')
							end,
						},
						fontShadow = {
							order = 4,
							type = "toggle",
							name = L["Font Shadow"],
							desc = L["Toggles if the font will have a shadow"],
							get = function() return db.artifact.keystoneFont.shadow end,
							set = function(_, value)
								db.artifact.keystoneFont.shadow = value
								Archy:ConfigUpdated('artifact')
							end,
						},
						fontColor = {
							type = "color",
							order = 5,
							name = L["Font Color"],
							desc = L["The color of the font"],
							hasAlpha = true,
							get = function(info)
								return db.artifact.keystoneFont.color.r, db.artifact.keystoneFont.color.g, db.artifact.keystoneFont.color.b, db.artifact.keystoneFont.color.a
							end,
							set = function(info, r, g, b, a)
								db.artifact.keystoneFont.color.r = r
								db.artifact.keystoneFont.color.g = g
								db.artifact.keystoneFont.color.b = b
								db.artifact.keystoneFont.color.a = a
								Archy:ConfigUpdated('artifact')
							end,
						},
					},
				},
			},
		},
		colorOptions = {
			name = L["Color Options"],
			order = 6,
			type = "group",
			args = {
				fragmentBarColor = {
					order = 31,
					name = L["Progress Bar Color"],
					desc = L["Set the color of the progress bar for artifacts you are working on"],
					type = "color",
					get = function(info)
						return db.artifact.fragmentBarColors["Normal"].r, db.artifact.fragmentBarColors["Normal"].g, db.artifact.fragmentBarColors["Normal"].b
					end,
					set = function(info, r, g, b)
						db.artifact.fragmentBarColors["Normal"].r = r
						db.artifact.fragmentBarColors["Normal"].g = g
						db.artifact.fragmentBarColors["Normal"].b = b
						Archy:ConfigUpdated('artifact', 'color')
					end,
				},
				fragmentBarFirstTimeColor = {
					order = 32,
					name = L["First Time Color"],
					desc = L["Set the color of the progress bar for artifacts you are working on for the first time"],
					type = "color",
					get = function(info)
						return db.artifact.fragmentBarColors["FirstTime"].r, db.artifact.fragmentBarColors["FirstTime"].g, db.artifact.fragmentBarColors["FirstTime"].b
					end,
					set = function(info, r, g, b)
						db.artifact.fragmentBarColors["FirstTime"].r = r
						db.artifact.fragmentBarColors["FirstTime"].g = g
						db.artifact.fragmentBarColors["FirstTime"].b = b
						Archy:ConfigUpdated('artifact', 'color')
					end,
				},
				fragmentBarSolvableColor = {
					order = 33,
					name = L["Solvable Color"],
					desc = L["Set the color of the progress bar for artifacts you can solve"],
					type = "color",
					get = function(info)
						return db.artifact.fragmentBarColors["Solvable"].r, db.artifact.fragmentBarColors["Solvable"].g, db.artifact.fragmentBarColors["Solvable"].b
					end,
					set = function(info, r, g, b)
						db.artifact.fragmentBarColors["Solvable"].r = r
						db.artifact.fragmentBarColors["Solvable"].g = g
						db.artifact.fragmentBarColors["Solvable"].b = b
						Archy:ConfigUpdated('artifact', 'color')
					end,
				},
				fragmentBarRareColor = {
					order = 34,
					name = L["Rare Color"],
					desc = L["Set the color of the progress bar for rare artifacts you are working on"],
					type = "color",
					get = function(info)
						return db.artifact.fragmentBarColors["Rare"].r, db.artifact.fragmentBarColors["Rare"].g, db.artifact.fragmentBarColors["Rare"].b
					end,
					set = function(info, r, g, b)
						db.artifact.fragmentBarColors["Rare"].r = r
						db.artifact.fragmentBarColors["Rare"].g = g
						db.artifact.fragmentBarColors["Rare"].b = b
						Archy:ConfigUpdated('artifact', 'color')
					end,
				},
				fragmentBarKeystoneColor = {
					order = 35,
					name = L["Solvable With Key Stone Color"],
					desc = L["Set the color of the progress bar for artifacts could solve if you attach key stones to them"],
					type = "color",
					get = function(info)
						return db.artifact.fragmentBarColors["AttachToSolve"].r, db.artifact.fragmentBarColors["AttachToSolve"].g, db.artifact.fragmentBarColors["AttachToSolve"].b
					end,
					set = function(info, r, g, b)
						db.artifact.fragmentBarColors["AttachToSolve"].r = r
						db.artifact.fragmentBarColors["AttachToSolve"].g = g
						db.artifact.fragmentBarColors["AttachToSolve"].b = b
						Archy:ConfigUpdated('artifact', 'color')
					end,
				},
			},
		},
	},
}
local digsiteOptions = {
	order = 3,
	type = "group",
	childGroups = "tab",
	name = L["Dig Sites"],
	desc = L["Dig Site Options"],
	args = {
		options = {
			name = _G.GENERAL_LABEL,
			order = 0,
			type = "group",
			args = {
				desc = {
					order = 0,
					type = "description",
					name = L["Control various aspects of the Dig Site options"],
				},
				show = {
					order = 1,
					type = "toggle",
					name = _G.SHOW,
					desc = L["Toggles the display of the Dig Sites list"],
					get = function() return db.digsite.show end,
					set = function(_, value)
						db.digsite.show = value
						Archy:ConfigUpdated('digsite')
					end,
				},
				filterLDB = {
					order = 1.5,
					type = "toggle",
					name = L["Filter LDB to Continent"],
					desc = L["Filter the LDB tooltip to only include the current continent"],
					get = function() return db.digsite.filterLDB end,
					set = function(_, value)
						db.digsite.filterLDB = value
						Archy:ConfigUpdated('digsite')
					end,
				},
				sortByDistance = {
					order = 2,
					type = "toggle",
					name = L["Sort by distance"],
					desc = L["Sort the dig sites by your distance to them"],
					get = function() return db.digsite.sortByDistance end,
					set = function(_, value)
						db.digsite.sortByDistance = value
						Archy:ConfigUpdated('digsite')
					end,
				},
				announceNearest = {
					order = 3,
					type = "toggle",
					name = L["Announce Nearest Dig Site"],
					desc = L["Announces the nearest dig site when it is found"],
					get = function() return db.digsite.announceNearest end,
					set = function(_, value)
						db.digsite.announceNearest = value
						Archy:ConfigUpdated('digsite')
					end,
				},
				minimalOptions = {
					name = L["Minimal Style Options"],
					type = "group",
					order = 10,
					guiInline = true,
					disabled = function() return (db.general.theme == "Graphical") end,
					args = {
						showZone = {
							order = 1,
							type = "toggle",
							name = L["Show Zone"],
							get = function() return db.digsite.minimal.showZone end,
							set = function(_, value)
								db.digsite.minimal.showZone = value
								Archy:ConfigUpdated('digsite')
							end,
						},
						announceNearest = {
							order = 3,
							type = "toggle",
							name = L["Show Distance"],
							get = function() return db.digsite.minimal.showDistance end,
							set = function(_, value)
								db.digsite.minimal.showDistance = value
								Archy:ConfigUpdated('digsite')
							end,
						},
					},
				},
			},
		},
		distanceIndicator = {
			name = L["Survey Distance Indicator"],
			order = 1,
			type = "group",
			args = {
				desc = {
					order = 0,
					type = "description",
					name = L["Control various aspects of Survey Distance Indicator options"],
				},
				enable = {
					order = 1,
					type = "toggle",
					name = _G.ENABLE,
					desc = L["Enable the Survey Distance Indicator"],
					get = function() return db.digsite.distanceIndicator.enabled end,
					set = function(_, value)
						db.digsite.distanceIndicator.enabled = value
						Archy:ConfigUpdated('digsite')
					end,
				},
				showSurveyButton = {
					order = 1.5,
					type = "toggle",
					name = L["Show Survey Button"],
					desc = L["Shows a Survey button with the Distance Indicator."],
					get = function() return db.digsite.distanceIndicator.showSurveyButton end,
					set = function(_, value)
						db.digsite.distanceIndicator.showSurveyButton = value
						Archy:ConfigUpdated('digsite')
					end,
				},
				docked = {
					order = 2,
					type = "toggle",
					name = L["Undock"],
					desc = L["Undock the survey distance indicator from the Dig Sites list"],
					get = function() return db.digsite.distanceIndicator.undocked end,
					set = function(_, value)
						db.digsite.distanceIndicator.undocked = value
						Archy:ConfigUpdated('digsite')
					end,
				},
				anchor = {
					order = 2.5,
					type = "select",
					name = L["Anchor"],
					desc = L["The corner of the survey distance indicator that the frame will anchor from."],
					get = function() return db.digsite.distanceIndicator.anchor end,
					set = function(_, value)
						db.digsite.distanceIndicator.anchor = value
						Archy:SaveFramePosition(distanceIndicatorFrame)
					end,
					values = frameAnchorOptions,
					disabled = function() return not db.digsite.distanceIndicator.undocked end,
				},
				space = {
					order = 3,
					type = "description",
					name = "",
				},
				green = {
					order = 5,
					type = "range",
					name = L["Green Distance Radius"],
					desc = L["Set how large the green area of the survey distance indicator will use"],
					min = 1,
					max = 200,
					step = 1,
					get = function() return db.digsite.distanceIndicator.green end,
					set = function(_, value)
						db.digsite.distanceIndicator.green = value
						Archy:ConfigUpdated('digsite')
					end,
				},
				yellow = {
					order = 6,
					type = "range",
					name = L["Yellow Distance Radius"],
					desc = L["Set how large the yellow area of the survey distance indicator will use"],
					min = 1,
					max = 200,
					step = 1,
					get = function() return db.digsite.distanceIndicator.yellow end,
					set = function(_, value)
						db.digsite.distanceIndicator.yellow = value
						Archy:ConfigUpdated('digsite')
					end,
				},
			},
		},
		frameOptions = {
			name = L["Frame Options"],
			order = 2,
			type = "group",
			args = {
				desc = {
					order = 0,
					type = "description",
					name = L["Control various aspects of how the Dig Site list is displayed"],
				},
				scale = {
					order = 7,
					type = "range",
					name = L["Size"],
					desc = L["Set how large the Dig Site list is"],
					min = 0.25,
					max = 4,
					step = 0.01,
					bigStep = 0.05,
					get = function() return db.digsite.scale end,
					set = function(_, value)
						db.digsite.scale = value
						Archy:ConfigUpdated('digsite')
					end,
				},
				alpha = {
					order = 8,
					type = "range",
					name = _G.OPACITY,
					desc = L["Set how transparent or opaque the Dig Site list is"],
					min = 0,
					max = 1,
					step = 0.01,
					bigStep = 0.05,
					get = function() return db.digsite.alpha end,
					set = function(_, value)
						db.digsite.alpha = value
						Archy:ConfigUpdated('digsite')
					end,
				},
				anchor = {
					order = 9,
					type = "select",
					name = L["Anchor"],
					desc = L["The corner of the Dig Sites list that the frame will grow from."],
					get = function() return db.digsite.anchor end,
					set = function(_, value)
						db.digsite.anchor = value
						Archy:SaveFramePosition(digsiteFrame)
					end,
					values = frameAnchorOptions,
				},
				space2 = {
					order = 12,
					type = "description",
					name = "",
				},
				borderAlpha = {
					order = 13,
					type = "range",
					name = L["Border Opacity"],
					desc = L["Set how transparent or opaque the border for the Dig Sites list is"],
					min = 0,
					max = 1,
					step = 0.01,
					bigStep = 0.05,
					get = function() return db.digsite.borderAlpha end,
					set = function(_, value)
						db.digsite.borderAlpha = value
						Archy:ConfigUpdated('digsite')
					end,
				},
				bgAlpha = {
					order = 14,
					type = "range",
					name = L["Background Opacity"],
					desc = L["Set how transparent or opaque the background for the Dig Sites list is"],
					min = 0,
					max = 1,
					step = 0.01,
					bigStep = 0.05,
					get = function() return db.digsite.bgAlpha end,
					set = function(_, value)
						db.digsite.bgAlpha = value
						Archy:ConfigUpdated('digsite')
					end,
				},
				borderTexture = {
					order = 13.5,
					type = "select",
					name = L["Border Texture"],
					desc = L["Set the texture used by the frame border"],
					dialogControl = "LSM30_Border",
					values = lsm:HashTable(lsm.MediaType.BORDER),
					get = function() return db.digsite.borderTexture end,
					set = function(_, value)
						db.digsite.borderTexture = value
						Archy:ConfigUpdated('digsite')
					end,
				},
				backgroundTexture = {
					order = 14.5,
					type = "select",
					name = L["Background Texture"],
					desc = L["Set the texture used by the frame background"],
					dialogControl = "LSM30_Border",
					values = lsm:HashTable(lsm.MediaType.BACKGROUND),
					get = function() return db.digsite.backgroundTexture end,
					set = function(_, value)
						db.digsite.backgroundTexture = value
						Archy:ConfigUpdated('digsite')
					end,
				},
			},
		},
		fontOptions = {
			name = L["Font Options"],
			order = 5,
			type = "group",
			args = {
				mainFontOptions = {
					order = 1,
					type = "group",
					name = L["Main Font Options"],
					guiInline = true,
					args = {
						fontName = {
							order = 1,
							type = "select",
							dialogControl = 'LSM30_Font',
							name = L["Font"],
							desc = L["The font that will be used"],
							values = _G.AceGUIWidgetLSMlists.font,
							get = function() return db.digsite.font.name end,
							set = function(_, value)
								db.digsite.font.name = value
								Archy:ConfigUpdated('digsite', 'font')
							end,
						},
						fontSize = {
							order = 2,
							type = "range",
							name = _G.FONT_SIZE,
							desc = L["Control the font size"],
							min = 4,
							max = 30,
							step = 1,
							get = function() return db.digsite.font.size end,
							set = function(_, value)
								db.digsite.font.size = value
								Archy:ConfigUpdated('digsite', 'font')
							end,
						},
						fontOutline = {
							order = 3,
							type = "select",
							name = L["Font Outline"],
							desc = L["The outline of the font"],
							values = outlines,
							get = function() return db.digsite.font.outline end,
							set = function(_, value)
								db.digsite.font.outline = value
								Archy:ConfigUpdated('digsite', 'font')
							end,
						},
						fontShadow = {
							order = 4,
							type = "toggle",
							name = L["Font Shadow"],
							desc = L["Toggles if the font will have a shadow"],
							get = function() return db.digsite.font.shadow end,
							set = function(_, value)
								db.digsite.font.shadow = value
								Archy:ConfigUpdated('digsite', 'font')
							end,
						},
						fontColor = {
							type = "color",
							order = 5,
							name = L["Font Color"],
							desc = L["The color of the font"],
							hasAlpha = true,
							get = function(info)
								return db.digsite.font.color.r, db.digsite.font.color.g, db.digsite.font.color.b, db.digsite.font.color.a
							end,
							set = function(info, r, g, b, a)
								db.digsite.font.color.r = r
								db.digsite.font.color.g = g
								db.digsite.font.color.b = b
								db.digsite.font.color.a = a
								Archy:ConfigUpdated('digsite', 'font')
							end,
						},
					},
				},
				zoneFontOptions = {
					order = 2,
					type = "group",
					name = L["Zone Font Options"],
					guiInline = true,
					disabled = function() return (db.general.theme ~= "Graphical") end,
					args = {
						fontName = {
							order = 1,
							type = "select",
							dialogControl = 'LSM30_Font',
							name = L["Font"],
							desc = L["The font that will be used"],
							values = _G.AceGUIWidgetLSMlists.font,
							get = function() return db.digsite.zoneFont.name end,
							set = function(_, value)
								db.digsite.zoneFont.name = value
								Archy:ConfigUpdated('digsite', 'font')
							end,
						},
						fontSize = {
							order = 2,
							type = "range",
							name = _G.FONT_SIZE,
							desc = L["Control the font size"],
							min = 4,
							max = 30,
							step = 1,
							get = function() return db.digsite.zoneFont.size end,
							set = function(_, value)
								db.digsite.zoneFont.size = value
								Archy:ConfigUpdated('digsite', 'font')
							end,
						},
						fontOutline = {
							order = 3,
							type = "select",
							name = L["Font Outline"],
							desc = L["The outline of the font"],
							values = outlines,
							get = function() return db.digsite.zoneFont.outline end,
							set = function(_, value)
								db.digsite.zoneFont.outline = value
								Archy:ConfigUpdated('digsite', 'font')
							end,
						},
						fontShadow = {
							order = 4,
							type = "toggle",
							name = L["Font Shadow"],
							desc = L["Toggles if the font will have a shadow"],
							get = function() return db.digsite.zoneFont.shadow end,
							set = function(_, value)
								db.digsite.zoneFont.shadow = value
								Archy:ConfigUpdated('digsite', 'font')
							end,
						},
						fontColor = {
							type = "color",
							order = 5,
							name = L["Font Color"],
							desc = L["The color of the font"],
							hasAlpha = true,
							get = function(info)
								return db.digsite.zoneFont.color.r, db.digsite.zoneFont.color.g, db.digsite.zoneFont.color.b, db.digsite.zoneFont.color.a
							end,
							set = function(info, r, g, b, a)
								db.digsite.zoneFont.color.r = r
								db.digsite.zoneFont.color.g = g
								db.digsite.zoneFont.color.b = b
								db.digsite.zoneFont.color.a = a
								Archy:ConfigUpdated('digsite', 'font')
							end,
						},
					},
				},
			},
		},
	},
}

--[[
local archyDataOptions = {
    order = 6,
    type = "group",
    name = "ArchyData",
    disabled = function()
        local _, _, _, enabled, _, reason, _ = GetAddOnInfo("Archy_Data")
        return not enabled or (reason ~= nil)
    end,
    args = {
        desc = {
            order = 0,
            type = "description",
            name = L["Import Survey Node data from ArchyData"],
        },
        loadData = {
            order = 5,
            name = L["Import ArchyData"],
            desc = L["Load ArchyData and import the data to your database."],
            type = "execute",
            func = function()
                local loaded, reason = LoadAddOn("Archy_Data")
                if loaded then
                    local ArchyData = LibStub("AceAddon-3.0"):GetAddon("Archy_Data")
--                    local dataVersion = tonumber(GetAddOnMetadata("Archy_Data", "X-Generated-Version"):match("%d+"))
                    ArchyData:PerformImport(true)
                    Archy:Print(L["ArchyData has been imported."])
                    Archy:ConfigUpdated()
                    if not db.data then db.data = {} end
--                    db.data.lastImport = dataVersion
                    db.data.imported = true
                else
                    Archy:Print(L["Failed to load ArchyData due to "]..reason)
                end
            end,
            disabled = function()
                local _, _, _, enabled, _, reason, _ = GetAddOnInfo("Archy_Data")
                return not enabled or (reason ~= nil) or (db.data and db.data.imported)
            end,
        },
    },
}

]] --
local tomtomOptions = {
	order = 4,
	type = "group",
	name = "TomTom",
	desc = L["TomTom Options"],
	args = {
		desc = {
			order = 0,
			type = "description",
			name = L["Control various aspects of TomTom integration"],
		},
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable TomTom integration"],
			desc = L["Toggle if Archy will send the nearest dig site waypoint information to TomTom"],
			width = "double",
			get = function() return db.tomtom.enabled end,
			set = function(_, value)
				db.tomtom.enabled = value
				Archy:ConfigUpdated('tomtom')
			end,
		},
		arrivalDistance = {
			order = 2,
			type = "range",
			name = L["\"Arrival Distance\""],
			desc = L["This setting will control the distance at which the waypoint arrow switches to a downwards arrow, indicating you have arrived at your destination.\nNOTE: This may not work with emulation addons if they do not support this."],
			min = 0,
			max = 150,
			step = 5,
			get = function() return db.tomtom.distance end,
			set = function(_, value)
				db.tomtom.distance = value
				Archy:ConfigUpdated('tomtom')
			end,
			disabled = function() return not db.tomtom.enabled or not tomtomExists end,
			--            width = "double"
		},
		arrivalPing = {
			order = 3,
			type = "toggle",
			name = L["Play a sound when arriving at a waypoint"],
			desc = L["When you 'arrive' at a waypoint (this distance is controlled by the 'Arrival Distance' setting in this group) a sound can be played to indicate this.  You can enable or disable this sound using this setting."],
			width = "double",
			get = function() return db.tomtom.ping end,
			set = function(_, value)
				db.tomtom.ping = value
				Archy:ConfigUpdated('tomtom')
			end,
			disabled = function() return not db.tomtom.enabled or not tomtomExists end,
			width = "double"
		},
	},
}
local minimapOptions = {
	order = 5,
	type = "group",
	childGroups = "tab",
	name = _G.MINIMAP_LABEL,
	desc = L["Minimap Options"],
	args = {
		options = {
			name = _G.GENERAL_LABEL,
			order = 0,
			type = "group",
			args = {
				desc = {
					order = 0,
					type = "description",
					name = L["Control various aspects of Minimap options"],
				},
				show = {
					order = 1,
					type = "toggle",
					name = L["Show Dig Sites"],
					desc = L["Show your dig sites on the minimap"],
					get = function() return db.minimap.show end,
					set = function(_, value)
						db.minimap.show = value
						Archy:ConfigUpdated('minimap')
					end,
				},
				nearest = {
					order = 2,
					type = "toggle",
					name = L["Nearest only"],
					desc = L["Show only the nearest dig site on the minimap"],
					get = function() return db.minimap.nearest end,
					set = function(_, value)
						db.minimap.nearest = value
						Archy:ConfigUpdated('minimap')
					end,
					disabled = function() return not db.minimap.show end,
				},
				fragmentNodes = {
					order = 3,
					type = "toggle",
					name = L["Show Fragment Nodes"],
					desc = L["Show the locations where you have collected fragments"],
					get = function() return db.minimap.fragmentNodes end,
					set = function(_, value)
						db.minimap.fragmentNodes = value
						Archy:ConfigUpdated('minimap')
					end,
					width = "double",
				},
				fragmentIcon = {
					order = 3.5,
					name = L["Node Icon"],
					desc = L["Icon to use for the fragment node icon"],
					type = "select",
					values = fragmentIconValues,
					get = function() return db.minimap.fragmentIcon end,
					set = function(_, value)
						db.minimap.fragmentIcon = value
						Archy:ConfigUpdated('minimap')
					end,
				},
				fragmentColorBySurveyDistance = {
					order = 4,
					name = L["Color Node Icons On Survey"],
					desc = L["Color code the fragment node icon based on the survey distance"],
					type = "toggle",
					get = function() return db.minimap.fragmentColorBySurveyDistance end,
					set = function(_, value)
						db.minimap.fragmentColorBySurveyDistance = value
						Archy:ConfigUpdated('minimap')
					end,
				},
			},
		},
		blobs = {
			name = L["Dig Site Boundaries"],
			order = 1,
			type = "group",
			args = {
				blob = {
					order = 4,
					type = "toggle",
					name = L["Show Dig Site Boundaries on minimap"],
					desc = L["Show the dig site boundaries on the minimap"],
					width = "double",
					get = function() return db.minimap.blob end,
					set = function(_, value)
						db.minimap.blob = value
						Archy:ConfigUpdated('minimap')
					end,
					width = "full",
				},
				zoneMapBlob = {
					order = 5,
					type = "toggle",
					name = L["Show Dig Site Boundaries on battlefield map"],
					desc = L["Show the dig site boundaries on the battlefield map"],
					width = "double",
					get = function() return db.minimap.zoneBlob end,
					set = function(_, value)
						db.minimap.zoneBlob = value
						Archy:ConfigUpdated('minimap')
					end,
					width = "full",
				},
				blobAlpha = {
					order = 6,
					type = "range",
					name = _G.OPACITY,
					desc = L["Set how transparent or opaque the Dig Site boundaries are"],
					min = 0.25,
					max = 1,
					step = 0.01,
					bigStep = 0.05,
					get = function() return db.minimap.blobAlpha end,
					set = function(_, value)
						db.minimap.blobAlpha = value
						Archy:ConfigUpdated('minimap')
					end,
					disabled = function() return not db.minimap.blob and not db.minimap.zoneBlob end,
				},
				useBlobDistance = {
					order = 4.4,
					type = "toggle",
					name = L["Enable \"Arrival Distance\""],
					desc = L["This setting will control the distance at which the minimap blob will become visible.\nNOTE: This is a semi-workaround for the boundaries exceeding the minimap area."],
					get = function() return db.minimap.useBlobDistance end,
					set = function(_, value)
						db.minimap.useBlobDistance = value
						Archy:ConfigUpdated('minimap')
					end,
					disabled = function() return not db.minimap.blob end,
					width = "full",
				},
				blobDistance = {
					order = 4.5,
					type = "range",
					name = L["\"Arrival Distance\""],
					desc = L["This setting will control the distance at which the minimap blob will become visible.\nNOTE: This is a semi-workaround for the boundaries exceeding the minimap area."],
					min = 0,
					max = 550,
					step = 5,
					get = function() return db.minimap.blobDistance end,
					set = function(_, value)
						db.minimap.blobDistance = value
						Archy:ConfigUpdated('minimap')
					end,
					disabled = function() return not db.minimap.blob or not db.minimap.useBlobDistance end,
					--                    width = "double"
				},
			},
		},
	},
}

--[[ Meta Tables ]] --
setmetatable(raceData, {
	__index = function(t, k)
		if _G.GetNumArchaeologyRaces() == 0 then
			return
		end
		local raceName, raceTexture, itemID, currencyAmount = _G.GetArchaeologyRaceInfo(k)
		local itemName, _, _, _, _, _, _, _, _, itemTexture, _ = _G.GetItemInfo(itemID)

		t[k] = {
			name = raceName,
			currency = currencyAmount,
			texture = raceTexture,
			keystone = {
				id = itemID,
				name = itemName,
				texture = itemTexture,
				inventory = 0
			}
		}
		return t[k]
	end
})


setmetatable(artifacts, {
	__index = function(t, k)
		if k then
			t[k] = {
				name = "",
				tooltip = "",
				icon = "",
				sockets = 0,
				stonesAdded = 0,
				fragments = 0,
				fragAdjust = 0,
				fragTotal = 0,
			}
			return t[k]
		end
	end
})


local blobs = setmetatable({}, {
	__index = function(t, k)
		local f = _G.CreateFrame("ArchaeologyDigSiteFrame", "Archy" .. k .. "_Blob")
		_G.rawset(t, k, f)
		f:ClearAllPoints()
		f:EnableMouse(false)
		f:SetFillAlpha(256 * db.minimap.blobAlpha)
		f:SetFillTexture("Interface\\WorldMap\\UI-ArchaeologyBlob-Inside")
		f:SetBorderTexture("Interface\\WorldMap\\UI-ArchaeologyBlob-Outside")
		f:EnableSmoothing(true)
		f:SetBorderScalar(0.1)
		f:Hide()
		return f
	end
})

local pois = setmetatable({}, {
	__index = function(t, k)
		local poi = _G.CreateFrame("Frame", "ArchyMinimap_POI" .. k, _G.Minimap)
		poi:SetWidth(10)
		poi:SetHeight(10)
		poi:SetScript("OnEnter", POI_OnEnter)
		poi:SetScript("OnLeave", POI_OnLeave)

		local arrow = _G.CreateFrame("Frame", nil, poi)
		arrow:SetPoint("CENTER", poi)
		arrow:SetScript("OnUpdate", Arrow_OnUpdate)
		arrow:SetWidth(32)
		arrow:SetHeight(32)

		local arrowtexture = arrow:CreateTexture(nil, "OVERLAY")
		arrowtexture:SetTexture([[Interface\Minimap\ROTATING-MINIMAPGUIDEARROW]]) -- [[Interface\Archeology\Arch-Icon-Marker]])
		arrowtexture:SetAllPoints(arrow)
		arrow.texture = arrowtexture
		arrow.t = 0
		arrow.poi = poi
		arrow:Hide()
		poi.useArrow = false
		poi.arrow = arrow
		poi:Hide()
		return poi
	end
})




--[[ Pre load tables ]] --
do
	-- cache the zone/map data
	local orig = _G.GetCurrentMapAreaID()

	for cid, cname in pairs{ _G.GetMapContinents() } do
		_G.SetMapZoom(cid)
		local mapid = _G.GetCurrentMapAreaID()
		continentMapToID[mapid] = cid

		local cmn = _G.GetMapInfo()

		zoneData[mapid] = {
			continent = cid,
			map = mapid,
			level = 0,
			mapFile = cmn,
			id = 0,
			name = cname
		}
		mapFileToID[cmn] = mapid
		mapIDToZoneName[mapid] = cname

		for zid, zname in pairs{ _G.GetMapZones(cid) } do
			_G.SetMapZoom(cid, zid)
			local mapid = _G.GetCurrentMapAreaID()
			local level = _G.GetCurrentMapDungeonLevel()
			mapFileToID[_G.GetMapInfo()] = mapid
			mapIDToZone[mapid] = zid
			mapIDToZoneName[mapid] = zname
			zoneIDToName[zid] = zname
			zoneData[mapid] = {
				continent = zid,
				map = mapid,
				level = level,
				mapFile = _G.GetMapInfo(),
				id = zid,
				name = zname
			}
		end
	end
	_G.SetMapByID(orig)

	--  Minimap size values
	minimapSize = {
		indoor = {
			[0] = 300,
			[1] = 240,
			[2] = 180,
			[3] = 120,
			[4] = 80,
			[5] = 50,
		},
		outdoor = {
			[0] = 466 + 2 / 3,
			[1] = 400,
			[2] = 333 + 1 / 3,
			[3] = 266 + 2 / 6,
			[4] = 200,
			[5] = 133 + 1 / 3,
		},
		inScale = {
			[0] = 1,
			[1] = 1.25,
			[2] = 5 / 3,
			[3] = 2.5,
			[4] = 3.75,
			[5] = 6,
		},
		outScale = {
			[0] = 1,
			[1] = 7 / 6,
			[2] = 1.4,
			[3] = 1.75,
			[4] = 7 / 3,
			[5] = 3.5,
		},
	}
end

--[[ Function Hooks ]] --
-- Hook and overwrite the default SolveArtifact function to provide confirmations when nearing cap
local blizSolveArtifact = _G.SolveArtifact
_G.SolveArtifact = function(race_index, use_stones)
	if not race_index then
		race_index = ARTIFACT_NAME_TO_RACE_ID_MAP[_G.GetSelectedArtifactInfo()]
	end
	local rank, maxRank = GetArchaeologyRank()

	if db.general.confirmSolve and maxRank < MAX_ARCHAEOLOGY_RANK and (rank + 25) >= maxRank then
		if not confirmArgs then
			confirmArgs = {}
		end
		confirmArgs.race = race_index
		confirmArgs.useStones = use_stones
		_G.StaticPopup_Show("ARCHY_CONFIRM_SOLVE", rank, maxRank)
	else
		return SolveRaceArtifact(race_index, use_stones)
	end
end

--[[ Dialog declarations ]] --
_G.StaticPopupDialogs["ARCHY_CONFIRM_SOLVE"] = {
	text = L["Your Archaeology skill is at %d of %d.  Are you sure you would like to solve this artifact before visiting a trainer?"],
	button1 = _G.YES,
	button2 = _G.NO,
	OnAccept = function()
		if confirmArgs and confirmArgs.race then
			SolveRaceArtifact(confirmArgs.race, confirmArgs.useStones)
			confirmArgs = nil
		else
			blizSolveArtifact()
			confirmArgs = nil
		end
	end,
	OnCancel = function()
		confirmArgs = nil
	end,
	timeout = 0,
	sound = "levelup2",
	whileDead = false,
	hideOnEscape = true,
}


--[[ Local Helper Functions ]] --

-- Returns true if the player has the archaeology secondary skill
local function HasArchaeology()
	local _, _, arch = _G.GetProfessions()
	return arch
end

local function IsTaintable()
	return (inCombat or _G.InCombatLockdown() or _G.UnitAffectingCombat("player"))
end

local function ShouldBeHidden()
	return (not db.general.show or not playerContinent or _G.UnitIsGhost("player") or _G.IsInInstance() or not HasArchaeology())
end

-- opens the Blizzard_ArchaeologyUI panel
function Archy:ShowArchaeology()
	if _G.IsAddOnLoaded("Blizzard_ArchaeologyUI") then
		_G.ShowUIPanel(_G.ArchaeologyFrame)
		return true
	end
	local loaded, reason = _G.LoadAddOn("Blizzard_ArchaeologyUI")

	if loaded then
		_G.ShowUIPanel(_G.ArchaeologyFrame)
		return true
	else
		Archy:Print(L["ArchaeologyUI not loaded: %s Try opening manually."]:format(_G["ADDON_" .. reason]))
		return false
	end
end

-- returns the rank and max rank for the players archaeology skill
function GetArchaeologyRank()
	local _, _, archaeology_index = _G.GetProfessions()

	if not archaeology_index then
		return
	end
	local _, _, rank, maxRank = _G.GetProfessionInfo(archaeology_index)
	return rank, maxRank
end

-- Toggles the lock of the panels
local function ToggleLock()
	db.general.locked = not db.general.locked
	Archy:Print(db.general.locked and _G.LOCKED or _G.UNLOCK)
	Archy:ConfigUpdated()
end

-- extract the itemid from the itemlink
local function GetIDFromLink(link)
	if not link then
		return
	end
	local found, _, str = link:find("^|c%x+|H(.+)|h%[.+%]")

	if not found then
		return
	end

	local _, id = (":"):split(str)
	return tonumber(id)
end

-- deformat substitute
local function MatchFormat(msg, pattern)
	return msg:match(pattern:gsub("(%%s)", "(.+)"):gsub("(%%d)", "(.+)"))
end


-- return the player, itemlink and quantity of the item in the chat_msg_loot
local function ParseLootMessage(msg)
	local player = _G.UnitName("player")
	local item, quantity = MatchFormat(msg, _G.LOOT_ITEM_SELF_MULTIPLE)

	if item and quantity then
		return player, item, tonumber(quantity)
	end
	quantity = 1
	item = MatchFormat(msg, _G.LOOT_ITEM_SELF)

	if item then
		return player, item, tonumber(quantity)
	end
	player, item, quantity = MatchFormat(msg, _G.LOOT_ITEM_MULTIPLE)

	if player and item and quantity then
		return player, item, tonumber(quantity)
	end
	quantity = 1
	player, item = MatchFormat(msg, _G.LOOT_ITEM)

	return player, item, tonumber(quantity)
end

-- load the race related data tables
local function LoadRaceData()
	if _G.GetNumArchaeologyRaces() == 0 then
		return
	end

	for race_id = 1, _G.GetNumArchaeologyRaces() do
		local race = raceData[race_id] -- meta table should load the data

		if race then -- we have race data
			raceNameToID[race.name] = race_id
			keystoneIDToRaceID[race.keystone.id] = race_id
		end
	end
	_G.RequestArtifactCompletionHistory()
	raceDataLoaded = true
end

-- returns a list of race ids for the continent map id
local function ContinentRaces(cid)
	local races = {}
	for _, site in pairs(DIG_SITES) do
		if site.continent == continentMapToID[cid] and not _G.tContains(races, site.race) then
			table.insert(races, site.race)
		end
	end
	return races
end

function ResetPositions()
	db.digsite.distanceIndicator.position = { unpack(defaults.profile.digsite.distanceIndicator.position) }
	db.digsite.distanceIndicator.anchor = defaults.profile.digsite.distanceIndicator.anchor
	db.digsite.distanceIndicator.undocked = defaults.profile.digsite.distanceIndicator.undocked
	db.digsite.position = { unpack(defaults.profile.digsite.position) }
	db.digsite.anchor = defaults.profile.digsite.anchor
	db.artifact.position = { unpack(defaults.profile.artifact.position) }
	db.artifact.anchor = defaults.profile.artifact.anchor
	Archy:ConfigUpdated()
	Archy:UpdateFramePositions()
end

local CONFIG_UPDATE_FUNCTIONS = {
	artifact = function(option)
		if option == "autofill" then
			for race_id = 1, _G.GetNumArchaeologyRaces() do
				UpdateRaceArtifact(race_id)
			end
		elseif option == "color" then
			Archy:RefreshRacesDisplay()
		else
			Archy:UpdateRacesFrame()
			Archy:RefreshRacesDisplay()
			Archy:SetFramePosition(racesFrame)
		end
	end,
	digsite = function(option)
		Archy:UpdateDigSiteFrame()

		if option == "font" then
			Archy:ResizeDigSiteDisplay()
		else
			Archy:RefreshDigSiteDisplay()
		end
		Archy:SetFramePosition(digsiteFrame)
		Archy:SetFramePosition(distanceIndicatorFrame)
		ToggleDistanceIndicator()
	end,
	minimap = function(option)
		UpdateMinimapPOIs(true)
		UpdateSiteBlobs()
	end,
	tomtom = function(option)
		if db.tomtom.enabled and tomtomExists then
			if _G.TomTom.profile then
				_G.TomTom.profile.arrow.arrival = db.tomtom.distance
				_G.TomTom.profile.arrow.enablePing = db.tomtom.ping
			end
		end
		RefreshTomTom()
	end,
}

function Archy:ConfigUpdated(namespace, option)
	db = self.db.profile

	if not namespace then
		self:UpdateRacesFrame()
		self:RefreshRacesDisplay()
		self:UpdateDigSiteFrame()
		self:RefreshDigSiteDisplay()
		UpdateMinimapPOIs(true)
		UpdateSiteBlobs()
		RefreshTomTom()
	else
		CONFIG_UPDATE_FUNCTIONS[namespace](option)
	end
end

--[[ Artifact Functions ]] --
local function Announce(race_id)
	if not db.general.show then
		return
	end
	local race_name = "|cFFFFFF00" .. raceData[race_id].name .. "|r"
	local artifact = artifacts[race_id]
	local artifact_name = "|cFFFFFF00" .. artifact.name .. "|r"
	local text = L["You can solve %s Artifact - %s (Fragments: %d of %d)"]:format(race_name, artifact_name, artifact.fragments + artifact.fragAdjust, artifact.fragTotal)
	Archy:Pour(text, 1, 1, 1)
end

local function Ping()
	if not db.general.show then
		return
	end
	_G.PlaySoundFile("Interface\\AddOns\\Archy\\Media\\dingding.mp3")
end

function UpdateRaceArtifact(race_id)
	local race = raceData[race_id]

	if not race then
		--@??? Maybe use a wipe statement here
		artifacts[race_id] = nil
		return
	end
	raceData[race_id].keystone.inventory = _G.GetItemCount(raceData[race_id].keystone.id) or 0

	if _G.GetNumArtifactsByRace(race_id) == 0 then
		return
	end

	if _G.ArchaeologyFrame and _G.ArchaeologyFrame:IsVisible() then
		_G.ArchaeologyFrame_ShowArtifact(race_id)
	end
	_G.SetSelectedArtifact(race_id)

	local name, _, rarity, icon, spellDescription, numSockets = _G.GetSelectedArtifactInfo()
	local base, adjust, total = _G.GetArtifactProgress()
	local artifact = artifacts[race_id]

	ARTIFACT_NAME_TO_RACE_ID_MAP[name] = race_id

	artifact.canSolve = _G.CanSolveArtifact()
	artifact.fragments = base
	artifact.fragTotal = total
	artifact.sockets = numSockets
	artifact.icon = icon
	artifact.tooltip = spellDescription
	artifact.rare = (rarity ~= 0)
	artifact.name = name
	artifact.canSolveStone = nil
	artifact.fragAdjust = 0
	artifact.completionCount = 0

	local prevAdded = math.min(artifact.stonesAdded, raceData[race_id].keystone.inventory, numSockets)

	if db.artifact.autofill[race_id] then
		prevAdded = math.min(raceData[race_id].keystone.inventory, numSockets)
	end
	artifact.stonesAdded = math.min(raceData[race_id].keystone.inventory, numSockets)

	if artifact.stonesAdded > 0 and numSockets > 0 then
		for i = 1, math.min(artifact.stonesAdded, numSockets) do
			_G.SocketItemToArtifact()

			if not _G.ItemAddedToArtifact(i) then
				break
			end
		end
		base, adjust, total = _G.GetArtifactProgress()
		artifact.canSolveStone = _G.CanSolveArtifact()

		if prevAdded > 0 then
			artifact.fragAdjust = adjust
		end
	end
	artifact.stonesAdded = prevAdded

	_G.RequestArtifactCompletionHistory()

	if db.artifact.blacklist[race_id] then
		return
	end

	if not artifact.has_announced and ((db.artifact.announce and artifact.canSolve) or (db.artifact.keystoneAnnounce and artifact.canSolveStone)) then
		artifact.has_announced = true
		Announce(race_id)
	end

	if not artifact.has_pinged and ((db.artifact.ping and artifact.canSolve) or (db.artifact.keystonePing and artifact.canSolveStone)) then
		artifact.has_pinged = true
		Ping()
	end
end

local function UpdateRace(race_id)
	UpdateRaceArtifact(race_id)
	UpdateArtifactFrame(race_id)
end

function SolveRaceArtifact(race_id, useStones)
	if race_id then
		_G.SetSelectedArtifact(race_id)
		artifactSolved.raceId = race_id
		artifactSolved.name = _G.GetSelectedArtifactInfo()
		keystoneLootRaceID = race_id -- this is to force a refresh after the ARTIFACT_COMPLETE event

		if useStones ~= nil then
			if useStones then
				artifacts[race_id].stonesAdded = math.min(raceData[race_id].keystone.inventory, artifacts[race_id].sockets)
			else
				artifacts[race_id].stonesAdded = 0
			end
		end

		if artifacts[race_id].stonesAdded > 0 then
			for index = 1, artifacts[race_id].stonesAdded do
				SocketItemToArtifact()

				if not ItemAddedToArtifact(index) then
					break
				end
			end
		else
			if artifacts[race_id].sockets > 0 then
				for index = 1, artifacts[race_id].stonesAdded do
					RemoveItemFromArtifact()
				end
			end
		end
		GetArtifactProgress()
	end
	blizSolveArtifact()
end

function Archy:SolveAnyArtifact(useStones)
	local found = false
	for rid, artifact in pairs(artifacts) do
		if not db.artifact.blacklist[rid] then
			if (artifact.canSolve or (useStones and artifact.canSolveStone)) then
				SolveRaceArtifact(rid, useStones)
				found = true
				break
			end
		end
	end
	if not found then
		Archy:Print(L["No artifacts were solvable"])
	end
end

local function GetArtifactStats(rid, name)
	local numArtifacts = GetNumArtifactsByRace(rid)

	if not numArtifacts then
		return
	end

	for artifactIndex = 1, numArtifacts do
		local artifactName, _, _, _, _, _, _, firstCompletionTime, completionCount = GetArtifactInfoByRace(rid, artifactIndex)
		if name == artifactName then
			return artifactIndex, firstCompletionTime, completionCount
		end
	end
end

local function UpdateArtifactFrame(rid)
end

function Archy:SocketClicked(self, button, down)
	local race_id = self:GetParent():GetParent():GetID()

	if button == "LeftButton" then
		if artifacts[race_id].stonesAdded < artifacts[race_id].sockets and artifacts[race_id].stonesAdded < raceData[race_id].keystone.inventory then
			artifacts[race_id].stonesAdded = artifacts[race_id].stonesAdded + 1
		end
	else
		if artifacts[race_id].stonesAdded > 0 then
			artifacts[race_id].stonesAdded = artifacts[race_id].stonesAdded - 1
		end
	end
	UpdateRaceArtifact(race_id)
	Archy:RefreshRacesDisplay()
end

--[[ Dig Site List Functions ]] --
local function ResetDigCounter(id)
	siteStats[id].counter = 0
end

local function IncrementDigCounter(id)
	siteStats[id].counter = (siteStats[id].counter or 0) + 1
end

local function CompareAndResetDigCounters(a, b)
	if not a or not b or (#a == 0) or (#b == 0) then
		return
	end

	for _, siteA in pairs(a) do
		local exists = false
		for _, siteB in pairs(b) do
			if siteA.id == siteB.id then
				exists = true
				break
			end
		end

		if not exists then
			ResetDigCounter(siteA.id)
		end
	end
end

local DIG_LOCATION_TEXTURE = 177

local function GetContinentSites(continent_id)
	local sites, orig = {}, _G.GetCurrentMapAreaID()
	_G.SetMapZoom(continent_id)

	local totalPOIs = _G.GetNumMapLandmarks()

	for index = 1, totalPOIs do
		local name, description, textureIndex, px, py = _G.GetMapLandmarkInfo(index)

		if textureIndex == DIG_LOCATION_TEXTURE then
			local zoneName, mapFile, texPctX, texPctY, texX, texY, scrollX, scrollY = _G.UpdateMapHighlight(px, py)
			local site = DIG_SITES[name]
			local mc, fc, mz, fz, zoneID = 0, 0, 0, 0, 0
			mc, fc = astrolabe:GetMapID(continent_id, 0)
			mz = site.map
			zoneID = mapIDToZone[mz]


			if site then
				local x, y = astrolabe:TranslateWorldMapPosition(mc, fc, px, py, mz, fz)

				local raceName, raceCrestTexture = _G.GetArchaeologyRaceInfo(site.race)

				local digsite = {
					continent = mc,
					zoneId = zoneID,
					zoneName = mapIDToZoneName[mz] or _G.UNKNOWN,
					mapFile = mapFile,
					map = mz,
					level = fz,
					x = x,
					y = y,
					name = name,
					raceId = site.race,
					id = site.blob,
					distance = 999999,
				}
				table.insert(sites, digsite)
			end
		end
	end
	_G.SetMapByID(orig)
	return sites
end

local function UpdateSites()
	local sites

	for continent_id, continent_name in pairs{ _G.GetMapContinents() } do
		if not digsites[continent_id] then
			digsites[continent_id] = {}
		end
		sites = GetContinentSites(continent_id)

		if sites and #sites > 0 and continent_id == continentMapToID[playerContinent] then
			CompareAndResetDigCounters(digsites[continent_id], sites)
			CompareAndResetDigCounters(sites, digsites[continent_id])
		end

		if #sites > 0 then
			digsites[continent_id] = sites
		end
	end
end

function Archy:IsSiteBlacklisted(name)
	return blacklisted_sites[name]
end

function Archy:ToggleSiteBlacklist(name)
	blacklisted_sites[name] = not blacklisted_sites[name]
end

local function SortSitesByDistance(a, b)
	if Archy:IsSiteBlacklisted(a.name) and not Archy:IsSiteBlacklisted(b.name) then
		return 1 < 0
	elseif not Archy:IsSiteBlacklisted(a.name) and Archy:IsSiteBlacklisted(b.name) then
		return 0 < 1
	end

	if (a.distance == -1 and b.distance == -1) or (not a.distance and not b.distance) then
		return a.zoneName .. ":" .. a.name < b.zoneName .. ":" .. b.name
	else
		return (a.distance or 0) < (b.distance or 0)
	end
end

local function SortSitesByName(a, b)
	return a.zoneName .. ":" .. a.name < b.zoneName .. ":" .. b.name
end

function Archy:UpdateSiteDistances()
	if not digsites[continentMapToID[playerContinent]] or (#digsites[continentMapToID[playerContinent]] == 0) then
		nearestSite = nil
		return
	end
	local distance, nearest

	for index = 1, SITES_PER_CONTINENT do
		local site = digsites[continentMapToID[playerContinent]][index]

		if site.poi then
			site.distance = astrolabe:GetDistanceToIcon(site.poi)
		else
			site.distance = astrolabe:ComputeDistance(playerPosition.map, playerPosition.level, playerPosition.x, playerPosition.y, site.map, site.level, site.x, site.y)
		end
		if not Archy:IsSiteBlacklisted(site.name) then
			if not distance or site.distance < distance then
				distance = site.distance
				nearest = site
			end
		end
	end

	if nearest and (not nearestSite or nearestSite.id ~= nearest.id) then
		-- nearest dig site has changed
		nearestSite = nearest
		tomtomActive = true
		RefreshTomTom()
		UpdateSiteBlobs()
		UpdateMinimapPOIs()
		if db.digsite.announceNearest and db.general.show then
			AnnounceNearestSite()
		end
	end

	-- Sort sites
	local sites = digsites[continentMapToID[playerContinent]]
	if db.digsite.sortByDistance then
		table.sort(sites, SortSitesByDistance)
	else -- sort by zone then name
		table.sort(sites, SortSitesByName)
	end
end

function AnnounceNearestSite()
	if not nearestSite or not nearestSite.distance or nearestSite.distance == 999999 then
		return
	end
	local site_name = ("%s%s|r"):format(_G.GREEN_FONT_COLOR_CODE, nearestSite.name)
	local site_zone = ("%s%s|r"):format(_G.GREEN_FONT_COLOR_CODE, nearestSite.zoneName)

	Archy:Pour(L["Nearest Dig Site is: %s in %s (%.1f yards away)"]:format(site_name, site_zone, nearestSite.distance), 1, 1, 1)
end

local function UpdateSiteFrame(index)
end

function Archy:ImportOldStatsDB()
	for key, st in pairs(Archy.db.char.digsites) do
		if key ~= "blacklist" and key ~= "stats" and key ~= "counter" and key ~= "" then
			if DIG_SITES[key] then
				local site = DIG_SITES[key]
				siteStats[site.blob].surveys = (siteStats[site.blob].surveys or 0) + (st.surveys or 0)
				siteStats[site.blob].fragments = (siteStats[site.blob].fragments or 0) + (st.fragments or 0)
				siteStats[site.blob].looted = (siteStats[site.blob].looted or 0) + (st.looted or 0)
				siteStats[site.blob].keystones = (siteStats[site.blob].keystones or 0) + (st.keystones or 0)
				Archy.db.char.digsites[key] = nil
			end
		end
	end
end




--[[ Survey Functions ]] --
local function AddSurveyNode(siteId, map, level, x, y)
	local newNode = {
		m = map,
		f = level,
		x = x,
		y = y
	}
	local exists = false

	if not Archy.db.global.surveyNodes then
		Archy.db.global.surveyNodes = {}
	end

	if not Archy.db.global.surveyNodes[siteId] then
		Archy.db.global.surveyNodes[siteId] = {}
	end

	for _, node in pairs(Archy.db.global.surveyNodes[siteId]) do
		local distance = astrolabe:ComputeDistance(newNode.m, newNode.f, newNode.x, newNode.y, node.m, node.f, node.x, node.y)

		if not distance or _G.IsInInstance() then
			distance = 0
		end

		if distance <= 10 then
			exists = true
			break
		end
	end
	if not exists then
		table.insert(Archy.db.global.surveyNodes[siteId], newNode)
	end
end

function Archy:InjectSurveyNode(siteId, map, level, x, y)
	local newNode = {
		m = map,
		f = level,
		x = x,
		y = y
	}
	local exists = false

	if not Archy.db.global.surveyNodes then
		Archy.db.global.surveyNodes = {}
	end

	if not Archy.db.global.surveyNodes[siteId] then
		Archy.db.global.surveyNodes[siteId] = {}
	end

	for _, node in pairs(Archy.db.global.surveyNodes[siteId]) do
		local distance = astrolabe:ComputeDistance(newNode.m, newNode.f, newNode.x, newNode.y, node.m, node.f, node.x, node.y)
		if not distance then
			distance = 0
		end

		if distance <= 10 then
			exists = true
			break
		end
	end
	if not exists then
		table.insert(Archy.db.global.surveyNodes[siteId], newNode)
	end
end

function Archy:ClearSurveyNodeDB()
	Archy.db.global.surveyNodes = {}
	collectgarbage('collect')
end

function ToggleDistanceIndicator()
	if IsTaintable() then
		return
	end

	if not db.digsite.distanceIndicator.enabled or ShouldBeHidden() then
		distanceIndicatorFrame:Hide()
		return
	end
	distanceIndicatorFrame:Show()

	if distanceIndicatorActive then
		distanceIndicatorFrame.circle:SetAlpha(1) else distanceIndicatorFrame.circle:SetAlpha(0)
	end

	if db.digsite.distanceIndicator.showSurveyButton then
		distanceIndicatorFrame.surveyButton:Show()
		distanceIndicatorFrame:SetWidth(52 + distanceIndicatorFrame.surveyButton:GetWidth())
	else
		distanceIndicatorFrame.surveyButton:Hide()
		distanceIndicatorFrame:SetWidth(42)
	end
end

local DISTANCE_COLOR_TEXCOORDS = {
	green = {
		0, 0.24609375, 0, 1
	},
	yellow = {
		0.24609375, 0.5, 0, 1
	},
	red = {
		0.5, 0.75, 0, 1
	},
}
local function SetDistanceIndicatorColor(color)
	distanceIndicatorFrame.circle.texture:SetTexCoord(unpack(DISTANCE_COLOR_TEXCOORDS[color]))
	distanceIndicatorFrame.circle:SetAlpha(1)
	ToggleDistanceIndicator()
end

local function UpdateDistanceIndicator()
	if survey_location.x == 0 and survey_location.y == 0 or _G.IsInInstance() then
		return
	end
	local distance = astrolabe:ComputeDistance(playerPosition.map, playerPosition.level, playerPosition.x, playerPosition.y, survey_location.map, survey_location.level, survey_location.x, survey_location.y)

	if not distance then
		distance = 0
	end
	local greenMin, greenMax = 0, db.digsite.distanceIndicator.green
	local yellowMin, yellowMax = greenMax, db.digsite.distanceIndicator.yellow
	local redMin, redMax = yellowMax, 500

	if distance >= greenMin and distance <= greenMax then
		SetDistanceIndicatorColor("green")
	elseif distance >= yellowMin and distance <= yellowMax then
		SetDistanceIndicatorColor("yellow")
	elseif distance >= redMin and distance <= redMax then
		SetDistanceIndicatorColor("red")
	else
		ToggleDistanceIndicator()
		return
	end
	distanceIndicatorFrame.circle.distance:SetFormattedText("%1.f", distance)
end


--[[ Minimap Functions ]] --
local sitePool = {}
local surveyPool = {}
local allPois = {}
local sitePoiCount, surveyPoiCount = 0, 0

local function GetSitePOI(siteId, map, level, x, y, tooltip)
	local poi = table.remove(sitePool)

	if not poi then
		sitePoiCount = sitePoiCount + 1
		poi = _G.CreateFrame("Frame", "ArchyMinimap_SitePOI" .. sitePoiCount, _G.Minimap)
		poi.index = sitePoiCount
		poi:SetWidth(10)
		poi:SetHeight(10)

		table.insert(allPois, poi)

		poi.icon = poi:CreateTexture("BACKGROUND")
		poi.icon:SetTexture([[Interface\Archeology\Arch-Icon-Marker.blp]])
		poi.icon:SetPoint("CENTER", 0, 0)
		poi.icon:SetHeight(14)
		poi.icon:SetWidth(14)
		poi.icon:Hide()

		poi.arrow = poi:CreateTexture("BACKGROUND")
		poi.arrow:SetTexture([[Interface\Minimap\ROTATING-MINIMAPGUIDEARROW.tga]])
		poi.arrow:SetPoint("CENTER", 0, 0)
		poi.arrow:SetWidth(32)
		poi.arrow:SetHeight(32)
		poi.arrow:Hide()
		poi:Hide()
	end
	poi:SetScript("OnEnter", POI_OnEnter)
	poi:SetScript("OnLeave", POI_OnLeave)
	poi:SetScript("OnUpdate", Arrow_OnUpdate)
	poi.type = "site"
	poi.tooltip = tooltip
	poi.location = {
		map,
		level,
		x,
		y
	}
	poi.active = true
	poi.siteId = siteId
	poi.t = 0
	return poi
end

local function ClearSitePOI(poi)
	if not poi then
		return
	end
	astrolabe:RemoveIconFromMinimap(poi)
	poi.icon:Hide()
	poi.arrow:Hide()
	poi:Hide()
	poi.active = false
	poi.tooltip = nil
	poi.location = nil
	poi.siteId = nil
	poi:SetScript("OnEnter", nil)
	poi:SetScript("OnLeave", nil)
	poi:SetScript("OnUpdate", nil)
	table.insert(sitePool, poi)
end

local function GetSurveyPOI(siteId, map, level, x, y, tooltip)
	local poi = table.remove(surveyPool)

	if not poi then
		surveyPoiCount = surveyPoiCount + 1
		poi = _G.CreateFrame("Frame", "ArchyMinimap_SurveyPOI" .. surveyPoiCount, _G.Minimap)
		poi.index = surveyPoiCount
		poi:SetWidth(8)
		poi:SetHeight(8)

		table.insert(allPois, poi)

		poi.icon = poi:CreateTexture("BACKGROUND")
		poi.icon:SetTexture([[Interface\AddOns\Archy\Media\Nodes]])

		if db.minimap.fragmentIcon == "Cross" then
			poi.icon:SetTexCoord(0, 0.46875, 0, 0.453125)
		else
			poi.icon:SetTexCoord(0, 0.234375, 0.5, 0.734375)
		end
		poi.icon:SetPoint("CENTER", 0, 0)
		poi.icon:SetHeight(8)
		poi.icon:SetWidth(8)
		poi.icon:Hide()

		poi:Hide()
	end
	poi:SetScript("OnEnter", POI_OnEnter)
	poi:SetScript("OnLeave", POI_OnLeave)
	poi:SetScript("OnUpdate", Arrow_OnUpdate)
	poi.type = "survey"
	poi.tooltip = tooltip
	poi.location = {
		map,
		level,
		x,
		y
	}
	poi.active = true
	poi.siteId = siteId
	poi.t = 0
	return poi
end

local function ClearSurveyPOI(poi)
	if not poi then
		return
	end
	astrolabe:RemoveIconFromMinimap(poi)
	poi.icon:Hide()
	poi:Hide()
	poi.active = nil
	poi.tooltip = nil
	poi.siteId = nil
	poi.location = nil
	poi:SetScript("OnEnter", nil)
	poi:SetScript("OnLeave", nil)
	poi:SetScript("OnUpdate", nil)
	table.insert(surveyPool, poi)
end

-- TODO: Figure out if this should be used somewhere - it currently is not, and should maybe be removed.
local function CreateMinimapPOI(index, type, loc, title, siteId)
	local poi = pois[index]
	local poiButton = _G.CreateFrame("Frame", nil, poi)
	poiButton.texture = poiButton:CreateTexture(nil, "OVERLAY")

	if type == "site" then
		poi.useArrow = true
		poiButton.texture:SetTexture([[Interface\Archeology\Arch-Icon-Marker.blp]])
		poiButton:SetWidth(14)
		poiButton:SetHeight(14)
	else
		poi.useArrow = false
		poiButton.texture:SetTexture([[Interface\AddOns\Archy\Media\Nodes]])
		if db.minimap.fragmentIcon == "Cross" then
			poiButton.texture:SetTexCoord(0, 0.46875, 0, 0.453125)
		else
			poiButton.texture:SetTexCoord(0, 0.234375, 0.5, 0.734375)
		end
		poiButton:SetWidth(8)
		poiButton:SetHeight(8)
	end
	poiButton.texture:SetAllPoints(poiButton)
	poiButton:SetPoint("CENTER", poi)
	poiButton:SetScale(1)
	poiButton:SetParent(poi)
	poiButton:EnableMouse(false)
	poi.poiButton = poiButton
	poi.index = index
	poi.type = type
	poi.title = title
	poi.location = loc
	poi.active = true
	poi.siteId = siteId
	pois[index] = poi
	return poi
end

function UpdateMinimapEdges()
	for id, poi in pairs(allPois) do
		if poi.active then
			local edge = astrolabe:IsIconOnEdge(poi)
			if poi.type == "site" then
				if edge then
					poi.icon:Hide()
					poi.arrow:Show()
				else
					poi.icon:Show()
					poi.arrow:Hide()
				end
			else
				if edge then
					poi.icon:Hide()
					poi:Hide()
				else
					poi.icon:Show()
					poi:Show()
				end
			end
		end
	end
end

local lastNearestSite

local function GetContinentSiteIDs()
	local validSiteIDs = {}

	if db.general.show and db.minimap.show then
		return validSiteIDs
	end

	if digsites[continentMapToID[playerContinent]] then
		for _, site in pairs(digsites[continentMapToID[playerContinent]]) do
			table.insert(validSiteIDs, site.id)
		end
	end
	return validSiteIDs
end

local function ClearAllPOIs()
	for idx, poi in ipairs(allPois) do
		if poi.type == "site" then
			ClearSitePOI(poi)
		elseif poi.type == "survey" then
			ClearSurveyPOI(poi)
		end
	end
end

local function ClearInvalidPOIs()
	local validSiteIDs = GetContinentSiteIDs()

	for idx, poi in ipairs(allPois) do
		if not validSiteIDs[poi.siteId] then
			if poi.type == "site" then
				ClearSitePOI(poi)
			else
				ClearSurveyPOI(poi)
			end
		elseif poi.type == "survey" and lastNearestSite.id ~= nearestSite.id and lastNearestSite.id == poi.siteId then
			ClearSurveyPOI(poi)
		end
	end
end

function UpdateMinimapPOIs(force)
	if _G.WorldMapButton:IsVisible() then
		return
	end

	if lastNearestSite ~= nearestSite or force then
		lastNearestSite = nearestSite
		local validSiteIDs = GetContinentSiteIDs()
		local sites = digsites[continentMapToID[playerContinent]]

		if not sites or #sites == 0 or _G.IsInInstance() then
			ClearAllPOIs()
			return
		else
			ClearInvalidPOIs()
		end

		if not playerPosition.x and not playerPosition.y then
			return
		end
		local i = 1

		for _, site in pairs(sites) do
			site.poi = GetSitePOI(site.id, site.map, site.level, site.x, site.y, ("%s\n(%s)"):format(site.name, site.zoneName))
			site.poi.active = true

			astrolabe:PlaceIconOnMinimap(site.poi, site.map, site.level, site.x, site.y)

			if ((not db.minimap.nearest) or (nearestSite and nearestSite.id == site.id)) and db.general.show and db.minimap.show then
				site.poi:Show()
				site.poi.icon:Show()
			else
				site.poi:Hide()
				site.poi.icon:Hide()
			end

			if nearestSite and nearestSite.id == site.id then
				if not site.surveyPOIs then
					site.surveyPOIs = {}
				end

				if Archy.db.global.surveyNodes[site.id] and db.minimap.fragmentNodes then
					for index, node in pairs(Archy.db.global.surveyNodes[site.id]) do
						site.surveyPOIs[index] = GetSurveyPOI(site.id, node.m, node.f, node.x, node.y, ("%s #%d\n%s\n(%s)"):format(L["Survey"], index, site.name, site.zoneName))

						local POI = site.surveyPOIs[index]
						POI.active = true

						astrolabe:PlaceIconOnMinimap(POI, node.m, node.f, node.x, node.y)

						if db.general.show then
							POI:Show()
							POI.icon:Show()
						else
							POI:Hide()
							POI.icon:Hide()
						end
						Arrow_OnUpdate(POI, 5)
					end
				end
			end

			Arrow_OnUpdate(site.poi, 5)
		end
		--UpdateMinimapEdges()
		if db.minimap.fragmentColorBySurveyDistance and db.minimap.fragmentIcon ~= "CyanDot" then
			for id, poi in pairs(allPois) do
				if poi.active and poi.type == "survey" then
					poi.icon:SetTexCoord(0, 0.234375, 0.5, 0.734375)
				end
			end
		end
		-- print("Calling collectgarbage for UpdateMinimapPOIs(force = ", force,")")
		collectgarbage('collect')
	else
		--        if lastNearestSite then UpdateMinimapEdges() end
	end
end

function POI_OnEnter(self)
	if not self.tooltip then
		return
	end
	_G.GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
	_G.GameTooltip:SetText(self.tooltip, _G.NORMAL_FONT_COLOR[1], _G.NORMAL_FONT_COLOR[2], _G.NORMAL_FONT_COLOR[3], 1) --, true)
end

function POI_OnLeave(self)
	_G.GameTooltip:Hide()
end

local square_half = math.sqrt(0.5)
local rad_135 = math.rad(135)
local update_threshold = 0.1
function Arrow_OnUpdate(self, elapsed)
	self.t = self.t + elapsed
	if self.t < update_threshold then
		return
	end
	self.t = 0

	if _G.IsInInstance() then
		self:Hide()
		return
	end

	if not self.active then
		return
	end

	local edge = astrolabe:IsIconOnEdge(self)

	if self.type == "site" then
		if edge then
			if self.icon:IsShown() then self.icon:Hide() end
			if not self.arrow:IsShown() then self.arrow:Show() end

			-- Rotate the icon, as required
			local angle = astrolabe:GetDirectionToIcon(self)
			angle = angle + rad_135

			if _G.GetCVar("rotateMinimap") == "1" then
				--local cring = MiniMapCompassRing:GetFacing()
				local cring = _G.GetPlayerFacing()
				angle = angle - cring
			end

			local sin, cos = math.sin(angle) * square_half, math.cos(angle) * square_half
			self.arrow:SetTexCoord(0.5 - sin, 0.5 + cos, 0.5 + cos, 0.5 + sin, 0.5 - cos, 0.5 - sin, 0.5 + sin, 0.5 - cos)
		else
			if not self.icon:IsShown() then self.icon:Show() end
			if self.arrow:IsShown() then self.arrow:Hide() end
		end
	else
		if edge then
			if self.icon:IsShown() then self.icon:Hide() end
		else
			if not self.icon:IsShown() then self.icon:Show() end
		end
	end
end

--[[ Blob Functions ]] --
function RefreshBlobInfo(f)
	f:DrawNone()
	local numEntries = _G.ArchaeologyMapUpdateAll()

	for i = 1, numEntries do
		local blobID = _G.ArcheologyGetVisibleBlobID(i)
		f:DrawBlob(blobID, true)
	end
end

function MinimapBlobSetPositionAndSize(f)
	if not f or not playerPosition.x or not playerPosition.y then
		return
	end
	local dx = (playerPosition.x - 0.5) * f:GetWidth()
	local dy = (playerPosition.y - 0.5) * f:GetHeight()
	f:ClearAllPoints()
	f:SetPoint("CENTER", _G.Minimap, "CENTER", -dx, dy)

	local mapWidth = f:GetParent():GetWidth()
	local mapHeight = f:GetParent():GetHeight()
	local mapSizePix = math.min(mapWidth, mapHeight)

	local indoors = _G.GetCVar("minimapZoom") + 0 == _G.Minimap:GetZoom() and "outdoor" or "indoor"
	local zoom = _G.Minimap:GetZoom()
	local mapSizeYards = minimapSize[indoors][zoom]

	if not playerPosition.map or playerPosition.map == -1 then
		return
	end

	local _, _, yw, yh, _, _ = astrolabe:GetMapInfo(playerPosition.map, playerPosition.level)
	local pw = yw * mapSizePix / mapSizeYards
	local ph = yh * mapSizePix / mapSizeYards

	if pw == old_pw and ph == oldph then
		return
	end
	old_pw, old_ph = pw, ph

	f:SetSize(pw, ph)

	f:SetFillAlpha(256 * db.minimap.blobAlpha)
	--    f:SetFrameStrata("LOW")
	--    f:SetFrameLevel(f:GetParent():GetFrameLevel() + 7)
end

function UpdateSiteBlobs()
	if IsTaintable() then
		return
	end

	if _G.BattlefieldMinimap then
		if db.minimap.zoneBlob and db.general.show and not _G.IsInInstance() then
			local blob = blobs["Battlefield"]
			if blob:GetParent() ~= _G.BattlefieldMinimap then -- set the battlefield map parent
				blob:SetParent(_G.BattlefieldMinimap)
				blob:ClearAllPoints()
				blob:SetAllPoints(_G.BattlefieldMinimap)
				blob:SetFrameLevel(_G.BattlefieldMinimap:GetFrameLevel() + 2)
			end
			RefreshBlobInfo(blob)
			if not blob:IsShown() then blob:Show() end
		elseif blobs["Battlefield"]:IsShown() then
			blobs["Battlefield"]:Hide()
		end
	end

	if db.minimap.show and db.minimap.blob and db.general.show and not _G.IsInInstance() then
		local blob = blobs["Minimap"]

		if blob:GetParent() ~= _G.Minimap then -- set the minimap parent
			blob:SetParent(_G.Minimap)
			blob:SetFrameLevel(_G.Minimap:GetFrameLevel() + 2)
		end

		if (db.minimap.useBlobDistance and nearestSite and nearestSite.distance and (nearestSite.distance > db.minimap.blobDistance)) then
			if blob:IsShown() then blob:Hide() end
			return
		end

		RefreshBlobInfo(blob)
		MinimapBlobSetPositionAndSize(blob)

		if not blob:IsShown() then
			blob:Show()
		end
	elseif blobs["Minimap"]:IsShown() then
		blobs["Minimap"]:Hide()
	end
end


--[[ TomTom Functions ]] --
-- clear the waypoint we gave tomtom
function ClearTomTomPoint()
	if not tomtomPoint then
		return
	end
	tomtomPoint = _G.TomTom:RemoveWaypoint(tomtomPoint)
end

function UpdateTomTomPoint()
	if not tomtomSite and not nearestSite then
		-- we have no information to pass tomtom
		ClearTomTomPoint()
		return
	end

	if nearestSite then
		tomtomSite = nearestSite
	else
		nearestSite = tomtomSite
	end

	if not tomtomFrame then
		tomtomFrame = _G.CreateFrame("Frame")
	end

	if not tomtomFrame:IsShown() then
		tomtomFrame:Show()
	end
	local waypointExists

	if _G.TomTom.WaypointExists then -- do we have the legit TomTom?
		waypointExists = _G.TomTom:WaypointExists(continentMapToID[tomtomSite.continent], tomtomSite.zoneId, tomtomSite.x * 100, tomtomSite.y * 100, tomtomSite.name .. "\n" .. tomtomSite.zoneName)
	end

	if not waypointExists then -- waypoint doesn't exist or we have a TomTom emulator
		ClearTomTomPoint()
		tomtomPoint = _G.TomTom:AddZWaypoint(continentMapToID[tomtomSite.continent], tomtomSite.zoneId, tomtomSite.x * 100, tomtomSite.y * 100, tomtomSite.name .. "\n" .. tomtomSite.zoneName, false, false, false, false, false, true)
	end
end

function RefreshTomTom()
	if db.general.show and db.tomtom.enabled and tomtomExists and tomtomActive then
		UpdateTomTomPoint()
	else
		if db.tomtom.enabled and not tomtomExists then
			-- TomTom (or emulator) was disabled, disabling TomTom support
			db.tomtom.enabled = false
			Archy:Print("TomTom doesn't exist... disabling it")
		end

		if tomtomPoint then
			ClearTomTomPoint()
			tomtomPoint = nil
		end

		if tomtomFrame then
			if tomtomFrame:IsShown() then
				tomtomFrame:Hide()
			end
			tomtomFrame = nil
		end
	end
end

--[[ LibDataBroker functions ]] --
local myProvider, cellPrototype = qtip:CreateCellProvider()
function cellPrototype:InitializeCell()
	local bar = self:CreateTexture(nil, "OVERLAY", self)
	self.bar = bar
	bar:SetWidth(100)
	bar:SetHeight(12)
	bar:SetPoint("LEFT", self, "LEFT", 1, 0)

	local bg = self:CreateTexture(nil, "BACKGROUND")
	self.bg = bg
	bg:SetWidth(102)
	bg:SetHeight(14)
	bg:SetTexture(0, 0, 0, 0.5)
	bg:SetPoint("LEFT", self)

	local fs = self:CreateFontString(nil, "OVERLAY")
	self.fs = fs
	fs:SetAllPoints(self)
	fs:SetFontObject(_G.GameTooltipText)
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(1, -1)
	self.r, self.g, self.b = 1, 1, 1
end

function cellPrototype:SetupCell(tooltip, value, justification, font, r, g, b)
	local barTexture = [[Interface\TargetingFrame\UI-StatusBar]]
	local bar = self.bar
	local fs = self.fs
	--[[    {
    1 artifact.fragments,
    2 artifact.fragAdjust,
    3 artifact.fragTotal,
    4 raceData[rid].keystone.inventory,
    5 artifact.sockets,
    6 artifact.stonesAdded,
    7 artifact.canSolve,
    8 artifact.canSolveStone,
    9 artifact.rare }
]]

	local perc = math.min((value[1] + value[2]) / value[3] * 100, 100)

	if value[7] then
		self.r, self.g, self.b = db.artifact.fragmentBarColors["Solvable"].r, db.artifact.fragmentBarColors["Solvable"].g, db.artifact.fragmentBarColors["Solvable"].b
	elseif value[8] then
		self.r, self.g, self.b = db.artifact.fragmentBarColors["AttachToSolve"].r, db.artifact.fragmentBarColors["AttachToSolve"].g, db.artifact.fragmentBarColors["AttachToSolve"].b
	elseif value[9] then
		self.r, self.g, self.b = db.artifact.fragmentBarColors["Rare"].r, db.artifact.fragmentBarColors["Rare"].g, db.artifact.fragmentBarColors["Rare"].b
	else
		self.r, self.g, self.b = db.artifact.fragmentBarColors["Normal"].r, db.artifact.fragmentBarColors["Normal"].g, db.artifact.fragmentBarColors["Normal"].b
	end
	bar:SetVertexColor(self.r, self.g, self.b)
	bar:SetWidth(perc)
	bar:SetTexture(barTexture)
	bar:Show()
	fs:SetFontObject(font or tooltip:GetFont())
	fs:SetJustifyH("CENTER")
	fs:SetTextColor(1, 1, 1)

	local adjust = ""
	if value[2] > 0 then
		adjust = "(+" .. tostring(value[2]) .. ")"
	end

	fs:SetFormattedText("%d%s / %d", value[1], adjust, value[3])
	fs:Show()

	return bar:GetWidth() + 2, bar:GetHeight() + 2
end

function cellPrototype:ReleaseCell()
	self.r, self.g, self.b = 1, 1, 1
end

function cellPrototype:getContentHeight()
	return self.bar:GetHeight() + 2
end

local progress_data = {}

function ldb:OnEnter()
	local numCols, colIndex, line = 10, 0, 0
	local tooltip = qtip:Acquire("ArchyTooltip", numCols, "CENTER", "LEFT", "LEFT", "LEFT", "RIGHT", "RIGHT", "RIGHT", "RIGHT", "RIGHT")
	tooltip:SetScale(1)
	tooltip:SetAutoHideDelay(0.25, self)
	tooltip:EnableMouse()
	tooltip:SmartAnchorTo(self)
	tooltip:Hide()
	tooltip:Clear()

	local line = tooltip:AddHeader(".")
	tooltip:SetCell(line, 1, ("%s%s%s"):format(_G.ORANGE_FONT_COLOR_CODE, "Archy", "|r"), "CENTER", numCols)

	if HasArchaeology() then
		line = tooltip:AddLine(".")
		local rank, maxRank = GetArchaeologyRank()
		local skill = ("%d/%d"):format(rank, maxRank)

		if maxRank < MAX_ARCHAEOLOGY_RANK and (maxRank - rank) <= 25 then
			skill = ("%s - |cFFFF0000%s|r"):format(skill, L["Visit a trainer!"])
		elseif maxRank == MAX_ARCHAEOLOGY_RANK and rank == maxRank then
			skill = ("%s%s|r"):format(_G.GREEN_FONT_COLOR_CODE, "MAX")
		end
		tooltip:SetCell(line, 1, ("%s%s|r%s"):format(_G.NORMAL_FONT_COLOR_CODE, _G.SKILL .. ": ", skill), "CENTER", numCols)

		line = tooltip:AddLine(".")
		tooltip:SetCell(line, 1, ("%s%s|r"):format("|cFFFFFF00", L["Artifacts"]), "LEFT", numCols)
		tooltip:AddSeparator()

		line = tooltip:AddLine(".")
		tooltip:SetCell(line, 1, " ", "LEFT", 1)
		tooltip:SetCell(line, 2, _G.NORMAL_FONT_COLOR_CODE .. _G.RACE .. "|r", "LEFT", 1)
		tooltip:SetCell(line, 3, " ", "LEFT", 1)
		tooltip:SetCell(line, 4, _G.NORMAL_FONT_COLOR_CODE .. L["Artifact"] .. "|r", "LEFT", 2)
		tooltip:SetCell(line, 6, _G.NORMAL_FONT_COLOR_CODE .. L["Progress"] .. "|r", "CENTER", 1)
		tooltip:SetCell(line, 7, _G.NORMAL_FONT_COLOR_CODE .. L["Keys"] .. "|r", "CENTER", 1)
		tooltip:SetCell(line, 8, _G.NORMAL_FONT_COLOR_CODE .. L["Sockets"] .. "|r", "CENTER", 1)
		tooltip:SetCell(line, 9, _G.NORMAL_FONT_COLOR_CODE .. L["Completed"] .. "|r", "CENTER", 2)

		for rid, artifact in pairs(artifacts) do
			if artifact.fragTotal > 0 then
				line = tooltip:AddLine(" ")
				tooltip:SetCell(line, 1, " " .. ("|T%s:18:18:0:1:128:128:4:60:4:60|t"):format(raceData[rid].texture), "LEFT", 1)
				tooltip:SetCell(line, 2, raceData[rid].name, "LEFT", 1)
				tooltip:SetCell(line, 3, " " .. ("|T%s:18:18|t"):format(artifact.icon), "LEFT", 1)

				local artifactName = artifact.name

				if artifact.rare then
					artifactName = ("%s%s|r"):format("|cFF0070DD", artifactName)
				end

				tooltip:SetCell(line, 4, artifactName, "LEFT", 2)

				progress_data[1] = artifact.fragments
				progress_data[2] = artifact.fragAdjust
				progress_data[3] = artifact.fragTotal
				progress_data[4] = raceData[rid].keystone.inventory
				progress_data[5] = artifact.sockets
				progress_data[6] = artifact.stonesAdded
				progress_data[7] = artifact.canSolve
				progress_data[8] = artifact.canSolveStone
				progress_data[9] = artifact.rare

				tooltip:SetCell(line, 6, progress_data, myProvider, 1, 0, 0)
				tooltip:SetCell(line, 7, (raceData[rid].keystone.inventory > 0) and raceData[rid].keystone.inventory or "", "CENTER", 1)
				tooltip:SetCell(line, 8, (artifact.sockets > 0) and artifact.sockets or "", "CENTER", 1)

				local _, _, completionCount = GetArtifactStats(rid, artifact.name)
				tooltip:SetCell(line, 9, (completionCount or "unknown"), "CENTER", 2)
			end
		end

		line = tooltip:AddLine(" ")
		line = tooltip:AddLine(" ")
		tooltip:SetCell(line, 1, ("%s%s|r"):format("|cFFFFFF00", L["Dig Sites"]), "LEFT", numCols)
		tooltip:AddSeparator()

		for cid, csites in pairs(digsites) do
			if (#csites > 0) and (cid == continentMapToID[playerContinent] or not db.digsite.filterLDB) then
				local continentName
				for _, zone in pairs(zoneData) do
					if zone.continent == cid and zone.id == 0 then
						continentName = zone.name
						break
					end
				end
				line = tooltip:AddLine(" ")
				tooltip:SetCell(line, 1, "  " .. _G.ORANGE_FONT_COLOR_CODE .. continentName .. "|r", "LEFT", numCols)

				line = tooltip:AddLine(" ")
				tooltip:SetCell(line, 1, " ", "LEFT", 1)
				tooltip:SetCell(line, 2, _G.NORMAL_FONT_COLOR_CODE .. L["Fragment"] .. "|r", "LEFT", 2)
				tooltip:SetCell(line, 4, _G.NORMAL_FONT_COLOR_CODE .. L["Dig Site"] .. "|r", "LEFT", 1)
				tooltip:SetCell(line, 5, _G.NORMAL_FONT_COLOR_CODE .. _G.ZONE .. "|r", "LEFT", 2)
				tooltip:SetCell(line, 7, _G.NORMAL_FONT_COLOR_CODE .. L["Surveys"] .. "|r", "CENTER", 1)
				tooltip:SetCell(line, 8, _G.NORMAL_FONT_COLOR_CODE .. L["Digs"] .. "|r", "CENTER", 1)
				tooltip:SetCell(line, 9, _G.NORMAL_FONT_COLOR_CODE .. _G.ARCHAEOLOGY_RUNE_STONES .. "|r", "CENTER", 1)
				tooltip:SetCell(line, 10, _G.NORMAL_FONT_COLOR_CODE .. L["Keys"] .. "|r", "CENTER", 1)

				for _, site in pairs(csites) do
					line = tooltip:AddLine(" ")
					tooltip:SetCell(line, 1, " " .. ("|T%s:18:18:0:1:128:128:4:60:4:60|t"):format(raceData[site.raceId].texture), "LEFT", 1)
					tooltip:SetCell(line, 2, raceData[site.raceId].name, "LEFT", 2)
					tooltip:SetCell(line, 4, site.name, "LEFT", 1)
					tooltip:SetCell(line, 5, site.zoneName, "LEFT", 2)
					tooltip:SetCell(line, 7, siteStats[site.id].surveys, "CENTER", 1)
					tooltip:SetCell(line, 8, siteStats[site.id].looted, "CENTER", 1)
					tooltip:SetCell(line, 9, siteStats[site.id].fragments, "CENTER", 1)
					tooltip:SetCell(line, 10, siteStats[site.id].keystones, "CENTER", 1)
				end
				line = tooltip:AddLine(" ")
			end
		end
	else
		line = tooltip:AddLine(" ")
		tooltip:SetCell(line, 1, L["Learn Archaeology in your nearest major city!"], "CENTER", numCols)
	end

	line = tooltip:AddLine(" ")
	line = tooltip:AddLine(" ") tooltip:SetCell(line, 1, "|cFF00FF00" .. L["Left-Click to toggle Archy"] .. "|r", "LEFT", numCols)
	line = tooltip:AddLine(" ") tooltip:SetCell(line, 1, "|cFF00FF00" .. L["Shift Left-Click to toggle Archy's on-screen lists"] .. "|r", "LEFT", numCols)
	line = tooltip:AddLine(" ") tooltip:SetCell(line, 1, "|cFF00FF00" .. L["Right-Click to lock/unlock Archy"] .. "|r", "LEFT", numCols)
	line = tooltip:AddLine(" ") tooltip:SetCell(line, 1, "|cFF00FF00" .. L["Middle-Click to display the Archaeology window"] .. "|r", "LEFT", numCols)

	tooltip:UpdateScrolling()
	tooltip:Show()
end

function ldb:OnLeave()
end

function ldb:OnClick(button, down)
	if button == "LeftButton" and _G.IsShiftKeyDown() then
		db.general.stealthMode = not db.general.stealthMode
		Archy:ConfigUpdated()
	elseif button == "LeftButton" and _G.IsControlKeyDown() then
		_G.InterfaceOptionsFrame_OpenToCategory(Archy.optionsFrame)
	elseif button == "LeftButton" then
		db.general.show = not db.general.show
		Archy:ConfigUpdated()
		ToggleDistanceIndicator()
	elseif button == "RightButton" then
		ToggleLock()
	elseif button == "MiddleButton" then
		Archy:ShowArchaeology()
	end
end


--[[ Slash command handler ]] --
local function SlashHandler(msg, editbox)
	local command = msg:lower()

	if command == L["config"]:lower() then
		_G.InterfaceOptionsFrame_OpenToCategory(Archy.optionsFrame)
	elseif command == L["stealth"]:lower() then
		db.general.stealthMode = not db.general.stealthMode
		Archy:ConfigUpdated()
	elseif command == L["dig sites"]:lower() then
		db.digsite.show = not db.digsite.show
		Archy:ConfigUpdated('digsite')
	elseif command == L["artifacts"]:lower() then
		db.artifact.show = not db.artifact.show
		Archy:ConfigUpdated('artifact')
	elseif command == _G.SOLVE:lower() then
		Archy:SolveAnyArtifact()
	elseif command == L["solve stone"]:lower() then
		Archy:SolveAnyArtifact(true)
	elseif command == L["nearest"]:lower() or command == L["closest"]:lower() then
		AnnounceNearestSite()
	elseif command == L["reset"]:lower() then
		ResetPositions()
	elseif command == ("TomTom"):lower() then
		db.tomtom.enabled = not db.tomtom.enabled
		RefreshTomTom()
	elseif command == _G.MINIMAP_LABEL:lower() then
		db.minimap.show = not db.minimap.show
		Archy:ConfigUpdated('minimap')
	elseif command == "test" then
		racesFrame:SetBackdropBorderColor(1, 1, 1, 0.5)
	else
		Archy:Print(L["Available commands are:"])
		Archy:Print("|cFF00FF00" .. L["config"] .. "|r - " .. L["Shows the Options"])
		Archy:Print("|cFF00FF00" .. L["stealth"] .. "|r - " .. L["Toggles the display of the Artifacts and Dig Sites lists"])
		Archy:Print("|cFF00FF00" .. L["dig sites"] .. "|r - " .. L["Toggles the display of the Dig Sites list"])
		Archy:Print("|cFF00FF00" .. L["artifacts"] .. "|r - " .. L["Toggles the display of the Artifacts list"])
		Archy:Print("|cFF00FF00" .. _G.SOLVE .. "|r - " .. L["Solves the first artifact it finds that it can solve"])
		Archy:Print("|cFF00FF00" .. L["solve stone"] .. "|r - " .. L["Solves the first artifact it finds that it can solve (including key stones)"])
		Archy:Print("|cFF00FF00" .. L["nearest"] .. "|r or |cFF00FF00" .. L["closest"] .. "|r - " .. L["Announces the nearest dig site to you"])
		Archy:Print("|cFF00FF00" .. L["reset"] .. "|r - " .. L["Reset the window positions to defaults"])
		Archy:Print("|cFF00FF00" .. "TomTom" .. "|r - " .. L["Toggles TomTom Integration"])
		Archy:Print("|cFF00FF00" .. _G.MINIMAP_LABEL .. "|r - " .. L["Toggles the dig site icons on the minimap"])
	end
end


--[[ AddOn Initialization ]] --
function Archy:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("ArchyDB", defaults, 'Default')
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileUpdate")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileUpdate")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileUpdate")

	local about_panel = LibStub:GetLibrary("LibAboutPanel", true)

	if about_panel then
		self.optionsFrame = about_panel.new(nil, "Archy")
	end

	self:SetSinkStorage(Archy.db.profile.general.sinkOptions)

	generalOptions.args.output = Archy:GetSinkAce3OptionsDataTable()
	generalOptions.args.output.guiInline = true
	generalOptions.args.output.name = L["Announcements Output"]

	LibStub("AceConfig-3.0"):RegisterOptionsTable("Archy General", generalOptions)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Archy Artifacts", artifactOptions)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Archy Dig Sites", digsiteOptions)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Archy TomTom", tomtomOptions)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Archy Minimap", minimapOptions)
	-- LibStub("AceConfig-3.0"):RegisterOptionsTable("Archy Data", archyDataOptions)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Archy Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db))

	local ACD = LibStub("AceConfigDialog-3.0")
	ACD:AddToBlizOptions("Archy General", _G.GENERAL_LABEL, "Archy")
	ACD:AddToBlizOptions("Archy Artifacts", L["Artifacts"], "Archy")
	ACD:AddToBlizOptions("Archy Dig Sites", L["Dig Sites"], "Archy")
	ACD:AddToBlizOptions("Archy TomTom", L["TomTom Support"], "Archy")
	ACD:AddToBlizOptions("Archy Minimap", _G.MINIMAP_LABEL, "Archy")
	-- ACD:AddToBlizOptions("Archy Data", L["Import Data"], "Archy")
	ACD:AddToBlizOptions("Archy Profiles", L["Profiles"], "Archy")

	if not Archy.db.global.surveyNodes then
		Archy.db.global.surveyNodes = {}
	end

	if not Archy.db.char.digsites then
		Archy.db.char.digsites = {
			stats = {},
			blacklist = {}
		}
	end

	siteStats = Archy.db.char.digsites.stats

	setmetatable(siteStats, {
		__index = function(t, k)
			if k then
				t[k] = {
					surveys = 0,
					fragments = 0,
					looted = 0,
					keystones = 0,
					counter = 0
				}
				return t[k]
			end
		end
	})

	blacklisted_sites = Archy.db.char.digsites.blacklist
	setmetatable(blacklisted_sites, {
		__index = function(t, k)
			if k then
				t[k] = false
				return t[k]
			end
		end
	})

	db = self.db.profile
	if not db.data then
		db.data = {}
	end
	db.data.imported = false

	digsiteFrame = _G.CreateFrame("Frame", "ArchyDigSiteFrame", _G.UIParent, (db.general.theme == "Graphical" and "ArchyDigSiteContainer" or "ArchyMinDigSiteContainer"))
	digsiteFrame.children = setmetatable({}, {
		__index = function(t, k)
			if k then
				local f = _G.CreateFrame("Frame", "ArchyDigSiteChildFrame" .. k, digsiteFrame, (db.general.theme == "Graphical" and "ArchyDigSiteRowTemplate" or "ArchyMinDigSiteRowTemplate"))
				f:Show()
				t[k] = f
				return f
			end
		end
	})
	racesFrame = _G.CreateFrame("Frame", "ArchyArtifactFrame", _G.UIParent, (db.general.theme == "Graphical" and "ArchyArtifactContainer" or "ArchyMinArtifactContainer"))
	racesFrame.children = setmetatable({}, {
		__index = function(t, k)
			if k then
				local f = _G.CreateFrame("Frame", "ArchyArtifactChildFrame" .. k, racesFrame, (db.general.theme == "Graphical" and "ArchyArtifactRowTemplate" or "ArchyMinArtifactRowTemplate"))
				f:Show()
				t[k] = f
				return f
			end
		end
	})

	distanceIndicatorFrame = _G.CreateFrame("Frame", "ArchyDistanceIndicatorFrame", _G.UIParent, "ArchyDistanceIndicator")
	local surveySpellName = _G.GetSpellInfo(80451)
	distanceIndicatorFrame.surveyButton:SetText(surveySpellName)
	distanceIndicatorFrame.surveyButton:SetWidth(distanceIndicatorFrame.surveyButton:GetTextWidth() + 20)
	distanceIndicatorFrame.circle:SetScale(0.65)

	self:UpdateFramePositions()

	LDBI:Register("Archy", ldb, db.general.icon)

	TrapWorldMouse()

	self:ImportOldStatsDB()
end

function Archy:UpdateFramePositions()
	self:SetFramePosition(distanceIndicatorFrame)
	self:SetFramePosition(digsiteFrame)
	self:SetFramePosition(racesFrame)
end

local timer_handle

function Archy:OnEnable()
	--@TODO Setup and register the options table

	_G["SLASH_ARCHY1"] = "/archy"
	_G.SlashCmdList["ARCHY"] = SlashHandler
	--self:SecureHook("SetCVar")

	self:RegisterEvent("ARTIFACT_HISTORY_READY", "ArtifactHistoryReady")
	--    self:RegisterEvent("ARTIFACT_UPDATE", "ArtifactUpdated")
	self:RegisterEvent("LOOT_OPENED", "OnPlayerLooting")
	self:RegisterEvent("LOOT_CLOSED", "OnPlayerLooting")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnPlayerLogin")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CombatStateChanged")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CombatStateChanged")
	self:RegisterEvent("ARTIFACT_COMPLETE", "ArtifactCompleted")
	self:RegisterEvent("ARTIFACT_DIG_SITE_UPDATED", "DigSitesUpdated")
	self:RegisterEvent("BAG_UPDATE", "BagUpdated")
	self:RegisterEvent("SKILL_LINES_CHANGED", "SkillLinesChanged")
	self:RegisterEvent("CHAT_MSG_LOOT", "LootReceived")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "PlayerCastSurvey")
	self:RegisterEvent("CURRENCY_DISPLAY_UPDATE", "CurrencyUpdated")

	self:ScheduleTimer("UpdatePlayerPosition", 1, true)
	self:ScheduleTimer("UpdateDigSiteFrame", 1)
	self:ScheduleTimer("UpdateRacesFrame", 1)
	self:ScheduleTimer("RefreshAll", 1)

	timer_handle = self:ScheduleRepeatingTimer("UpdatePlayerPosition", 0.1)

	db.general.locked = false

	Archy:UpdateDigSiteFrame()
	Archy:UpdateRacesFrame()
	ToggleDistanceIndicator()
	tomtomActive = true
	tomtomExists = (_G.TomTom and _G.TomTom.AddZWaypoint and _G.TomTom.RemoveWaypoint) and true or false
	self:CheckForMinimapAddons()
end

function Archy:CheckForMinimapAddons()
	local mbf = LibStub("AceAddon-3.0"):GetAddon("Minimap Button Frame", true)

	if not mbf then
		return
	end
	local foundMBF = false

	if _G.MBF.db.profile.MinimapIcons then
		for i, button in pairs(_G.MBF.db.profile.MinimapIcons) do
			local lower_button = button:lower()

			if lower_button == "archyminimap" or lower_button == "archyminimap_" then
				foundMBF = true
				break
			end
		end
		if not foundMBF then
			table.insert(_G.MBF.db.profile.MinimapIcons, "ArchyMinimap")
			self:Print("Adding Archy to the MinimapButtonFrame protected items list")
		end
	end
end

function Archy:OnDisable()
	--    self:UnregisterEvent("ARTIFACT_HISTORY_READY")
	--    self:UnregisterEvent("ARTIFACT_UPDATE")
	self:UnregisterEvent("ARTIFACT_COMPLETE")
	self:UnregisterEvent("ARTIFACT_DIG_SITE_UPDATED")
	self:UnregisterEvent("BAG_UPDATE")
	self:UnregisterEvent("SKILL_LINES_CHANGED")
	self:UnregisterEvent("CHAT_MSG_LOOT")
	self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:UnregisterEvent("CURRENCY_DISPLAY_UPDATE")
	self:CancelTimer(timer_handle)
	--self:SecureHook("SetCVar")
end

function Archy:OnProfileUpdate()
	db = self.db.profile
	self:ConfigUpdated()
	self:UpdateFramePositions()
end

--[[ Event Handlers ]] --
function Archy:ArtifactHistoryReady()
	for rid, artifact in pairs(artifacts) do
		local _, _, completionCount = GetArtifactStats(rid, artifact.name)
		if completionCount then
			artifact.completionCount = completionCount
		end
	end
	self:RefreshRacesDisplay()
end

function Archy:ArtifactUpdated()
	-- ignore this event for now as it's can break other Archaeology UIs
	-- Would have been nice if Blizzard passed the race index or artifact name with the event
end

function Archy:ArtifactCompleted()
	archRelatedBagUpdate = true
end

function Archy:DigSitesUpdated()
	if not playerContinent then
		return
	end
	UpdateSites()
	self:UpdateSiteDistances()
	self:RefreshDigSiteDisplay()
end

function Archy:BagUpdated()
	if not playerContinent then
		return
	end

	if not archRelatedBagUpdate then
		return
	end

	-- perform an artifact refresh here
	if keystoneLootRaceID then
		UpdateRaceArtifact(keystoneLootRaceID)
		self:ScheduleTimer("RefreshRacesDisplay", 0.5)
		keystoneLootRaceID = nil
	end

	archRelatedBagUpdate = false
end

function Archy:SkillLinesChanged()
	if not playerContinent then
		return
	end

	local rank, maxRank = GetArchaeologyRank()
	--[[
    if rank == 300 or rank == 375 or rank == 450 then
        -- Force reload of race and artifact data when outland, northrend and tol'vir become available
        LoadRaceData()
        if _G.GetNumArchaeologyRaces() > 0 then
            for rid = 1,_G.GetNumArchaeologyRaces() do
                UpdateRaceArtifact(rid)
            end
            self:UpdateRacesFrame()
            self:RefreshRacesDisplay()
        end
    end
]]

	if racesFrame and racesFrame.skillBar then
		racesFrame.skillBar:SetMinMaxValues(0, maxRank)
		racesFrame.skillBar:SetValue(rank)
		racesFrame.skillBar.text:SetFormattedText("%s : %d/%d", _G.GetArchaeologyInfo(), rank, maxRank)
	end
end

function Archy:LootReceived(event, msg)
	local _, itemLink, amount = ParseLootMessage(msg)

	if not itemLink then
		return
	end
	local itemID = GetIDFromLink(itemLink)
	local race_id = keystoneIDToRaceID[itemID]

	if race_id then
		siteStats[lastSite.id].keystones = siteStats[lastSite.id].keystones + 1
		keystoneLootRaceID = race_id
		archRelatedBagUpdate = true
	end
end

function Archy:PlayerCastSurvey(event, unit, spell, _, _, spellid)
	if unit ~= "player" or spellid ~= SURVEY_SPELL_ID then
		return
	end

	if not playerPosition or not nearestSite then
		survey_location.map = 0
		survey_location.level = 0
		survey_location.x = 0
		survey_location.y = 0
		return
	end
	survey_location.x = playerPosition.x
	survey_location.y = playerPosition.y
	survey_location.map = playerPosition.map
	survey_location.level = playerPosition.level

	distanceIndicatorActive = true
	lastSite = nearestSite
	siteStats[lastSite.id].surveys = siteStats[lastSite.id].surveys + 1

	ToggleDistanceIndicator()
	UpdateDistanceIndicator()

	if db.minimap.fragmentColorBySurveyDistance then
		local min_green, max_green = 0, db.digsite.distanceIndicator.green or 0
		local min_yellow, max_yellow = max_green, db.digsite.distanceIndicator.yellow or 0
		local min_red, max_red = max_yellow, 500

		for id, poi in pairs(allPois) do
			if poi.active and poi.type == "survey" then
				local distance = astrolabe:GetDistanceToIcon(poi)

				if distance >= min_green and distance <= max_green then
					poi.icon:SetTexCoord(0.75, 1, 0.5, 0.734375)
					--                poi.poiButton.texture:SetVertexColor(0,1,0,1)
				elseif distance >= min_yellow and distance <= max_yellow then
					poi.icon:SetTexCoord(0.5, 0.734375, 0.5, 0.734375)
					--                poi.poiButton.texture:SetVertexColor(1,1,0,1)
				elseif distance >= min_red and distance <= max_red then
					poi.icon:SetTexCoord(0.25, 0.484375, 0.5, 0.734375)
					--                poi.poiButton.texture:SetVertexColor(1,0,0,1)
				end
			end
		end
	end
	tomtomActive = false
	RefreshTomTom()
	self:RefreshDigSiteDisplay()
end

function Archy:CurrencyUpdated()
	if not playerContinent or _G.GetNumArchaeologyRaces() == 0 then
		return
	end

	for race_id = 1, _G.GetNumArchaeologyRaces() do
		local _, _, _, currencyAmount = _G.GetArchaeologyRaceInfo(race_id)
		local diff = currencyAmount - (raceData[race_id].currency or 0)

		raceData[race_id].currency = currencyAmount

		if diff < 0 then
			-- we've spent fragments, aka. Solved an artifact
			artifacts[race_id].stonesAdded = 0

			if artifactSolved.raceId > 0 then
				-- announce that we have solved an artifact
				local _, _, completionCount = GetArtifactStats(race_id, artifactSolved.name)
				local text = L["You have solved %s Artifact - %s (Times completed: %d)"]:format("|cFFFFFF00" .. raceData[race_id].name .. "|r", "|cFFFFFF00" .. artifactSolved.name .. "|r", completionCount or 0)
				self:Pour(text, 1, 1, 1)

				-- reset it since we know it's been solved
				artifactSolved.raceId = 0
				artifactSolved.name = ""
				self:RefreshRacesDisplay()
			end

		elseif diff > 0 then
			-- we've gained fragments, aka. Successfully dug at a dig site

			-- update the artifact info
			UpdateRaceArtifact(race_id)

			-- deactivate the distance indicator
			distanceIndicatorActive = false
			ToggleDistanceIndicator()

			-- Increment the site stats
			IncrementDigCounter(lastSite.id)
			siteStats[lastSite.id].looted = (siteStats[lastSite.id].looted or 0) + 1
			siteStats[lastSite.id].fragments = siteStats[lastSite.id].fragments + diff

			AddSurveyNode(lastSite.id, playerPosition.map, playerPosition.level, playerPosition.x, playerPosition.y)

			survey_location.map = 0
			survey_location.level = 0
			survey_location.x = 0
			survey_location.y = 0

			UpdateMinimapPOIs(true)
			self:RefreshRacesDisplay()
			self:RefreshDigSiteDisplay()
		end
	end
end

function Archy:CombatStateChanged(event)
	if event == "PLAYER_REGEN_DISABLED" then
		inCombat = true
		blobs["Minimap"]:DrawNone()
	elseif event == "PLAYER_REGEN_ENABLED" then
		inCombat = false
	end
end


--[[ Positional functions ]] --
function Archy:UpdatePlayerPosition(force)
	if not db.general.show or not HasArchaeology() or _G.IsInInstance() or _G.UnitIsGhost("player") then
		return
	end

	if _G.GetCurrentMapAreaID() == -1 then
		self:UpdateSiteDistances()
		self:UpdateDigSiteFrame()
		self:RefreshDigSiteDisplay()
		return
	end
	local map, level, x, y = astrolabe:GetCurrentPlayerPosition()

	if not map or not level or (x == 0 and y == 0) then
		return
	end
	local continent = astrolabe:GetMapInfo(map, level)

	if playerPosition.x ~= x or playerPosition.y ~= y or playerPosition.map ~= map or playerPosition.level ~= level or force then
		playerPosition.x, playerPosition.y, playerPosition.map, playerPosition.level = x, y, map, level

		self:RefreshAll()
	end

	if playerContinent ~= continent then
		playerContinent = continent

		if #raceData == 0 then
			LoadRaceData()
		end
		ClearTomTomPoint()
		RefreshTomTom()
		UpdateSites()

		if _G.GetNumArchaeologyRaces() > 0 then
			for race_id = 1, _G.GetNumArchaeologyRaces() do
				UpdateRaceArtifact(race_id)
			end
			self:UpdateRacesFrame()
			self:RefreshRacesDisplay()
		end
		self:UpdateDigSiteFrame()
		self:RefreshDigSiteDisplay()
		self:UpdateFramePositions()
	end
end

function Archy:RefreshAll()
	if not _G.IsInInstance() then
		self:UpdateSiteDistances()
		UpdateDistanceIndicator()
		UpdateMinimapPOIs()
		UpdateSiteBlobs()
	end
	self:RefreshDigSiteDisplay()
end


--[[ UI functions ]] --
local function TransformSiteFrame(frame)
	if db.digsite.style == "Compact" then
		frame.crest:SetWidth(20)
		frame.crest:SetHeight(20)
		frame.crest.icon:SetWidth(20)
		frame.crest.icon:SetHeight(20)
		frame.zone:Hide()
		frame.distance:Hide()
		frame:SetHeight(24)
	else
		frame.crest:SetWidth(40)
		frame.crest:SetHeight(40)
		frame.crest.icon:SetWidth(40)
		frame.crest.icon:SetHeight(40)
		frame.zone:Show()
		frame.distance:Show()
		frame:SetHeight(40)
	end
end

local function TransformRaceFrame(frame)
	if db.artifact.style == "Compact" then
		--[[
        frame.icon:Hide()
]]

		frame.crest:ClearAllPoints()
		frame.crest:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)

		frame.icon:ClearAllPoints()
		frame.icon:SetPoint("LEFT", frame.crest, "RIGHT", 0, 0)
		frame.icon:SetWidth(32)
		frame.icon:SetHeight(32)
		frame.icon.texture:SetWidth(32)
		frame.icon.texture:SetHeight(32)
		--        frame.fragmentBar:ClearAllPoints()
		--        frame.fragmentBar:SetPoint("LEFT", frame.icon, "RIGHT", 5, 0)


		frame.crest.text:Hide()
		frame.crest:SetWidth(36)
		frame.crest:SetHeight(36)
		frame.solveButton:SetText("")
		frame.solveButton:SetWidth(34)
		frame.solveButton:SetHeight(34)
		frame.solveButton:SetNormalTexture([[Interface\ICONS\TRADE_ARCHAEOLOGY_AQIR_ARTIFACTFRAGMENT]])
		frame.solveButton:SetDisabledTexture([[Interface\ICONS\TRADE_ARCHAEOLOGY_AQIR_ARTIFACTFRAGMENT]])
		frame.solveButton:GetDisabledTexture():SetBlendMode("MOD")

		frame.solveButton:ClearAllPoints()
		frame.solveButton:SetPoint("LEFT", frame.fragmentBar, "RIGHT", 5, 0)
		frame.fragmentBar.fragments:ClearAllPoints()
		frame.fragmentBar.fragments:SetPoint("RIGHT", frame.fragmentBar.keystones, "LEFT", -7, 2)
		frame.fragmentBar.keystone1:Hide()
		frame.fragmentBar.keystone2:Hide()
		frame.fragmentBar.keystone3:Hide()
		frame.fragmentBar.keystone4:Hide()
		frame.fragmentBar.artifact:SetWidth(160)

		frame:SetWidth(315 + frame.solveButton:GetWidth())
		frame:SetHeight(36)
	else
		frame.icon:ClearAllPoints()
		frame.icon:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
		frame.icon:SetWidth(36)
		frame.icon:SetHeight(36)
		frame.icon.texture:SetWidth(36)
		frame.icon.texture:SetHeight(36)

		frame.icon:Show()
		frame.crest.text:Show()
		frame.crest:SetWidth(24)
		frame.crest:SetHeight(24)
		frame.crest:ClearAllPoints()
		frame.crest:SetPoint("TOPLEFT", frame.icon, "BOTTOMLEFT", 0, 0)
		frame.solveButton:SetHeight(24)
		frame.solveButton:SetNormalTexture(nil)
		frame.solveButton:SetDisabledTexture(nil)
		frame.solveButton:ClearAllPoints()
		frame.solveButton:SetPoint("TOPRIGHT", frame.fragmentBar, "BOTTOMRIGHT", 0, -3)
		frame.fragmentBar.fragments:ClearAllPoints()
		frame.fragmentBar.fragments:SetPoint("RIGHT", frame.fragmentBar, "RIGHT", -5, 2)
		frame.fragmentBar.keystones:Hide()
		frame.fragmentBar.artifact:SetWidth(200)

		frame:SetWidth(295)
		frame:SetHeight(70)
	end
end

local function SetMovableState(self, value)
	self:SetMovable(value)
	self:EnableMouse(value)

	if value then
		self:RegisterForDrag("LeftButton")
	else
		self:RegisterForDrag()
	end
end

local function ApplyShadowToFontString(fs, hasShadow)
	if hasShadow then
		fs:SetShadowColor(0, 0, 0, 1)
		fs:SetShadowOffset(1, -1)
	else
		fs:SetShadowColor(0, 0, 0, 0)
		fs:SetShadowOffset(0, 0)
	end
end

function Archy:UpdateRacesFrame()
	if IsTaintable() then
		return
	end
	racesFrame:SetScale(db.artifact.scale)
	racesFrame:SetAlpha(db.artifact.alpha)
	--    racesFrame:ClearAllPoints()
	--    racesFrame:SetPoint("TOPLEFT", _G.UIParent, "TOPLEFT", db.artifact.positionX, db.artifact.positionY)
	SetMovableState(racesFrame, (not db.general.locked))

	local artifact_font_data = db.artifact.font
	local artifact_fragment_font_data = db.artifact.fragmentFont

	local font = lsm:Fetch("font", artifact_font_data.name)
	local fragment_font = lsm:Fetch("font", artifact_fragment_font_data.name)
	local keystone_font = lsm:Fetch("font", db.artifact.keystoneFont.name)

	for _, child in pairs(racesFrame.children) do
		if db.general.theme == "Graphical" then
			child.fragmentBar.artifact:SetFont(font, artifact_font_data.size, artifact_font_data.outline)
			child.fragmentBar.artifact:SetTextColor(artifact_font_data.color.r, artifact_font_data.color.g, artifact_font_data.color.b, artifact_font_data.color.a)

			child.fragmentBar.fragments:SetFont(fragment_font, artifact_fragment_font_data.size, artifact_fragment_font_data.outline)
			child.fragmentBar.fragments:SetTextColor(artifact_fragment_font_data.color.r, artifact_fragment_font_data.color.g, artifact_fragment_font_data.color.b, artifact_fragment_font_data.color.a)

			child.fragmentBar.keystones.count:SetFont(keystone_font, db.artifact.keystoneFont.size, db.artifact.keystoneFont.outline)
			child.fragmentBar.keystones.count:SetTextColor(db.artifact.keystoneFont.color.r, db.artifact.keystoneFont.color.g, db.artifact.keystoneFont.color.b, db.artifact.keystoneFont.color.a)

			ApplyShadowToFontString(child.fragmentBar.artifact, artifact_font_data.shadow)
			ApplyShadowToFontString(child.fragmentBar.fragments, artifact_fragment_font_data.shadow)
			ApplyShadowToFontString(child.fragmentBar.keystones.count, db.artifact.keystoneFont.shadow)
		else
			child.fragments.text:SetFont(font, artifact_font_data.size, artifact_font_data.outline)
			child.fragments.text:SetTextColor(artifact_font_data.color.r, artifact_font_data.color.g, artifact_font_data.color.b, artifact_font_data.color.a)

			child.sockets.text:SetFont(font, artifact_font_data.size, artifact_font_data.outline)
			child.sockets.text:SetTextColor(artifact_font_data.color.r, artifact_font_data.color.g, artifact_font_data.color.b, artifact_font_data.color.a)

			child.artifact.text:SetFont(font, artifact_font_data.size, artifact_font_data.outline)
			child.artifact.text:SetTextColor(artifact_font_data.color.r, artifact_font_data.color.g, artifact_font_data.color.b, artifact_font_data.color.a)

			ApplyShadowToFontString(child.fragments.text, artifact_font_data.shadow)
			ApplyShadowToFontString(child.sockets.text, artifact_font_data.shadow)
			ApplyShadowToFontString(child.artifact.text, artifact_font_data.shadow)
		end
	end

	local borderTexture = lsm:Fetch('border', db.artifact.borderTexture) or [[Interface\None]]
	local backgroundTexture = lsm:Fetch('background', db.artifact.backgroundTexture) or [[Interface\None]]
	racesFrame:SetBackdrop({
		bgFile = backgroundTexture,
		edgeFile = borderTexture,
		tile = false,
		edgeSize = 8,
		tileSize = 8,
		insets = {
			left = 2,
			top = 2,
			right = 2,
			bottom = 2
		}
	})
	racesFrame:SetBackdropColor(1, 1, 1, db.artifact.bgAlpha)
	racesFrame:SetBackdropBorderColor(1, 1, 1, db.artifact.borderAlpha)


	if not IsTaintable() then
		local height = racesFrame.container:GetHeight() + ((db.general.theme == "Graphical") and 15 or 25)
		if db.general.showSkillBar and db.general.theme == "Graphical" then
			height = height + 30
		end
		racesFrame:SetHeight(height)
		racesFrame:SetWidth(racesFrame.container:GetWidth() + ((db.general.theme == "Graphical") and 45 or 0))
	end

	if racesFrame:IsVisible() then
		if db.general.stealthMode or not db.artifact.show or ShouldBeHidden() then
			racesFrame:Hide()
		end
	else
		if not db.general.stealthMode and db.artifact.show and not ShouldBeHidden() then
			racesFrame:Show()
		end
	end
end

function Archy:RefreshRacesDisplay()
	if ShouldBeHidden() or _G.GetNumArchaeologyRaces() == 0 then
		return
	end
	local maxWidth, maxHeight = 0, 0
	self:SkillLinesChanged()

	local topFrame = racesFrame.container
	local hiddenAnchor = racesFrame
	local count = 0

	if db.general.theme == "Minimal" then
		racesFrame.title.text:SetText(L["Artifacts"])
	end

	for _, child in pairs(racesFrame.children) do
		child:Hide()
	end

	for rid, race in pairs(raceData) do
		local child = racesFrame.children[rid]
		local artifact = artifacts[rid]
		local _, _, completionCount = GetArtifactStats(rid, artifact.name)
		child:SetID(rid)

		if db.general.theme == "Graphical" then
			child.solveButton:SetText(_G.SOLVE)
			child.solveButton:SetWidth(child.solveButton:GetTextWidth() + 20)
			child.solveButton.tooltip = _G.SOLVE

			if child.style ~= db.artifact.style then
				TransformRaceFrame(child)
			end

			child.crest.texture:SetTexture(race.texture)
			child.crest.tooltip = race.name .. "\n" .. _G.NORMAL_FONT_COLOR_CODE .. L["Key Stones:"] .. "|r " .. race.keystone.inventory
			child.crest.text:SetText(race.name)
			child.icon.texture:SetTexture(artifact.icon)
			child.icon.tooltip = _G.HIGHLIGHT_FONT_COLOR_CODE .. artifact.name .. "|r\n" .. _G.NORMAL_FONT_COLOR_CODE .. artifact.tooltip
				.. "\n\n" .. _G.HIGHLIGHT_FONT_COLOR_CODE .. L["Solved Count: %s"]:format(_G.NORMAL_FONT_COLOR_CODE .. (completionCount or "0") .. "|r")
				.. "\n\n" .. _G.GREEN_FONT_COLOR_CODE .. L["Left-Click to open artifact in default Archaeology UI"] .. "|r"

			-- setup the bar texture here
			local barTexture = (lsm and lsm:Fetch('statusbar', db.artifact.fragmentBarTexture)) or _G.DEFAULT_STATUSBAR_TEXTURE
			child.fragmentBar.barTexture:SetTexture(barTexture)
			child.fragmentBar.barTexture:SetHorizTile(false)
			--            if db.artifact.fragmentBarTexture == "Archy" then
			--                child.fragmentBar.barTexture:SetTexCoord(0, 0.810546875, 0.40625, 0.5625)            -- can solve with keystones if they were attached
			--            else
			--                child.fragmentBar.barTexture:SetTexCoord(0, 0, 0.77525001764297, 0.810546875)
			--            end


			local barColor
			if artifact.rare then
				barColor = db.artifact.fragmentBarColors["Rare"]
				child.fragmentBar.barBackground:SetTexCoord(0, 0.72265625, 0.3671875, 0.7890625) -- rare
			else
				if completionCount == 0 then
					barColor = db.artifact.fragmentBarColors["FirstTime"]
				else
					barColor = db.artifact.fragmentBarColors["Normal"]
				end
				child.fragmentBar.barBackground:SetTexCoord(0, 0.72265625, 0, 0.411875) -- bg
			end
			child.fragmentBar:SetMinMaxValues(0, artifact.fragTotal)
			child.fragmentBar:SetValue(math.min(artifact.fragments + artifact.fragAdjust, artifact.fragTotal))

			local adjust = (artifact.fragAdjust > 0) and (" (|cFF00FF00+%d|r)"):format(artifact.fragAdjust) or ""
			child.fragmentBar.fragments:SetFormattedText("%d%s / %d", artifact.fragments, adjust, artifact.fragTotal)
			child.fragmentBar.artifact:SetText(artifact.name)
			child.fragmentBar.artifact:SetWordWrap(true)

			local endFound = false
			local artifactNameSize = child.fragmentBar:GetWidth() - 10

			if db.artifact.style == "Compact" then
				artifactNameSize = artifactNameSize - 40

				if artifact.sockets > 0 then
					child.fragmentBar.keystones.tooltip = L["%d Key stone sockets available"]:format(artifact.sockets)
						.. "\n" .. L["%d %ss in your inventory"]:format(race.keystone.inventory or 0, race.keystone.name or L["Key stone"])
					child.fragmentBar.keystones:Show()

					if child.fragmentBar.keystones and child.fragmentBar.keystones.count then
						child.fragmentBar.keystones.count:SetFormattedText("%d/%d", artifact.stonesAdded, artifact.sockets)
					end

					if artifact.stonesAdded > 0 then
						child.fragmentBar.keystones.icon:SetTexture(race.keystone.texture)
					else
						child.fragmentBar.keystones.icon:SetTexture(nil)
					end
				else
					child.fragmentBar.keystones:Hide()
				end
			else
				for ki = 1, (_G.ARCHAEOLOGY_MAX_STONES or 4) do
					if ki > artifact.sockets or not race.keystone.name then
						child.fragmentBar["keystone" .. ki]:Hide()
					else
						child.fragmentBar["keystone" .. ki].icon:SetTexture(race.keystone.texture)
						if ki <= artifact.stonesAdded then
							child.fragmentBar["keystone" .. ki].icon:Show()
							child.fragmentBar["keystone" .. ki].tooltip = _G.ARCHAEOLOGY_KEYSTONE_REMOVE_TOOLTIP:format(race.keystone.name)
							child.fragmentBar["keystone" .. ki]:Enable()
						else
							child.fragmentBar["keystone" .. ki].icon:Hide()
							child.fragmentBar["keystone" .. ki].tooltip = _G.ARCHAEOLOGY_KEYSTONE_ADD_TOOLTIP:format(race.keystone.name)
							child.fragmentBar["keystone" .. ki]:Enable()
							if endFound then
								child.fragmentBar["keystone" .. ki]:Disable()
							end
							endFound = true
						end
						child.fragmentBar["keystone" .. ki]:Show()
					end
				end
			end

			if artifact.canSolve or (artifact.stonesAdded > 0 and artifact.canSolveStone) then
				child.solveButton:Enable()
				barColor = db.artifact.fragmentBarColors["Solvable"]
			else
				if (artifact.canSolveStone) then
					barColor = db.artifact.fragmentBarColors["AttachToSolve"]
				end
				child.solveButton:Disable()
			end

			child.fragmentBar.barTexture:SetVertexColor(barColor.r, barColor.g, barColor.b, 1)

			artifactNameSize = artifactNameSize - child.fragmentBar.fragments:GetStringWidth()
			child.fragmentBar.artifact:SetWidth(artifactNameSize)

		else
			local fragmentColor = (artifact.canSolve and "|cFF00FF00" or (artifact.canSolveStone and "|cFFFFFF00" or ""))
			local nameColor = (artifact.rare and "|cFF0070DD" or ((completionCount and completionCount > 0) and _G.GRAY_FONT_COLOR_CODE or ""))
			child.fragments.text:SetFormattedText("%s%d/%d", fragmentColor, artifact.fragments, artifact.fragTotal)

			if raceData[rid].keystone.inventory > 0 or artifact.sockets > 0 then
				child.sockets.text:SetFormattedText("%d/%d", raceData[rid].keystone.inventory, artifact.sockets)
				child.sockets.tooltip = L["%d Key stone sockets available"]:format(artifact.sockets) .. "\n" .. L["%d %ss in your inventory"]:format(race.keystone.inventory or 0, race.keystone.name or L["Key stone"])
			else
				child.sockets.text:SetText("")
				child.sockets.tooltip = nil
			end
			child.crest:SetNormalTexture(raceData[rid].texture)
			child.crest:SetHighlightTexture(raceData[rid].texture)
			child.crest.tooltip = artifact.name .. "\n" .. _G.NORMAL_FONT_COLOR_CODE .. _G.RACE .. " - " .. "|r" .. _G.HIGHLIGHT_FONT_COLOR_CODE .. raceData[rid].name .. "\n\n" .. _G.GREEN_FONT_COLOR_CODE .. L["Left-Click to solve without key stones"] .. "\n" .. L["Right-Click to solve with key stones"]

			child.artifact.text:SetFormattedText("%s%s", nameColor, artifact.name)
			child.artifact.tooltip = _G.HIGHLIGHT_FONT_COLOR_CODE .. artifact.name .. "|r\n" .. _G.NORMAL_FONT_COLOR_CODE .. artifact.tooltip
				.. "\n\n" .. _G.HIGHLIGHT_FONT_COLOR_CODE .. L["Solved Count: %s"]:format(_G.NORMAL_FONT_COLOR_CODE .. (completionCount or "0") .. "|r")
				.. "\n\n" .. _G.GREEN_FONT_COLOR_CODE .. L["Left-Click to open artifact in default Archaeology UI"] .. "|r"

			child.artifact:SetWidth(child.artifact.text:GetStringWidth())
			child.artifact:SetHeight(child.artifact.text:GetStringHeight())
			child:SetWidth(child.fragments:GetWidth() + child.sockets:GetWidth() + child.crest:GetWidth() + child.artifact:GetWidth() + 30)
		end

		if not db.artifact.blacklist[rid] and artifact.fragTotal > 0 and (not db.artifact.filter or _G.tContains(ContinentRaces(playerContinent), rid)) then
			child:ClearAllPoints()

			if topFrame == racesFrame.container then
				child:SetPoint("TOPLEFT", topFrame, "TOPLEFT", 0, 0)
			else
				child:SetPoint("TOPLEFT", topFrame, "BOTTOMLEFT", 0, -5)
			end
			topFrame = child
			child:Show()
			maxHeight = maxHeight + child:GetHeight() + 5
			maxWidth = (maxWidth > child:GetWidth()) and maxWidth or child:GetWidth()
			count = count + 1
		else
			child:Hide()
		end
	end

	local containerXofs = 0
	if db.general.theme == "Graphical" and db.artifact.style == "Compact" then
		maxHeight = maxHeight + 10
		containerXofs = -10
	end


	racesFrame.container:SetHeight(maxHeight)
	racesFrame.container:SetWidth(maxWidth)

	if racesFrame.skillBar then
		racesFrame.skillBar:SetWidth(maxWidth)
		racesFrame.skillBar.border:SetWidth(maxWidth + 9)

		if db.general.showSkillBar then
			racesFrame.skillBar:Show()
			racesFrame.container:ClearAllPoints()
			racesFrame.container:SetPoint("TOP", racesFrame.skillBar, "BOTTOM", containerXofs, -10)
			maxHeight = maxHeight + 30
		else
			racesFrame.skillBar:Hide()
			racesFrame.container:ClearAllPoints()
			racesFrame.container:SetPoint("TOP", racesFrame, "TOP", containerXofs, -20)
			maxHeight = maxHeight + 10
		end
	else
		racesFrame.container:ClearAllPoints()
		racesFrame.container:SetPoint("TOP", racesFrame, "TOP", containerXofs, -20)
		maxHeight = maxHeight + 10
	end

	if not IsTaintable() then
		if count == 0 then racesFrame:Hide() end
		racesFrame:SetHeight(maxHeight + ((db.general.theme == "Graphical") and 15 or 25))
		racesFrame:SetWidth(maxWidth + ((db.general.theme == "Graphical") and 45 or 0))
	end
end

function Archy:UpdateDigSiteFrame()
	if IsTaintable() then
		return
	end
	digsiteFrame:SetScale(db.digsite.scale)
	digsiteFrame:SetAlpha(db.digsite.alpha)

	local borderTexture = lsm:Fetch('border', db.digsite.borderTexture) or [[Interface\None]]
	local backgroundTexture = lsm:Fetch('background', db.digsite.backgroundTexture) or [[Interface\None]]
	digsiteFrame:SetBackdrop({ bgFile = backgroundTexture, edgeFile = borderTexture, tile = false, edgeSize = 8, tileSize = 8, insets = { left = 2, top = 2, right = 2, bottom = 2 } })
	digsiteFrame:SetBackdropColor(1, 1, 1, db.digsite.bgAlpha)
	digsiteFrame:SetBackdropBorderColor(1, 1, 1, db.digsite.borderAlpha)
	--SetMovableState(digsiteFrame, (not db.general.locked))

	local font = lsm:Fetch("font", db.digsite.font.name)
	local zoneFont = lsm:Fetch("font", db.digsite.zoneFont.name)

	for _, siteFrame in pairs(digsiteFrame.children) do
		siteFrame.site.name:SetFont(font, db.digsite.font.size, db.digsite.font.outline)
		siteFrame.digCounter.value:SetFont(font, db.digsite.font.size, db.digsite.font.outline)
		siteFrame.site.name:SetTextColor(db.digsite.font.color.r, db.digsite.font.color.g, db.digsite.font.color.b, db.digsite.font.color.a)
		siteFrame.digCounter.value:SetTextColor(db.digsite.font.color.r, db.digsite.font.color.g, db.digsite.font.color.b, db.digsite.font.color.a)
		ApplyShadowToFontString(siteFrame.site.name, db.digsite.font.shadow)
		ApplyShadowToFontString(siteFrame.digCounter.value, db.digsite.font.shadow)

		if db.general.theme == "Graphical" then
			siteFrame.zone.name:SetFont(zoneFont, db.digsite.zoneFont.size, db.digsite.zoneFont.outline)
			siteFrame.distance.value:SetFont(zoneFont, db.digsite.zoneFont.size, db.digsite.zoneFont.outline)
			siteFrame.zone.name:SetTextColor(db.digsite.zoneFont.color.r, db.digsite.zoneFont.color.g, db.digsite.zoneFont.color.b, db.digsite.zoneFont.color.a)
			siteFrame.distance.value:SetTextColor(db.digsite.zoneFont.color.r, db.digsite.zoneFont.color.g, db.digsite.zoneFont.color.b, db.digsite.zoneFont.color.a)
			ApplyShadowToFontString(siteFrame.zone.name, db.digsite.zoneFont.shadow)
			ApplyShadowToFontString(siteFrame.distance.value, db.digsite.zoneFont.shadow)
		else
			siteFrame.zone.name:SetFont(font, db.digsite.font.size, db.digsite.font.outline)
			siteFrame.distance.value:SetFont(font, db.digsite.font.size, db.digsite.font.outline)
			siteFrame.zone.name:SetTextColor(db.digsite.font.color.r, db.digsite.font.color.g, db.digsite.font.color.b, db.digsite.font.color.a)
			siteFrame.distance.value:SetTextColor(db.digsite.font.color.r, db.digsite.font.color.g, db.digsite.font.color.b, db.digsite.font.color.a)
			ApplyShadowToFontString(siteFrame.zone.name, db.digsite.font.shadow)
			ApplyShadowToFontString(siteFrame.distance.value, db.digsite.font.shadow)
		end
	end

	local cid = continentMapToID[playerContinent]

	if digsiteFrame:IsVisible() then
		if db.general.stealthMode or not db.digsite.show or ShouldBeHidden() or not digsites[cid] or #digsites[cid] == 0 then
			digsiteFrame:Hide()
		end
	else
		if not db.general.stealthMode and db.digsite.show and not ShouldBeHidden() and digsites[cid] and #digsites[cid] > 0 then
			digsiteFrame:Show()
		end
	end
end

function Archy:ShowDigSiteTooltip(digsite)
	local site_id = digsite:GetParent():GetID()
	local normal_font = _G.NORMAL_FONT_COLOR_CODE
	local highlight_font = _G.HIGHLIGHT_FONT_COLOR_CODE

	digsite.tooltip = digsite.name:GetText()
	digsite.tooltip = digsite.tooltip .. ("\n%s%s%s%s|r"):format(normal_font, _G.ZONE .. ": ", highlight_font, digsite:GetParent().zone.name:GetText())
	digsite.tooltip = digsite.tooltip .. ("\n\n%s%s %s%s|r"):format(normal_font, L["Surveys:"], highlight_font, siteStats[site_id].surveys or 0)
	digsite.tooltip = digsite.tooltip .. ("\n%s%s %s%s|r"):format(normal_font, L["Digs"] .. ": ", highlight_font, siteStats[site_id].looted or 0)
	digsite.tooltip = digsite.tooltip .. ("\n%s%s %s%s|r"):format(normal_font, _G.ARCHAEOLOGY_RUNE_STONES .. ": ", highlight_font, siteStats[site_id].fragments or 0)
	digsite.tooltip = digsite.tooltip .. ("\n%s%s %s%s|r"):format(normal_font, L["Key Stones:"], highlight_font, siteStats[site_id].keystones or 0)
	digsite.tooltip = digsite.tooltip .. "\n\n" .. _G.GREEN_FONT_COLOR_CODE .. L["Left-Click to view the zone map"]

	if Archy:IsSiteBlacklisted(digsite.siteName) then
		digsite.tooltip = digsite.tooltip .. "\n" .. L["Right-Click to remove from blacklist"]
	else
		digsite.tooltip = digsite.tooltip .. "\n" .. L["Right-Click to blacklist"]
	end
	_G.GameTooltip:SetOwner(digsite, "ANCHOR_BOTTOMRIGHT")
	_G.GameTooltip:SetText(digsite.tooltip, _G.NORMAL_FONT_COLOR[1], _G.NORMAL_FONT_COLOR[2], _G.NORMAL_FONT_COLOR[3], 1, true)
end

function Archy:ResizeDigSiteDisplay()
	if db.general.theme == "Graphical" then
		self:ResizeGraphicalDigSiteDisplay()
	else
		self:ResizeMinimalDigSiteDisplay()
	end
end

function Archy:ResizeMinimalDigSiteDisplay()
	local maxWidth, maxHeight = 0, 0
	local topFrame = digsiteFrame.container
	local siteIndex = 0
	local maxNameWidth, maxZoneWidth, maxDistWidth, maxDigCounterWidth = 0, 0, 70, 20
	for _, siteFrame in pairs(digsiteFrame.children) do
		siteIndex = siteIndex + 1
		siteFrame.zone:SetWidth(siteFrame.zone.name:GetStringWidth())
		siteFrame.distance:SetWidth(siteFrame.distance.value:GetStringWidth())
		siteFrame.site:SetWidth(siteFrame.site.name:GetStringWidth())
		local width
		local nameWidth = siteFrame.site:GetWidth()
		local zoneWidth = siteFrame.zone:GetWidth()
		if maxNameWidth < nameWidth then maxNameWidth = nameWidth end
		if maxZoneWidth < zoneWidth then maxZoneWidth = zoneWidth end
		if maxDistWidth < siteFrame.distance:GetWidth() then maxDistWidth = siteFrame.distance:GetWidth() end
		maxHeight = maxHeight + siteFrame:GetHeight() + 5

		siteFrame:ClearAllPoints()
		if siteIndex == 1 then siteFrame:SetPoint("TOP", topFrame, "TOP", 0, 0) else siteFrame:SetPoint("TOP", topFrame, "BOTTOM", 0, -5) end
		topFrame = siteFrame
	end
	if not db.digsite.minimal.showDistance then maxDistWidth = 0 end
	if not db.digsite.minimal.showZone then maxZoneWidth = 0 end
	if not db.digsite.minimal.showDigCounter then maxDigCounterWidth = 0 end
	maxWidth = 57 + maxDigCounterWidth + maxNameWidth + maxZoneWidth + maxDistWidth
	for _, siteFrame in pairs(digsiteFrame.children) do
		siteFrame.zone:SetWidth(maxZoneWidth == 0 and 1 or maxZoneWidth)
		siteFrame.site:SetWidth(maxNameWidth)
		siteFrame.distance:SetWidth(maxDistWidth == 0 and 1 or maxDistWidth)
		siteFrame:SetWidth(maxWidth)
		siteFrame.distance:SetAlpha(db.digsite.minimal.showDistance and 1 or 0)
		siteFrame.zone:SetAlpha(db.digsite.minimal.showZone and 1 or 0)
	end
	local cpoint, crelTo, crelPoint, cxOfs, cyOfs = digsiteFrame.container:GetPoint()

	digsiteFrame.container:SetWidth(maxWidth)

	digsiteFrame.container:SetHeight(maxHeight)
	if not IsTaintable() then
		-- digsiteFrame:SetHeight(digsiteFrame.container:GetHeight() + cyOfs + 40)
		digsiteFrame:SetHeight(maxHeight + cyOfs + 40)
		digsiteFrame:SetWidth(maxWidth + cxOfs + 30)
	end
end

function Archy:ResizeGraphicalDigSiteDisplay()
	local maxWidth, maxHeight = 0, 0
	local topFrame = digsiteFrame.container
	local siteIndex = 0
	for _, siteFrame in pairs(digsiteFrame.children) do
		siteIndex = siteIndex + 1
		siteFrame.zone:SetWidth(siteFrame.zone.name:GetStringWidth())
		siteFrame.distance:SetWidth(siteFrame.distance.value:GetStringWidth())
		siteFrame.site:SetWidth(siteFrame.site.name:GetStringWidth())
		local width
		local nameWidth = siteFrame.site:GetWidth()
		local zoneWidth = siteFrame.zone:GetWidth() + 10
		if nameWidth > zoneWidth then
			width = siteFrame.crest:GetWidth() + nameWidth + siteFrame.digCounter:GetWidth() + 6
		else
			width = siteFrame.crest:GetWidth() + zoneWidth + siteFrame.distance:GetWidth() + 6
		end
		if width > maxWidth then maxWidth = width end
		maxHeight = maxHeight + siteFrame:GetHeight() + 5

		siteFrame:ClearAllPoints()
		if siteIndex == 1 then siteFrame:SetPoint("TOP", topFrame, "TOP", 0, 0) else siteFrame:SetPoint("TOP", topFrame, "BOTTOM", 0, -5) end
		topFrame = siteFrame
	end
	for _, siteFrame in pairs(digsiteFrame.children) do
		siteFrame:SetWidth(maxWidth)
	end
	local cpoint, crelTo, crelPoint, cxOfs, cyOfs = digsiteFrame.container:GetPoint()

	digsiteFrame.container:SetWidth(maxWidth)

	digsiteFrame.container:SetHeight(maxHeight)
	if not IsTaintable() then
		-- digsiteFrame:SetHeight(digsiteFrame.container:GetHeight() + cyOfs + 40) -- masahikatao on wowinterface
		digsiteFrame:SetHeight(maxHeight + cyOfs + 40)
		digsiteFrame:SetWidth(maxWidth + cxOfs + 30)
	end
end

function Archy:RefreshDigSiteDisplay()
	if ShouldBeHidden() then
		return
	end
	local continent_id = continentMapToID[playerContinent]

	if not continent_id or not digsites[continent_id] or #digsites[continent_id] == 0 then
		return
	end

	for _, siteFrame in pairs(digsiteFrame.children) do
		siteFrame:Hide()
	end

	for _, site in pairs(digsites[continent_id]) do
		if not site.distance then
			return
		end
	end

	for siteIndex, site in pairs(digsites[continent_id]) do
		local siteFrame = digsiteFrame.children[siteIndex]
		local count = siteStats[site.id].counter

		if db.general.theme == "Graphical" then
			if siteFrame.style ~= db.digsite.style then
				TransformSiteFrame(siteFrame)
			end
			count = (count and count > 0) and tostring(count) or ""
		else
			count = (count and tostring(count) or "0") .. "/3"
		end

		siteFrame.distance.value:SetFormattedText(L["%d yards"], site.distance)
		siteFrame.digCounter.value:SetText(count)

		if Archy:IsSiteBlacklisted(site.name) then
			siteFrame.site.name:SetFormattedText("|cFFFF0000%s", site.name)
		else
			siteFrame.site.name:SetText(site.name)
		end

		if siteFrame.site.siteName ~= site.name then
			siteFrame.crest.icon:SetTexture(raceData[site.raceId].texture)
			siteFrame.crest.tooltip = raceData[site.raceId].name
			siteFrame.zone.name:SetText(site.zoneName)
			siteFrame.site.siteName = site.name
			siteFrame.site.zoneId = site.zoneId
			siteFrame:SetID(site.id)
		end
		siteFrame:Show()
	end
	self:ResizeDigSiteDisplay()
end

function Archy:SetFramePosition(frame)
	local bPoint, bRelativeTo, bRelativePoint, bXofs, bYofs

	if not frame.isMoving then
		bRelativeTo = _G.UIParent
		if frame == digsiteFrame then
			bPoint, bRelativePoint, bXofs, bYofs = unpack(db.digsite.position)
		elseif frame == racesFrame then
			bPoint, bRelativePoint, bXofs, bYofs = unpack(db.artifact.position)
		elseif frame == distanceIndicatorFrame then
			if not db.digsite.distanceIndicator.undocked then
				bRelativeTo = digsiteFrame
				bPoint, bRelativePoint, bXofs, bYofs = "CENTER", "TOPLEFT", 50, -5
				frame:SetParent(digsiteFrame)
			else
				frame:SetParent(_G.UIParent)
				bPoint, bRelativePoint, bXofs, bYofs = unpack(db.digsite.distanceIndicator.position)
			end
		end

		frame:ClearAllPoints()
		frame:SetPoint(bPoint, bRelativeTo, bRelativePoint, bXofs, bYofs)
		frame:SetFrameLevel(2)
		if frame:GetParent() == _G.UIParent and not IsTaintable() and not db.general.locked then
			frame:SetUserPlaced(false)
		end
	end
end

function Archy:SaveFramePosition(frame)
	local bPoint, bRelativeTo, bRelativePoint, bXofs, bYofs = frame:GetPoint()
	local width, height
	local anchor, position

	if frame == digsiteFrame then
		anchor = Archy.db.profile.digsite.anchor
		position = Archy.db.profile.digsite.position
	elseif frame == racesFrame then
		anchor = Archy.db.profile.artifact.anchor
		position = Archy.db.profile.artifact.position
	elseif frame == distanceIndicatorFrame then
		anchor = Archy.db.profile.digsite.distanceIndicator.anchor
		position = Archy.db.profile.digsite.distanceIndicator.position
	end

	if not anchor or not position then
		return
	end

	if anchor == bPoint then
		position = { bPoint, bRelativePoint, bXofs, bYofs }
	else
		width = frame:GetWidth()
		height = frame:GetHeight()

		if bPoint == "TOP" then
			bXofs = bXofs - (width / 2)
		elseif bPoint == "LEFT" then
			bYofs = bYofs + (height / 2)
		elseif bPoint == "BOTTOMLEFT" then
			bYofs = bYofs + height
		elseif bPoint == "TOPRIGHT" then
			bXofs = bXofs - width
		elseif bPoint == "RIGHT" then
			bYofs = bYofs + (height / 2)
			bXofs = bXofs - width
		elseif bPoint == "BOTTOM" then
			bYofs = bYofs + height
			bXofs = bXofs - (width / 2)
		elseif bPoint == "BOTTOMRIGHT" then
			bYofs = bYofs + height
			bXofs = bXofs - width
		elseif bPoint == "CENTER" then
			bYofs = bYofs + (height / 2)
			bXofs = bXofs - (width / 2)
		end

		if anchor == "TOPRIGHT" then
			bXofs = bXofs + width
		elseif anchor == "BOTTOMRIGHT" then
			bYofs = bYofs - height
			bXofs = bXofs + width
		elseif anchor == "BOTTOMLEFT" then
			bYofs = bYofs - height
		end

		position = { anchor, bRelativePoint, bXofs, bYofs }
		if frame == digsiteFrame then
			db.digsite.position = position
		elseif frame == racesFrame then
			db.artifact.position = position
		elseif frame == distanceIndicatorFrame then
			db.digsite.distanceIndicator.position = position
		end
	end

	self:OnProfileUpdate()
	--Archy:SetFramePosition(frame)
end




--[[
    Hook World Frame Mouse Interaction - Credit to Sutorix for his implementation of this in Fishing Buddy
    This code is quite raw and does need some cleaning up as it is experimental at best
]] --
-- handle option keys for enabling casting
local function NormalHijackCheck()
	-- if ( not IsTaintable() and db.general.easyCast and not ShouldBeHidden() ) then -- karl_w_w
	if (not IsTaintable() and db.general.easyCast and not ShouldBeHidden() and 0 ~= _G.ArchaeologyMapUpdateAll()) then
		return true
	end
end

local HijackCheck = NormalHijackCheck

local function SetHijackCheck(func)
	if not func then
		func = NormalHijackCheck
	end
	HijackCheck = func
end

local sabutton
local function CreateSAButton(name, postclick)
	if sabutton then
		return
	end
	local btn = _G.CreateFrame("Button", name, _G.UIParent, "SecureActionButtonTemplate")
	btn:SetPoint("LEFT", _G.UIParent, "RIGHT", 10000, 0)
	btn:SetFrameStrata("LOW")
	btn:EnableMouse(true)
	btn:RegisterForClicks("RightButtonUp")
	btn:SetScript("PostClick", postclick)
	btn:Hide()
	btn.name = name

	sabutton = btn

	return btn
end

local function GetSurveySkillInfo()
	local _, _, arch = _G.GetProfessions()

	if arch then
		local name = _G.GetProfessionInfo(arch)
		return true, name
	end
	return false, _G.PROFESSIONS_ARCHAEOLOGY
end

local ActionBarID
local SURVEYTEXTURE = "Interface\\Icons\\INV_Misc_Shovel_01"
local function GetSurveyActionBarID(force)
	if force or not ActionBarID then
		for slot = 1, 72 do
			if _G.HasAction(slot) and not _G.IsAttackAction(slot) then
				local action_type, _, _ = _G.GetActionInfo(slot)

				if action_type == "spell" then
					local tex = _G.GetActionTexture(slot)

					if tex and tex == SURVEYTEXTURE then
						ActionBarID = slot
						break
					end
				end
			end
		end
	end
	return ActionBarID
end

local function InvokeSurvey(useaction, btn)
	btn = btn or sabutton

	if not btn then
		return
	end
	local _, name = GetSurveySkillInfo()
	local findid = GetSurveyActionBarID()

	if not useaction or not findid then
		btn:SetAttribute("type", "spell")
		btn:SetAttribute("spell", 80451)
		btn:SetAttribute("action", nil)
	else
		btn:SetAttribute("type", "action")
		btn:SetAttribute("action", findid)
		btn:SetAttribute("spell", nil)
	end
end

local function OverrideClick(btn)
	btn = btn or sabutton

	if not sabutton then
		return
	end
	_G.SetOverrideBindingClick(btn, true, "BUTTON2", btn.name)
end

local function CentralCasting()
	InvokeSurvey(true)
	OverrideClick()
	OverrideOn = true
end

local lastClickTime
local ACTIONDOUBLEWAIT = 0.4
local MINACTIONDOUBLECLICK = 0.05
local isLooting = false

local function CheckForDoubleClick()
	if not isLooting and lastClickTime then
		local pressTime = _G.GetTime()
		local doubleTime = pressTime - lastClickTime

		if doubleTime < ACTIONDOUBLEWAIT and doubleTime > MINACTIONDOUBLECLICK then
			lastClickTime = nil
			return true
		end
	end
	lastClickTime = _G.GetTime()
	return false
end

local function ExtendDoubleClick()
	if not lastClickTime then
		return
	end
	lastClickTime = lastClickTime + ACTIONDOUBLEWAIT / 2
end

local SavedWFOnMouseDown

-- handle mouse up and mouse down in the WorldFrame so that we can steal
-- the hardware events to implement 'Easy Cast'
-- Thanks to the Cosmos team for figuring this one out -- I didn't realize
-- that the mouse handler in the WorldFrame got everything first!
local function WF_OnMouseDown(...)
	-- Only steal 'right clicks' (self is arg #1!)
	local button = select(2, ...)

	if button == "RightButton" and HijackCheck() then
		if CheckForDoubleClick() then
			-- We're stealing the mouse-up event, make sure we exit MouseLook
			if IsMouselooking() and not InCombatLockdown() then
				MouselookStop()
			end
			CentralCasting()
		end
	end

	if SavedWFOnMouseDown then
		SavedWFOnMouseDown(...)
	end
end

local function SafeHookMethod(object, method, new_method)
	local oldValue = object[method]

	if oldValue ~= _G[new_method] then
		object[method] = new_method
		return true
	end
	return false
end

local function SafeHookScript(frame, handlername, newscript)
	local oldValue = frame:GetScript(handlername)
	frame:SetScript(handlername, newscript)
	return oldValue
end


function TrapWorldMouse()
	if WorldFrame.OnMouseDown then
		hooksecurefunc(WorldFrame, "OnMouseDown", WF_OnMouseDown)
	else
		SavedWFOnMouseDown = SafeHookScript(WorldFrame, "OnMouseDown", WF_OnMouseDown)
	end
end

function Archy:CheckOverride()
	if not IsTaintable() then
		ClearOverrideBindings(Archy_SurveyButton)
	end
	OverrideOn = false
end

function Archy:OnPlayerLogin()
	CreateSAButton("Archy_SurveyButton", Archy.CheckOverride)
end

function Archy:OnPlayerLooting(event, ...)
	isLooting = (event == "LOOT_OPENED")
	local autoLootEnabled = ...

	if autoLootEnabled == 1 then
		return
	end

	if isLooting and db.general.autoLoot then
		for slotNum = 1, _G.GetNumLootItems() do
			if _G.LootSlotIsCurrency(slotNum) then
				_G.LootSlot(slotNum)
			elseif _G.LootSlotIsItem(slotNum) then
				local link = _G.GetLootSlotLink(slotNum)

				if link then
					local itemID = GetIDFromLink(link)

					if itemID and keystoneIDToRaceID[itemID] then
						_G.LootSlot(slotNum)
					end
				end
			end
		end
	end
end
