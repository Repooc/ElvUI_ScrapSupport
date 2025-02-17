local E = unpack(ElvUI)
local B = E:GetModule('Bags')

local _G = _G
local GetContainerItemID = C_Container and C_Container.GetContainerItemID or _G.GetContainerItemID
local Scrap = _G.Scrap
if not Scrap then return end

local Spotlight = _G.Scrap.Spotlight

local function UpdateSlot(_, frame, bagID, slotID)
	if not frame then return end
	local bag = frame.Bags[bagID]
	local slot = bag and bag[slotID]
	if not slot or bagID <= -1 then return end

	local itemID = GetContainerItemID(bagID, slotID)
	local isJunk = itemID and Scrap:IsJunk(itemID, bagID, slotID)

	local icon = (slot.JunkIcon or Spotlight.Icons[slot] or Spotlight:NewIcon(slot))
	local glow = (Spotlight.Glows[slot] or Spotlight:NewGlow(slot))

	icon:SetShown(isJunk and Scrap.sets.icons)
	glow:SetShown(isJunk and Scrap.sets.glow)
end

local function UpdateAll()
	local container = _G.ElvUI_ContainerFrame
	if not container then return end

	for k, frame in pairs(container.Bags) do
		if not E.Retail then
			k = k-1
		end

		local numSlots = frame.numSlots
		if not numSlots then return end
		if type(numSlots) == 'string' then numSlots = tonumber(numSlots) end
		for i = 1, numSlots do
			local slot = _G['ElvUI_ContainerFrameBag'..k..'Slot'..i]
			if not slot then return end
			UpdateSlot(nil, container, slot.BagID, slot.SlotID)
		end
	end
end

hooksecurefunc(Scrap, 'ToggleJunk', UpdateAll)
hooksecurefunc(B, 'UpdateSlot', UpdateSlot)
Scrap:RegisterSignal('LIST_CHANGED', UpdateAll)
