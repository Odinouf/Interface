local addon, ns = ...
local cfg = ns.cfg
if not cfg.EnableMountz then return end
-------- < Universal Mount macro:  Mountz("your_ground_mount","your_flying_mount") 
function Mountz(groundmount, flyingmount, underwatermount)
    local flyablex, swimablex, vjswim
	local num = GetNumCompanions("MOUNT")
--	local continent = GetCurrentMapContinent()	local zone = GetCurrentMapZone() if zone == 16 and continent == 2 then end
    if not num or IsMounted() then
        Dismount()
        return
    end
    if CanExitVehicle() then 
        VehicleExit()
        return
    end
	for i = 1, 40 do
		local n, _, _, _, _, _, _, _, _, _, sid = UnitBuff("player",i) 
		if sid == 73701 or sid == 76377 then
			vjswim = true
		end
	end
	flyablex = IsFlyableArea()
    if IsControlKeyDown() then
        flyablex = not flyablex
    end
	if IsAltKeyDown() then
        vjswim = not vjswim
    end
    for i=1, num, 1 do
        local _, info, id = GetCompanionInfo("MOUNT", i)
        if flyingmount and info == flyingmount and flyablex then
            CallCompanion("MOUNT", i)
            return
        elseif groundmount and info == groundmount and not flyablex then
            CallCompanion("MOUNT", i)
            return
		elseif id == 75207 and vjswim and IsSwimming() then
			CallCompanion("MOUNT", i)
            return
        end
    end
end