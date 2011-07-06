local L = LibStub("AceLocale-3.0"):GetLocale("Ovale")

local node={}
local defines = {}
local customFunctions = {}

local function AddNode(newNode)
	node[#node+1] = newNode
	newNode.nodeId = #node
	return "node"..#node
end

local function ParseParameters(params)
	local paramList = {}
	if not params then
		return paramList
	end
	for k,v in string.gmatch(params, "(%w+)=([-%w\\_%.]+)") do
		if (string.match(v,"^%-?%d+%.?%d*$")) then
			v = tonumber(v)
		end	
		if (string.match(k,"^%-?%d+%.?%d*$")) then
			k = tonumber(k)
		end		
		paramList[k] = v
	end
	params = string.gsub(params,"%w+=[-%w\\_%.]+","")
	local n=0
	for w in string.gmatch(params, "[-%w_\\%.]+") do
		if (string.match(w,"^%-?%d+%.?%d*$")) then
			w = tonumber(w)
		end		
		paramList[n+1] = w
		n=n+1
	end
	return paramList
end

local function ParseTime(value)
	return AddNode({type="time", value=tonumber(value)})
end

local function ParseNumber(dummy, value)
	return dummy..AddNode({type="time", value=tonumber(value)})
end

local function ParseFunction(prefix, func, params)
	local paramList = ParseParameters(params)
	if func ~= "" then
		paramList.target = prefix
	else
		func = prefix
	end
	
	if string.find(func, "Target") == 1 then
		if not paramList.target then
			paramList.target = "target"
		end
		func = string.sub(func, 7)
	end
	
	if customFunctions[func] then
		return customFunctions[func]
	end
	
	local newNode = { type="function", func=func, params=paramList}
	return AddNode(newNode)
end

local function ParseSpellAddDebuff(params)
	local paramList = ParseParameters(params)
	local spellId = paramList[1]
	if spellId then
		paramList[1] = nil
		Ovale:GetSpellInfo(spellId).aura.player.HARMFUL = paramList
	end
	return ""
end

local function ParseSpellAddBuff(params)
	local paramList = ParseParameters(params)
	local spellId = paramList[1]
	if spellId then
		paramList[1] = nil
		Ovale:GetSpellInfo(spellId).aura.player.HELPFUL = paramList
	end
	return ""
end

local function ParseSpellAddTargetDebuff(params)
	local paramList = ParseParameters(params)
	local spellId = paramList[1]
	if spellId then
		paramList[1] = nil
		Ovale:GetSpellInfo(spellId).aura.target.HARMFUL = paramList
	end
	return ""
end

local function HasGlyph(spellId)
	for i = 1, GetNumGlyphSockets() do
		local enalbled, glypType, glyphSpellID = GetGlyphSocketInfo(i)
		if (glyphSpellID == spellId) then
			return true
		end
	end
	return false
end

local function HasTalent(talentId)
	if not Ovale.listeTalentsRemplie then
		Ovale:RemplirListeTalents()
	end
	if Ovale.listeTalentsRemplie then
		if Ovale.pointsTalent[talentId]~=nil then
			return Ovale.pointsTalent[talentId]>0
		else
			Ovale:Print("Unknown talent "..talentId)
			return false
		end
	else
		return false
	end
end

local function ParseSpellInfo(params)
	local paramList = ParseParameters(params)
	local spellId = paramList[1]
	if spellId then
		if paramList.glyph and not HasGlyph(paramList.glyph) then
			return ""
		end
		if paramList.talent and not HasTalent(paramList.talent) then
			return ""
		end
		local spellInfo = Ovale:GetSpellInfo(spellId)
		for k,v in pairs(paramList) do
			if k == "addduration" then
				spellInfo.duration = spellInfo.duration + v
			elseif k == "addcd" then
				spellInfo.cd = spellInfo.cd + v
			else
				spellInfo[k] = v
			end
		end
	end
	return ""
end

local function ParseScoreSpells(params)
	for v in string.gmatch(params, "(%d+)") do
		local spellId = tonumber(v)
		if spellId then
			--Ovale:Print("Add spell to score "..spellId)
			Ovale.scoreSpell[spellId] = true
		else
			Ovale:Print("unknown spell "..v)
		end
	end
end

local function ParseSpellList(name, params)
	Ovale.buffSpellList[name] = {}
	local i = 1
	for v in string.gmatch(params, "(%d+)") do
		Ovale.buffSpellList[name][i] = tonumber(v)
		i = i + 1
	end
end

local function ParseIf(a, b)
	local newNode = {type="if", a=node[tonumber(a)], b=node[tonumber(b)]}
	return AddNode(newNode)
end

local function ParseUnless(a, b)
	local newNode = {type="unless", a=node[tonumber(a)], b=node[tonumber(b)]}
	return AddNode(newNode)
end

local function ParseAnd(a,b)
	local newNode = {type="and", a=node[tonumber(a)], b=node[tonumber(b)]}
	return AddNode(newNode)
end

local function ParseBefore(a,b)
	local newNode = {type="before", time=node[tonumber(a)], a=node[tonumber(b)]}
	return AddNode(newNode)
end

local function ParseAfter(a,b)
	local newNode = {type="after", time=node[tonumber(a)], a=node[tonumber(b)]}
	return AddNode(newNode)
end

local function ParseBetween(a,b)
	local newNode = {type="between", a=node[tonumber(a)], b=node[tonumber(b)]}
	return AddNode(newNode)
end

local function ParseFromUntil(a,b)
	local newNode = {type="fromuntil", a=node[tonumber(a)], b=node[tonumber(b)]}
	return AddNode(newNode)
end

local function ParseOr(a,b)
	local newNode = {type="or", a=node[tonumber(a)], b=node[tonumber(b)]}
	return AddNode(newNode)
end

local function ParseOp(a, op, b)
	local newNode = {type="operator", operator=op, a=node[tonumber(a)], b=node[tonumber(b)]}
	return AddNode(newNode)
end

local function ParseCompare(comp,t,a)
	local newNode = {type="compare", comparison=comp, time=node[tonumber(t)], a=node[tonumber(a)]}
	return AddNode(newNode)
end

local function ParseGroup(text)
	local nodes={}
	
	for w in string.gmatch(text, "node(%d+)") do
		nodes[#nodes+1] = node[tonumber(w)]
	end
	
	text = string.gsub(text, "node%d+", "")

	if (string.match(text,"[^ ]")) then
		Ovale:Print("syntax error:"..text)
		return nil
	end
	
	local newNode = {type="group", nodes=nodes}
	return AddNode(newNode)
end

local function subtest(text, pattern, func)
	while (1==1) do
		local was = text
		text = string.gsub(text, pattern, func)
		if (was == text) then
			break
		end
	end
	return text
end

local function TestConditions(paramList)
	if paramList.glyph and not HasGlyph(paramList.glyph) then
		return false
	end
	if paramList.mastery and paramList.mastery~=GetPrimaryTalentTree() then
		return false
	end
	if paramList.talent and not HasTalent(paramList.talent) then
		return false
	end
	if paramList.checkboxon then
		local cb = paramList.checkboxon
		if not Ovale.casesACocher[cb] then
			Ovale.casesACocher[cb] = {}
		end
		Ovale.casesACocher[cb].compile = true
		if not Ovale.db.profile.check[cb] then
			return false
		end
	end
	if paramList.checkboxoff then
		local cb = paramList.checkboxoff
		if not Ovale.casesACocher[cb] then
			Ovale.casesACocher[cb] = {}
		end
		Ovale.casesACocher[cb].compile = true
		if Ovale.db.profile.check[cb] then
			return false
		end
	end
	if paramList.list and paramList.item then
		local list = paramList.list
		local key = paramList.item
		if not Ovale.listes[list] then
			Ovale.listes[list] = { items = {}}
		end
		Ovale.listes[list].compile = true
		if Ovale.db.profile.list[list] ~= key then
			return false
		end
	end
	return true
end

local function ParseAddListItem(list, item, text, params)
	local paramList = ParseParameters(params)
	if not TestConditions(paramList) then
		return ""
	end
	if (not Ovale.listes[list]) then
		Ovale.listes[list] = {items={},default=nil}
	end
	Ovale.listes[list].items[item] = text
	if paramList[1] and paramList[1] == "default" then
		Ovale.listes[list].default=item
	end
	return ""
end


local function ParseAddCheckBox(item, text, params)
	local paramList = ParseParameters(params)
	if not TestConditions(paramList) then
		return ""
	end
	if not Ovale.casesACocher[item] then
		Ovale.casesACocher[item] = {}
	end
	Ovale.casesACocher[item].text = text
	if  paramList[1] and paramList[1]=="default" then
		Ovale.casesACocher[item].checked = true
	end
	return ""
end

local function ParseDefine(key, value)
	defines[key] = value
	return ""
end

local function ParseLua(text)
	local newNode = {type="lua", lua = string.sub(text, 2, string.len(text)-1)}
	return AddNode(newNode)
end

local function ParseCommands(text)
	local original = text
	text = string.gsub(text,"(%b[])", ParseLua)
	while (1==1) do
		local was = text
		text = string.gsub(text, "(%w+)%.?(%w*)%s*%((.-)%)", ParseFunction)
		text = string.gsub(text, "(%d+%.?%d*)s", ParseTime)
		text = string.gsub(text, "between%s+node(%d+)%s+and%s+node(%d+)", ParseBetween)
		text = string.gsub(text, "from%s+node(%d+)%s+until%s+node(%d+)", ParseFromUntil)
		text = string.gsub(text, "(more)%s+than%s+node(%d+)%s+node(%d+)", ParseCompare)
		text = string.gsub(text, "(less)%s+than%s+node(%d+)%s+node(%d+)", ParseCompare)		
		text = string.gsub(text, "(at least)%s+node(%d+)%s+node(%d+)", ParseCompare)
		text = string.gsub(text, "(at most)%s+node(%d+)%s+node(%d+)", ParseCompare)		
		text = string.gsub(text, "node(%d+)%s+before%s+node(%d+)", ParseBefore)
		text = string.gsub(text, "node(%d+)%s+after%s+node(%d+)", ParseAfter)
		text = string.gsub(text, "([^%w])(%d+%.?%d*)", ParseNumber)
		text = string.gsub(text, "node(%d+)%s*([%*%+%-%/%>%<])%s*node(%d+)", ParseOp)
		if (was == text) then
			break
		end
	end

	while (1==1) do
		local was = text
		text = string.gsub(text, "node(%d+)%s*([%*%+%-%/%>%<])%s*node(%d+)", ParseOp)
		text = string.gsub(text, "node(%d+)%s+and%s+node(%d+)", ParseAnd)
		text = string.gsub(text, "node(%d+)%s+or%s+node(%d+)", ParseOr)
		text = string.gsub(text, "if%s+node(%d+)%s+node(%d+)",ParseIf)
		text = string.gsub(text, "unless%s+node(%d+)%s+node(%d+)",ParseUnless)
		text = string.gsub(text, "{([node%d ]*)}", ParseGroup)
		if (was == text) then
			break
		end
	end

		
	local masterNode
	if (text) then
		masterNode = string.match(text, "node(%d+)")
	end
	if (not masterNode) then
		Ovale:Print("no master node")
		return nil
	end
	
	-- Si il reste autre chose que des espaces, c'est une erreur de syntaxe
	text = string.gsub(text, "node%d+", "", 1)
	if (string.match(text,"[^ ]")) then
		Ovale:Print("Group:"..original)
		Ovale:Print("syntax error:"..text)
		return nil
	end
	return masterNode
end

local function ParseAddIcon(params, text)
	-- On convertit le numéro de node en node
	local masterNode = ParseCommands(text)
	masterNode = node[tonumber(masterNode)]
	masterNode.params = ParseParameters(params)
	if not TestConditions(masterNode.params) then
		return nil
	end
	return masterNode
end

function Ovale:CompileInputs(text)
	self.casesACocher = {}
	self.listes = {}
	self.defaultListes = {}
	self.defaultCheck = {}
	
	text = string.gsub(text, "AddListItem%s*%(%s*(%w+)%s+(%w+)%s+\"(.-)\"%s*(.-)%s*%)", ParseAddListItem)
	text = string.gsub(text, "AddCheckBox%s*%(%s*(%w+)%s+\"(.-)\"%s*(.-)%s*%)", ParseAddCheckBox)
	return text
end

local function ParseCanStopChannelling(text)
	local spellId = tonumber(text)
	if spellId then
		Ovale:GetSpellInfo(spellId).canStopChannelling = true
	else
		Ovale:Print("CanStopChannelling with unknown spell "..spellId)
	end
	return ""
end

local function ParseSpellName(text)
	local spell = Ovale:GetSpellInfoOrNil(text)
	if (spell) then
		return '"'..spell..'"'
	else
		Ovale:Print("SpellName of "..text.." unknown")
		return nil
	end
end

local function ParseL(text)
	return '"'..L[text]..'"'
end

function Ovale:Compile(text)
	self.bug = false
	node = {}
	defines = {}
	
	-- Suppression des commentaires
	text = string.gsub(text, "#.-\n","")
	text = string.gsub(text, "#.*$","")

	-- Define(CONSTANTE valeur)
	text = string.gsub(text, "Define%s*%(%s*(%w+)%s+(%w+)%s*%)", ParseDefine)
	
	-- On remplace les constantes par leur valeur
	for k,v in pairs(defines) do
		text = subtest(text, "([^%w])"..k.."([^%w])", "%1"..v.."%2")
	end
	
	-- Fonctions
	text = string.gsub(text, "SpellName%s*%(%s*(%w+)%s*%)", ParseSpellName)
	text = string.gsub(text, "L%s*%(%s*(%w+)%s*%)", ParseL)
	
	-- Options diverses
	Ovale:ResetSpellInfo()
	text = string.gsub(text, "CanStopChannelling%s*%(%s*(%w+)%s*%)", ParseCanStopChannelling)
	text = string.gsub(text, "SpellAddBuff%s*%((.-)%)", ParseSpellAddBuff)
	text = string.gsub(text, "SpellAddDebuff%s*%((.-)%)", ParseSpellAddDebuff)
	text = string.gsub(text, "SpellAddTargetDebuff%s*%((.-)%)", ParseSpellAddTargetDebuff)
	text = string.gsub(text, "SpellInfo%s*%((.-)%)", ParseSpellInfo)
	text = string.gsub(text, "ScoreSpells%s*%((.-)%)", ParseScoreSpells)
	text = string.gsub(text, "SpellList%s*%(%s*(%w+)%s*(.-)%)", ParseSpellList)
			
	-- On vire les espaces en trop
	text = string.gsub(text, "\n", " ")
	text = string.gsub(text, "%s+", " ")
	
	-- On compile les AddCheckBox et AddListItem
	text = self:CompileInputs(text)
	
	for p,t in string.gmatch(text, "AddFunction%s+(%w+)%s*(%b{})") do
		local newNode = ParseCommands(t)
		if newNode then
			customFunctions[p] = "node"..newNode
		end
	end
	
	local masterNodes ={}
	
	-- On compile les AddIcon
	for p,t in string.gmatch(text, "AddIcon%s*(.-)%s*(%b{})") do
		local newNode = ParseAddIcon(p,t)
		if newNode then
			masterNodes[#masterNodes+1] = newNode
		end
	end
	return masterNodes
end

function Ovale:DebugNode(node)
	local text
	if (not node) then
		return "#nil"
	end
	if (node.type == "group") then
		text = "{"
		for k,n in ipairs(node.nodes) do
			text = text .. self:DebugNode(n) .. " "
		end
		text = text .. "}\n"
	elseif (node.type == "function") then
		text = node.func.."("
		for k,p in pairs(node.params) do
			text = text .. k.."=" .. p .. " "
		end
		text = text .. ")"
	elseif (node.type == "if") then
		text = "if "..self:DebugNode(node.a).." "..self:DebugNode(node.b)
	elseif (node.type == "unless") then
		text = "unless "..self:DebugNode(node.a).." "..self:DebugNode(node.b)
	elseif (node.type == "and") then
		text = self:DebugNode(node.a).." and "..self:DebugNode(node.b)
	elseif (node.type == "or") then
		text = self:DebugNode(node.a).." or "..self:DebugNode(node.b)
	elseif (node.type == "before") then
		text = self:DebugNode(node.time) .. " before "..self:DebugNode(node.a)
	elseif (node.type == "between") then
		text = "between "..self:DebugNode(node.a).." and "..self:DebugNode(node.b)
	elseif (node.type == "fromuntil") then
		text = "from "..self:DebugNode(node.a).." until "..self:DebugNode(node.b)
	elseif (node.type == "compare") then
		text = node.comparison.." than "..self:DebugNode(node.time).." "..self:DebugNode(node.a)
	elseif (node.type == "time") then
		text = node.value.."s"
	elseif node.type == "operator" then
		text = self:DebugNode(node.a)..node.operator..self:DebugNode(node.b)
	elseif node.type == "lua" then
		text = "["..node.lua.."]"
	else
		text = "#unknown node type#"
	end
	
	return text
end