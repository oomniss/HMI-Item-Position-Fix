-- by omnis._.

-- === CONTEXTS ===
local l         = context.mainHand and 1 or -1
local itemName  = I:getName(context.item):gsub("minecraft:", "")

-- === PACKS COMPATIBILITY ===
local w3di        = ${w3di} 
local a3ds        = ${a3ds} 
local rvTorchs    = ${rvTorchs} 
local bensBundle  = ${bensBundle}
local freshOres   = ${freshOresIngots} 

-- === FUNCTIONS ===
local function itemMatches(tableMatch)
    for _, item in ipairs(tableMatch) do
        if itemName:match(item) then
            return true
        end
    end
    return false
end

local function pose(tables)
    for _, t in ipairs(tables) do
        if (t.condition and t.condition[1]) or not t.condition then
            for _, i in ipairs(t[1]) do
                if itemName:match(i) then
                    if t.m then 
                        if t.m[1] then M:moveX(context.matrices, t.m[1] * l) end
                        if t.m[2] then M:moveY(context.matrices, t.m[2]) end
                        if t.m[3] then M:moveZ(context.matrices, t.m[3]) end
                    end
                    if t.r then 
                        if t.r[1] then M:rotateX(context.matrices, t.r[1]) end
                        if t.r[2] then M:rotateY(context.matrices, t.r[2] * l) end
                        if t.r[3] then M:rotateZ(context.matrices, t.r[3] * l) end
                    end
                    if t.s then 
                        if t.s[1] and not t.s[2] and not t.s[3] then
                            M:scale(context.matrices, t.s[1], t.s[1], t.s[1])
                        elseif t.s[1] or t.s[2] or t.s[3] then
                            M:scale(context.matrices, t.s[1], t.s[2], t.s[3])
                        end
                    end
                end
            end
        end
    end
end

-- === PACKS ADJUSTS ===
local undoPackAdjustments = {
    w3di = {
        { {
            "fire_charge", "goat_horn", "snowball", "^egg$", "blue_egg", "brown_egg", "ender_pearl", 
            "ender_eye", "firework_rocket", "lead", "^bone$", "brick&", "honeycomb",
            "clay_ball", "nautilus_shell", "_rod", "book", "gunpowder", "glowstone_dust", 
            "blaze_powder", "^sugar$", "stick", "heart_of_the_sea", "slime_ball", "^map$", "totem_of_undying"
        }, m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },

        -- Tools
        { {"boat", "raft"}, m = {nil, 0.05, nil} },
        { {"flint_and_steel"}, m = {nil, nil, -0.05}, r = {nil, nil, -10} },
        { {"shears"}, m = {nil, 0.1, -0.05}, r = {nil, nil, -10} },
        { {"armor_stand"}, m = {0.09, 0.12, -0.05}, r = {nil, nil, -10} },
        { {"^compass$"}, m = {0.12, 0.12, -0.05}, r = {nil, nil, -10} },

        -- Ingredients
        { {"banner_pattern", "name_tag"}, m = {nil, -0.3, 0.05} },
    },
    wd3iOres = {
        { {
            "^flint$", "coal$", "raw", "^emerald$", "^diamond$", "^lapis_lazuli$", "^quartz$", "nugget", 
            "amethyst_shard", "ingot", "netherite_scrap", "^redstone$"
        }, m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} }
    },
    w3diBundles = {
        { {"bundle"}, m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} }
    }
}
if w3di and a3ds and itemMatches(undoPackAdjustments.w3di[1][1]) then pose(undoPackAdjustments.w3di) end
if w3di and freshOres and itemMatches(undoPackAdjustments.w3di[1][1]) then pose(undoPackAdjustments.wd3iOres) end

-- Actually 3D Stuff
if a3ds then
    if not bensBundle and itemName:match("bundle") then
        if w3di then pose(undoPackAdjustments.w3diBundles) end
    end
    if not freshOres and itemMatches(undoPackAdjustments.wd3iOres[1][1]) then
        if w3di then pose(undoPackAdjustments.wd3iOres) end
    end
    pose({
        { {"lily_pad"}, m = {nil, 0.6, -0.1} }
    })
end

-- Weskerson's 3D Items
if w3di and not rvTorchs then
    pose({
        { {"copper_torch"}, m = {nil, nil, 0.05}, r = {nil, nil, 10} }
    })
elseif w3di and rvTorchs then
    pose({
        { {"^torch$", "soul_torch"}, m = {nil, nil, -0.05}, r = {nil, nil, -10} }
    })
end

-- === HANGING PLANTS ADJUSTS ===
pose({
    { {"weeping_vines", "hanging_roots", "pale_hanging_moss", "spore_blossom"}, m = {nil, 0.35, -0.05} },
})