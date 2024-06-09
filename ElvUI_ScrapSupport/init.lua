local E = unpack(ElvUI)
local B = E:GetModule('Bags')

local _G = _G
local GetContainerItemID = C_Container and C_Container.GetContainerItemID or _G.GetContainerItemID
local Scrap = _G.Scrap

local function UpdateSlot(_, frame, bagID, slotID)
	if not frame then return end
	local bag = frame.Bags[bagID]
	local slot = bag and bag[slotID]
	if not slot or bagID <= -1 then return end

	local itemID = GetContainerItemID(bagID, slotID)
	local isJunk = itemID and Scrap:IsJunk(itemID, bagID, slotID)
	if E.Retail then
		slot.ScrapIcon:SetShown(isJunk and Scrap.sets.icons)
	else
		slot.JunkIcon:SetShown(isJunk and Scrap.sets.icons)
	end
end

local function UpdateAll()
	local container = _G.ElvUI_ContainerFrame
	for k, frame in pairs(container.Bags) do
		if not E.Retail then
			k = k-1
		end

		local numSlots = frame.numSlots
		for i = 1, numSlots do
			local slot = _G['ElvUI_ContainerFrameBag'..k..'Slot'..i]
			if not slot then return end
			UpdateSlot(nil, container, slot.BagID, slot.SlotID)
		end
	end
end

hooksecurefunc(Scrap, 'ToggleJunk', UpdateAll)
hooksecurefunc(B, 'UpdateSlot', UpdateSlot)
