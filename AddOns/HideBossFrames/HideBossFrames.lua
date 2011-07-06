-- HideBossFrames by Strikerhawk

function hideBossFrames()
	for i = 1, 4 do
		local frame = _G["Boss"..i.."TargetFrame"]
		frame:UnregisterAllEvents()
		frame:Hide()
		frame.Show = function () end
	end
end
-- Call the hide function
hideBossFrames()