-- by omnis._.

local l           = context.mainHand and 1 or -1
local mat         = context.matrices
local itemName    = I:getName(context.item):gsub("minecraft:", "")

-- === FUNCTIONS ===
if not ItemsTag or not ItemLists or not PackCompat then
    return
end
local function getTag()
    for _, tag in ipairs(ItemsTag.default) do
        if I:isIn(context.item, Tags:getVanillaTag(tag)) or I:isIn(context.item, Tags:getFabricTag(tag)) then
            return tag
        end
    end
    for tag, pose in pairs(ItemsTag.registry) do
        for _, i in ipairs(pose) do
            if itemName:match(i) then
                return tag
            end
        end
    end
end
local tag = getTag()

local function isInList(list)
    for _, i in ipairs(list) do
        if itemName == i or tag == i then
            return true
        end
    end
    return false
end

local itemCompatCache = { [0] = {}, [1] = {} }
local function getItemCompat()
    if itemCompatCache[0][itemName] then
        return false
    end
    if itemCompatCache[1][itemName] then
        return true
    end

    for _, rp in ipairs(ActivePacks) do
        if PackCompat[rp] then
            for _, item in ipairs(PackCompat[rp]) do
                if item == tag or item == itemName then
                    itemCompatCache[1][itemName] = rp
                    return true
                end
            end
        end
    end
    itemCompatCache[0][itemName] = true
    return false
end
local itemCompat = getItemCompat()

local move = {
    x = function(v) M:moveX(context.matrices, (v or 0) * l)   end,
    y = function(v) M:moveY(context.matrices, v or 0)         end,
    z = function(v) M:moveZ(context.matrices, v or 0)         end
}
local rotate = {
    x = function(v) M:rotateX(context.matrices, v or 0)       end,
    y = function(v) M:rotateY(context.matrices, (v or 0) * l) end,
    z = function(v) M:rotateZ(context.matrices, (v or 0) * l) end
}

local function transform(ops, position)
    local order = position[4] or "xyz"

    for i = 1, 3 do
        local axis = order:sub(i, i):lower()
        local val  = position[i]
        if val and ops[axis] then ops[axis](val) end
    end
end

local function process(pos)
    if pos["renderAsBlock"] ~= nil then
        renderAsBlock:put(I:getName(context.item), pos["renderAsBlock"])
    end

    local ops = pos["ops"] or "mrs"
    for j = 1, 3 do
        local operation = ops:sub(j, j):lower()

        if operation == "m" and pos.m then
            transform(move, pos.m)

        elseif operation == "r" and pos.r then
            transform(rotate, pos.r)

        elseif operation == "s" and pos.s then
            if pos.s[1] ~= nil and pos.s[2] == nil and pos.s[3] == nil then
                M:scale(mat, pos.s[1], pos.s[1], pos.s[1])
            else
                M:scale(mat, pos.s[1], pos.s[2], pos.s[3])
            end
        end
    end
end

local function condition(entry)
    return (entry["condition"] ~= nil and entry["condition"]) or entry["condition"] == nil
end

local positions   = {}
local claimed     = { ["adjust"] = {}, ["desadjust"] = {} }

local function positioning(pos)
    if claimed["adjust"][itemName] then return end
    local key = (pos[itemName] and itemName) or (pos[tag] and tag)

    if pos[key] then
        if condition(pos[key]) then
            positions[itemName] = pos[key]
            claimed["adjust"][itemName] = true
        end
    end
end

-- === INDIVIDUAL ADJUSTS ===
local poses = {
    hanging_plants    = { m = {nil, 0.35, -0.05} },
    glow_item_frame   = { m = {0, -0.1, 0.05}, r = {25, nil, nil} },
    buckets           = { r = {-9, nil, 8}, m = {-0.02, -0.1, 0.15, "yxy"}, ops = "rms", condition = not (refinedBuckets or w3di) }
}
local pose = poses[itemName] or poses[tag]

if pose and not itemCompat then
    if condition(pose) then
        process(pose)
    end
end

-- === PACKS POSITIONS ===
if w3Dfoods then
    if isInList(PackCompat.w3Dfoods) then
        transform(rotate, {nil, nil, 10})
        transform(move, {0.05, -0.09, -0.09, "zyx"})
    end
end

if glowing3Darmors then
    positioning({
        elytra        = { m = {nil, 0.415, nil}, condition = not w3di },
        chest_armor   = { m = {nil, 0.415, nil} },
        leg_armor     = { m = {nil, 0.415, nil} }
    })
end

if a3ds then
    positioning({
        lily_pad = { m = {nil, 0.375, nil} }
    })
end

if w3di then
    positioning({
        copper_torch    = { r = {nil, nil, 10}, m = {nil, nil, 0.05}, condition = not (rvTorches or refinedTorches) },
        elytra          = { m = {nil, 0.415, nil}, condition = not just3Darmors }
    })
end

local posePack = positions[itemName] or positions[tag]

if posePack and itemCompat then
    if condition(posePack) then
        process(posePack)
    end
end

-- === PACKS DEPOSITIONS ===
local function depositioning(pos)
    if claimed["desadjust"][itemName] then return end
    local key = (pos[itemName] and itemName) or (pos[tag] and tag)

    if pos[key] then
        if pos[key].cases then
            for _, case in ipairs(pos[key].cases) do
                if condition(case) then
                    process(case)
                end
            end
            claimed["desadjust"][itemName] = true
            return
        elseif condition(pos[key]) then
            process(pos[key])
            claimed["desadjust"][itemName] = true
            return
        end
    end
end

local depositions = {
    a3ds = {
        -- Natural Blocks
        vine                    = { m = {0.05, -0.25, nil, "zyx"} },
        glow_lichen             = { m = {0.05, -0.25, nil, "zyx"} },
        hanging_plants          = { m = {0.05, -0.25, nil, "zyx"} },
    },
    w3di = {
        -- Functional Blocks
        torches                 = { m = {-0.05, nil, nil, "zxy"}, r = {-10, nil, nil, "zyx"}, condition = itemName ~= "copper_torch" },
        lanterns                = { m = {-0.1, -0.05, nil, "zyx"} },
        campfires               = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        armor_stand             = { m = {0.09, 0.12, 0.05}, r = {nil, nil, -10} },
        -- Redstone Blocks
        repeater                = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        comparator              = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        -- Tools & Utilities
        totem_of_undying        = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        music_discs             = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        bundles                 = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        bookshelf_books         = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        buckets                 = { m = {0, -0.1, nil, "yzx"}, r = {5, -10, nil, "yzx"} },
        ender_items             = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        lead                    = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        map                     = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        firework_rocket         = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        goat_horn               = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        name_tag                = { m = {0.05, -0.3, nil, "zyx"} },
        rods                    = { m = {-0.2, 0.2, 0.1}, r = {nil, nil, -10} },
        boats                   = { m = {nil, 0.05, nil} },
        chest_boats             = { m = {nil, 0.05, nil} },
        flint_and_steel         = { m = {nil, nil, -0.05}, r = {nil, nil, -10} },
        shears                  = { m = {nil, 0.1, -0.05}, r = {nil, nil, -10} },
        compass                 = { m = {0.12, 0.12, -0.05}, r = {nil, nil, -10} },
        clock                   = { m = {0.12, 0.12, -0.05}, r = {nil, nil, -10} },
        -- Combat
        eggs                    = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        snowball                = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        -- Foods & Drinks
        beefs                   = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        muttons                 = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        chickens                = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        rabbits                 = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        apples                  = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        melon_slice             = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        glistering_melon_slice  = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        berries                 = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        chorus_fruit            = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        carrots                 = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        beetroot                = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        potatoes                = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        dried_kelp              = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        fishes                  = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        pufferfish              = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        bread                   = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        cookie                  = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        cake                    = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        pumpkin_pie             = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        spider_eye              = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        bowl_foods              = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        bottles_drink           = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        -- Ingredients
        coals                   = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        raw_materials           = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        emerald                 = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        diamond                 = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        lapis_lazuli            = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        nuggets                 = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        quartz                  = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        amethyst_shard          = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        ingots                  = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        bricks                  = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        netherite_scrap         = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        flint                   = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        fire_charge             = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        stick                   = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        blaze_rod               = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        breeze_rod              = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        bone                    = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        honeycomb               = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        clay_ball               = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        heart_of_the_sea        = { m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} },
        banner_patterns         = { m = {0.05, -0.3, nil, "zyx"} }
    }
}
if w3di then
    local w3diConditions = {
        { a3ds,             PackCompat.a3ds },
        { freshOres,        PackCompat.freshOresIngots },
        { freshDiscs,       PackCompat.freshDiscs },
        { freshFoods,       PackCompat.freshFoods },
        { bensBundle,       PackCompat.bensBundle },
        { glowing3Dtotem,   PackCompat.glowing3Dtotem },
        { better3Dbooks,    PackCompat.better3Dbooks },
        { refinedBuckets,   PackCompat.refinedBuckets },
        { refinedTorches,   PackCompat.refinedTorches },
        { rvTorches,        PackCompat.rvTorches }
    }
    for _, entry in ipairs(w3diConditions) do
        if entry[1] and isInList(entry[2]) then
            depositioning(depositions["w3di"])
        end
    end
end

if a3ds then
    local a3dsConditions = {
        { freshFlowers, PackCompat.freshFlowersPlants }
    }
    for _, entry in ipairs(a3dsConditions) do
        if entry[1] and isInList(entry[2]) then
            depositioning(depositions["a3ds"])
        end
    end
end

-- === ANIMATIONS ===
global.mainHandSwitch           = 0.0;
global.offHandSwitch            = 0.0;

local switch_val                = (context.mainHand and mainHandSwitch) or offHandSwitch
local switchAnimationVariable   = Easings:easeInBack(M:sin(M:clamp(switch_val, 0.09723, 0.60632) * 3.24 * 1.65 - 0.1))

if glowing3Darmors and tag == "head_armor" then
    M:rotateX(mat, 10 * switchAnimationVariable)
    M:rotateZ(mat, 6 * switchAnimationVariable)
end
