local defaultLanguage = false
--[===[@debug@
defaultLanguage = true
--@end-debug@]===]

local L = LibStub:GetLibrary("AceLocale-3.0"):NewLocale("Ovale", "frFR", defaultLanguage, defaultLanguage)
if not L then return end

L["AOE"] = "Multicible"
L["Affichage numérique"] = true
L["Affiche le temps de recharge sous forme numérique"] = true
L["Affiche les deux prochains sorts et pas uniquement le suivant"] = true
L["Afficher la fenêtre"] = true
L["Afficher les raccourcis clavier dans le coin inférieur gauche des icônes"] = true
L["Apparence"] = true
L["Blood"] = "Saignement"
L["Cacher bouton vide"] = true
L["Cacher dans les véhicules"] = true
L["Cacher la fenêtre"] = true
L["Cacher si cible amicale ou morte"] = true
L["Caractère de portée"] = true
L["Ce caractère est affiché dans un coin de l'icône pour indiquer si la cible est à portée"] = true
L["Cliquer pour afficher/cacher les options"] = true
L["Code"] = true
L["Correction de la latence"] = true
L["Décalage horizontal des options"] = true
L["Décalage vertical des options"] = true
L["Défilement"] = true
L["En combat uniquement"] = true
L["Focus"] = true
L["Ignorer les clics souris"] = true
L["Illuminer l'icône"] = true
L["Illuminer l'icône quand la technique doit être spammée"] = true
L["Illuminer l'icône quand le temps de recharge est écoulé"] = true
L["Inverser la boîte à cocher "] = true
L["La taille des icônes"] = true
L["La taille des petites icônes"] = true
L["La taille des polices"] = true
L["Les icônes se déplacent"] = true
L["Marge entre deux icônes"] = true
L["Melee"] = "Corps-à-corps"
L["None"] = "Aucun"
L["Opacité des icônes"] = true
L["Opacité des options"] = true
L["Prédictif"] = "Deux sorts"
L["Raccourcis clavier"] = true
L["Si cible uniquement"] = true
L["Taille des icônes"] = true
L["Taille des petites icônes"] = true
L["Taille des polices"] = true
L["Verrouiller position"] = true
L["Vertical"] = true
L["aoe"] = "Attaque multi-cible"
L["buff"] = "Améliorations"
L["cd"] = [=[Techniques à longs temps de recharge.
Lancer dès que possible ou conserver pour les phases de dégâts amplifiés.]=]
L["main"] = "Attaque principale"
L["mana"] = "Regain de mana"
L["multidot"] = "Multicible pour DoTs"
L["offgcd"] = [=[Attaque hors temps de recharge globale.
Lancer en parallèle de l'attaque principale.]=]

