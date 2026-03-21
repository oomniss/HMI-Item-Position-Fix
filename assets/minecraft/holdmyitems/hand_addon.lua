-- by omnis._.

-- === CONTEXTS ===
local l           = context.mainHand and 1 or -1
local itemName    = I:getName(context.item):gsub("minecraft:", "")

-- === FUNCTIONS AND COMPATIBILITY ===
local function matched(item, match)
    local list = type(item) == "table" and item or {item}

    local function check(i)
        if match then
            return itemName:match(i) ~= nil
        end
        return itemName == i
            or I:isIn(context.item, Tags:getFabricTag(i))
            or I:isIn(context.item, Tags:getVanillaTag(i))
    end

    for _, i in ipairs(list) do
        if check(i) then return true end
    end
    return false
end

-- == Compatibility ==
local isItemCompat = false
for _, rp in ipairs(ActivePacks) do
    local pack = PackCompat[rp]
    for _, i in ipairs(pack[1]) do
        if matched(i, pack.matches) then
            isItemCompat = true
        end
    end
end

-- == Position Processing ==
local move = {
    x = function(v) M:moveX(context.matrices, v * l) end,
    y = function(v) M:moveY(context.matrices, v) end,
    z = function(v) M:moveZ(context.matrices, v) end
}
local rotate = {
    x = function(v) M:rotateX(context.matrices, v) end,
    y = function(v) M:rotateY(context.matrices, v * l) end,
    z = function(v) M:rotateZ(context.matrices, v * l) end
}

local function process(ops, dataORx, default_y, default_z)
    if type(dataORx) ~= "table" then
        if dataORx   then ops.x(dataORx)    end
        if default_y then ops.y(default_y)  end
        if default_z then ops.z(default_z)  end
        return
    end
    local order = dataORx[4] or "xyz"
    for i = 1, 3 do
        local axis = order:sub(i, i):lower()
        local val  = dataORx[i]
        if val and ops[axis] then ops[axis](val) end
    end
end

local function pose(tables, force)
    for _, t in ipairs(tables) do
        for _, i in ipairs(t[1]) do
            if matched(i, t.matches) then
                if not isItemCompat or force then
                    if t.m then process(move, t.m)   end
                    if t.r then process(rotate, t.r) end
                    if t.s then
                        if t.s[2] == nil and t.s[3] == nil then
                            M:scale(t.s[1], t.s[1], t.s[1])
                        else
                            M:scale(t.s[1], t.s[2], t.s[3])
                        end
                    end
                end
                return
            end
        end
    end
end

-- === PACKS COMPATIBILITY ===


-- === INDIVIDUAL ADJUSTS ===
pose({
    { {"weeping_vines", "hanging_roots", "pale_hanging_moss", "spore_blossom"}, m = {nil, 0.35, -0.05} },
    { {"glow_item_frame"}, m = {0.14, nil, nil}, r = {25, nil, nil} }
})