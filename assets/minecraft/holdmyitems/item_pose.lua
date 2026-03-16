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

-- === FUNCTIONS ===
local function itemMatches(tableMatch)
    for _, item in ipairs(tableMatch) do
        if itemName:match(item) then
            return true
        end
    end
    return false
end

local function move(x, y, z)
    if not isItemUsing then
        if x then M:moveX(context.matrices, x * l) end
        if y then M:moveY(context.matrices, y) end
        if z then M:moveZ(context.matrices, z) end
    end
end

local function rotate(x, y, z)
    if not isItemUsing then
        if x then M:rotateX(context.matrices, x) end
        if y then M:rotateY(context.matrices, y * l) end
        if z then M:rotateZ(context.matrices, z * l) end
    end
end

local function scale(x, y, z)
    M:scale(context.matrices, x, y, z)
end

local function pose(tables)
    for _, t in ipairs(tables) do
        if (t.condition ~= nil and t.condition[1]) or t.condition == nil then
            for _, i in ipairs(t[1]) do
                if
                    (t.matches == true and itemName:match(i))
                    or (t.matches == nil and (itemName == i or I:isIn(context.item, Tags:getFabricTag(i)) or I:isIn(context.item, Tags:getVanillaTag(i))))
                then
                    if t.m then 
                        move(t.m[1], t.m[2], t.m[3]) 
                    end
                    if t.r then 
                        rotate(t.r[1], t.r[2], t.r[3]) 
                    end
                    if t.s then 
                        if t.s[1] and not t.s[2] and not t.s[3] then
                            scale(t.s[1], t.s[1], t.s[1])
                        elseif t.s[1] or t.s[2] or t.s[3] then
                            scale(t.s[1], t.s[2], t.s[3])
                        end
                    end
                    break
                end
            end
        end
    end
end

local function hand(posMainHand, posOffHand)
    return l == 1 and posMainHand or posOffHand
end

-- === ITEMS LISTS ===
local itemLists = {
    hangingPlants = {"spore_blossom", "hanging_roots", "pale_hanging_moss", "weeping_vines"},
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
        "glass_pane",
        -- Natural Blocks
        "small_amethyst_bud", "pitcher_pod", "lily_pad", "_seeds", "_bars", "sugar_cane",
        -- Functional Blocks
        "armor_stand", "glow_item_frame", "ender_eye", "fire_charge", "name_tag", "lead", "ladder", "sign",
        -- Redstone Blocks
        "^redstone$", "string", "tripwire_hook", "minecart",
        -- Tools
        "bundle", "compass", "^map$", "wind_charge", "ender_pearl", "_harness",
        "elytra", "saddle", "goat_horn", "firework_rocket", "brush", "clock", "music_disc",
        -- Combat
        "wolf_armor", "totem_of_undying", "arrow", "_helmet", "_chestplate", "leggings", "boots", "horse_armor",
        "snowball", "^egg$", "brown_egg", "blue_egg", "nautilus_armor",
        -- Foods
        "apple", "chorus_fruit", "melon_slice", "carrot", "potato", "^beetroot$",
        "bread", "cookie", "pumpkin_pie", "beef", "porkchop", "^chicken$", "mutton", "^rabbit$", 
        "^cod$", "^salmon$", "^tropical_fish$", "^pufferfish$", "cooked_chicken", 
        "cooked_rabbit", "cooked_cod", "cooked_salmon", "_stew", "_soup", "rotten_flesh", "^spider_eye$", 
        "^dried_kelp$", "^honeycomb$", "_berries", "bowl", "bottle", "potion",
        -- Ingredients
        "coal$", "raw_", "^emerald$", "^lapis_lazuli$", "^diamond$", "quartz$", "_shard", "netherite_scrap", "flint", 
        "wheat", "feather", "^leather$", "rabbit_hide", "resin_clump", "ink_sac", "_scute", "slime_ball", "clay_ball", 
        "prismarine_crystals", "nautilus_shell", "heart_of_the_sea", "phantom_membrane", "_key", "ghast_tear",
        "nether_star", "shulker_shell", "popped_chorus_fruit", "disc_fragment_5", "brick$", 
        "paper", "firework_star", "glowstone_dust", "book$", "gunpowder", "fermented_spider_eye", "blaze_powder", 
        "^sugar$", "glistering_melon_slice", "magma_cream", "_nugget", "_ingot", "^stick$", "bone", "_dye", 
        "dragon_breath", "rabbit_foot", "banner_pattern", "pottery_sherd", "smithing_template"
    },
    exepct = {
        "pink_petals", "wildflowers", "leaf_litter", "bucket", "fishing_rod", "shears", "rail", "fence", "wall",
        "bed_", "_banner$", "candle", "glow_lichen", "sniffer_egg", "sculk_vein", "^torch$", "_torch",
        "hanging_sign", "golem_statue", "comparator", "conduit", "_head", "campfire", "anvil", "brewing_stand",
        "repeater", "button", "hopper", "pickaxe", "axe", "shovel", "hoe", "sword", "_on_a_stick", 
        "boat", "raft", "trident", "mace", "cake", "blaze_rod", "breeze_rod", "heavy_core", "item_frame", "painting", 
        "^lantern$", "soul_lantern", "copper_lantern", "_head", "_skull", "pressure_plate", "trapdoor", "carpet", 
        "bamboo", "^vine$", "frogspawn", "turtle_egg", "dried_ghast"
    },
}

-- === ITEM TYPE CHECKING ===
local is2D          = (itemMatches(itemLists.sprites2D) or itemName:match("spawn_egg")) and not itemMatches(itemLists.exepct)
local isException   = itemMatches(itemLists.hangingPlants) or itemMatches(itemLists.exepct)
local general3D     = (not isException and not is2D) or itemMatches({"_bulb", "crafting_table", "waxed.*rod", "waxed.*chest"})
local general2D     = not isException and is2D

-- === NOT RENDER AS BLOCK ===
local NotRenderAsBlock = {
    "weeping_vines", "^vine$", "ladder", "sign", "tripwire_hook", "string", "_bars", "resin_clump", "glass_pane", "sugar_cane"
}
for _, i in ipairs(NotRenderAsBlock) do
    if (itemName:match(i) and not isException) or itemName == "vine" then
        renderAsBlock:put(I:getName(context.item), false)
    end
end

-- === GENERAL ADJUST ===
if general3D then
    move(0.05, -0.075, -0.1)
    rotate(-4, 18, -1)
elseif general2D then
    move(0.035, 0.04, -0.075)
    rotate(-6.5, -5.5, -1)
end

-- === INDIVIDUAL ADJUST ===
pose({
    -- Building Blocks
    { {"_trapdoor", "_pressure_plate"}, m = {0.18, -0.08, -0.065}, r = {-7.5, -6, nil}, matches = true },
    { {"doors"}, m = {-0.065, -0.32, 0.334}, r = {nil, -110.5, nil} },
    { {"bars"}, m = {nil, nil, -0.01} },
    { {"fences", "fence_gates", "walls"}, m = {0.175, -0.085, -0.075}, r = {-3.5, -5.5, -1} },
    { {"fence_gates"}, m = {nil, -0.105, -0.065} },
    { {"chains"}, m = {0.06, nil, -0.01} },

    -- Colored Blocks
    { {"banners"}, m = {0.045, 0.06, 0.03}, r = {-5, -95, nil} },
    { {"beds"}, m = {-0.225, -0.015, -0.005}, r = {7.5, 95, nil} },
    { {"candles"}, m = {0.37, -0.175, -0.215}, r = {-5.5, -6.5, -1}, s = {2.2} },
    { {"_carpet"}, m = {0.18, -0.08, -0.065}, r = {-7.5, -6, nil}, matches = true },
    { {"glass_pane"}, m = {-0.025, 0.035, nil}, matches = true },

    -- Natural Blocks
    { itemLists.hangingPlants, m = {0.105, -0.59, -0.025} },
    { {"amethyst_bud", "amethyst_cluster"}, m = {0.04, nil, -0.005}, matches = true, condition = {itemName ~= "small_amethyst_bud"} },
    { {"_mushroom", "fungus"}, m = {0.07, nil, -0.02}, matches = true, condition = {itemName ~= "warped_fungus_on_a_stick"} },
    { {"_grass", "_roots", "nether_sprouts"}, m = {0.05, nil, nil}, matches = true, condition = {itemName ~= "grass_block"} },
    { {"fern", "pointed_dripstone"}, m = {0.07, nil, -0.01}, matches = true },
    { {"bush", "lilac", "peony", "pitcher_plant", "_coral$", "_coral_fan", "cobweb"}, m = {0.055, nil, -0.025}, matches = true },
    { {"small_flowers"}, m = {0.065, nil, -0.015} },
    { {"saplings"}, m = {0.075, nil, -0.045}, s = {1.25} },
    { {"small_amethyst_bud"}, m = {nil, -0.03, 0.015} },
    { {"torchflower"}, m = {-0.065, 0.035, 0.075}, r = {nil, -31.5, nil} },
    { {"cactus_flower"}, m = {0.07, nil, -0.03}, s = {1.2} },
    { {"bamboo"}, m = {0.4, -0.15, -0.25}, r = {-3.5, -4.5, nil}, s = {2.4, 1.5, 2.4} },
    { {"weeping_vines"}, m = {0.105, -0.24, -0.12}, r = {-3, nil, nil}, s = {1.6} },
    { {"twisting_vines"}, m = {0.085, nil, nil} },
    { {"vine", "glow_lichen", "sculk_vein"}, m = {-0.07, -0.35, 0.01}, r = {-7.5, -96, -6.5}, s = {1, 1, 0.2} },
    { {"sunflower"}, m = {hand(-0.08, -0.02), nil, hand(0.33, -0.07)}, r = {nil, hand(-131.5, 30), nil} },
    { {"small_dripleaf"}, m = {0.06, nil, -0.015} },
    { {"big_dripleaf"}, m = {0.065, nil, -0.09} },
    { {"chorus_plant"}, m = {0.06, -0.145, -0.09}, s = {1.65} },
    { {"frogspawn"}, m = {0.17, -0.11, -0.08}, r = {-6.5, -5.5, -1} },
    { {"turtle_egg"}, m = {0.25, -0.195, -0.19}, r = {-5.5, -5.5, -0.5}, s = {1.7} },
    { {"sniffer_egg"}, m = {0.145, -0.1, -0.05}, r = {-6.5, -5.5, -1} },
    { {"dried_ghast"}, m = {-0.2, -0.105, 0.25}, r = {-4, 175, nil}, s = {1.25} },
    { {"parrot_food"}, m = {-0.04, -0.07, -0.01} },
    { {"beetroot_seeds"}, m = {nil, 0.035, nil} },
    { {"torchflower_seeds"}, m = {nil, -0.03, nil} },
    { {"pitcher_pod"}, m = {-0.04, nil, -0.01} },
    { {"cocoa_beans"}, m = {0.18, -0.275, 0.145}, r = {0.5, -21.5, -1}, s = {1.7} },
    { {"nether_wart"}, m = {0.105, 0.015, 0.085}, r = {nil, -23.5, nil} },
    { {"seagrass", "kelp"}, m = {0.08, 0.015, 0.085}, r = {nil, -23.5, nil} },
    { {"lily_pad"}, m = {-0.02, -0.01, -0.035}, r = {90, nil, nil}, s = {1, 1, 0.385} },
    { {"sea_pickle"}, m = {0.155, nil, 0.05}, r = {nil, -23.5, nil}, s = {1.5} },
    { {"pink_petals", "wildflowers", "leaf_litter"}, m = {nil, -0.19, -0.05}, r = {-72.5, 0.5, -1} },

    -- Functional Blocks
    { {"froglight", "shulker_box"}, m = {-0.04, nil, 0.025}, matches = true },
    { {"campfire"}, m = {0.21, -0.085, -0.095}, r = {-4, -5.5, -1}, s = {1.25}, matches = true },
    { {"lightning_rod"}, m = {0.18, -0.1, 0.02}, r = {-1, -23, nil}, s = {1.3}, matches = true },
    { {"torch", "soul_torch", "copper_torch", "redstone_torch"}, m = {0.07, -0.08, -0.065}, r = {-4.5, -5, -1}, s = {1.2} },
    { {"end_rod"}, m = {0.195, -0.025, 0.03}, r = {nil, -24, nil}, s = {1.5} },
    { {"end_rod"}, m = {0.195, -0.025, 0.03}, r = {nil, -24, nil}, s = {1.5} },
    { {"grindstone"}, m = {0.16, 0.35, -0.05}, r = {90, nil, 22.5} },
    { {"furnace", "blast_furnace", "smoker", "wooden_shelves", "lectern", "barrel"}, m = {-0.305, nil, 0.27}, r = {-180, nil, 180} },
    { {"anvil", "brewing_stand"}, m = {-0.105, -0.09, -0.13}, r = {-6, 84.5, -1} },
    { {"end_crystal"}, m = {-0.125, -0.065, 0.23}, r = {nil, -29.5, nil} },
    { {"conduit"}, m = {0.22, -0.22, -0.1}, r = {-5.5, -6, -1}, s = {1.3} },
    { {"scaffolding"}, m = {0.13, -0.265, 0.025}, r = {nil, -23, nil} },
    { {"flower_pot"}, m = {0.19, -0.035, 0.05}, r = {-1.5, -24, nil}, s = {1.4} },
    { {"wooden_shelves"}, m = {nil, -0.005, 0.01}, r = {0.5, -23, nil} },
    { {"signs"}, m = {-0.02, nil, 0.015} },
    { {"ender_eye", "ender_pearl"}, m = {-0.045, nil, 0.03} },
    { {"copper_golem_statues"}, m = {-0.005, 0.515, -0.385}, r = {175.5, -131.5, -3}, s = {1.4} },
    { {"lanterns"}, m = {0.035, -0.585, 0.095}, r = {-21.5, nil, nil} },
    { {"item_frame", "glow_item_frame", "painting"}, m = {0.035, -0.565, 0.225}, r = {-25, nil, nil} },
    { {"hanging_signs"}, m = {0.1, -0.685, 0.055}, r = {-12.5, -5.5, -1} },
    { {"bell"}, m = {-0.105, -0.61, 0.19}, r = {-18.5, -27.5, -7.5}, s = {1.2} },

    -- Redstone Blocks
    { {"minecart"}, m = {-0.055}, matches = true },
    { {"repeater", "comparator"}, m = {0.2, -0.075, -0.065}, r = {-5.5, -6, -0.5}, s = {1.25} },
    { {"lever"}, m = {-0.47, -0.06, -0.1}, r = {nil, 100, nil}, s = {2} },
    { {"buttons"}, m = {0.235, -0.105, -0.115}, r = {-7, -6, -0.5}, s = {1.4} },
    { {"hopper"}, m = {0.18, -0.09, -0.085}, r = {-5.5, -5.5, nil} },
    { {"string"}, m = {-0.05, -0.005, 0.015} },
    { {"piston", "dropper", "dispenser", "crafter", "chiseled_bookshelf"}, m = {-0.305, nil, 0.27}, r = {-180, nil, 180} },
    { {"rails"}, m = {0.165, -0.085, -0.09}, r = {-5.5, -5, -1.5} },

    -- Tools & Utilities
    { {"bucket"}, m = {0.03, -0.02, -0.26}, r = {-95.5, nil, 149}, matches = true },
    { {"fishing_rod", "_on_a_stick"}, m = {0.02, 0.04, -0.035}, r = {nil, -5.5, nil}, matches = true },
    { {"pickaxes", "axes", "hoes"}, m = {0.025, -0.115, -0.04}, r = {nil, -8.5, nil} },
    { {"shovels"}, m = {0.005, -0.185, 0.035}, r = {-4, 5.5, -7} },
    { {"warped_fungus_on_a_stick"}, m = {nil, 0.035, -0.03} },
    { {"flint_and_steel"}, m = {-0.055, 0.035, nil} },
    { {"fire_charge"}, m = {-0.025, -0.035, 0.03} },
    { {"shears"}, m = {0.03, -0.075, -0.065}, r = {-55, -4, 50} },
    { {"brush"}, m = {nil, nil, 0.055}, s = {0.8} },
    { {"bundles"}, m = {-0.05, nil, 0.02} },
    { {"recovery_compass"}, m = {-0.01, nil, nil} },
    { {"compass"}, m = {-0.005, -0.04, -0.005} },
    { {"spyglass"}, m = {-0.12, nil, 0.015}, r = {nil, -24.5, nil} },
    { {"map", "paper"}, m = {nil, -0.035, nil} },
    { {"bookshelf_books"}, m = {-0.065, nil, nil} },
    { {"wind_charge", "music_discs"}, m = {-0.015, -0.07, 0.02} },
    { {"elytra"}, m = {nil, -0.07, nil} },
    { {"firework_rocket"}, m = {-0.06, nil, 0.025} },
    { {"saddle"}, m = {-0.06, -0.04, 0.01} },
    { {"boats", "chest_boats"}, m = {-0.04, 0.115, 0.025} },
    { {"goat_horn"}, m = {0.025, -0.04, nil} },
    { {"music_disc_11"}, m = {nil, nil, -0.025} },

    -- Combat
    { {"horse_armor"}, m = {0.02, -0.075, nil}, matches = true },
    { {"nautilus_armor"}, m = {-0.04, -0.075, -0.005}, matches = true },
    { {"swords"}, m = {0.025, nil, -0.05}, r = {nil, -5, nil} },
    { {"mace"}, m = {0.025, -0.06, -0.05}, r = {nil, -5, nil} },
    { {"trident"}, m = {-0.005, nil, 0.1}, r = {nil, 19, nil} },
    { {"spears"}, m = {-0.07, nil, 0.1}, r = {nil, -14, 180} },
    { {"shield"}, m = {-0.035, 0.06, 0.005}, r = {-1.5, -22.5, nil}, s = {0.8, 1, 1} },
    { {"head_armor", "foot_armor"}, m = {nil, -0.11, -0.005} },
    { {"leg_armor"}, m = {nil, -0.035, -0.005} },
    { {"wolf_armor"}, m = {-0.005, -0.285, -0.015} },
    { {"snowball", "egg", "brown_egg", "blue_egg"}, m = {-0.02, -0.045, 0.015} },
    { {"arrows"}, m = {nil, nil, 0.02} },
    { {"bow"}, m = {0.005, nil, 0.07}, r = {nil, -25.5, -10.5} },
    { {"crossbow"}, m = {-0.12, 0.08, 0.065}, r = {nil, -11, nil} },

    -- Foods & Drinks
    { {"potato"}, m = {nil, -0.04, 0.015}, matches = true },
    { {"bowl", "_stew", "_soup"}, m = {nil, -0.075, -0.015}, matches = true },
    { {"potion", "bottle", "dragon_breath"}, m = {-0.025, nil, nil}, matches = true },
    { {"sweet_berries"}, m = {0.19, 0.08, nil}, r = {nil, nil, 51} },
    { {"chorus_fruit"}, m = {-0.04, nil, nil} },
    { {"carrot"}, m = {nil, -0.085, nil} },
    { {"beetroot"}, m = {nil, -0.105, nil} },
    { {"rabbit", "cooked_rabbit"}, m = {nil, -0.105, nil} },
    { {"cod","cooked_cod", "salmon", "cooked_salmon", "tropical_fish"}, m = {nil, -0.065, nil} },
    { {"pufferfish"}, m = {-0.025, -0.045, -0.01} },
    { {"bread"}, m = {nil, 0.03, 0.01} },
    { {"cookie"}, m = {nil, -0.035, nil} },
    { {"spider_eye", "fermented_spider_eye"}, m = {-0.055, -0.04, nil} },
    { {"cake"}, m = {0.2, -0.095, -0.085}, r = {-6.5, -5, -1}, s = {1.2} },
    { {"lingering_potion", "splash_potion"}, m = {-0.025, nil, 0.03} },
    { {"ominous_bottle"}, m = {0.015, nil, nil} },

    -- Ingredients
    { {"raw"}, m = {nil, -0.035, -0.01}, matches = true },
    { {"_ingot", "brick$"}, m = {nil, -0.06, nil}, matches = true },
    { {"_key"}, m = {-0.025, 0.005, 0.01}, s = {0.8}, matches = true },
    { {"emerald", "lapis_lazuli"}, m = {nil, -0.035, nil} },
    { {"amethyst_shard"}, m = {nil, -0.05, nil} },
    { {"nuggets"}, m = {0.02, -0.07, -0.01} },
    { {"iron_nugget"}, m = {-0.015, -0.035, nil} },
    { {"gold_nugget"}, m = {-0.025, nil, nil} },
    { {"stick", "bone", "blaze_rod", "breeze_rod"}, m = {-0.01, -0.28, nil}, r = {15.5, nil, nil} },
    { {"bone"}, m = {nil, -0.09, 0.015} },
    { {"ink_sac", "glow_ink_sac"}, m = {nil, -0.075, -0.01} },
    { {"honeycomb"}, m = {0.01, -0.04, nil} },
    { {"resin_clump"}, m = {-0.01, -0.075, nil} },
    { {"turtle_scute", "armadillo_scute", "disc_fragment_5"}, m = {nil, -0.105, -0.01} },
    { {"slime_ball", "clay_ball", "magma_cream"}, m = {nil, -0.04, nil} },
    { {"prismarine_shard"}, m = {-0.03, nil, nil} },
    { {"prismarine_crystals"}, m = {-0.03, -0.075, nil} },
    { {"nether_star"}, m = {-0.02, nil, nil} },
    { {"heavy_core"}, m = {0.275, -0.12, -0.125}, r = {-5.5, -5, -1.5}, s = {1.75} },
    { {"popped_chorus_fruit"}, m = {-0.005, -0.035, -0.015} },
    { {"echo_shard"}, m = {nil, nil, -0.01} },
    { {"firework_star"}, m = {nil, -0.04, -0.01} },
    { {"redstone", "gunpowder", "glowstone_dust", "sugar", "rabbit_foot"}, m = {-0.02, -0.02, 0.015} },
    { {"ghast_tear"}, m = {nil, -0.105, nil} },
    { {"smithing_template"}, m = {-0.02, nil, 0.02} },

    -- Spawn Eggs
    { itemLists.spawnEggAdjust, m = {nil, 0.04, nil}, matches = true, condition = {itemName:match("spawn_egg")} },
    { {"_spawn_egg"}, m = {-0.005, -0.04, nil}, matches = true }
})