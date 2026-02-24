-- by omnis._.

local itemName = I:getName(context.item):gsub("minecraft:", "")
local matrices = context.matrices

if (
    itemName == "weeping_vines" or
    itemName == "hanging_roots" or
    itemName == "pale_hanging_moss" or
    itemName == "spore_blossom"
) then
    M:moveY(matrices, 0.35)
    M:moveZ(matrices, -0.05)
end