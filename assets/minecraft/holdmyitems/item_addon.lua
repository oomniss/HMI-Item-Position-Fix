-- by omnis._.

-- === CONTEXTS ===
local l         = context.mainHand and 1 or -1
local itemName  = I:getName(context.item):gsub("minecraft:", "")
local AlexModel = ${AlexSkinModel}

-- === ITEM STATE ===
local isItemUsing = false
if P:isUsingItem(context.player) then
    local useAction = I:getUseAction(context.item)
    isItemUsing = useAction == "drink" or useAction == "eat" or useAction == "trident"
end

-- === PACKS COMPATIBILITY ===
local packCompatibility = {
    rvTorchs = {"torch", "^lantern$", "soul_lantern", "copper_lantern", "campfire", "candle", "repeater", "comparator"},
    freshSeeds = {"_seeds"},
    bensBundle = {"bundle"},
    glowing3Dtotem = {"totem_of_undying"},
    w3di = {
        -- Functional Blocks
        "torch", "^lantern$", "soul_lantern", "copper_lantern", "campfire", "end_crystal", "flower_pot", "armor_stand", "_sign", "ender_eye",
        -- Redstone Blocks
        "redstone$", "repeater", "comparator", "lever",
        -- Tools
        "bucket", "fishing_rod", "flint_and_steel", "fire_charge", "bone_meal", "shears", "name_tag",
        "lead", "bundle", "compass", "clock", "map", "book", "wind_charge", "ender_pearl", "elytra",
        "firework_rocket", "carrot_on_a_stick", "warped_fungus_on_a_stick", "goat_horn", "music_disc",
        "_boat", "_raft",
        -- Combat
        "mace", "nautilus_armor", "totem_of_undying", "snowball", "^egg$", "brown_egg", "blue_egg",
        -- Foods & Potions
        "apple", "^chorus_fruit$", "melon_slice", "carrot", "potato", "^beetroot$",
        "bread", "cookie", "pumpkin_pie", "beef", "porkchop", "^chicken$", "mutton", "^rabbit$", 
        "^cod$", "^salmon$", "^tropical_fish$", "^pufferfish$", "cooked_chicken", 
        "cooked_rabbit", "cooked_cod", "cooked_salmon", "_stew", "_soup", "rotten_flesh", "^spider_eye$", 
        "^dried_kelp$", "^honeycomb$", "_berries", "bowl", "potion", "cake",
        -- Ingredients
        "coal$", "raw", "^emerald$", "^lapis_lazuli$", "diamond$", "quartz$", "amethyst_shard",
        "nugget", "ingot", "netherite_scrap", "stick$", "flint$", "bone$", "feather", 
        "honeycomb", "scute", "slime_ball", "clay_ball", "prismarine_crystals",
        "nautilus_shell", "heart_of_the_sea", "blaze_rod", "breeze_rod", "shulker_shell",
        "disc_fragment_5", "bowl", "brick$", "bottle", "glowstone_dust", "gunpowder",
        "dragon_breath", "blaze_powder", "sugar$", "_banner_pattern",
        -- Spawn Eggs
        "spawn_egg"
    },
    a3ds = {
        -- Natural Blocks
        "pale_hanging_moss", "sapling", "mangrove_propagule", "_mushroom$", "_fungus$", "_grass", "fern",
        "bush", "dandelion", "poppy", "orchid", "allium", "azure_bluet", "tulip", "oxeye_daisy", "cornflower",
        "lily_of_the_valley", "^torchflower$", "_eyeblossom", "wither_rose", "pink_petals", "wildflowers",
        "leaf_litter", "^bamboo$", "sugar_cane", "crimson_roots", "warped_roots", "nether_sprouts", "vines",
        "sunflower", "lilac", "rose_bush", "pitcher_plant", "glow_lichen", "hanging_roots", "frogspawn", "lily_pad",
        -- Functional Blocks
        "^bell$", "armor_stand", "item_frame", "painting", "ender_eye",
        -- Redstone Blocks
        "^redstone$", "string", "minecart", "_raft", "_boat",
        -- Tools
        "fishing_rod", "flint_and_steel", "fire_charge", "bone_meal", "shears", "brush", "name_tag", "lead", "bundle",
        "^compass$", "^map$", "writable_book", "ender_pearl", "firework_rocket", "saddle", "_harness", "on_a_stick",
        "goat_horn",
        -- Combat
        "totem_of_undying", "snowball", "^egg$", "brown_egg", "blue_egg",
        -- Ingredients
        "coal$", "raw_", "^emerald$", "^lapis_lazuli$", "^diamond$", "^quartz$", "_shard", "_nugget", "_ingot",
        "netherite_scrap", "^stick$", "flint", "^bone$", "^leather$", "rabbit_hide", "^honeycomb$", "resin_clump",
        "ink_sac", "slime_ball", "clay_ball", "prismarine_crystals", "nautilus_shell", "heart_of_the_sea", "blaze_rod",
        "breeze_rod", "nether_star", "_dye", "brick$", "paper", "^book$", "firework_star", "glowstone_dust", "gunpowder",
        "blaze_powder", "^sugar$", "rabbit_foot", "magma_cream", "ghast_tear", "banner_pattern", "_smithing_template",
        "_key", "enchanted_book"
    },
    freshFlowersPlants = {
        "pale_hanging_moss", "_sapling", "mangrove_propagule", "^azalea$", "^flowering_azalea$", "_mushroom$",
        "_fungus$", "_grass", "fern", "bush", "dandelion", "poppy", "blue_orchid", "allium",
        "azure_bluet", "tulip", "oxeye_daisy", "cornflower", "lily_of_the_valley", "^torchflower$",
        "cacutus_flower", "eyeblossom", "wither_rose", "pink_petals", "wildflowers", "leaf_litter",
        "spore_blossom", "bamboo", "sugar_cane", "roots", "nether_sprouts",
        "vines", "sunflower", "lilac", "peony", "pitcher_plant", "_dripleaf", "rose_bush",
        "glow_lichen", "lily_pad", "seagrass", "sea_pickle", "^kelp$", "_coral$", "_coral_fan", "sculk_vein", "cactus_flower"
    },
    freshFoods = {
        "apple", "chorus_fruit", "melon_slice", "carrot", "potato", "^beetroot$",
        "bread", "cookie", "pumpkin_pie", "beef", "porkchop", "^chicken$", "mutton", "^rabbit$", 
        "^cod$", "^salmon$", "^tropical_fish$", "^pufferfish$", "cooked_chicken", 
        "cooked_rabbit", "cooked_cod", "cooked_salmon", "_stew", "_soup", "rotten_flesh", "^spider_eye$", 
        "^dried_kelp$", "^honeycomb$", "_berries", "bowl"
    },
    freshOresIngots = {
        "redstone$", "coal$", "raw", "^emerald$", "^lapis_lazuli$", "^diamond$", "quartz$",
        "amethyst_shard", "_amethyst_bud", "amethyst_cluster", "nugget", "_ingot",
        "netherite_scrap", "flint$", "resin_clump", "echo_shard", "resin_brick", "^brick$",
        "nether_brick", "pointed_dripstone"
    },
    glowing3Darmors = {
        "copper_helmet", "copper_chestplate", "copper_leggings", "copper_boots",
        "iron_helmet", "iron_chestplate", "iron_leggings", "iron_boots",
        "gold_helmet", "gold_chestplate", "gold_leggings", "gold_boots",
        "diamond_helmet", "diamond_chestplate", "diamond_leggings", "diamond_boots",
        "netherite_helmet", "netherite_chestplate", "netherite_leggings", "netherite_boots",
        "horse_armor"
    }
}

local w3di            = ${w3di}
local a3ds            = ${a3ds}
local rvTorchs        = ${rvTorchs}
local glowing3Darmors = ${glowing3Darmors}
local glowing3Dtotem  = ${glowing3Dtotem}
local freshFlowers    = ${freshFlowersPlants}
local freshFoods      = ${freshFoods}
local freshOres       = ${freshOresIngots}
local freshSeeds      = ${freshSeeds}
local bensBundle      = ${bensBundle}
    
local activePacks = {}
    if w3di             then table.insert(activePacks, "w3di") end
    if a3ds             then table.insert(activePacks, "a3ds") end
    if rvTorchs         then table.insert(activePacks, "rvTorchs") end
    if glowing3Darmors  then table.insert(activePacks, "glowing3Darmors") end
    if glowing3Dtotem   then table.insert(activePacks, "glowing3Dtotem") end
    if freshFlowers     then table.insert(activePacks, "freshFlowersPlants") end
    if freshFoods       then table.insert(activePacks, "freshFoods") end
    if freshOres        then table.insert(activePacks, "freshOresIngots") end
    if freshSeeds       then table.insert(activePacks, "freshSeeds") end
    if bensBundle       then table.insert(activePacks, "bensBundle") end

-- === FUNCTIONS ===
local function itemMatches(tableMatch)
    for _, item in ipairs(tableMatch) do
        if itemName:match(item) then
            return true
        end
    end
    return false
end

local function isItemCompat()
    for _, t in ipairs(activePacks) do
        if itemMatches(packCompatibility[t] or {}) then
            return true
        end
    end
    return false
end

local function move(x, y, z, force)
    if not isItemUsing then
        if not isItemCompat() or force then
            if x then M:moveX(context.matrices, x * l) end
            if y then M:moveY(context.matrices, y) end
            if z then M:moveZ(context.matrices, z) end
        end
    end
end

local function rotate(x, y, z, force)
    if not isItemUsing then
        if not isItemCompat() or force then
            if x then M:rotateX(context.matrices, x) end
            if y then M:rotateY(context.matrices, y * l) end
            if z then M:rotateZ(context.matrices, z * l) end
        end
    end
end

local function scale(x, y, z, force)
    if not isItemCompat() or force then 
        M:scale(context.matrices, x, y, z)
    end
end

local function pose(tables, force)
    for _, t in ipairs(tables) do
        if (t.condition and t.condition[1]) or not t.condition then
            for _, i in ipairs(t[1]) do
                if itemName:match(i) then
                    if t.m then 
                        move(t.m[1], t.m[2], t.m[3], force) 
                    end
                    if t.r then 
                        rotate(t.r[1], t.r[2], t.r[3], force) 
                    end
                    if t.s then 
                        if t.s[1] and not t.s[2] and not t.s[3] then
                            scale(t.s[1], t.s[1], t.s[1], force)
                        elseif t.s[1] or t.s[2] or t.s[3] then
                            scale(t.s[1], t.s[2], t.s[3], force)
                        end
                    end
                end
            end
        end
    end
end

local function hand(posMainHand, posOffHand)
    return l == 1 and posMainHand or posOffHand
end

local function skinModel(posAlex, posSteve)
    return AlexModel and posAlex or posSteve
end

local function isInList(items)
    for _, i in ipairs(items) do
        if itemName == i then return true end
    end
    return false
end

-- === PACKS ADJUSTS ===
local undoPackAdjustments = {
    w3di = {
        { {
            "armor_stand", "quartz", "nugget", "amethyst_shard", "honeycomb", "nautilus_shell",
            "gunpowder", "glowstone_dust", "bone_meal", "redstone", "blaze_powder", "sugar",
            "map"
        }, m = {-0.07, 0, 0.05}, r = {0.3, -4, 7}, s = {1/1.1} },

        -- Tools
        { {"fishing_rod"}, m = {0.1, 0.1, nil}, r = {70, 1, 10}, s = {1/1.2} },
        { {"fishing_rod"}, m = {-0.05, nil, -0.1}, r = {5.5, 15.5, nil} },
        { {"lead"}, m = {-0.1, nil, 0.2}, r = {nil, -20, 10}, s = {1/1.2, 1, 1} },
        { {"lead"}, m = {0.035, -0.105, -0.34}, r = {5.5, 8.5, -12} },
        { {"shears"}, m = {-0.05, nil, 0.1}, r = {30, 25, 45}, s = {1/1.3, 1/1.4, 1/1.3} },
        { {"flint_and_steel"}, r = {10, nil, 5}, s = {1/1.1} },
        { {"ender_eye", "ender_pearl", "firework_rocket"}, m = {0.05, nil, 0.05}, r = {0, -95, 5}, s = {1/1.05} },
        { {"ender_eye", "ender_pearl"}, m = {-0.145, 0.01, 0.01}, r = {-9, 2.5, 1.5} },
        { {"ender_pearl"}, m = {nil, nil, 0.02} },
        { {"firework_rocket"}, m = {0, nil, 0.03}, s = {1/1.2} },
        { {"firework_rocket"}, m = {-0.185, nil, 0.11}, r = {-9, 1.5, 6} },
        { {"fire_charge"}, m = {0.01, 0, nil}, r = {nil, nil, 6}, s = {1/1.25} },
        { {"^compass$"}, m = {-0.03, 0, -0.01}, r = {10, -4, 7}, s = {1/1.2} },
        { {"writable_book"}, m = {0.045, -0.035, -0.01}, r = {12.5, -14, 12.5} },
        { {"carrot_on_a_stick"}, m = {0.095, nil, -0.015}, r = {65.5, 80, nil} },
        { {"carrot_on_a_stick"}, m = {0.025, nil, 0.01}, r = {nil, 10, nil} },
        { {"warped_fungus_on_a_stick"}, m = {-0.02, 0.02, -0.02}, r = {87.5, 83.5, -73.5} },
        { {"warped_fungus_on_a_stick"}, m = {nil, nil, -0.02}, r = {nil, nil, -20} },
        { {"boat", "raft"}, m = {nil, 0.025, nil}, r = {-120, -4, -180}, s = {1/1.35} },
        { {"name_tag"}, m = {0.07, -0.18, -0.09}, r = {103, nil, nil} },
        { {"goat_horn"}, m = {-0.015, nil, 0.05}, r = {0, 0, 5}, s = {1/1.3} },
        { {"goat_horn"}, m = {0.02, 0.05, 0.05}, r = {-10, -40, -5}, s = {1/1.3}, condition = {P:isUsingItem(context.player)} },
        { {"bucket"}, m = {-0.07, -0.065, -0.045}, r = {85, -159.5, -5.5}, s = {0.8} },

        -- Combat
        { {"snowball", "^egg$", "blue_egg", "brown_egg"}, m = {nil, -0.015, nil}, r = {nil, nil, 5} },

        --Ingredients
        { {"^bone$", "blaze_rod", "breeze_rod", "stick"}, m = {0.05, 0.05, 0.07}, r = {nil, -85, 4} },
        { {"blaze_rod", "breeze_rod", "stick"}, m = {-0.045, nil, 0.01}, r = {7.5, 0.5, 6.5} },
        { {"stick"}, m = {-0.01, nil, -0.005}, r = {-1.5, 1, -4} },
        { {"^bone$"}, m = {-0.05, nil, 0.02}, r = {2.5, nil, nil} },
        { {"heart_of_the_sea"}, m = {-0.07, nil, 0.05}, r = {0, nil, 5}, s = {1/1.35} },
        { {"banner_pattern", "name_tag"}, m = {nil, 0.15, -0.1}, r = {130, nil, 180}, s = {1/1.4} },
        { {"banner_pattern"}, m = {-0.05, -0.2, nil}, r = {-103.5, -3.5, nil} },
        { {"honeycomb"}, m = {0.03, nil, nil}, r = {1, -2, nil} },
        { {"firework_star"}, m = {-0.01, nil, 0.075} },
        { {"heart_of_the_sea"}, m = {0.06, nil, -0.02} },
        { {"clay_ball"}, m = {hand(0.065, 0), nil, hand(0, -0.07)} },
    },
    w3diOres = {
        { {"quartz", "nugget", "amethyst_shard", "redstone", "netherite_scrap", "resin_clump"},
        m = {-0.07, nil, 0.05}, r = {0.3, -4, 7}, s = {1/1.1, 1/1.1, 1/1.1} },
        { {"diamond", "emerald", "lapis_lazuli"}, m = {-0.07, 0.05, 0.1}, r = {0.3, 0, 7}, s = {1/1.1, 1/1.25, 1/1.1} },
        { {"ingot", "brick"}, m = {0, nil, 0.1}, r = {0.3, -15, 5}, s = {1/1.15, 1/1.15, 1/1.15} },
        { {"raw"}, m = {-0.05, nil, 0.05}, r = {nil, nil, 5}, s = {1/1.3, 1, 1/1.3} },
        { {"coal"}, m = {0.05, nil, 0.05}, r = {nil, -95, 5}, s = {1, 1/1.2, 1} },
        { {"flint"}, r = {10, nil, 5}, s = {1/1.3, 1/1.3, 1/1.3} },
        { {"diamond"}, m = {0.045, -0.065, -0.015}, r = {nil, -6, -3.5}, s = {0.96, 0.96, 0.96} },
        { {"emerald"}, m = {0.04, -0.085, nil}, r = {nil, -3, -3} },
        { {"coal"}, m = {-0.275, 0.02, 0.1} },
        { {"amethyst_shard"}, m = {nil, -0.025, nil} },
        { {"nugget", "ingot", "brick"}, m = {-0.01, nil, nil} },
        { {"netherite_scrap"}, m = {0.02, nil, -0.035}, r = {nil, nil, -4.5} },
        { {"flint"}, m = {0.03, -0.01, -0.055} },
        { {"redstone"}, m = {-0.025, nil, nil} },
        { {"resin_clump"}, m = {0.075, nil, -0.055} },
    },
    A3dsW3diOres = {
        { {"quartz"}, m = {-0.08, -0.005, 0.035} },
        { {"amethyst_shard"}, m = {-0.1, nil, 0.07}, r = {nil, -6.5, 4} },
        { {"_nugget"}, m = {-0.095, -0.005, 0.035}, r = {1.5, -3, 4.5} },
        { {"ingot", "brick"}, m = {-0.005, -0.005, nil}, r = {nil, -18.5, 4} },
        { {"netherite_scrap"}, m = {-0.08, 0.005, nil}, r = {nil, nil, 2} },
        { {"coal"}, m = {-0.155, 0.035, 0.1}, r = {-3, -6.5, -6} },
        { {"raw"}, m = {-0.085, nil, nil} },
        { {"emerald"}, m = {-0.035, -0.02, 0.125}, r = {nil, nil, 4} },
        { {"lapis_lazuli"}, m = {-0.095, nil, 0.095}, r = {nil, nil, 6} },
        { {"diamond"}, m = {-0.025, nil, 0.105}, r = {nil, -2, 6}, s = {0.9, 0.9, 0.9} },
        { {"redstone"}, m = {-0.095, -0.005, 0.035} }
    }
}
if w3di and a3ds and itemMatches(packCompatibility.w3di) then pose(undoPackAdjustments.w3di, true) end
if w3di and not a3ds and freshOres and itemMatches(packCompatibility.freshOresIngots) then pose(undoPackAdjustments.w3diOres, true) end
if a3ds and w3di and freshOres and itemMatches(packCompatibility.freshOresIngots) then pose(undoPackAdjustments.A3dsW3diOres) end

-- Glowing 3D Totem
if glowing3Dtotem and itemName == "totem_of_undying" then
    scale(0.8, 0.8, 0.8, true)
    if w3di and not a3ds then
        move(0.07, 0.115, -0.175, true)
        rotate(-7, 4, -4.5, true)
        scale(0.8, 0.8, 0.8, true)
        if not AlexModel then move(0.025, nil, nil, true) end
    elseif a3ds and not w3di then
        move(0.035, 0.14, -0.185, true)
        rotate(-94, -10, -110.5, true)
        if not AlexModel then move(nil, 0.025, -0.01, true) end
    elseif w3di and a3ds then
        move(0.05, 0.17, -0.15, true)
        rotate(220, 8.5, -106.5, true)
        scale(0.8, 0.8, 0.8, true)
        if not AlexModel then move(-0.01, 0.025, nil, true) end
    else
        move(skinModel(0.02, 0.03), 0.15, -0.16, true)
        rotate(16.5, 64, -21.5, true)
    end
end

-- R&V Torchs
if rvTorchs and itemMatches(packCompatibility.rvTorchs) then
    if w3di then
        pose({
            { {"^torch", "soul_torch"}, m = {-0.04, 0.085, 0.01}, r = {nil, 5, nil}, s = {0.65} },
            { {"campfire"}, m = {-0.1, -0.1, -0.15}, r = {75, -15, -7}, s = {1/1.35, 1/1.35, 1/1.5} },
            { {"campfire"}, m = {0.15, 0.45, -0.56}, r = {-2.5, 7.5, -36.5} },
            { {"repeater", "comparator"}, m = {-0.15, 0.15, -0.1}, r = {85, -35, 7}, s = {1/1.35} },
            { {"repeater", "comparator"}, m = {0.15, 0.095, -0.06}, r = {nil, 2, 9} },
            { {"lantern"}, m = {-0.035, 0.165, nil}, s = {0.6} }
        }, true)
    end
    move(skinModel(0.01, 0.04), nil, nil, true)
    rotate(nil, -5.5, nil, true)
end

-- Fresh Seeds
if freshSeeds and itemMatches(packCompatibility.freshSeeds) then
    move(skinModel(0.035, 0.065), 0.045, 0.025, true)
    rotate(8, 1.5, 1, true)
end

-- Fresh Ores and Ingots
if freshOres and itemMatches(packCompatibility.freshOresIngots) then
    if not AlexModel and not itemMatches({"_shard"}) then move(0.04, -0.005, nil, true) end
    pose({
        { {"amethyst_cluster", "amethyst_bud"}, m = {0.005, -0.005, -0.01}, r = {nil, nil, -3.5} },
        { {"ingot", "brick"}, m = {0.025, -0.025, -0.055}, r = {3, 17, -7.5} },
        { {"diamond"}, m = {0.055, 0.02, -0.195}, r = {20, 21, -12} },
        { {"emerald"}, m = {0.045, -0.005, -0.235}, r = {20, 21, -12} },
        { {"_shard"}, m = {nil, -0.06, -0.06}, r = {15, 3, -7.5} },
        { {"resin_clump"}, m = {0.05, 0.005, -0.055}, r = {nil, nil, -8.5} },
        { {"lapis_lazuli"}, m = {-0.03, -0.11, -0.205}, r = {nil, 5, -7.5} },
        { {"quartz"}, m = {0.045, -0.035, -0.1}, r = {4.5, 2.5, -6} },
        { {"pointed_dripstone"}, m = {0.135, -0.02, -0.105}, r = {nil, -5, -1.5} },
        { {"redstone"}, m = {0.135, -0.095, -0.165}, r = {-4, nil, -7} },
        { {"raw"}, m = {0.08, -0.03, -0.155}, r = {11.5, nil, nil} },
        { {"nugget"}, m = {0.095, -0.085, -0.105}, r = {nil, 3.5, -6.5} },
        { {"netherite_scrap"}, m = {0.11, -0.075, -0.17}, r = {nil, nil, -18} },
        { {"flint"}, m = {0.105, 0.06, -0.075}, r = {17, nil, -6.5} },
        { {"coal"}, m = {0.075, nil, -0.17}, r = {nil, nil, -6} },
    }, true)
end

-- Ben's Bundle
if bensBundle and itemName:match("bundle") then
    if w3di and not a3ds then
        move(0.045, 0.085, 0.049, true)
        rotate(5.5, 27, -7, true)
        scale(0.7, 0.7, 0.7, true)
    elseif a3ds and not w3di then
        move(0.005, 0.1, -0.04, true)
        rotate(9, 32.5, -10.5, true)
    elseif w3di and a3ds then
        move(0.04, 0.08, 0.03, true)
        rotate(4.5, 27.5, -6.5, true)
        scale(0.7, 0.7, 0.7, true)
    else
        move(0.01, 0.1, -0.025, true) 
        rotate(11.5, 32.5, -11.5, true)
    end
end

-- Fresh Flowers and Plants
if freshFlowers and itemMatches(packCompatibility.freshFlowersPlants) then
    if not AlexModel then move(0.03, nil, nil, true) end
    pose({
        { {
            "sapling", "mangrove_propagule", "azalea", "_grass", "fern", "bush", "crimson_roots", 
            "warped_roots", "nether_sprouts"
        }, m = {0.01, -0.015, -0.075}, r = {16, -7.5, -3} },

        { {"_coral"}, m = {0.16, -0.035, -0.035}, r = {nil, -4.5, -1.5} },
        { {"mushroom", "fungus"}, m = {0.025, nil, nil}, r = {nil, -5, -2} },
        { {"seagrass"}, m = {0.24, -0.105, -0.195}, r = {3, -2.5, -5} },
        { {"seagrass", "rose_bush"}, m = {-0.01, 0.015, 0.055}, r = {-16, 7.5, 3} },
        { {"bamboo"}, m = {0.015, nil, nil}, r = {nil, -5, nil} },
        { {"sugar_cane"}, m = {-0.02, nil, nil}, r = {nil, -3, nil} },
        { {"sea_pickle"}, m = {0.015, nil, nil}, r = {nil, -4, nil} },
        { {"twisting_vines"}, m = {0.09, 0.01, 0.06}, r = {13.5, nil, nil} },
    }, true)
end

-- Fresh Foods
if freshFoods and itemMatches(packCompatibility.freshFoods) then
    if w3di then
        if not AlexModel then
            pose({
                { {"beef", "porkchop", "mutton"}, m = {0.005, nil, nil} },
                { {"apple", "chorus_fruit", "pufferfish"}, m = {0.015, nil, nil} },
                { {"potato"}, m = {nil, -0.015, nil} },
                { {"^chicken$", "cooked_chicken"}, m = {0.005, -0.055, -0.02}, r = {nil, -1.5, nil} },
                { {"salmon"}, m = {nil, nil, 0.02} },
                { {"tropical_fish"}, m = {-0.015, nil, 0.035}, r = {-10, 3.5, 1.5} },
            }, true)
            if not itemMatches({
                "carrot", "spider_eye", "melon_slice", "sweet_berries", "glow_berries", "potato", "beetroot", "dried_kelp",
                "beef", "porkchop", "mutton", "rabbit", "pufferfish", "bread", "cookie", "cake", "soup", "stew", "bowl"
            }) then 
                move(0.03, nil, nil, true) 
            end
        end

        pose({
            { {
                "spider_eye", "apple", "sweet_berries", "chorus_fruit", "pufferfish", "pumpkin_pie",
                "potato", "beef", "porkchop", "^chicken$", "mutton", "rotten_flesh", "bread", "cookie",
                "cod", "salmon", "tropical_fish", "glow_berries", "melon", "kelp", "cooked_chicken"
            }, r = {nil, nil, 5} },

            { {"apple", "sweet_berries", "chorus_fruit", "pufferfish", "carrot"}, s = {1/1.05, 1/1.05, 1/1.05} },
            { {"sweet_berries", "spider_eye", "glow_berries"}, s = {1/1.1, 1/1.1, 1/1.1} },
            { {"apple", "chorus_fruit", "pufferfish"}, m = {-0.05, -0.01, 0.05}, r = {1.5, -2, -1} },
            { {"beef", "porkchop", "mutton", "rotten_flesh"}, m = {-0.05, nil, 0.01}, s = {1/1.2, 1/1.4, 1/1.2} },
            { {"^chicken$", "^rabbit$", "cooked_chicken"}, m = {-0.045, nil, 0.1}, r = {nil, 4, nil}, s = {1/1.15, 1/1.15, 1/1.15} },
            { {"cod", "salmon", "tropical_fish"}, m = {-0.06, 0.01, -0.01}, r = {6, -3.5, nil}, s = {1/1.3, 1/1.4, 1/1.3} },
            { {"cod", "salmon", "tropical_fish"}, r = {4, 0.5, -2.5} },
            { {"_soup", "_stew", "bowl"}, m = {nil, -0.13, -0.2}, r = {-115, -180, 180}, s = {1/1.2, 1/1.2, 1/1.2} },
            { {"_soup", "_stew", "bowl"}, r = {3.5, -9, nil} },
            { {"_soup", "_stew", "bowl"}, m = {-0.06, 0.2, -0.3} },
            { {"_soup"}, m = {0.08, nil, nil}, r = {nil, 3.5, -8.5} },
            { {"chorus_fruit"}, m = {-0.015, nil, nil}, r = {-4, nil, nil} },
            { {"pufferfish"}, r = {nil, -16, nil} },
            { {"melon_slice"}, m = {0.025, nil, nil} },
            { {"^cod$"}, m = {nil, nil, 0.055} },
            { {"spider_eye"}, m = {-0.05, nil, 0.04} },
            { {"^spider_eye$"}, m = {0.025, -0.005, nil} },
            { {"potato"}, m = {-0.07, nil, 0.02}, r = {-4, -2, nil} },
            { {"carrot"}, m = {-0.07, nil, -0.03}, r = {-4, -4, 8} },
            { {"melon_slice"}, m = {-0.07, nil, nil}, s = {1/1.2, 1/1.2, 1/1.2} },
            { {"^chicken$", "cooked_chicken"}, m = {nil, nil, -0.06} },
            { {"^rabbit$"}, m = {0.045, -0.055, -0.045}, r = {nil, -2.5, 6} },
            { {"cooked_rabbit"}, m = {-0.06, nil, 0.07}, r = {nil, nil, 5.5} },
            { {"pumpkin_pie"}, m = {-0.07, nil, nil}, s = {1/1.15, 1/1.15, 1/1.15} },
            { {"bread"}, m = {-0.05, nil, 0.1}, s = {1/1.15, 1/1.25, 1/1.15} },
            { {"cookie"}, m = {-0.04, nil, -0.015}, r = {-1, -2.5, -0.5}, s = {1/1.15, 1/1.25, 1/1.15} },
            { {"golden_carrot"}, m = {nil, nil, -0.01} },
            { {"beetroot"}, m = {-0.07, nil, 0.02}, r = {nil, -4, 8}, s = {1/1.04, 1/1.04, 1/1.04} },
            { {"glow_berries"}, m = {-0.07, -0.025, -0.055} },
            { {"sweet_berries"}, m = {0.015, 0.03, -0.025}, r = {nil, 4, -2} },
            { {"dried_kelp"}, m = {-0.07, nil, 0.02}, s = {1/1.05, 1/1.05, 1/1.05} },
            { {"tropical_fish"}, m = {0.02, nil, 0.05}, r = {-3.5, nil, 1.5} },
            { {"cake"}, m = {-0.1, -0.1, -0.15}, r = {75, -7, -15}, s = {1/1.35, 1/1.35, 1/1.5} },
            { {"cake"}, m = {0.14, 0.28, 0.115}, r = {3, -6, 23} },
            { {"cake"}, m = {-0.2, -0.1, -0.4} },
        }, true)
    end

    if not AlexModel and not itemMatches({"carrot", "spider_eye"}) then move(0.03, nil, nil, true) end
    pose({
        { {"apple"}, m = {skinModel(0.105, 0.095), 0.02, -0.035}, r = {10.5, 9.5, -7} },
        { {"melon_slice"}, m = {0.105, -0.06, -0.095}, r = {nil, 10.5, -8.5} },
        { {"sweet_berries"}, m = {0.02, nil, -0.025}, r = {nil, nil, -10} },
        { {"glow_berries"}, m = {0.03, -0.03, -0.075}, r = {10, nil, -18} },
        { {"chorus_fruit"}, m = {skinModel(0.125, 0.11), -0.04, -0.08}, r = {11, 4, -8} },
        { {"carrot"}, m = {nil, nil, -0.01}, r = {10.5, 4, -4.5} },
        { {"golden_carrot"}, m = {nil, -0.02, -0.03}, r = {-4, nil, 1} },
        { {"potato"}, m = {0.05, 0.03, -0.105}, r = {9, 6, -8.5}, s = {1.2, 1.2, 1.2} },
        { {"poisonous_potato", "baked_potato"}, m = {-0.005, -0.016, nil}, r = {-3, nil, nil} },
        { {"beetroot"}, m = {0.025, -0.085, -0.195}, r = {9, 3.5, -8.5} },
        { {"dried_kelp"}, m = {0.08, -0.025, -0.105}, r = {11, 17, -10.5} },
        { {"beef", "porkchop", "^chicken$", "cooked_chicken", "mutton"}, m = {0.09, 0.012, -0.075}, r = {6, 2.5, -9}, s = {1.1, 1.1, 1.1} },
        { {"mutton"}, m = {-0.025, nil, nil} },
        { {"^chicken$", "cooked_chicken"}, m = {0.005, -0.02, nil}, r = {nil, -0.5, nil}, s = {1/1.1, 1/1.1, 1/1.1} },
        { {"^chicken$", "cooked_chicken"}, m = {-0.01, nil, nil}, r = {nil, 3, nil} },
        { {"cooked_rabbit"}, m = {0.005, nil, -0.06}, r = {nil, 3, -10} },
        { {"cod", "salmon", "tropical_fish"}, m = {0.115, -0.06, -0.125}, r = {1, 5, -7} },
        { {"salmon"}, m = {-0.09, nil, skinModel(0, -0.03)} },
        { {"pufferfish"}, m = {0.145, -0.03, -0.075}, r = {11, nil, nil} },
        { {"bread"}, m = {skinModel(0.105, 0.11), -0.05, -0.09}, r = {8.5, 7.5, -8} },
        { {"cookie"}, m = {0.105, 0.005, -0.08}, r = {10.5, 9.5, -9} },
        { {"cake"}, m = {0.115, -0.02, -0.015}, r = {-1, -6, nil} },
        { {"pumpkin_pie"}, m = {0.095, 0.04, -0.15}, r = {14.5, 11.5, -3.5} },
        { {"rotten_flesh"}, m = {0.05, -0.11, -0.22} },
        { {"spider_eye"}, m = {-0.01, -0.14, -0.18}, r = {2, 10.5, 26.5} },
        { {"^spider_eye$"}, m = {nil, 0.095, nil} },
        { {"_stew", "_soup", "bowl"}, m = {0.105, -0.035, -0.045}, r = {7.5, 3.5, -7} },
        { {"^rabbit$"}, m = {0.09, 0.012, -0.075}, r = {6, 2.5, -9}, s = {1.1, 1.1, 1.1} },
        { {"^rabbit$"}, m = {0.005, -0.02, nil}, r = {nil, -0.5, nil}, s = {1/1.1, 1/1.1, 1/1.1} },
    }, true)
end

-- Actually 3D Stuff
if a3ds and itemMatches(packCompatibility.a3ds) then
    if not glowing3Dtotem and itemName == "totem_of_undying" then
        if w3di then 
            move(0.07, -0.035, -0.05, true)
            rotate(-10.5, -51, -2.5, true)
            scale(0.8, 0.8, 0.8, true)
        elseif not w3di then
            move(0.075, -0.03, -0.055, true)
            rotate(nil, nil, -4, true)
        end
    end
    if not bensBundle and itemName:match("bundle") then
        if w3di then
            move(0.04, 0.025, 0.04, true)
            rotate(2, nil, -3.5, true)
            scale(0.7, 0.7, 0.7, true)
        else
            move(0.055, 0.03, -0.035, true)
            rotate(3, 5, -8, true)
        end
    end
    if not freshOres and itemMatches(packCompatibility.freshOresIngots) then
        if w3di then
            pose({
                { {"coal"}, m = {-0.035, -0.055, -0.025}, r = {-7.5, -54, -7.5}, s = {0.8} },
                { {"raw"}, m = {-0.025, -0.04, -0.05}, r = {nil, 5.5, nil}, s = {1/1.3, 1, 1/1.3} },
                { {"emerald"}, m = {-0.035, 0.045, 0.01}, r = {2.5, 5, -1.5}, s = {0.9} },
                { {"lapis_lazuli"}, m = {-0.045, nil, -0.025}, r = {1, nil, nil} },
                { {"diamond"}, m = {-0.035, 0.02, -0.015}, r = {2, 5, nil} },
                { {"quartz"}, m = {0.09, 0.075, -0.01}, r = {1, 4.5, -7}, s = {0.7} },
                { {"amethyst_shard", "echo_shard"}, m = {0.08, 0.03, -0.065}, r = {1.5, 4, -6} },
                { {"echo_shard"}, m = {-0.01, nil, nil} },
                { {"nugget"}, m = {0.08, 0.035, -0.065}, r = {0.5, 2.5, -7} },
                { {"ingot", "brick"}, m = {0.025, 0.01, 0.015}, r = {nil, -10, -3}, s = {0.7} },
                { {"netherite_scrap"}, m = {0.025, 0.1, -0.185}, r = {0.5, -12, -2.5} },
                { {"^flint$"}, m = {0.05, nil, -0.13}, r = {12.5, 4, -2.5}, s = {0.85} }
            }, true)
        else
            pose({
                { {"coal"}, m = {-0.075, -0.015, -0.075}, r = {7, 39.5, -7.5} },
                { {"emerald"}, m = {0.01, 0.04, -0.07}, r = {3, 4, -6} },
                { {"lapis_lazuli"}, m = {0.02, -0.04, -0.105}, r = {nil, 2, -8.5} },
                { {"diamond"}, m = {0.015, -0.03, -0.095}, r = {1, 5.5, -7} },
                { {"quartz"}, m = {0.055, 0.065, nil}, r = {nil, 4, -7.5}, s = {0.7} },
                { {"amethyst_shard"}, m = {0.065, 0.04, -0.055}, r = {1.5, 4, -7} },
                { {"nugget"}, m = {0.06, 0.05, -0.025}, r = {2, 4, -5.5} },
                { {"ingot"}, m = {0.03, 0.02, -0.02}, r = {2.5, 4.5, -7}, s = {0.8} },
                { {"netherite_scrap"}, m = {-0.005, 0.11, -0.155}, r = {2, 4.5, -7.5} },
                { {"flint$"}, m = {0.015, nil, -0.1}, r = {2.5, 5, -7} }
            }, true)
        end
    end
    pose({
        --Natural Blocks
        { {"jungle_sapling"}, m = {0.125, 0.075, -0.045}, r = {7.5, nil, -5} },
        { {"bamboo"}, m = {0.005, nil, nil}, r = {nil, -6, nil}, s = {0.8} },
        { {"sugar_cane"}, m = {0.015, nil, -0.06}, r = {nil, -7.5, nil}, s = {0.9} },
        { {"frogspawn"}, m = {nil, 0.06, -0.01}, r = {4.5, 4, -9.5} },
        { {"lily_pad"}, m = {-0.04, -0.125, -0.04}, r = {-110.5, nil, nil} },

        -- Functional Blocks
        { {"armor_stand"}, m = {0.07, nil, nil}, r = {nil, 4, -7} },
        { {"bell"}, m = {-0.07, 0.04, nil} },

        -- Redstone Blocks
        { {"redstone"}, m = {0.05, 0.02, -0.075}, r = {2.5, nil, -5.5} },
        { {"string"}, m = {0.095, 0.015, -0.065}, r = {8, 4.5, -10} },
        { {"minecart"}, m = {0.085, 0.005, -0.02}, r = {3, 4, -8.5}, s = {0.95} },

        -- Tools
        { {"brush"}, m = {0.01, 0.045, nil}, r = {nil, -4.5, nil}, s = {0.9} },
        { {"saddle", "_harness"}, m = {0.055, -0.09, -0.11}, r = {0.5, 5.5, -8} },
        { {"flint_and_steel"}, m = {-0.02, -0.075, -0.1}, r = {10, 4, -3}, s = {0.8} },
        { {"fire_charge"}, m = {0.06, 0.055, 0.04}, r = {1, 5, -9} },
        { {"bone_meal"}, m = {0.075, 0.065, -0.125}, r = {0.5, 5, -7} },
        { {"^compass$"}, m = {0.07, 0.035, -0.045}, r = {1, 4, -8} },
        { {"map", "paper"}, m = {0.07, -0.02, -0.06}, r = {2.5, 4, -7} },
        { {"writable_book"}, m = {0.015, -0.02, -0.06}, r = {nil, 14.5, -9.5}, s = {0.75} },
        { {"ender_"}, m = {0.06, 0.01, -0.065}, r = {2, 3, -6.5} },
        { {"ender_pearl"}, m = {-0.02, nil, nil} },
        { {"firework_rocket"}, m = {-0.005, nil, -0.15}, r = {2, 3, -8} },
        { {"goat_horn"}, m = {0.07, 0.08, -0.065}, r = {nil, 3.5, -7.5} },
        { {"carrot_on_a_stick"}, r = {nil, 10.5, nil} },
        { {"warped_fungus_on_a_stick"}, m = {0.01, nil, nil}, r = {14, 12, nil} },

        -- Combat
        { {"snowball"}, m = {0.055, nil, -0.08}, r = {3, 3.5, -7} },
        { {"^egg$", "_egg"}, m = {0.065, 0.01, -0.08}, r = {3, 3.5, -7} },

        -- Ingredients
        { {"leather", "rabbit_hide"}, m = {0.05, -0.05, -0.1}, r = {nil, 5.5, -8} },
        { {"prismarine_shard"}, m = {nil, nil, -0.095}, r = {2, 4.5, -8.5} },
        { {"nether_star"}, m = {0.055, -0.055, -0.04}, r = {1.5, 3, -5.5} },
        { {"_dye"}, m = {0.045, nil, -0.09}, r = {1.5, 3, -7} },
        { {"rabbit_foot"}, m = {0.02, nil, -0.09}, r = {2, 4.5, -6.5} },
        { {"smithing_template"}, m = {-0.105, -0.075, -0.135}, r = {1.5, 4, -8} },
        { {"key"}, m = {0.02, -0.055, -0.1}, r = {2, nil, -8} },
        { {"stick"}, m = {0.025, nil, -0.02}, r = {-4.5, -6.5, 0.5} },
        { {"bone"}, m = {0.025, nil, -0.035}, r = {nil, -6, nil} },
        { {"honeycomb"}, m = {0.045, 0.04, -0.065}, r = {nil, 6, -7} },
        { {"ink_sac"}, m = {0.055, 0.025, -0.04}, r = {3, 4, -8} },
        { {"prismarine_crystals"}, m = {0.07, 0.015, -0.14}, r = {nil, 2.5, -6.5} },
        { {"nautilus_shell"}, m = {-0.025, -0.035, -0.045}, r = {2, 4, -7.5} },
        { {"heart_of_the_sea", "firework_star"}, m = {0.055, 0.045, 0.01}, r = {3, 5.5, -6} },
        { {"blaze_rod", "breeze_rod"}, m = {0.02, nil, -0.025}, r = {-5.5, -6, -3} },
        { {"^book$"}, m = {-0.02, 0.105, 0.02}, r = {1.5, 4.5, -8} },
        { {"glowstone_dust", "gunpowder", "blaze_powder", "^sugar$"}, m = {0.045, -0.014, -0.1}, r = {nil, nil, -3} },
        { {"banner_pattern"}, m = {nil, -0.055, -0.125}, r = {6, nil, nil} },
        { {"clay_ball"}, m = {hand(0, 0.1), nil, nil} },
    }, true)
end

-- Weskerson's 3D Items
if w3di and not a3ds then
    if not bensBundle and itemName:match("bundle") then
        move(nil, nil, 0.005, true)
        rotate(2.5, -0.5, -2.5, true)
        scale(0.8, 0.8, 0.8, true)
    end
    if not freshOres and itemMatches(packCompatibility.freshOresIngots) then
        pose({
            { {"emerald"}, m = {0.015, 0.035, -0.02}, r = {2.5, 4.5, nil}, s = {0.75} },
            { {"lapis_lazuli"}, m = {-0.02, 0.045, nil}, r = {nil, 4.5, nil} },
            { {"diamond"}, m = {0.015, 0.035, -0.045}, r = {2, 4, nil}, s = {0.75} },
            { {"amethyst_shard"}, m = {nil, nil, -0.05} },
            { {"nugget"}, m = {nil, 0.08, -0.02} },
            { {"ingot", "brick$"}, m = {0.03, 0.01, -0.02}, r = {nil, -10.5, -2.5}, s = {0.85} },
            { {"flint"}, m = {-0.065, -0.075, -0.12}, r = {11.5, 3.5, -4} },
        }, true)
    end
    if not freshFoods and itemMatches(packCompatibility.freshFoods) then
        pose({
            { {"melon_slice"}, m = {nil, nil, -0.115}, r = {nil, 4.5, nil} },
            { {"glow_berries", "carrot"}, m = {nil, nil, -0.035} },
            { {"potato"}, r = {nil, 4.5, -4.5} },
            { {"mutton"}, m = {0.055, nil, nil} },
            { {"cod", "fish", "salmon"}, m = {-0.045, nil, -0.07}, r = {nil, 2.5, nil} },
            { {"pufferfish"}, m = {0.02, -0.01, 0.045}, r = {nil, 3.5, -2.5} },
            { {"cake"}, m = {-0.005, 0.15, 0.015}, r = {6.5, nil, 2.5}, s = {0.9} },
            { {"pumpkin_pie"}, m = {-0.03, -0.005, nil}, r = {2, 3.5, nil} },
            { {"fishing_rod"}, m = {0.15, nil, -0.165} },
            { {"^spider_eye"}, m = {0.025, 0.005, -0.045}, r = {2.5, 4, -3} },
            { {"stew", "soup", "bowl"}, m = {0.05, -0.01, -0.115}, r = {nil, 5, -8.5} },
        }, true)
    end
    if not rvTorchs and itemMatches(packCompatibility.rvTorchs) then
        pose({
            { {"torch"}, m = {0.015, 0.09, 0.005}, r = {4.5, -25.5, -6} },
            { {"copper_torch"}, m = {0.07, -0.085, 0.02}, r = {nil, -6, nil}, s = {1.3} },
            { {"lantern"}, m = {nil, 0.125, 0.025}, s = {0.7} },
        }, true)
    end
    pose({
        -- Functional Blocks
        { {"armor_stand"}, m = {-0.02, nil, -0.085} },
        { {"ender_"}, m = {0.015, nil, -0.04}, r = {1.5, -0.5, -2.5}, s = {0.9} },
        { {"flower_pot"}, m = {0.02, 0.015, -0.015}, r = {9.5, -4.5, 3.5} },
        { {"sign"}, m = {0.03, 0.08, -0.03}, r = {7, 4, nil} },

        -- Tools
        { {"fishing_rod"}, m = {0.03, nil, 0.135} },
        { {"flint_and_steel"}, m = {nil, nil, -0.12}, r = {3, -6.5, 1.5} },
        { {"fire_charge"}, m = {0.05, nil, -0.045}, r = {nil, 1.5, nil}, s = {0.85} },
        { {"compass", "clock"}, m = {0.025, -0.005, -0.16}, r = {11.5, -1.5, nil} },
        { {"writable_book"}, m = {0.09, nil, -0.155} },
        { {"carrot_on_a_stick"}, m = {0.05, nil, -0.06}, r = {nil, nil, -14.5} },
        { {"warped_fungus_on_a_stick"}, m = {-0.05, nil, 0.055}, r = {-52.5, 7.5, -2.5} },
        { {"bucket"}, m = {-0.07, -0.065, -0.045}, r = {85, -159.5, -5.5}, s = {0.8} },
        { {"shears"}, m = {nil, nil, -0.035} },

        -- Combat
        { {"snowball", "^egg$", "blue_egg", "brown_egg"}, m = {0.1, nil, -0.045}, r = {nil, 1.5, nil}, s = {0.85} },

        --Ingredients
        { {"^bone$"}, m = {-0.02, -0.06, nil} },
        { {"bone_meal"}, m = {-0.02, nil, nil} },
        { {"honeycomb"}, m = {-0.03, nil, nil} },
        { {"prismarine_crystals"}, m = {nil, nil, 0.01}, r = {nil, 24.5, nil} },
        { {"heart_of_the_sea"}, m = {0.01, 0.015, -0.025}, r = {3.5, 2.5, -1}, s = {0.75} },
        { {"breeze_rod", "blaze_rod"}, m = {-0.015, nil, nil} },
        { {"banner_pattern"}, m = {0.065, -0.07, nil}, r = {nil, 8.5, nil} },
    }, true)
end

-- === ITEMS LISTS ===
local itemLists = {
    hangingPlants = {"spore_blossom", "hanging_roots", "pale_hanging_moss", "weeping_vines"},
    flowers = {
        "dandelion", "poppy", "blue_orchid", "allium", "azure_bluet",
        "oxeye_daisy", "cornflower", "lily_of_the_valley", "^torchflower$", "cactus_flower",
        "closed_eyeblossom", "open_eyeblossom", "wither_rose", 
        "sunflower", "lilac", "rose_bush", "peony", "pitcher_plant", "^azalea$",
        "^flowering_azalea$", "^nether_wart$"
    },
    foods = {
        "apple", "chorus_fruit", "melon_slice", "carrot", "potato", "^beetroot$",
        "bread", "cookie", "pumpkin_pie", "beef", "porkchop", "^chicken$", "mutton", "^rabbit$", 
        "^cod$", "^salmon$", "^tropical_fish$", "^pufferfish$", "cooked_chicken", 
        "cooked_rabbit", "cooked_cod", "cooked_salmon", "_stew", "_soup", "rotten_flesh", "^spider_eye$", 
        "^dried_kelp$", "^honeycomb$", "_berries", "bowl"
    },
    spawnEggAdjust = {
        "blaze", "bogged", "breeze", "camel", "cave_spider", "cod", "cow",
        "creaking", "creeper", "dolphin", "donkey", "drowned", "elder_guardian",
        "enderman", "evoker", "frog", "ghast", "glow_squid", "goat", "guardian",
        "happy_ghast", "hoglin", "horse", "husk", "iron_golem", "llama", "magma_cube",
        "mooshroom", "mule", "panda", "phantom", "pig", "piglin", "piglin_brute",
        "pillager", "polar_bear", "pufferfish", "ravager", "salmon", "sheep", 
        "shulker", "skeleton", "skeleton_horse", "slime", "sniffer", "snow_golem",
        "cave", "squid", "stray", "strider", "tadpole", "trader_llama", "tropical_fish",
        "turtle", "spider", "villager", "vindicator", "wandering_trader", "warden",
        "witch", "wither_skeleton", "wolf", "zoglin", "zombie", "zombie_horse",
        "zombie_villager", "zombified_piglin", "nautilus", "zombie_nautilus",
        "camel_husk", "parched"
    },
    sprites2D = {
        -- Colored Blocks
        "candle",
        -- Natural Blocks
        "small_amethyst_bud", "glow_lichen", "^vines$", "twisting_vines", "pitcher_pod", "lily_pad",
        "frogspawn", "sniffer_egg", "^kelp$", "seagrass",
        -- Functional Blocks
        "armor_stand", "glow_item_frame", "ender_eye", "fire_charge", "bone_meal", "name_tag", "lead",
        "cauldron", "ladder",
        -- Redstone Blocks
        "^redstone$", "string", "comparator", "repeater", "tripwire_hook", "hopper", 
        -- Tools
        "bundle", "compass", "^map$", "wind_charge", "ender_pearl",
        "elytra", "saddle", "goat_horn", "firework_rocket", "brush", "clock",
        -- Combat
        "turtle_helmet", "wolf_armor", "totem_of_undying", "arrow",
        "snowball", "^egg$", "brown_egg", "blue_egg",
        -- Ingredients
        "coal$", "raw_", "^emerald$", "^lapis_lazuli$", "^diamond$", "quartz$", "_shard", "netherite_scrap", "flint", 
        "wheat", "feather", "leather", "rabbit_hide", "resin_clump", "ink_sac", "_scute", "slime_ball", "clay_ball", 
        "prismarine_crystals", "nautilus_shell", "heart_of_the_sea", "phantom_membrane", "_key", "ghast_tear",
        "nether_star", "shulker_shell", "popped_chorus_fruit", "disc_fragment_5", "^nether_brick$", "^resin_brick$", 
        "paper", "firework_star", "glowstone_dust", "book$", "gunpowder", "fermented_spider_eye", "blaze_powder", 
        "^sugar$", "glistering_melon_slice", "magma_cream"
    }
}

-- === ITEM TYPE CHECKING ===
local is2D = (
    itemMatches({
        "music_disc_", "_dye", "_banner_pattern", "_pottery_sherd", "_smithing_template", "_spawn_egg",
        "_bundle", "_harness", "candle", "_nugget", "_ingot", "_helmet", "_chestplate", "_leggings", "_boots",
        "_horse_armor", "_seeds", "rail", "minecart", "nautilus_armor"
    }) or
    (itemName:match("_sign") and not itemName:match("hanging_sign")) or
    itemMatches(itemLists.sprites2D) or 
    isInList({"brick", "rabbit_foot", "iron_bars"})
)

local isException = (
    itemMatches({
        "_door", "_hanging_sign", "_boat", "_raft", "^lantern$", "soul_lantern", "copper_lantern", "_golem_statue",
        "_pickaxe", "_shovel", "_hoe", "_axe", "_sword", "rail", "bucket", "_head", "_skull", "_dye", "_spear", 
        "torch", "button", "chain", "^bamboo$", "painting", "^item_frame$", "^bell$", "fishing_rod", "spyglass",
        "on_a_stick", "mace", "trident", "_bottle", "potion", "dragon_breath", "^stick$", "^bone$", "blaze_rod", 
        "breeze_rod", "pink_petals", "wildflowers", "leaf_litter", "shears", "shield", "bow$", "lever", "cocoa_beans", 
        "sculk_vein", "filled_map"
    }) or
    itemMatches(itemLists.foods)
)

-- === GENERAL BLOCK ADJUSTMENTS ===
if not isException then
    move(skinModel(0.17, 0.175), nil, 0.07)
    if not (
        is2D or
        itemMatches(itemLists.flowers) or
        itemMatches({
            "_coral$", "_coral_fan", "_sapling", "_fungus$", "_roots", "_tulip", "_bush", "_grass", "fern", "_mushroom$", 
            "glass_pane", "_dripleaf"
        }) or
        isInList({
            "mangrove_propagule", "medium_amethyst_bud", "large_amethyst_bud", "amethyst_cluster", "pointed_dripstone", 
            "nether_sprouts", "cobweb"
        })
    ) then
        if
            I:isBlock(context.item) and
            not itemMatches({
                "_fence", "_wall", "_bed", "_banner$", "end_rod", "grindstone", "anvil", "brewing_stand", "conduit", 
                "scaffolding", "lightning_rod", "flower_pot", "decorated_pot", "_shelf", "dragon_egg", "heavy_core", 
                "pressure_plate", "chorus_plant", "turtle_egg", "cocoa_beans", "sea_pickle", "copper_bars", "cake"
            })
        then
            move(-0.135, 0.08, -0.07)
            scale(0.9, 0.9, 0.9)
        else
            move(nil, 0.08, nil)
            rotate(4, -31, -5)
        end
    end
end

-- === 2D SPRITES ADJUSTMENTS ===
if is2D then
    move(skinModel(-0.14, -0.1), 0.04, -0.105)
    rotate(nil, 5, -8)

    pose({{{"small_amethyst_bud", "pitcher_pod", "lily_pad", "glow_lichen",  "_seeds"}, r = {nil, -33, -1.9} }})
end

-- === ROTATED BLOCKS (90/180 DEGREES) ===
-- 90
pose({{{"piston", "barrel"}, m = {-0.03, 0.38, -0.05}, r = {90, nil, nil}}})

-- 180
pose({
    { {
        "lectern", "chiseled_bookshelf", "crafter", "furnace", "dispenser", "dropper", "loom", "smoker", 
        "blast_furnace", "_shelf"
    }, m = {-0.3, nil, 0.3}, r = {nil, 180, nil} },

    { {"_shelf"}, m = {skinModel(0.02, 0), nil, skinModel(-0.07, -0.13)} }
})

-- === CATEGORY-BASED ADJUSTMENTS ===
-- == Construction Blocks ==
pose({
    { {"_fence", "_wall"}, m = {skinModel(-0.02, 0), nil, 0.05} },
    { {"_fence_gate"},     m = {skinModel(-0.02, 0), -0.1, -0.03} },
    { {"_button"},         m = {skinModel(0.215, 0.245), 0.035, 0.07}, r = {8.2, -31, -5}, s = {1.3, 1.3, 1.3} },
    { {"_bars"},           m = {skinModel(-0.02, 0.01), nil, 0.04} },
    { {"iron_bars"},       m = {0.07, 0.05, -0.06}, r = {nil, nil, -0.5} },
    { {"chain"},           m = {skinModel(0.08, 0.1), 0.026, nil}, r = {0.4, nil, -14.7} }
})
if itemMatches({"^waxed"}) and itemMatches({"_copper_chain"}) then 
    move(skinModel(-0.03, -0.02), nil, 0.049) 
end

-- == Colored Blocks ==
pose({
    { {"glass_pane"}, m = {skinModel(-0.1, -0.07), 0.1, -0.12}, r = {nil, nil, -6} },
    { {"_banner$"},   m = {skinModel(-0.14, -0.13), 0.13, 0.17}, r = {nil, -90, nil} },
    { {"candle"},    m = {hand(0.02, 0.05), 0.03, -0.03} },
    { {"_bed"},       m = {-0.2, nil, 0.3} }
})

-- == Natural Blocks ==
pose({
    { {
        "_coral$", "_coral_fan", "sapling", "_fungus$", "_roots", "_tulip", "_bush", "_grass", "fern", "_mushroom$",
        "mangrove_propagule", "medium_amethyst_bud", "large_amethyst_bud", "amethyst_cluster", "pointed_dripstone",
        "nether_sprouts", "cobweb"
    }, m = {skinModel(-0.05, -0.047), 0.06, skinModel(-0.1, -0.08)}, r = {4, nil, -5} },

    { {"^sunflower$"}, 
        m = {hand(-0.1, -0.07), nil, hand(skinModel(0.32, 0.35), skinModel(-0.07, -0.06))}, 
        r = {nil, hand(-120, 30), nil} 
    },

    { itemLists.flowers, m = {skinModel(-0.05, -0.047), 0.06, skinModel(-0.1, -0.08)}, r = {4, nil, -5} },
    { itemLists.hangingPlants, m = {nil, -0.53, nil}, r = {4, nil, -5} },
    { {"^bush$"}, m = {0.045, nil, skinModel(0.02, 0.05)} },
    { {"^fern$"}, m = {skinModel(0.01, 0), nil, nil} },
    { {"^small_dripleaf$"}, m = {skinModel(-0.052, -0.03), nil, -0.083} },
    { {"^big_dripleaf$"}, m = {skinModel(-0.058, -0.027), nil, -0.163} },
    { {"^spore_blossom$"}, m = {-0.07, nil, nil} },
    { {"^sugar_cane$"}, m = {hand(0.022, 0.036), nil, skinModel(0, 0.016)}, r = {nil, nil, -7} },
    { {"^frogspawn$"}, m = {skinModel(0, 0.04), 0.03, -0.03} },
    { {"^torchflower$"}, m = {skinModel(0.056, 0.048), 0.061, skinModel(0.07, 0.12)} },
    { {"^azalea$", "^flowering_azalea$"}, m = {skinModel(0.01, 0), nil, skinModel(-0.01, 0.02)} },
    { {"^chorus_plant$"}, m = {hand(skinModel(0.02, 0.043), skinModel(-0.01, 0.03)), -0.1, nil} },
    { {"^sea_pickle$"}, m = {skinModel(0.07, 0.09), -0.07, -0.03}, r = {nil, 0.5, nil}, s = {1.5, 1.5, 1.5} },
    { {"^weeping_vines$"}, m = {skinModel(-0.02, 0), skinModel(-0.3, -0.2), skinModel(-0.1, 0)} },
    { {"^twisting_vines$"}, m = {hand(skinModel(0.095, 0.128), skinModel(-0.01, 0.02)), skinModel(0.06, 0.02), -0.03} },
    { {"^dried_ghast$"}, m = {-0.3, nil, 0.3}, r = {nil, 180, nil} },
    { {"^pitcher_pod$"}, m = {hand(-0.05, skinModel(0.08, 0.15)), 0.104, 0.07} },
    { {"^nether_wart$"}, m = {hand(0.04, skinModel(0.03, 0.02)), skinModel(0.03, 0.04), 0.12}, r  = {4, -31, nil} },
    { {"^lily_pad$"}, m = {nil, 0.2, nil}, r = {101.5, nil, -6} },
    { {"^bamboo$"}, m = {skinModel(0.02, 0.04), nil, skinModel(0.02, 0)} },
    { {"^vines$"}, m = {skinModel(-0.12, -0.15), -0.3, nil}, r = {10, 90, nil} },
    { {"^glow_lichen$"}, m = {skinModel(-0.15, -0.17), -0.2, nil}, r = {10, 90, nil} },
    { {"^sculk_vein$"}, m = {-0.16, -0.119, nil}, r = {11.6, 58.8, -8.5} },
    { {"^kelp$"}, m = {hand(0.17, -0.1), -0.03, -0.04} },
    { {"^seagrass$"}, m = {skinModel(0.04, 0.06), skinModel(0.06, 0.04), -0.035} },
    { {"^small_amethyst_bud$"}, m = {nil, 0.105, 0.09} },
    { {"^turtle_egg$"}, m = {skinModel(0.02, 0.046), -0.08, -0.06}, s = {1.3, 1.3, 1.3} },
    { {"^sniffer_egg$"}, m = {hand(-0.02, skinModel(0.11, 0.1)), 0.03, -0.03} },
    { {"_seeds"}, m = {hand(-0.03, 0.02), 0.08, skinModel(0.07, 0.1)} },
    { {"^beetroot_seeds$"}, m = {skinModel(0.04, 0.02), 0.03, -0.02}, r = {nil, -5, nil} },
    { {"^torchflower_seeds$"}, m = {0.22, -0.065, -0.055}, r = {nil, -1.5, hand(7, 3)} },
    { {"^cocoa_beans$"}, m = {skinModel(0.18, 0.2), -0.186, 0.145}, r = {8.8, -30, -3.4}, s = {1.5, 1.5, 1.5} },
})

-- == Functional Blocks ==
pose({
    { {"ender_eye", "ender_pearl"}, m = {hand(0.02, 0.05), -0.02, -0.05} },
    { {"torch"}, m = {skinModel(-0.01, 0.02), 0.04, 0.02}, r = {7.5, nil, -5}, s = {1.2, 1.2, 1.2} },
    { {"anvil"}, m = {skinModel(-0.31, -0.28), nil, nil}, r = {nil, 90, nil} },
    { {"lightning_rod"}, m = {skinModel(-0.02, -0.01), nil, skinModel(0.02, 0.05)} },
    { {"golem_statue"}, m = {-0.04, nil, -0.05} },
    { {"^end_rod$"}, m = {skinModel(0.03, 0.04), nil, skinModel(0.02, 0.05)}, s = {1.3, 1.3, 1.3} },
    { {"^grindstone$"}, m = {skinModel(0, 0.035), 0.33, -0.08}, r = {90, nil, nil} },
    { {"^end_crystal$"}, m = {-0.15, -0.1, 0.15} },
    { {"^conduit$"}, m = {skinModel(-0.05, -0.06), skinModel(-0.07, -0.04), skinModel(0.08, 0.16)} },
    { {"^scaffolding$"}, m = {skinModel(0, 0.01), -0.27, nil}, r = {nil, nil, skinModel(0, -3.5)} },
    { {"^flower_pot$"}, m = {skinModel(-0.02, 0), nil, 0.05} },
    { {"^dragon_egg$"}, m = {skinModel(0, 0.03), -0.04, nil} },
    { {"^ladder$"}, m = {skinModel(0.05, 0.03), 0.03, -0.03} },
    { {"^glow_item_frame$"}, m = {hand(0.02, 0.04), nil, -0.03} },
    { {"^armor_stand$"}, m = {hand(0.05, skinModel(0.02, 0.055)), 0.03, -0.07} },
    { {"^cauldron$"}, m = {hand(skinModel(0.06, 0.05), 0.02), nil, -0.03} },
})

if itemMatches({"_sign"}) and not itemMatches({"hanging_sign"}) then 
    move(hand(0.02, 0.05), nil, nil)
end

-- == Redstone Blocks ==
pose({
    { {"hopper", "tripwire_hook"}, m = {0.04, nil, -0.03} },
    { {"minecart"}, m = {hand(skinModel(0.06, 0), skinModel(0.025, 0)), nil, skinModel(-0.06, -0.05)} },
    { {"rail"}, m = {skinModel(0.2, 0.2), nil, 0.06} },
    { {"^redstone$"}, m = {skinModel(0.03, 0.02), nil, nil} },
    { {"^lever$"}, m = {-0.42, 0.045, -0.125}, r = {9.5, 101, nil}, s = {2.2, 2.2, 2.2} },
    { {"^string$"}, m = {hand(0, skinModel(0.09, 0.07)), nil, -0.03} }
})

-- == Tools ==
pose({
    { {"bone_meal", "name_tag"}, m = {hand(0, 0.05), nil, -0.06} },
    { {"_boat", "_raft"}, m = {0.1, 0.08, -0.05} },
    { {"pickaxe", "shovel", "hoe", "axe"}, m = {skinModel(0.02, 0.04), nil, -0.05} },
    { {"pickaxe"}, m = {skinModel(0, -0.01), nil, 0.005}, r = {nil, nil, -0.5} },
    { {"shovel"}, m = {-0.07, -0.2, skinModel(0.07, 0.095)}, r = {5.5, 3.5, -5.5} },
    { {"hoe"}, m = {skinModel(0, 0.02), -0.185, 0.005}, r = {nil, -6, nil} },
    { {"axe"}, m = {skinModel(0, 0.02), -0.105, nil}, r = {nil, -6, nil} },
    { {"bundle"}, m = {hand(skinModel(0.01, -0.01), skinModel(0.04, 0.02)), nil, -0.02} },
    { {"music_disc"}, m = {hand(0.05, skinModel(0.02, 0)), -0.08, -0.05} },
    { {"^music_disc_11$"}, m = {nil, 0.04, nil} },
    { {"^fishing_rod$"}, m = {skinModel(0.01, 0.03), 0.03, nil}, r = {nil, nil, -5.5} },
    { {"^carrot_on_a_stick$"}, m = {skinModel(0.06, 0.1), skinModel(0.06, 0.02), nil}, r = {nil, 4, -10.8} },
    { {"^warped_fungus_on_a_stick$"}, m = {skinModel(0.122, 0.16), 0.02, 0.04}, r = {nil, 2.2, -5.5} },
    { {"^flint_and_steel$"}, m = {hand(-0.1, 0.07), hand(0, 0.03), hand(-0.07, -0.03)}, r = {nil, -10, 8} },
    { {"^shears$"}, m = {hand(skinModel(0.16, 0.2), skinModel(-0.16, -0.2)), -0.05, hand(-0.07, 0.05)} },
    { {"^brush$"}, m = {skinModel(-0.01, -0.02), nil, skinModel(-0.02, 0.03)}, r = {nil, -10, 8} },
    { {"^clock$"}, m = {skinModel(0.04, 0.03), 0.03, -0.05} },
    { {"^fire_charge$"}, m = {skinModel(-0.02, -0.03), nil, 0.03} },
    { {"^recovery_compass$"}, m = {skinModel(0.04, 0.03), nil, -0.05} },
    { {"^compass$"}, m = {skinModel(0.01, -0.01), nil, nil} },
    { {"^writable_book$"}, m = {-0.03, nil, -0.05} },
    { {"^firework_rocket$"}, m = {hand(-0.05, 0.05), nil, -0.03} },
    { {"^lead$"}, m = {hand(0, skinModel(0.05, 0)), nil, -0.06} },
    { {"^spyglass$"}, r = {nil, nil, -10} },
    { {"^wind_charge$"}, m = {hand(skinModel(0.055, 0.04), skinModel(0.02, 0)), -0.08, -0.04} },
    { {"saddle", "goat_horn", "_harness"}, m = {nil, nil, -0.06} }
})

if itemMatches({"bucket"}) then 
    move(nil, -0.2, nil) 
end

-- == Combat ==
pose({
    { {"^egg$", "^snowball$", "^blue_egg$", "^brown_egg$"}, m = {skinModel(0.03, 0.01), -0.04, skinModel(-0.03, -0.02)} },
    { {"helmet", "chestplate", "leggings", "boots"}, m = {skinModel(0, -0.01), 0.04, nil} },
    { {"helmet"}, m = {0.04, -0.14, -0.05} },
    { {"leggings"}, m = {0.05, -0.078, -0.06} },
    { {"boots"}, m = {0.04, -0.11, -0.06} },
    { {"_sword"}, r = {nil, -6.5, nil} },
    { {"_sword", "mace"}, m = {skinModel(0.03, 0.04), nil, -0.02} },
    { {"_spear"}, m = {0.01, nil, 0.02} },
    { {"_horse_armor"}, m = {hand(0.03, -0.05), nil, nil} },
    { {"_nautilus_armor"}, m = {hand(0, 0.06), nil, -0.05} },
    { {"^totem_of_undying$"}, m = {skinModel(0.04, 0.03), nil, -0.05} },
    { {"^mace$"}, m = {0, -0.04, -0.04}, r = {nil, -5.5, nil}, s = {0.9, 0.9, 0.9} },
    { {"^shield$"}, r = {nil, nil, -8} },
    { {"^wolf_armor$"}, m = {hand(0, skinModel(0.06, 0.05)), -0.12, -0.06} },
    { {"^arrow$", "^spectral_arrow$", "^tipped_arrow$"}, m = {nil, nil, -0.02} }
})

if itemName == "trident" then 
    move(skinModel(-0.09, -0.04), nil, 0.07) 
end

-- == Foods & Potions ==
pose({
    { itemLists.foods, m = {skinModel(0.06, 0.09), 0.05, -0.07}, r = {nil, 5, -8} },
    { {"stew", "soup", "^bowl$"}, m = {skinModel(0.01, 0.02), -0.08, -0.02} },
    { {"beef", "porkchop", "^rabbit_stew$"}, m = {0.03, nil, nil} },
    { {"beef"}, m = {hand(0, -0.08), nil, nil} },
    { {"carrot"}, m = {nil, -0.04, nil} },
    { {"mutton"}, m = {hand(0.08, -0.05), 0.02, -0.02} },
    { {"rabbit$"}, m = {hand(-0.03, 0.05), -0.08, -0.03} },
    { {"^rabbit_stew$"}, m = {nil, 0.03, nil} },
    { {"^melon_slice$"}, m = {hand(0.07, -0.07), nil, nil} },
    { {"^sweet_berries$"}, m = {nil, nil, 0.07} },
    { {"^chorus_fruit$"}, m = {hand(-0.03, 0.04), nil, nil} },
    { {"^beetroot$"}, m = {hand(0, -0.08), nil, 0.05} },
    { {"^dried_kelp$"}, m = {nil, nil, -0.02} },
    { {"^cookie$"}, m = {skinModel(0.015, 0.02), -0.05, -0.03} },
    { {"^spider_eye$"}, m = {hand(-0.04, 0.05), nil, nil} },
    { {"^pufferfish$"}, m = {skinModel(-0.02, -0.03), nil, nil} },
    { {"^bread$"}, m = {nil, nil, skinModel(-0.01, 0)} },
    { {"^ominous_bottle$"}, m = {hand(skinModel(0.02, 0.01), skinModel(-0.02, -0.01)), nil, nil} },
    { {"splash_potion", "lingering_potion"}, m = {nil, -0.02, nil} },
    { {"^potato$", "^poisonous_potato$"}, m = {hand(0.06, -0.05), -0.03, 0.01} },
    { {"bottle", "potion", "dragon_breath"}, 
        m = {hand(skinModel(0.05, 0.08), skinModel(0.08, 0.1)), skinModel(0.03, 0.05), skinModel(-0.09, -0.07)},
        r = {nil, 5, -8}
        }
})

-- == Ingredients ==
pose({
    { { -- Move Back
        "raw", "coal", "_banner_pattern", "_pottery_sherd", "_smithing_template", "_key", "quartz$", "^amethyst_shard$",
        "netherite_scrap", "^diamond$", "^flint$", "wheat", "feather", "heart_of_the_sea", "nether_star", "leather",
        "rabbit_hide", "prismarine_shard", "shulker_shell", "echo_shard", "^book$", "fermented_spider_eye", 
        "blaze_powder", "glistering_melon_slice", "phantom_membrane", "enchanted_book", "copper_nugget", "^stick$"
    }, m = {skinModel(0.01, 0), nil, -0.06} },

    { { -- Move right
        "_banner_pattern", "_pottery_sherd", "_smithing_template", "wheat", "feather", "^stick$", "^bone$", "^flint$",
        "^diamond$", "quartz$", "amethyst_shard", "leather", "rabbit_hide", "heart_of_the_sea", "blaze_rod", 
        "breeze_rod", "^book$", "phantom_membrane", "enchanted_book", "^emerald$", "copper_nugget"
    }, m = {0.03, nil, nil} },

    { { -- Move down
        "turtle_scute", "armadillo_scute", "disc_fragment_5", "ghast_tear", "_nugget"
    }, m = {nil, -0.07, nil} },

    { { -- Move left in off-hand
        "coal$", "raw_", "netherite_scrap", "resin_clump", "prismarine_shard", "nether_star", "shulker_shell", 
        "echo_shard", "fermented_spider_eye", "blaze_powder", "glistering_melon_slice", "_key"
    }, m = {hand(0, 0.05), nil, nil} },

    -- Individual items
    { {"_ingot", "^brick$", "resin_brick", "^emerald$", "^lapis_lazuli$", "^nether_brick$"}, m = {nil, -0.03, -0.05} },
    { {"^prismarine_shard$", "^nether_star$"}, m = {0.01, nil, nil} },
    { {"blaze_rod", "breeze_rod"}, m = {skinModel(-0.03, 0), nil, nil} },
    { {"_dye"}, m = {skinModel(0.2, 0.2), 0.06, 0.03} },
    { {"ink_sac"}, m = {0.03, -0.06, -0.05} },
    { {"^emerald$"}, m = {skinModel(0.01, 0), nil, nil} },
    { {"^turtle_scute$"}, m = {-0.02, nil, nil} },
    { {"^resin_clump$"}, m = {nil, nil, -0.03} },
    { {"^slime_ball$"}, m = {0.03, -0.03, -0.05} },
    { {"^prismarine_crystals$"}, m = {nil, -0.04, -0.05} },
    { {"^nautilus_shell$"}, m = {hand(0.085, -0.02), nil, -0.06} },
    { {"^copper_nugget$"}, m = {skinModel(hand(0.06, 0.02), 0), nil, skinModel(-0.04, 0)} },
    { {"^iron_nugget$"}, m = {nil, nil, -0.02} },
    { {"^gold_nugget$"}, m = {0.03, 0.01, -0.05} },
    { {"^experience_bottle$"}, m = {nil, nil, -0.02} },
    { {"^bone$"}, m = {nil, -0.35, nil} },
    { {"^slime_ball$"}, m = {skinModel(0.01, 0), nil, nil} },
    { {"^glistering_melon_slice$"}, m = {skinModel(-0.03, -0.05), nil, nil} },
    { {"^iron_nugget$"}, m = {nil, nil, -0.02} },
    { {"heavy_core"}, m = {0.105, -0.07, -0.025}, s = {1.65} }
})

-- == Spawn Eggs ==

local function isEggAdjust(eggID)
    for _, egg in ipairs(itemLists.spawnEggAdjust) do
        if eggID == egg .. "_spawn_egg" then return true end
    end
    return false
end

if isEggAdjust(itemName) then
    move(skinModel(0.065, 0.04), nil, -0.06)
elseif itemName:match("_spawn_egg") then
    move(0.005, nil, nil)
end