  
  --get the addon namespace
  local addon, ns = ...
  
  --get the config values
  local cfg = ns.cfg
  local barcfg = cfg.bars.bar5
  
  local bar = CreateFrame("Frame","rABS_MultiBarLeft",UIParent, "SecureHandlerStateTemplate")
  if barcfg.uselayout2x6 then
    bar:SetHeight(barcfg.buttonsize*6+barcfg.buttonspacing*5) --inverse
    bar:SetWidth(barcfg.buttonsize*2+barcfg.buttonspacing)
  else  
    bar:SetWidth(barcfg.buttonsize*12+barcfg.buttonspacing*11)
    bar:SetHeight(barcfg.buttonsize)
  end
  if barcfg.uselayout2x6 then
  --  bar:SetPoint(barcfg.pos.a1,barcfg.pos.af,barcfg.pos.a2,barcfg.pos.x-((barcfg.buttonsize*6+barcfg.buttonspacing*6)/2),barcfg.pos.y)
    bar:SetPoint(barcfg.pos.a1,barcfg.pos.af,barcfg.pos.a2,barcfg.pos.x-((barcfg.buttonsize*6+barcfg.buttonspacing*6)/2),barcfg.pos.y)
  else 
    bar:SetPoint(barcfg.pos.a1,barcfg.pos.af,barcfg.pos.a2,barcfg.pos.x,barcfg.pos.y)
  end
  bar:SetHitRectInsets(-cfg.barinset, -cfg.barinset, -cfg.barinset, -cfg.barinset)
  
  if barcfg.testmode then
    bar:SetBackdrop(cfg.backdrop)
    bar:SetBackdropColor(1,0.8,1,0.6)
  end
  bar:SetScale(barcfg.barscale)

  cfg.applyDragFunctionality(bar,barcfg.userplaced,barcfg.locked)

  MultiBarLeft:SetParent(bar)
  
  for i=1, 12 do
    local button = _G["MultiBarLeftButton"..i]
    button:ClearAllPoints()
    button:SetSize(barcfg.buttonsize, barcfg.buttonsize)
    if i == 1 then
      button:SetPoint("TOPLEFT", bar, 0,0)
    else
      local previous = _G["MultiBarLeftButton"..i-1]
	  if barcfg.uselayout2x6 and i == 7 then
        previous = _G["MultiBarLeftButton1"]
        button:SetPoint("RIGHT", previous, "RIGHT", barcfg.buttonspacing+barcfg.buttonsize, 0)
      else
      button:SetPoint("TOP", previous, "BOTTOM", 0, -barcfg.buttonspacing)
	  end
    end
  end
  
  if barcfg.showonmouseover then    
    local function lighton(alpha)
      if MultiBarLeft:IsShown() then
        for i=1, 12 do
          local pb = _G["MultiBarLeftButton"..i]
          pb:SetAlpha(alpha)
        end
      end
    end    
    bar:EnableMouse(true)
    bar:SetScript("OnEnter", function(self) lighton(1) end)
    bar:SetScript("OnLeave", function(self) lighton(0) end)  
    for i=1, 12 do
      local pb = _G["MultiBarLeftButton"..i]
      pb:SetAlpha(0)
      pb:HookScript("OnEnter", function(self) lighton(1) end)
      pb:HookScript("OnLeave", function(self) lighton(0) end)
    end    
  end