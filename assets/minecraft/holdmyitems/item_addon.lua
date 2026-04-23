-- by omnis._.

-- === CONTEXTS ===
local l           = context.mainHand and 1 or -1
local itemName    = I:getName(context.item):gsub("minecraft:", "")
local AlexModel   = ${skinModel}

-- === FUNCTIONS ===
-- == Match Item ==
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

-- == Render Item as Block ==
local function renderBlock(render, items, force)
    if force then
        renderAsBlock:put(I:getName(context.item), render)
        return
    end
    if IsItemCompat then return end

    for _, i in ipairs(items) do
        if matched(i) then
            renderAsBlock:put(I:getName(context.item), render)
            return
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
        if (t.condition ~= nil and t.condition[1]) or t.condition == nil then
            for _, i in ipairs(t[1]) do
                if matched(i, t.matches) then
                    if not IsItemCompat or force then
                        if t.renderAsBlock ~= nil then
                            renderBlock(t.renderAsBlock, t[1], force)
                        end
                        local opsOrder = t.ops or "mrs"
                        for j = 1, #opsOrder do
                            local op = opsOrder:sub(j, j):lower()
                            if op == "m" and t.m then process(move, t.m) end
                            if op == "r" and t.r then process(rotate, t.r) end
                            if op == "s" and t.s then
                                if t.s[2] == nil and t.s[3] == nil then
                                    M:scale(context.matrices, t.s[1], t.s[1], t.s[1])
                                else
                                    M:scale(context.matrices, t.s[1], t.s[2], t.s[3])
                                end
                            end
                        end
                        if not t.prox then return end
                    end
                end
            end
        end
    end
end

-- === ITEMS LISTS ===
local itemLists = {
    hangingPlants = {"spore_blossom", "hanging_roots", "pale_hanging_moss", "weeping_vines"},
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
        "coal$", "^emerald$", "^lapis_lazuli$", "^diamond$", "quartz$", "_shard", "netherite_scrap", "flint",
        "wheat", "feather", "^leather$", "rabbit_hide", "resin_clump", "ink_sac", "_scute", "slime_ball", "clay_ball",
        "prismarine_crystals", "nautilus_shell", "heart_of_the_sea", "phantom_membrane", "_key", "ghast_tear",
        "nether_star", "shulker_shell", "popped_chorus_fruit", "disc_fragment_5", "brick$", "^raw_iron$", "^raw_gold$",
        "^raw_copper$", "paper", "firework_star", "glowstone_dust", "book$", "gunpowder", "fermented_spider_eye",
        "^sugar$", "glistering_melon_slice", "magma_cream", "_nugget", "_ingot", "^stick$", "bone", "_dye", "blaze_powder",
        "dragon_breath", "rabbit_foot", "banner_pattern", "pottery_sherd", "smithing_template"
    },
    spawnEggsAdjust = {
        "cow", "camel", "donkey", "horse", "mule", "llama", "panda", "polar_bear", "cod", "dolphin", "squid", "nautilus",
        "salmon", "tadpole", "tropical_fish", "mooshroom", "sniffer", "iron_golem", "creaking", "guardian", "slime",
        "warden", "ravager", "ghast", "hoglin", "magma_cube", "strider", "zoglin", "enderman"
    },
    except = {
        "pink_petals", "wildflowers", "leaf_litter", "bucket", "fishing_rod", "shears", "rail", "fence", "wall",
        "bed_", "_banner$", "candle", "glow_lichen", "sniffer_egg", "sculk_vein", "^torch$", "_torch",
        "hanging_sign", "golem_statue", "comparator", "conduit", "campfire", "anvil", "brewing_stand",
        "repeater", "button", "^hopper$", "pickaxe", "axe", "shovel", "hoe", "sword", "_on_a_stick",
        "boat", "raft", "trident", "mace", "cake", "blaze_rod", "breeze_rod", "heavy_core", "item_frame", "painting",
        "^lantern$", "soul_lantern", "copper_lantern", "_head", "_skull", "pressure_plate", "trapdoor", "carpet",
        "bamboo", "^vine$", "frogspawn", "turtle_egg", "dried_ghast", "_spear", "^cauldron$"
    }
}

-- === ITEM TYPE CHECKING ===
local isException   = matched(itemLists.hangingPlants) or matched(itemLists.except, true) or IsItemCompat
local is2D          = matched(itemLists.sprites2D, true) or matched("spawn_egg", true)
local general2D     = not isException and is2D
local general3D     = not (isException or is2D) or matched({"_bulb", "crafting_table", "waxed.*rod", "waxed.*chest", "waxed.*chain"}, true)

-- === NOT RENDER AS BLOCK ===
renderBlock(
    false,
    {"weeping_vines", "vine", "ladder", "signs", "tripwire_hook", "string", "bars", "resin_clump", "glass_panes", "sugar_cane"}
)

-- === GENERAL ADJUST ===
if general3D then
    process(move, 0.05, -0.075, -0.1)
    process(rotate, -4, 18, -1)
elseif general2D then
    process(move, 0.03, 0.04, -0.075)
    process(rotate, -6.5, -5.5, -1)
end

if not AlexModel then
    process(move, 0.035, nil, nil)
end

-- === INDIVIDUAL ADJUST ===
pose({
    -- Building Blocks
    { {"_trapdoor", "_pressure_plate"}, m = {0.18, -0.08, -0.065}, r = {-7.5, -6, nil}, matches = true },
    { {"waxed.*door"}, m = {-0.4, -0.495, -0.12}, r = {8.5, 83, -14}, s = {1.15}, matches = true },
    { {"doors"}, m = {0.01, -0.445, 0.345}, r = {2.5, -113, 3.5}, s = {1.15} },
    { {"bars"}, m = {nil, nil, -0.01} },
    { {"fences", "walls"}, m = {0.175, -0.085, -0.075}, r = {-3.5, -5.5, -1} },
    { {"fence_gates"}, m = {0.17, -0.185, -0.09}, r = {-4.5, -5, -1.5} },
    { {"chains"}, m = {0.06, nil, -0.01} },

    -- Colored Blocks
    { {"_carpet"}, m = {0.18, -0.08, -0.065}, r = {-7.5, -6, nil}, matches = true },
    { {"glass_pane"}, m = {-0.01, 0.01, nil}, s = {0.75}, matches = true },
    { {"banners"}, m = {0.045, 0.06, 0.02}, r = {-5, -95, nil}, s = {1.25} },
    { {"beds"}, m = {-0.225, -0.015, -0.005}, r = {7.5, 95, nil} },
    { {"candles"}, m = {0.37, -0.175, -0.215}, r = {-5.5, -6.5, -1}, s = {2.2} },

    -- Natural Blocks
    { itemLists.hangingPlants, m = {0.105, -0.59, -0.025} },
    { {"amethyst_bud", "amethyst_cluster"}, m = {0.04, nil, -0.005}, matches = true, condition = {itemName ~= "small_amethyst_bud"} },
    { {"_grass", "_roots", "nether_sprouts"}, m = {0.05, nil, nil}, matches = true, condition = {itemName ~= "grass_block"} },
    { {"fern", "pointed_dripstone"}, m = {0.06, nil, -0.01}, matches = true },
    { {"_mushroom", "_fungus$"}, m = {0.08, nil, -0.04}, s = {1.3}, matches = true },
    { {"bush", "lilac", "peony", "pitcher_plant", "_coral$", "_coral_fan", "cobweb"}, m = {0.055, nil, -0.025}, matches = true },
    { {"torchflower"}, m = {0.01, 0.035, 0.07}, r = {nil, -35, nil} },
    { {"allium", "tulip"}, m = {0.1, nil, -0.045}, s = {1.4}, matches = true },
    { {"wither_rose"}, m = {0.08, nil, -0.065}, s = {1.4} },
    { {"small_flowers"}, m = {0.09, nil, -0.055}, s = {1.4} },
    { {"saplings"}, m = {0.075, nil, -0.045}, s = {1.25} },
    { {"small_amethyst_bud"}, m = {nil, -0.03, 0.015} },
    { {"cactus_flower"}, m = {0.07, nil, -0.03}, s = {1.2} },
    { {"bamboo"}, m = {0.49, -0.115, -0.26}, r = {-5, -5.5, -0.5}, s = {3, 1.2, 2.5} },
    { {"sugar_cane"}, m = {-0.06, -0.07, nil} },
    { {"weeping_vines"}, m = {0.105, -0.24, -0.12}, r = {-3, nil, nil}, s = {1.6} },
    { {"twisting_vines"}, m = {0.085, nil, nil} },
    { {"vine", "glow_lichen", "sculk_vein"}, m = {-0.11, -0.245, 0.08}, r = {-5, 84.5, -1.5}, s = {1, 1, 0.3} },
    { {"sunflower"}, m = {l == 1 and -0.08 or -0.02, nil, l == 1 and 0.33 or -0.07}, r = {nil, l == 1 and -131.5 or 30, nil} },
    { {"small_dripleaf"}, m = {0.06, nil, -0.015} },
    { {"big_dripleaf"}, m = {0.065, nil, -0.09} },
    { {"chorus_plant"}, m = {0.06, -0.145, -0.09}, s = {1.65} },
    { {"frogspawn"}, m = {0.17, -0.08, -0.08}, r = {-6.5, -5.5, -1} },
    { {"turtle_egg"}, m = {0.25, -0.165, -0.19}, r = {-5.5, -5.5, -0.5}, s = {1.7} },
    { {"sniffer_egg"}, m = {0.175, -0.08, -0.05}, r = {-6.5, -5.5, -1} },
    { {"dried_ghast"}, m = {-0.2, -0.06, 0.27}, r = {-4, 175, nil}, s = {1.25} },
    { {"parrot_food"}, m = {-0.025, -0.07, -0.01} },
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
    { {"torch", "soul_torch", "copper_torch", "redstone_torch"}, m = {0.08, -0.15, -0.075}, r = {-4.5, -5, -1}, s = {1.38} },
    { {"end_rod"}, m = {0.195, -0.025, 0.03}, r = {nil, -24, nil}, s = {1.5} },
    { {"grindstone"}, m = {0.215, 0.365, -0.08}, r = {90, nil, 22.5}, s = {1.35} },
    { {"furnace", "blast_furnace", "smoker", "lectern", "barrel"}, m = {-0.305, nil, 0.27}, r = {-180, nil, 180} },
    { {"anvil", "brewing_stand"}, m = {-0.11, -0.08, -0.13}, r = {10, 84.5, -16} },
    { {"end_crystal"}, m = {-0.125, -0.065, 0.23}, r = {nil, -29.5, nil} },
    { {"conduit"}, m = {0.22, -0.22, -0.1}, r = {-5.5, -6, -1}, s = {1.3} },
    { {"scaffolding"}, m = {0.13, -0.265, 0.025}, r = {nil, -23, nil} },
    { {"flower_pot"}, m = {0.19, -0.035, 0.05}, r = {-1.5, -24, nil}, s = {1.4} },
    { {"wooden_shelves"}, m = {-0.315, -0.005, 0.28}, r = {0.5, 157, nil} },
    { {"hanging_signs"}, m = {0.06, -0.745, 0.19}, r = {-29, -5.5, -1} },
    { {"signs"}, m = {-0.02, nil, 0.015} },
    { {"ender_eye", "ender_pearl"}, m = {-0.045, nil, 0.03} },
    { {"copper_golem_statues"}, m = {-0.005, 0.515, -0.385}, r = {175.5, -131.5, -3}, s = {1.4} },
    { {"lanterns"}, m = {0.035, -0.585, 0.095}, r = {-21.5, nil, nil} },
    { {"glow_item_frame"}, m = {nil, -0.53, 0.225}, r = {-37, nil, nil} },
    { {"item_frame"}, m = {-0.01, -0.535, 0.175}, r = {-29, nil, nil} },
    { {"painting"}, m = {-0.025, -0.62, 0.155}, r = {-25, nil, nil} },
    { {"bell"}, m = {-0.105, -0.61, 0.19}, r = {-18.5, -27.5, -7.5}, s = {1.2} },
    { {"armor_stand"}, m = {0.015, 0.03, nil} },
    { {"cauldron"}, m = {0.165, -0.16, -0.07}, r = {-5.5, -4.5, nil} },

    -- Redstone Blocks
    { {"minecart"}, m = {-0.055}, matches = true },
    { {"piston"}, r = {90, nil, nil}, m = {-0.01, -0.085, -0.355}, matches = true, ops = "rms" },
    { {"repeater", "comparator"}, m = {0.2, -0.075, -0.065}, r = {-5.5, -6, -0.5}, s = {1.25} },
    { {"lever"}, m = {-0.47, -0.06, -0.1}, r = {nil, 100, nil}, s = {2} },
    { {"buttons"}, m = {0.235, -0.105, -0.115}, r = {-7, -6, -0.5}, s = {1.4} },
    { {"hopper"}, m = {0.18, -0.09, -0.085}, r = {-5.5, -5.5, nil} },
    { {"string"}, m = {-0.05, -0.005, 0.015} },
    { {"dropper", "dispenser", "crafter", "chiseled_bookshelf"}, m = {-0.305, nil, 0.27}, r = {-180, nil, 180} },
    { {"rails"}, m = {0.165, -0.085, -0.09}, r = {-5.5, -5, -1.5} },

    -- Tools & Utilities
    { {"bucket"}, m = {0.01, -0.15, -0.15}, r = {nil, -7, nil}, s = {1.5}, matches = true },
    { {"fishing_rod", "carrot_on_a_stick"}, m = {0.02, 0.04, -0.035}, r = {nil, -5.5, nil} },
    { {"warped_fungus_on_a_stick"}, m = {0.02, 0.075, -0.07}, r = {nil, -5.5, nil} },
    { {"pickaxes", "axes", "hoes"}, m = {0.025, -0.115, -0.04}, r = {nil, -8.5, nil} },
    { {"shovels"}, m = {0.05, -0.173, 0.035}, r = {-4, 5.5, -4.5} },
    { {"flint_and_steel"}, m = {-0.105, nil, nil} },
    { {"fire_charge"}, m = {-0.025, -0.035, 0.03} },
    { {"shears"}, m = {0.03, -0.075, -0.065}, r = {-55, -4, 50} },
    { {"brush"}, m = {nil, nil, 0.1}, s = {0.7} },
    { {"bundles"}, m = {-0.05, nil, 0.02} },
    { {"recovery_compass"}, m = {-0.01, nil, nil} },
    { {"compass"}, m = {-0.005, -0.04, -0.005} },
    { {"spyglass"}, m = {-0.12, nil, 0.015}, r = {nil, -24.5, nil} },
    { {"map", "paper"}, m = {nil, -0.035, nil} },
    { {"bookshelf_books"}, m = {-0.065, -0.035, nil} },
    { {"music_disc_11"}, m = {-0.01, -0.07, -0.005} },
    { {"wind_charge", "music_discs"}, m = {-0.01, -0.07, 0.02} },
    { {"elytra"}, m = {nil, -0.07, nil} },
    { {"firework_rocket"}, m = {-0.06, nil, 0.025} },
    { {"saddle"}, m = {-0.06, -0.04, 0.01} },
    { {"boats", "chest_boats"}, m = {-0.04, 0.115, 0.025} },
    { {"goat_horn"}, m = {0.025, -0.04, nil} },

    -- Combat
    { {"horse_armor"}, m = {0.02, -0.04, nil}, matches = true },
    { {"nautilus_armor"}, m = {-0.04, -0.075, -0.005}, matches = true },
    { {"swords"}, m = {0.025, nil, -0.025}, r = {nil, -5, nil} },
    { {"mace"}, m = {0.025, -0.06, -0.025}, r = {nil, -5, nil} },
    { {"trident"}, m = {-0.03, nil, nil} },
    { {"shield"}, m = {-0.035, 0.06, 0.005}, r = {-1.5, -22.5, nil}, s = {0.8, 1, 1} },
    { {"head_armor", "foot_armor"}, m = {nil, -0.11, -0.005} },
    { {"leg_armor"}, m = {nil, -0.035, -0.005} },
    { {"wolf_armor"}, m = {-0.005, -0.285, -0.015} },
    { {"snowball", "egg", "brown_egg", "blue_egg"}, m = {nil, -0.06, nil} },
    { {"arrows"}, m = {nil, nil, 0.02} },
    { {"bow"}, m = {-0.03, nil, 0.07}, r = {nil, -25.5, -10.5} },
    { {"crossbow"}, m = {-0.12, 0.085, 0.065}, r = {nil, -11, nil} },

    -- Foods & Drinks
    { {"potato"}, m = {nil, -0.04, 0.015}, matches = true },
    { {"bowl", "_stew", "_soup"}, m = {nil, -0.075, -0.015}, matches = true },
    { {"potion", "bottle", "dragon_breath"}, m = {-0.025, nil, nil}, matches = true },
    { {"mutton"}, m = {l == 1 and 0 or -0.07, nil, nil}, matches = true },
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
    { {"_ingot", "brick$"}, m = {-0.065, -0.075, nil}, matches = true },
    { {"_key"}, m = {-0.025, 0.005, 0.01}, s = {0.8}, matches = true },
    { {"raw_iron", "raw_gold", "raw_copper"}, m = {nil, -0.035, -0.01} },
    { {"emerald", "lapis_lazuli"}, m = {nil, -0.035, nil} },
    { {"amethyst_shard"}, m = {nil, -0.05, nil} },
    { {"nuggets"}, m = {0.02, -0.07, -0.01} },
    { {"iron_nugget"}, m = {-0.015, -0.035, nil} },
    { {"gold_nugget"}, m = {-0.025, nil, nil} },
    { {"blaze_rod", "breeze_rod"}, m = {0.02, -0.24, -0.005}, r = {9, -7, nil} },
    { {"stick"}, m = {-0.01, -0.28, nil}, r = {15.5, nil, nil} },
    { {"bone"}, m = {nil, -0.39, nil}, r = {15.5, nil, nil} },
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
    { itemLists.spawnEggsAdjust, m = {-0.005, 0.03, nil}, matches = true },
    { {"_spawn_egg"}, m = {-0.01, -0.04, nil}, matches = true }
})