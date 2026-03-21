-- by omnis._.
-- using item_model_addon.lua because it doesn't overwrite and to better separate compatibility between packs
-- it is what it is, you gotta make do with what you've got

local isUsingItem = P:isUsingItem(context.player)

-- === FUNCTION ===
Positions = {}
local function addPos(tables)
    for _, t in ipairs(tables) do
        table.insert(Positions, t)
    end
end

-- === ITEMS RESOURCE PACKS ===
PackCompat = {
    refinedBuckets = { {"bucket"}, matches = true },
    freshDiscs = { {"music_disc", "disc_fragment_5"}, matches = true },
    rvTorches = { {
        "torch", "soul_torch", "copper_torch", "redstone_torch", "lanterns", "repeater", "comparator", 
        "campfire", "soul_campfire"} },
    refinedTorches = { {
        "torch", "soul_torch", "copper_torch", "redstone_torch", "lanterns", 
        "campfire", "soul_campfire"} },
    freshFoods = { {
        "apple", "chorus_fruit", "melon_slice", "carrot", "potato", "^beetroot$",
        "bread", "cookie", "pumpkin_pie", "beef", "porkchop", "^chicken$", "mutton", "^rabbit$",
        "^cod$", "^salmon$", "^tropical_fish$", "^pufferfish$", "cooked_chicken",
        "cooked_rabbit", "cooked_cod", "cooked_salmon", "_stew", "_soup", "rotten_flesh", "^spider_eye$",
        "^dried_kelp$", "^honeycomb$", "_berries", "bowl"}, matches = true },
}

ActivePacks = {}
    local rvTorches         = ${rvTorches} and (table.insert(ActivePacks, "rvTorches") or true)
    local refinedTorches    = ${refinedTorches} and (table.insert(ActivePacks, "refinedTorches") or true)
    local refinedBuckets    = ${refinedBuckets} and (table.insert(ActivePacks, "refinedBuckets") or true)
    local freshDiscs        = ${freshDiscs} and (table.insert(ActivePacks, "freshDiscs") or true)
    local freshFoods        = ${freshFoods} and (table.insert(ActivePacks, "freshFoods") or true)

-- === UNDO ADJUSTS ===
UndoAdjusts = {
}

-- === INDIVIDUAL RESOURCE PACK ADJUST ===
if rvTorches then
    addPos({
        { {"torch", "soul_torch", "redstone_torch", "copper_torch"}, m = {0.01, nil, -0.035}, r = {-5, -5.5, nil} },
        { {"repeater", "comparator"}, m = {-0.045, -0.02, -0.035}, r = {-6, -16, 2.5}, renderAsBlock = false },
        { {"lanterns"}, m = {0.07, -0.545, 0.06}, r = {-11.5, -5.5, nil} },
        { {"campfire", "soul_campfire"}, m = {-0.08, 0.185, 0.255}, r = {8, -9.5, -2.5} }
    })
end

if refinedTorches then
    addPos({
        { {"torch", "soul_torch", "redstone_torch", "copper_torch"}, m = {0.035, nil, -0.04}, r = {-5, -4.5, nil} },
        { {"lanterns"}, m = {-0.04, -0.48, 0.115}, r = {-8.5, 9, nil} },
    })
end

if freshDiscs then
    addPos({
        { {"music_disc"}, m = {0.015, -0.015, -0.08}, r = {-5.5, -5.5, -0.5}, matches = true },
        { {"disc_fragment_5"}, m = {-0.015, nil, -0.055} }
    })
end

if freshFoods then
    addPos({
        { {"spider_eye"}, m = {-0.01, -0.13, -0.19}, r = {-5.5, 1.5, 34.5}, condition = {not isUsingItem} },
        { {"spider_eye"}, m = {0.08, -0.015, -0.065}, r = {-5.5, 1.5, 34.5}, condition = {isUsingItem} },
        { {"_soup", "_stew", "bowl"}, m = {0.07, -0.025, -0.03}, r = {1.5, -4.5, -1}, matches = true },
        { {"beef", "porkchop", "mutton"}, m = {0.06, 0.005, -0.13}, r = {-1.5, -5.5, -1}, s = {1.15}, matches = true },
        { {"apple"}, m = {0.075, 0.015, -0.07}, r = {2, -0.5, nil}, matches = true },
        { {"melon_slice"}, m = {0.03, nil, -0.055}, r = {2, -0.5, nil}, matches = true },
        { {"carrot"}, m = {-0.04, -0.035, -0.05}, r = {nil, -5, 3}, matches = true },
        { {"potato"}, m = {0.025, -0.01, -0.105}, r = {-5, -5, nil}, s = {1.15}, matches = true },
        { {"sweet_berries"}, m = {-0.035, nil, -0.055}, r = {nil, -4, nil} },
        { {"glow_berries"}, m = {0.015, -0.055, -0.095} },
        { {"chorus_fruit"}, m = {0.1, -0.055, -0.085}, r = {nil, -5.5, nil} },
        { {"beetroot"}, m = {-0.01, -0.12, -0.165}, r = {1.5, -5.5, nil} },
        { {"dried_kelp"}, m = {0.035, -0.025, -0.09}, r = {nil, 7.5, -1.5} },
        { {"chicken", "cooked_chicken"}, m = {0.065, -0.04, -0.15} },
        { {"rabbit"}, m = {0.1, -0.045, -0.095}, r = {nil, -6, nil} },
        { {"cooked_rabbit"}, m = {-0.025, -0.11, -0.055}, r = {-0.5, -7.5, nil} },
        { {"cod", "cooked_cod", "tropical_fish"}, m = {0.065, -0.04, -0.09}, r = {1.5, -5, -1.5} },
        { {"salmon"}, m = {-0.005, -0.04, -0.09}, r = {1.5, -5, -1.5} },
        { {"cooked_salmon"}, m = {-0.005, -0.04, -0.13}, r = {1.5, -5, -1.5} },
        { {"pufferfish"}, m = {0.075, 0.005, -0.065}, r = {15, 7.5, 9} },
        { {"bread"}, m = {0.07, -0.04, -0.085}, r = {1, nil, nil} },
        { {"cookie"}, m = {0.07, 0.005, -0.075} },
        { {"cake"}, m = {-0.05, 0.025, 0.015} },
        { {"pumpkin_pie"}, m = {0.06, 0.02, -0.175}, r = {4.5, 3, 5.5} },
        { {"rotten_flesh"}, m = {0.085, -0.19, -0.035}, r = {-40.5, nil, 3.5}, s = {1.15} },
    })
end