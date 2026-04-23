-- by omnis._.

local l           = context.mainHand and 1 or -1
local mat         = context.matrices
local itemName    = I:getName(context.item):gsub("minecraft:", "")

-- === FUNCTIONS AND COMPATIBILITY ===
local function matched(items, matches)
    local list = type(items) == "table" and items or {items}

    local function check(i)
        if itemName == i then
            return true
        end
        if matches and itemName:match(i) then
            return true
        end
        if i:find("[%^%$%(%)%%%.%[%]%*%+%-%?]") then
            return false
        end
        return I:isIn(context.item, Tags:getFabricTag(i))
            or I:isIn(context.item, Tags:getVanillaTag(i))
    end

    for _, i in ipairs(list) do
        if check(i) then return true end
    end
    return false
end

-- == Position Processing ==
local move = {
    x = function(v) M:moveX(mat, v * l) end,
    y = function(v) M:moveY(mat, v) end,
    z = function(v) M:moveZ(mat, v) end
}
local rotate = {
    x = function(v) M:rotateX(mat, v) end,
    y = function(v) M:rotateY(mat, v * l) end,
    z = function(v) M:rotateZ(mat, v * l) end
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
        if (t.condition ~= nil and t.condition[1]) or t.condition == nil then
            for _, i in ipairs(t[1]) do
                if matched(i, t.matches) then
                    if not IsItemCompat or force then
                        local opsOrder = t.ops or "mrs"
                        for j = 1, #opsOrder do
                            local op = opsOrder:sub(j, j):lower()
                            if op == "m" and t.m then process(move, t.m) end
                            if op == "r" and t.r then process(rotate, t.r) end
                            if op == "s" and t.s then
                                if t.s[2] == nil and t.s[3] == nil then
                                    M:scale(mat, t.s[1], t.s[1], t.s[1])
                                else
                                    M:scale(mat, t.s[1], t.s[2], t.s[3])
                                end
                            end
                        end
                    end
                    return
                end
            end
        end
    end
end

-- === PACKS COMPATIBILITY ===
local a3ds              = ${a3ds}
local w3di              = ${w3di}
local w3Dfoods          = ${w3Dfoods}
local just3Darmors      = ${just3Darmors}
local glowing3Darmors   = ${glowing3Darmors}
local glowing3Dtotem    = ${glowing3Dtotem}
local rvTorches         = ${rvTorches}
local refinedTorches    = ${refinedTorches}
local refinedBuckets    = ${refinedBuckets}
local freshFoods        = ${freshFoods}
local freshOres         = ${freshOresIngots}
local freshDiscs        = ${freshDiscs}
local better3Dbooks     = ${better3Dbooks}
local bensBundle        = ${bensBundle}

-- == UNDO ADJUSTS ==
local handUndoAdjusts = {
    w3di = {
        totem = {
            { {"totem_of_undying"}, m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} }
        },
        musicDiscs = {
            { {"music_disc"}, m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} }
        },
        bucket = {
            { {"bucket"}, m = {0, -0.1, nil, "yzx"}, r = {5, -10, nil, "yzx"}, matches = true }
        },
        bundles = {
            { {"bundles"}, m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} }
        },
        books = {
            { {"writable_book"}, m = {0.09, 0.09, -0.05}, r = {nil, nil, -10}, condition = {w3di and not a3ds} },
            { {"book", "enchanted_book", "written_book"}, m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} }
        },
        torches = {
            { {"torch", "soul_torch", "redstone_torch"}, m = {-0.05, nil, nil, "zxy"}, r = {-10, nil, nil, "zyx"} },
            { {"lanterns"}, m = {-0.1, -0.05, nil, "zyx"} },
            { {"campfire", "soul_campfire"}, m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
            { {"repeater", "comparator"}, m = {0.09, 0.09, -0.05}, r = {nil, nil, -10}, condition = {rvTorches} },
        },
        foods = {
            { {
                "beef", "porkchop", "mutton", "rotten_flesh", "^chicken$", "cooked_chicken", "^rabbit$", "cooked_rabbit",
                "apple", "melon_slice", "_berries", "^chorus_fruit$", "carrot", "^beetroot$", "potato", "^dried_kelp$",
                "^cod$", "cooked_cod", "^salmon$", "cooked_salmon", "^tropical_fish$", "^pufferfish$", "bread", "cookie",
                "cake", "pumpkin_pie", "^spider_eye$", "_soup", "_stew", "bowl"
            }, m = {0.09, 0.09, -0.05}, r = {nil, nil, -10}, matches = true },
        },
        ores = {
            { {
                "coal$", "raw_", "^emerald$", "^diamond$", "^lapis_lazuli$", "_nugget", "^quartz$", "amethyst_shard",
                "_ingot", "brick$", "netherite_scrap", "^flint$"
            }, m = {0.09, 0.09, -0.05}, r = {nil, nil, -10}, matches = true },
        },
        a3dsCompat = {
            { {
                "ender_pearl", "ender_eye", "fire_charge", "lead", "map", "writable_book", "firework_rocket", "goat_horn",
                "egg", "blue_egg", "brown_egg", "snowball", "stick", "blaze_rod", "breeze_rod", "bone", "honeycomb",
                "clay_ball", "heart_of_the_sea"
            }, m = {0.09, 0.09, -0.05}, r = {nil, nil, -10}},

            { {"name_tag", "_banner_pattern"}, m = {0.05, -0.3, nil, "zyx"} },
            { {"armor_stand"}, m = {0.09, 0.12, 0.05}, r = {nil, nil, -10} },
            { {"boats"}, m = {nil, 0.05, nil} },
            { {"fishing_rod", "carrot_on_a_stick", "warped_fungus_on_a_stick"}, m = {-0.2, 0.2, 0.1}, r = {nil, nil, -10} },
            { {"flint_and_steel"}, m = {nil, nil, -0.05}, r = {nil, nil, -10} },
            { {"shears"}, m = {nil, 0.1, -0.05}, r = {nil, nil, -10} },
            { {"compass", "clock"}, m = {0.12, 0.12, -0.05}, r = {nil, nil, -10} }
        }
    }
}

if w3di and a3ds then
    pose(handUndoAdjusts.w3di.a3dsCompat, true)
    if not freshOres                    then pose(handUndoAdjusts.w3di.ores, true)          end
    if not glowing3Dtotem               then pose(handUndoAdjusts.w3di.totem, true)         end
    if not bensBundle                   then pose(handUndoAdjusts.w3di.bundles, true)       end
end
if w3di then
    if glowing3Dtotem                   then pose(handUndoAdjusts.w3di.totem, true)         end
    if bensBundle                       then pose(handUndoAdjusts.w3di.bundles, true)       end
    if freshFoods                       then pose(handUndoAdjusts.w3di.foods, true)         end
    if freshOres                        then pose(handUndoAdjusts.w3di.ores, true)          end
    if freshDiscs                       then pose(handUndoAdjusts.w3di.musicDiscs, true)    end
    if refinedBuckets                   then pose(handUndoAdjusts.w3di.bucket, true)        end
    if better3Dbooks                    then pose(handUndoAdjusts.w3di.books, true)         end
    if rvTorches or refinedTorches      then pose(handUndoAdjusts.w3di.torches, true)       end
end

-- == PACKS INDIVIDUAL ADJUSTS ==
if w3Dfoods then
    pose({
        { PackCompat.w3Dfoods, r = {nil, nil, 10}, m = {0.05, -0.09, -0.09, "zyx"}, ops = "rms", matches = true },
    })
end

if a3ds then
    pose({
        { {"lily_pad"}, m = {nil, 0.375, nil} }
    }, true)
end

if w3di then
    pose({
        { {"copper_torch"}, r = {nil, nil, 10}, m = {nil, nil, 0.05}, condition = {not (rvTorches or refinedTorches)} },
        { {"elytra"}, m = {nil, 0.415, nil}, condition = {not just3Darmors} }
    }, true)
end

if glowing3Darmors then
    pose({
        { {"elytra"}, m = {nil, 0.415, nil}, condition = {not w3di} },
        { {"chest_armor", "leg_armor"}, m = {nil, 0.415, nil} }
    }, true)
end

-- === INDIVIDUAL ADJUSTS ===
pose({
    { {"weeping_vines", "hanging_roots", "pale_hanging_moss", "spore_blossom"}, m = {nil, 0.35, -0.05} },
    { {"glow_item_frame"}, m = {0.14, nil, nil}, r = {25, nil, nil} },
    { {"bucket"}, r = {10, -5, nil, "zyx"}, m = {0.1, nil, nil, "zyx"}, ops = "rms", condition = {not (w3di or refinedBuckets)}, matches = true }
})

-- === ACTIONS & STUFF POSES OPTIONS ===
if ${actionsStuffPoses} then
    if matched({"mace", "shovels", "pickaxes", "axes", "hoes", "swords", "trident"}) then
        M:moveX(mat, -0.1 * l)
        M:moveY(mat, -0.02 * l)
        M:rotateX(mat, -9)
        M:rotateZ(mat, 8 * l)
    elseif matched("spears") then
        M:moveZ(mat, 0.25)
        M:moveX(mat, -0.2 * l)
        M:moveY(mat, -0.02)
        M:rotateZ(mat, 5 * l)
        M:rotateY(mat, -5 * l)
    end
end

-- === ANIMATIONS ===
global.mainHandSwitch           = 0.0;
global.offHandSwitch            = 0.0;

local switch_val                = (context.mainHand and mainHandSwitch) or offHandSwitch
local switchAnimationVariable   = Easings:easeInBack(M:sin(M:clamp(switch_val, 0.09723, 0.60632) * 3.24 * 1.65 - 0.1))

-- Switch Animation Head Armors Glowing3Darmors
if glowing3Darmors and matched("head_armor") then
    M:rotateX(mat, 10 * switchAnimationVariable)
    M:rotateZ(mat, 6 * switchAnimationVariable)
end