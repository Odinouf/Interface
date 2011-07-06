Qulight = { }

_, myclass = UnitClass("player") 
myname, _ = UnitName("player")
resolution = GetCurrentResolution()
getscreenresolution = select(resolution, GetScreenResolutions())
version = GetAddOnMetadata("QulightUI", "Version")
dummy = function() return end
client = GetLocale() 
incombat = UnitAffectingCombat("player")
patch = GetBuildInfo()
level = UnitLevel("player")
