local defaultLanguage = true
--[===[@debug@
defaultLanguage = false
--@end-debug@]===]

local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("Ovale", "enUS", defaultLanguage)
if not L then return end

L["AOE"] = true
L["Affichage numérique"] = "Numeric display"
L["Affiche le temps de recharge sous forme numérique"] = "Show the remaining time in numerical form"
L["Affiche les deux prochains sorts et pas uniquement le suivant"] = "Display two abilities and not only one"
L["Afficher la fenêtre"] = "Show Ovale"
L["Afficher les raccourcis clavier dans le coin inférieur gauche des icônes"] = "Show keyboard shortcuts in the icon bottom-left corner"
L["Apparence"] = "Appearance"
L["Blood"] = true
L["Cacher bouton vide"] = "Hide empty buttons"
L["Cacher dans les véhicules"] = "Hide in vehicles"
L["Cacher la fenêtre"] = "Hide Ovale"
L["Cacher si cible amicale ou morte"] = "Hide if friendly or dead target"
L["Caractère de portée"] = "Range indicator"
L["Ce caractère est affiché dans un coin de l'icône pour indiquer si la cible est à portée"] = "This text is displayed on the icon to show if the target is in range"
L["Cliquer pour afficher/cacher les options"] = "Click to hide/show options"
L["Code"] = true
L["Correction de la latence"] = "Latency correction"
L["Décalage horizontal des options"] = "Options horizontal shift"
L["Décalage vertical des options"] = "Options vertical shift"
L["Défilement"] = "Scrolling"
L["En combat uniquement"] = "Show in combat only"
L["Focus"] = true
L["Ignorer les clics souris"] = "Ignore mouse clicks"
L["Illuminer l'icône"] = "Highlight icon"
L["Illuminer l'icône quand la technique doit être spammée"] = "Hightlight icon when ability should be spammed"
L["Illuminer l'icône quand le temps de recharge est écoulé"] = "Flash the icon when the ability is ready"
L["Inverser la boîte à cocher "] = "Toggle check box"
L["La taille des icônes"] = "The icons scale"
L["La taille des petites icônes"] = "The small icons scale"
L["La taille des polices"] = "The font scale"
L["Les icônes se déplacent"] = "Scroll the icons"
L["Marge entre deux icônes"] = "Margin between icons"
L["Melee"] = true
L["None"] = true
L["Opacité des icônes"] = "Icons opacity"
L["Opacité des options"] = "Options opacity"
L["Prédictif"] = "Two abilities"
L["Raccourcis clavier"] = "Keyboard shortcuts"
L["Si cible uniquement"] = "If has target"
L["Taille des icônes"] = "Icon scale"
L["Taille des petites icônes"] = "Small icon scale"
L["Taille des polices"] = "Font scale"
L["Verrouiller position"] = "Lock position"
L["Vertical"] = true
L["aoe"] = "Multiple targets Attack"
L["buff"] = "Buffs"
L["cd"] = [=[Long cooldown abilities.
Cast as soon as possible or keep for multiplied damage phases.]=]
L["main"] = "Main Attack"
L["mana"] = "Mana gain"
L["multidot"] = "Damage Over Time on multiple targets"
L["offgcd"] = [=[Out of global cooldown ability.
Cast alongside your Main Attack.]=]
