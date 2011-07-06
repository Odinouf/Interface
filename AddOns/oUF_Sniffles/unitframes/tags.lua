local _, ns = ...
local oUF = ns.oUF

-- Credits to Caellian (oUF Caellian)
local function utf8sub(string, i, dots)
  local bytes = string:len()
  if bytes <= i then
    return string
  else
    local len, pos = 0, 1
    while pos <= bytes do
      len = len + 1
      local c = string:byte(pos)
      if c > 0 and c <= 127 then
        pos = pos + 1
      elseif c >= 194 and c <= 223 then
        pos = pos + 2
      elseif c >= 224 and c <= 239 then
        pos = pos + 3
      elseif c >= 240 and c <= 244 then
        pos = pos + 4
      end
      if len == i then break end
    end

    if len == i and pos <= bytes then
      return string:sub(1, pos - 1)..(dots and "..." or "")
    else
      return string
    end
  end
end

local function ShortenValue(value)
	if(value >= 1e6) then
		return ('%.2fm'):format(value / 1e6):gsub('%.?0+([km])$', '%1')
	elseif(value >= 1e4) then
		return ('%.1fk'):format(value / 1e3):gsub('%.?0+([km])$', '%1')
	else
		return value
	end
end
    
oUF.Tags["veryshortname"] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 4, false)
end
oUF.TagEvents["veryshortname"] = "UNIT_NAME_UPDATE"

oUF.Tags["shortname"] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 6, false)
end
oUF.TagEvents["shortname"] = "UNIT_NAME_UPDATE"

oUF.Tags["longname"] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 8, false)
end
oUF.TagEvents["longname"] = "UNIT_NAME_UPDATE"


oUF.TagEvents['sniffles:threat'] = 'UNIT_THREAT_LIST_UPDATE'
oUF.Tags['sniffles:threat'] = function(unit)
	local tanking, status, percent = UnitDetailedThreatSituation('player', 'target')
	if(percent and percent > 0) then
		return ('%s%d%%|r'):format(Hex(GetThreatStatusColor(status)), percent)
	end
end

oUF.Tags['sniffles:health'] = function(unit)
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local status = not UnitIsConnected(unit) and 'Offline' or UnitIsGhost(unit) and 'Ghost' or UnitIsDead(unit) and 'Dead'

	if(status) then
		return status
	elseif(unit == 'target' and UnitCanAttack('player', unit)) then
		return ('%s (%d|cff0090ff%%|r)'):format(ShortenValue(min), min / max * 100)
	elseif(unit == 'player' and min ~= max) then
		return ('|cffff8080%d|r %d|cff0090ff%%|r'):format(min - max, min / max * 100)
	elseif(min ~= max) then
		return ('%s |cff0090ff/|r %s'):format(ShortenValue(min), ShortenValue(max))
	else
		return max
	end
end

oUF.Tags['sniffles:power'] = function(unit)
	local power = UnitPower(unit)
	if(power > 0 and not UnitIsDeadOrGhost(unit)) then
		local _, type = UnitPowerType(unit)
		local colors = _COLORS.power
		return ('%s%d|r'):format(Hex(colors[type] or colors['RUNES']), power)
	end
end

oUF.Tags['sniffles:druid'] = function(unit)
	local min, max = UnitPower(unit, 0), UnitPowerMax(unit, 0)
	if(UnitPowerType(unit) ~= 0 and min ~= max) then
		return ('|cff0090ff%d%%|r'):format(min / max * 100)
	end
end

oUF.TagEvents['sniffles:name'] = 'UNIT_NAME_UPDATE UNIT_REACTION UNIT_FACTION'
oUF.Tags['sniffles:name'] = function(unit)
	local reaction = UnitReaction(unit, 'player')

	local r, g, b = 1, 1, 1
	if((UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)) or not UnitIsConnected(unit)) then
		r, g, b = 3/5, 3/5, 3/5
	elseif(not UnitIsPlayer(unit) and reaction) then
		r, g, b = unpack(_COLORS.reaction[reaction])
	elseif(UnitFactionGroup(unit) and UnitIsEnemy(unit, 'player') and UnitIsPVP(unit)) then
		r, g, b = 1, 0, 0
	end

	return ('%s%s|r'):format(Hex(r, g, b), UnitName(unit))
end