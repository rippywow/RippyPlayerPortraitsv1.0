local highestPortraitIndex = 13


local defaultPortraitIndex = 0


local TPortraitBase = "Interface\\AddOns\\RippyPortraits\\Portraits\\"
local TPortrait = "Interface\\AddOns\\RippyPortraits\\Portraits\\1"


local function UpdateMicroButtonPortrait ()
	if MicroButtonPortrait then
		SetPortraitTexture (MicroButtonPortrait, 'player')
	end
end


local function UpdatePaperDollPortrait ()
	if PaperDollSidebarTab1 and PaperDollSidebarTab1.Icon then
		SetPortraitTexture (PaperDollSidebarTab1.Icon, 'player')
	end
end


local function UpdateDressUpPortrait ()
	if DressUpFramePortrait then
		SetPortraitTexture (DressUpFramePortrait, 'player')
	end
end


local function UpdatePortraits ()
	SetPortraitTexture (PlayerPortrait, PlayerFrame.unit)
	SetPortraitTexture (TargetFramePortrait, TargetFrame.unit)
	if TargetFrame.totFrame and TargetFrame.totFrame.unit then
	 	SetPortraitTexture (TargetFrameToTPortrait, TargetFrame.totFrame.unit)
	end
	UpdateMicroButtonPortrait ()
	UpdatePaperDollPortrait ()
	UpdateDressUpPortrait ()
end


local function PlayerFrame_OnMouseWheel (self, direction)
	if direction > 0 then
		if savedPortraitIndex == highestPortraitIndex then
			savedPortraitIndex = 0
		else
			savedPortraitIndex = savedPortraitIndex + 1
		end
	elseif direction < 0 then
		if savedPortraitIndex == 0 then
			savedPortraitIndex = highestPortraitIndex
		else
			savedPortraitIndex = savedPortraitIndex - 1
		end
	end
	if savedPortraitIndex > 0 then
		TPortrait = TPortraitBase .. savedPortraitIndex
	end
	UpdatePortraits ()
end


local function Hook_SetPortraitTexture (portrait, unit)
	if UnitIsUnit (unit, 'player') and portrait and (savedPortraitIndex > 0) then
		portrait:SetTexture (TPortrait)
	end
end


function RippyPlayerPortraitFrame_OnEvent (self, event, ...)
	if event == 'PLAYER_ENTERING_WORLD' then
		UpdatePortraits ()
	elseif event == 'ADDON_LOADED' then
		local name = ...
		if not name == "RippyPlayerPortrait" then return end
		if not savedPortraitIndex then
			savedPortraitIndex = defaultPortraitIndex
		end
		if savedPortraitIndex < 0 then
			savedPortraitIndex = 0
		elseif savedPortraitIndex > highestPortraitIndex then
			savedPortraitIndex = highestPortraitIndex
		end
		TPortrait = TPortraitBase .. savedPortraitIndex
		self:UnregisterEvent 'ADDON_LOADED'
	end
end


function RippyPlayerPortraitFrame_OnLoad (self)
	hooksecurefunc ('SetPortraitTexture', Hook_SetPortraitTexture)
	PlayerFrame:EnableMouseWheel (true)
	PlayerFrame:SetScript ('OnMouseWheel', PlayerFrame_OnMouseWheel)
	self:RegisterEvent 'ADDON_LOADED'
	self:RegisterEvent 'PLAYER_ENTERING_WORLD'
end
