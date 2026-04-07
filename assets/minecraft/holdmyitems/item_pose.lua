-- by omnis._.

-- === CONTEXTS ===
local l           = context.mainHand and 1 or -1
local itemName    = I:getName(context.item):gsub("minecraft:", "")
local AlexModel   = ${AlexSkinModel}

-- === FUNCTIONS ===
-- == Match Item ==
local function matched(items, matches)
    local list = type(items) == "table" and items or {items}

    local function check(i)
        if itemName == i then
            return true
        end
        if matches then
            if itemName:match(i) then
                return true
            end
            if i:find("[%^%$%(%)%%%.%[%]%*%+%-%?]") then
                return false
            end
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
    { {"anvil", "brewing_stand"}, m = {-0.105, -0.09, -0.13}, r = {-6, 84.5, -1} },
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
    { {"fishing_rod", "_on_a_stick"}, m = {0.02, 0.04, -0.035}, r = {nil, -5.5, nil}, matches = true },
    { {"pickaxes", "axes", "hoes"}, m = {0.025, -0.115, -0.04}, r = {nil, -8.5, nil} },
    { {"shovels"}, m = {0.005, -0.185, 0.035}, r = {-4, 5.5, -7} },
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
    { {"swords"}, m = {0.025, nil, -0.05}, r = {nil, -5, nil} },
    { {"mace"}, m = {0.025, -0.06, -0.05}, r = {nil, -5, nil} },
    { {"trident"}, m = {-0.03, nil, nil} },
    { {"shield"}, m = {-0.035, 0.06, 0.005}, r = {-1.5, -22.5, nil}, s = {0.8, 1, 1} },
    { {"head_armor", "foot_armor"}, m = {nil, -0.11, -0.005} },
    { {"leg_armor"}, m = {nil, -0.035, -0.005} },
    { {"wolf_armor"}, m = {-0.005, -0.285, -0.015} },
    { {"snowball", "egg", "brown_egg", "blue_egg"}, m = {-0.02, -0.045, 0.015} },
    { {"arrows"}, m = {nil, nil, 0.02} },
    { {"bow"}, m = {-0.03, nil, 0.07}, r = {nil, -25.5, -10.5} },
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

-- === PHYSICS AND ANIMATIONS ===
-- Extracted from the HMI example_pack (item_pose.lua)
-- Credits: thesapling, KillaMC, OrkaMC, cyber

global.brushSpeedM          = 0;
global.brushSpeedO          = 0;
global.brushAngleM          = 0;
global.brushAngleO          = 0;
global.tridentM             = 0;
global.tridentMO            = 0;
global.tridentJ             = 0;
global.tridentJO            = 0;
global.spearCounterM        = 0;
global.spearUsageTime       = 0;
global.canDismountCounter   = 0;
global.canKnockbackCounter  = 0;
global.spearCounterO        = 0;
global.canDismountCounterO  = 0;
global.canKnockbackCounterO = 0;
global.hitImpactCounter     = 0;
global.hitImpactCounterO    = 0;
global.riptideCounter       = 0;
global.riptideCounterO      = 0;
global.swingCountPrev       = 0;
global.crossBowM            = 0.0;
global.crossBowSecM         = 0.0;
global.crossBowO            = 0.0;
global.crossBowSecO         = 0.0;
global.walk                 = 0.0;
global.walkSmoother         = 0.0;
global.swimSmoother         = 0.0;
global.swimCounter          = 0.0;
global.mainHandSwitch       = 0.0;
global.inspectionCounter    = 0.0;
global.inspectionSpin       = 0.0;
global.prevAge              = 0.0;
global.bowCountO            = 0.0;
global.bowCountSecO         = 0.0;
global.bowCount             = 0.0;
global.bowCountSec          = 0.0;
global.bowPullSpeed         = 0.0;
global.bowPullAngle         = 0.0;
global.bowPullSpeedO        = 0.0;
global.bowPullAngleO        = 0.0;
global.mapSmoother          = 0.0;
global.mapTransition        = 0.0;
global.mapZoomer            = 0.0;
global.fall                 = 0.0;
global.a                    = 0.0;
global.prevPitch            = 0.0;
global.pitchSpeed           = 0.0;
global.pitchAngle           = 0.0;
global.pitchSpeedO          = 0.0;
global.pitchAngleO          = 0.0;
global.yawSpeedO            = 0.0;
global.yawAngleO            = 0.0;
global.prevYaw              = 0.0;
global.yawSpeed             = 0.0;
global.yawAngle             = 0.0;
global.offHandSwitch        = 0.0;
global.foodCount            = 0.0;
global.foodCountSec         = 0.0;
global.foodCountSecO        = 0.0;
global.foodCountO           = 0.0;
global.brushCounter         = 0.0;
global.brushCounterO        = 0.0;
global.shieldDisable        = 0.0;
global.shieldM              = 0.0;
global.shieldO              = 0.0;
global.sneak                = 0.0;
global.bundleCounter        = 0.0;
global.swingOHandPrev       = false;
global.swingMHandPrev       = false;
global.foodCount = 0.0;
global.foodCountO = 0.0;

local swing_rot
local swing_sword_tilt
local swing_hit_second
local GRAVITY               = 0.04
local DAMPING               = 0.85
local INTENSITY             = 0.15
local dt                    = context.deltaTime * 30
local playerSpeed           = P:getSpeed(context.player)
local playerPitch           = P:getPitch(context.player)
local playerYaw             = P:getYaw(context.player)
local playerAge             = P:getAge(context.player)
local sp                    = I:getUseAction(P:getMainItem(context.player)) == "spear" and 1 or 0
local spo                   = I:getUseAction(P:getOffhandItem(context.player)) == "spear" and 1 or 0
local sc                    = context.mainHand and spearCounterM or spearCounterO
local scd                   = context.mainHand and canDismountCounter or canDismountCounterO
local sck                   = context.mainHand and canKnockbackCounter or canKnockbackCounterO
local sw                    = context.mainHand and mainHandSwitch or offHandSwitch
local mat                   = context.matrices
local hic                   = context.mainHand and Easings:easeInOutSine(hitImpactCounter) or hitImpactCounterO
local ywAngle               = (context.mainHand and yawAngle) or yawAngleO
local ptAngle               = (context.mainHand and pitchAngle) or pitchAngleO
local swing                 = M:sin(context.swingProgress * 3.14)
local swing_hit             = M:sin(M:clamp(context.swingProgress, 0.16561, 0.49422) * 4.78 * 2 + 4.7)
local swingOverall          = M:sin(context.swingProgress * 3.14)
local useAction             = I:getUseAction(context.item)
local isUsingItem           = P:isUsingItem(context.player)

-- == FUNCTIONS ==
function easeCustom(t)
    local t2 = t * t
    local t3 = t2 * t
    return 3 * t * (1 - t) * (1 - t) * 0.44 + 3 * t2 * (1 - t) * 1 + t3
end

function easeCustomSec(t)
    local t2 = t * t
    local t3 = t2 * t
    return 3 * t * (1 - t) * (1 - t) * 0.44 + 3 * t2 * (1 - t) * 0.94 + t3
end

local function glow(x, y, z, texture)
	particleManager:addParticle(
		context.particles,
		false,
		x, y, z,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 1.3,
		Texture:of("minecraft", texture),
		"ITEM", context.hand,
		"SPAWN", "ADDITIVE",
		0, 200 + (20 * M:sin(playerAge * 0.2))
	)
end

local function particle(x, y, z, texture, size, tick)
	particleManager:addParticle(
		context.particles, true,
		x, y, z,
		(math.random() * 0.12 - 0.06) * l, math.random() * 0.12,
		0, 0, 0, 0, 0, 0, 0, size or 0.4,
		Texture:of("minecraft", texture),
		"SCREEN", context.hand,
		"OPACITY", "TRANSLUCENT_L",
		1, 255, tick
	)
end

-- == CALC ==
local isSword        = matched({"swords"})
local isShovel       = matched({"shovels"})
local isAxe          = matched({"axes"})
local isHangingSign  = matched({"hanging_signs"})
local isPickaxe      = matched({"pickaxes"})
local isNugget       = matched({"nuggets"})
local isMusicDisc    = matched({"music_discs"})
local isSpearTag     = matched({"spears"})
local isSkull        = matched({"skulls"})

-- Brush
brushSpeedM = brushSpeedM + (M:sin(foodCountSec * 4.14) * brushCounter) * dt
brushSpeedM = brushSpeedM - GRAVITY * brushAngleM * dt
brushSpeedM = brushSpeedM * M:pow(DAMPING, dt)
brushAngleM = brushAngleM + brushSpeedM * dt

brushSpeedO = brushSpeedO + (M:sin(foodCountSecO * 4.14) * brushCounterO) * dt
brushSpeedO = brushSpeedO - GRAVITY * brushAngleO * dt
brushSpeedO = brushSpeedO * M:pow(DAMPING, dt)
brushAngleO = brushAngleO + brushSpeedO * dt

-- Pitch
pitchSpeed = pitchSpeed + ((playerSpeed * 22 * walkSmoother * -1) - (M:sin(context.mainHandSwingProgress * 3.14)) * 8 + fall * 3 + M:sin(sneak * 3.14) * 0.3 + (playerPitch - prevPitch)) * INTENSITY * dt
if useAction == "block" and context.mainHand and not isSword then
    pitchSpeed = pitchSpeed + 10 * M:sin(shieldDisable * 3.14) * INTENSITY * dt
    pitchSpeed = pitchSpeed + 12 * M:sin(shieldM      * 3.14) * INTENSITY * dt
end
pitchSpeed = pitchSpeed + ((-20 * M:sin(canDismountCounter   * 3.14) * spearCounterM) + (20 * M:sin(canKnockbackCounter * 3.14) * spearCounterM) + (12 * M:sin(inspectionCounter * 3.14)) + (15 * M:sin(spearCounterM       * 3.14)) + (-10 * M:clamp(M:sin(Easings:easeInBack(hitImpactCounter) * 6.28), 0, 1)) + ( 40 * M:clamp(M:sin(M:clamp(mainHandSwitch * 1.5 * sp, 0, 1) * 6.28), 0, 1))) * INTENSITY * dt
pitchSpeed = pitchSpeed - GRAVITY * pitchAngle * dt
pitchSpeed = pitchSpeed * M:pow(DAMPING, dt)
pitchAngle = pitchAngle + pitchSpeed * dt

pitchSpeedO = pitchSpeedO + ((playerSpeed * 22 * walkSmoother * -1) - (M:sin(context.offHandSwingProgress * 3.14)) * 8 + fall * 3 + M:sin(sneak * 3.14) * 0.3 + (playerPitch - prevPitch)) * INTENSITY * dt
if useAction == "block" and not context.mainHand and not isSword then
    pitchSpeedO = pitchSpeedO + 10 * M:sin(shieldDisable * 3.14) * INTENSITY * dt
    pitchSpeedO = pitchSpeedO + 12 * M:sin(shieldO      * 3.14) * INTENSITY * dt
end
pitchSpeedO = pitchSpeedO + ((-20 * M:sin(canDismountCounterO   * 3.14) * spearCounterO) + (20 * M:sin(canKnockbackCounterO * 3.14) * spearCounterO) + (15 * M:sin(spearCounterO * 3.14)) + ( 40 * M:clamp(M:sin(M:clamp(offHandSwitch * 1.5 * spo, 0, 1) * 6.28), 0, 1))) * INTENSITY * dt
pitchSpeedO = pitchSpeedO - GRAVITY * pitchAngleO * dt
pitchSpeedO = pitchSpeedO * M:pow(DAMPING, dt)
pitchAngleO = pitchAngleO + pitchSpeedO * dt

-- Yaw
yawSpeed = yawSpeed + (M:sin(walk) * 3 * walkSmoother+ (M:sin(context.mainHandSwingProgress * 3.14)) * 8+ M:sin(swimCounter * swimSmoother) * 3+ M:sin(mainHandSwitch * 6.28) * 3+ playerYaw - prevYaw) * INTENSITY * dt
yawSpeed = yawSpeed - GRAVITY * yawAngle * dt
yawSpeed = yawSpeed * M:pow(DAMPING, dt)
yawAngle = yawAngle + yawSpeed * dt

yawSpeedO = yawSpeedO + (M:sin(walk) * 3 * walkSmoother + (M:sin(context.offHandSwingProgress * 3.14)) * 8 + M:sin(swimCounter * swimSmoother) * 3 + M:sin(offHandSwitch * 6.28) * 3 + playerYaw - prevYaw) * INTENSITY * dt
yawSpeedO = yawSpeedO - GRAVITY * yawAngleO * dt
yawSpeedO = yawSpeedO * M:pow(DAMPING, dt)
yawAngleO = yawAngleO + yawSpeedO * dt

-- == RESOURCE PACKS ==
local rvTorches         = ${rvTorches}
local refinedTorches    = ${refinedTorches}
local glowing3Darmors   = ${glowing3Darmors}
local a3ds              = ${a3ds}
local w3di              = ${w3di}
local refinedBuckets    = ${refinedBuckets}
local freshFoods        = ${freshFoods}
local gousPoses         = ${gousPoses}
local nneSwords         = ${nneSwords}
local beashAnimations   = ${beashAnimations}
local torchesPack       = rvTorches or refinedTorches
local foodPack          = freshFoods or w3di

-- == SWING ANIMATIONS ==
if isPickaxe then
    context.swingProgress = easeCustom(context.swingProgress)
else
    context.swingProgress = easeCustomSec(context.swingProgress)
end

if context.swingProgress < 0.70016 then
    swing_rot = M:sin(M:clamp(context.swingProgress, 0, 0.308) * 5.1)
else
    swing_rot = M:sin(M:clamp(context.swingProgress, 0.70016, 1) * 5.1 - 2)
end

if context.swingProgress < 0.65245 then
    swing_sword_tilt = M:sin(M:clamp(context.swingProgress, 0, 0.16675) * 3.14 * 3)
else
    swing_sword_tilt = M:sin(M:clamp(context.swingProgress, 0.65245, 1) * 4.4 - 1.3)
end

swing_rot = swing_rot * swing_rot * swing_rot

if context.swingProgress < 0.65594 then
    swing_hit_second = M:sin(M:clamp(context.swingProgress, 0.16561, 0.32991) * 4.78 * 2 + 4.7)
else
    swing_hit_second = M:sin(M:clamp(context.swingProgress, 0.65594, 0.82025) * 4.78 * 2 - 4.7)
end

if useAction == "spear" then
    M:rotateZ(mat, 180 * l)

    M:rotateZ(mat, -180 * Easings:easeInOutBack(M:clamp(sw * 2, 0, 1)) * l)
    M:moveZ(mat, -0.2 * Easings:easeInOutSine(Easings:easeInOutBack(sc * 0.8)))

    M:moveY(mat, -0.05 * Easings:easeInOutBack(scd))

    M:rotateX(mat, -70 * Easings:easeInOutBack(sc * 0.8))
    M:rotateX(mat, -8 * Easings:easeInOutBack(scd))
    M:rotateY(mat, 60 * Easings:easeInOutBack(sc * 0.8) * l)
    M:rotateY(mat, -30 * Easings:easeInOutBack(scd) * l)

    M:rotateY(mat, -60 * Easings:easeOutBack(sck) * sck * l)

    M:moveY(mat, -0.25 * M:clamp(M:sin(Easings:easeInOutSine(hic) * 6.28), 0, 1))
end

if (useAction ~= "block" and useAction ~= "crossbow") or isSword then

    M:moveZ(mat, -0.05 * swing_rot)
    M:moveY(mat, -0.05 * swing_rot)
    M:rotateX(mat, 10 * swing_rot)
    M:rotateX(mat, -30 * swing_rot)
    M:rotateX(mat, -10 * swing_hit)

    if not isSword then
        if useAction == "trident" or useAction == "spear" then
            M:moveZ(mat, -0.1 * swing_rot)
            M:moveY(mat, -0.05 * swing_rot)

            if useAction == "spear" then
                M:moveY(mat, -0.15 * swing_hit)
                M:rotateX(mat, -5 * swing_hit)
            end

            M:rotateX(mat, -10 * swing_rot)
            M:rotateX(mat, -15 * swing_hit)

            if useAction == "trident" then
                M:rotateX(mat, -45 * swingOverall)
            else
                M:rotateX(mat, -45 * swing_sword_tilt)
            end

            M:moveY(mat, 0.05 * swing_hit)
            M:moveY(mat, 0.3 * swingOverall)

        else
            M:moveZ(mat, -0.05 * swing_rot)
            M:moveY(mat, -0.05 * swing_rot)
            M:rotateX(mat, -10 * swing_rot)
            M:rotateX(mat, -25 * swing_hit)
        end
    end

    if isShovel then
        M:moveY(mat, 0.12 * swing_sword_tilt)
        M:moveZ(mat, 0.05 * swing_sword_tilt)
        M:rotateX(mat, 10 * swing_sword_tilt)
        M:rotateX(mat, -30 * swingOverall)
        M:rotateX(mat, 20 * swing_rot)
        M:rotateX(mat, 10 * swing_hit_second)
    end

    if isSword and not (beashAnimations or nneSwords) then
        swing = M:sin(context.swingProgress * 3.14)
        M:moveY(mat, -0.1 * Easings:easeInOutBack(swing))
        M:rotateX(mat, -60 * Easings:easeInOutBack(swing))
    end

    if useAction == "bow" then
        M:moveX(mat, -0.065 * l)
    end
end

-- == PHYSICS ==
if matched({"bell", "end_crystal", "pink_petals", "leaf_litter", "wildflowers", "lanterns", "hanging_signs"}) then
	if matched({"pink_petals", "wildflowers", "leaf_litter"}) then
		M:rotateX(mat, M:clamp(playerPitch / 2.5, -20, 90) + ptAngle + ywAngle * 0.5, 0, -0.13, 0)
	end
	if matched({"end_crystal", "bell", "lanterns"}) then
		if itemName == "end_crystal" then
			M:scale(mat, 1 + 0.01 * M:sin(a * 15), 1 + 0.01 * M:sin(a * 15), 1 + 0.01 * M:sin(a * 8))
			M:moveY(mat, 0.03 * M:sin(a * 2))
			M:moveY(mat, 0.25)
			M:moveY(mat, ptAngle / 150)
			M:moveX(mat, ywAngle / 150 * l * -1)
			M:rotateZ(mat, 5 * M:sin(a))
			M:scale(mat, 0.7, 0.7, 0.7)
		elseif itemName == "bell" then
			M:moveX(mat, 0.15 * l)
			M:moveY(mat, -0.05)
			M:moveZ(mat, -0.1)
			M:scale(mat, 1.2, 1.2, 1.2)
			M:rotateX(mat, M:clamp(playerPitch / 2.5, -20, 90) + ptAngle, -0.1 * l, 0.4, 0.1)
			M:rotateZ(mat, ywAngle * -1, -0.1 * l, 0.4, 0.1)
        elseif not (torchesPack or w3di) then
			M:rotateX(mat, M:clamp(playerPitch / 2.5, -20, 90) + ptAngle, 0, 0.4, 0)
			M:rotateZ(mat, ywAngle * -1, 0, 0.4, 0)
		end
	end
	if isHangingSign then
		M:rotateX(mat, M:clamp(playerPitch / 2.5, -35, 90) + ptAngle, 0, 0.55, 0)
		M:rotateZ(mat, ywAngle * -1, 0, 0.55, 0)
	end
elseif itemName == "painting" or itemName == "item_frame" or (itemName == "glow_item_frame" and not a3ds) then
	context.swingProgress = 0
	M:rotateX(mat, M:clamp(playerPitch / 2.5, -25, 90) + ptAngle, 0, 0.45, 0)
	M:rotateZ(mat, ywAngle * -1, 0, 0.55, 0)
else
	if
		not I:isBlock(context.item)
		and not I:isEmpty(context.item)
		and useAction == "none"
		and useAction ~= "crossbow"
	then
		if isAxe or itemName == "mace" then
			local ptAngleMultiplier = (itemName == "mace" and 0.2) or 0.15
			M:rotateX(mat, -20 * M:sin(context.equipProgress * context.equipProgress * context.equipProgress) + (ptAngle * ptAngleMultiplier), 0.3 * l, -0.3, 0)
		else
			M:rotateX(mat, -20 * M:sin(context.equipProgress * context.equipProgress * context.equipProgress) + (ptAngle * 0.05), 0.3 * l, -0.4, 0)
		end
	end
	if (isAxe or itemName == "mace") and useAction ~= "crossbow" then
		M:rotateX(mat, (playerPitch * -0.05) + ptAngle * 0.2, 0, -0.2, 0)
	elseif useAction ~= "crossbow" then
		M:rotateX(mat, (playerPitch * -0.025) + ptAngle * 0.1, 0, -0.2, 0)
	end
end

-- == EAT & DRINK ANIMATION ==
local function applyTransform(op, progress, exp, x, y, z)
    local t = M:pow(progress, exp)

    if x then op.x(x * t) end
    if y then op.y(y * t) end
    if z then op.z(z * t) end
end

-- Animation
local function eatDrinkAnimation(use, progress, movePos, rotatePos, scalePos)
    local function m(default, override)
        if override ~= nil then return override else return default end
    end

    local moveVals = {
        x = movePos and m(nil, movePos[1]) or nil,
        y = movePos and m(nil, movePos[2]) or nil,
        z = movePos and m(-0.05, movePos[3]) or -0.05
    }
    local rotateVals = {
        x = rotatePos and m(nil, rotatePos[1]) or nil,
        y = rotatePos and m(-50, rotatePos[2]) or -50,
        z = rotatePos and m(nil, rotatePos[3]) or nil
    }

    applyTransform(move, progress, 1, 0.02, moveVals.y, moveVals.z)
    applyTransform(move, progress, 1, moveVals.x, nil, nil)

    if use == "eat" or use == "toot_horn" then
        local ex = rotatePos and m(-23, rotatePos[1]) or -23
        local ez = rotatePos and m(-12, rotatePos[3]) or -12
        applyTransform(rotate, progress, 2,  ex,  nil,  ez)
    end

    applyTransform(rotate, progress, 2,  rotateVals.x,  rotateVals.y,  rotateVals.z)

    if use == "drink" then
        local dx = rotatePos and m(15, rotatePos[1]) or 15
        applyTransform(rotate, progress, 2,  dx,  nil,  nil)
    end

    if scalePos then
        local t = M:pow(progress, 1)
        local sx = m(1, scalePos[1])
        local sy = m(1, scalePos[2])
        local sz = m(1, scalePos[3])
        M:scale(mat, 1 + (sx - 1) * t, 1 + (sy - 1) * t, 1 + (sz - 1) * t)
    end
end
local progress = context.mainHand and foodCount or foodCountO

local specialCases = {
    {
        pack = function() return refinedBuckets and w3di end,
        items = {"milk_bucket"},
        move = {0.01, 0.17, -0.1}, scale = {0.8, 0.8, 0.8}
    },
    {
        pack = function() return w3di and not refinedBuckets end,
        items = {"milk_bucket"},
        move = {-0.07, 0.05, -0.11}, rotate = {-5, -85, 5}, scale = {0.6, 0.6, 0.6}
    },
    -- Without packs
    {
        pack = function() return not (w3di or refinedBuckets) end,
        items = {"milk_bucket"},
        move = {-0.03, 0.15, -0.09}, rotate = {5, -40, 10}, scale = {0.55, 0.55, 0.55}
    },
    {
        pack = function() return not (w3di or refinedBuckets) and useAction == "drink" end,
        move = {-0.04, -0.015, nil}
    },
    {
        pack = function() return not (w3di or freshFoods) end,
        items = {"sweet_berries"},
        move = {nil, nil, 0.05}, rotate = {nil, 10, nil}
    },
    {
        pack = function() return not (w3di or freshFoods) and useAction == "eat" end,
        move = {nil, -0.05, 0.1}
    }
}

local caseMatched = false
for _, case in ipairs(specialCases) do
    if case.pack() then
        if (case.items ~= nil and matched(case.items)) or case.items == nil then
            eatDrinkAnimation(useAction, progress, case.move, case.rotate, case.scale)
            caseMatched = true
            break
        end
    end
end

if not caseMatched and (useAction == "eat" or useAction == "drink" or useAction == "toot_horn") then
    eatDrinkAnimation(useAction, progress)
end

global.foodCount    = 0.0;
global.foodCountO   = 0.0;

local easedFoodCounter = Easings:easeInQuart(context.mainHand and foodCount or foodCountO)

-- == BRUSH ANIMATION ==
if useAction == "brush" then
	if context.mainHand then
		M:moveZ(mat, -0.03 	* Easings:easeInOutBack(brushCounter))
		M:rotateX(mat, -30 	* Easings:easeInOutBack(brushCounter))
		M:rotateZ(mat, 15 	* l * M:sin((foodCountSec - 0.5) * 4.14) * Easings:easeInOutBack(brushCounter))
		M:rotateZ(mat, l 	* brushAngleM)
	else
		M:moveZ(mat, -0.03 	* Easings:easeInOutBack(brushCounterO))
		M:rotateX(mat, -30 	* Easings:easeInOutBack(brushCounterO))
		M:rotateZ(mat, 15 	* l * M:sin((foodCountSecO - 0.5) * 4.14) * Easings:easeInOutBack(brushCounterO))
		M:rotateZ(mat, l 	* brushAngleO)
	end
end

-- == FALL ANIMATION ==
if itemName == "slime_ball" or itemName == "slime_block" or itemName == "honey_block" then
    if itemName == "slime_ball" then
        local scaleY = (fall < 0 and fall * 0.06) or fall * 0.12
        M:moveY(mat, -0.1)
        M:scale(mat, 1, 1 + scaleY, 1)
        M:moveY(mat,  0.1)
    else
        local scaleX_Z = (fall < 0 and fall * 0.05) or fall * 0.1
        local scaleY   = (fall < 0 and fall * 0.1)  or fall * 0.3
        M:scale(mat, 1 - scaleX_Z, 1 + scaleY, 1 - scaleX_Z)
        M:shear(mat, 0, -ywAngle * 0.006 * l, 0)
    end
end

prevPitch   = P:getPitch(context.player)
prevYaw     = P:getYaw(context.player)

if itemName == "magma_cream" then
    M:scale(mat, 1 - (fall / 5), 1 + (fall / 5), 1)
end

-- == SWITCH ANIMATION ==
local activeSwitch              = context.mainHand and mainHandSwitch or offHandSwitch
local switchEvent               = context.mainHand and mainHandSwitchEvent or offHandSwitchEvent
local switchAnimationVariable   = Easings:easeInBack(M:sin(M:clamp(activeSwitch, 0.09723, 0.60632) * 5.346 - 0.1))

if
	(
		matched({"bundles", "skulls", "music_discs", "nuggets", "ender_pearl", "ender_eye"})
        or (glowing3Darmors and matched({"head_armor"}))
		or I:isThrowable(context.item)
	) and useAction ~= "trident"
then
    M:rotateX(mat, -10 * switchAnimationVariable)
    M:moveY(mat,  0.62 * switchAnimationVariable)
    M:moveY(mat,  M:clamp(0.1 * fall, 0, 255))

    local eased = Easings:easeInOutBack(M:clamp(activeSwitch * 1.65, 0, 1))

    if isNugget then
        if switchEvent then S:playSound("entity.experience_orb.pickup", 0.3) end
        M:moveY(mat, -0.07)
        M:rotateX(mat, 360 * Easings:easeInOutBack((context.mainHand and M:clamp(mainHandSwitch * 1.65, 0, 1)) or M:clamp(offHandSwitch * 1.65, 0, 1)), 0, 0.1, 0)
    elseif isMusicDisc then
        if switchEvent then S:playSound("entity.context.player.attack.weak", 0.3) end
        M:rotateZ(mat, 360 * eased, -0.1 * l, 0.25, 0)

    else
        if switchEvent then S:playSound("entity.context.player.attack.weak", 0.3) end
        local clampedSwitch = M:clamp(activeSwitch * 1.2, 0, 1)
        M:rotateZ(mat, -7 * l * M:sin(M:clamp(clampedSwitch, 0.0943, 0.66791) * 10.605 - 0.8))
    end
end

if (context.mainHand and mainHandSwitchEvent) or offHandSwitchEvent then
    S:playSound("context.item.armor.equip_leather", 0.2)
end

-- == MAP ANIMATION ==
local easedMapSmoother   = Easings:easeInOutBack(mapSmoother)
local easedMapZoomer     = Easings:easeInOutBack(mapZoomer)

if itemName == "filled_map" then
    M:rotateZ(mat, 5 * l * easedMapSmoother)
    M:rotateY(mat, (-40 - (20 * easedMapZoomer)) * l * easedMapSmoother)
    M:rotateZ(mat, 15 * l * easedMapSmoother)
    M:rotateX(mat, -10 * easedMapZoomer * easedMapSmoother)

    local smoother = 1 - easedMapSmoother
    M:moveZ(mat, -0.05 * smoother)
    M:moveY(mat, -0.05 * smoother)
    M:rotateX(mat, -40 * smoother)
    M:rotateY(mat, -10 * l * smoother)
    M:rotateZ(mat, 5 * l * smoother)
end

-- == GLOW AND PARTICLES ==
if not (refinedBuckets or torchesPack or w3di) then

    if itemName == "torch" 		            then glow(0.5 * l, 0.6, 0.5, "textures/particle/orange_glow.png")       end
    if itemName == "copper_torch" 	        then glow(0.5 * l, 0.6, 0.5, "textures/particle/copper_glow.png")       end
    if itemName == "soul_torch" 			then glow(0.5 * l, 0.6, 0.5, "textures/particle/blue_glow.png")         end
    if itemName == "redstone_torch" 		then glow(0.5 * l, 0.6, 0.5, "textures/particle/red_glow.png")          end
    if itemName == "lantern" 				then glow(0.45 * l, 0.15, 0.5, "textures/particle/orange_glow.png")     end
    if itemName == "soul_lantern" 			then glow(0.45 * l, 0.15, 0.5, "textures/particle/blue_glow.png")       end
    if itemName:match("copper_lantern") 	then glow(0.45 * l, 0.15, 0.5, "textures/particle/copper_glow.png")     end
    if itemName == "lava_bucket" 			then glow(-0.05 * l, 0, 0, "textures/particle/orange_glow.png")         end

elseif w3di and not (torchesPack or refinedBuckets) then

    if itemName == "torch" 		            then glow(0.5 * l, 0.6, 0.5, "textures/particle/orange_glow.png")       end
    if itemName == "copper_torch" 	        then glow(0.5 * l, 0.6, 0.5, "textures/particle/copper_glow.png")       end
    if itemName == "soul_torch" 			then glow(0.5 * l, 0.6, 0.5, "textures/particle/blue_glow.png")         end
    if itemName == "redstone_torch" 		then glow(0.5 * l, 0.6, 0.5, "textures/particle/red_glow.png")          end
	if itemName == "lantern" 			    then glow(0.05 * l, -0.2, -0.2, "textures/particle/orange_glow.png")    end
	if itemName == "soul_lantern" 		    then glow(0.05 * l, -0.2, -0.2, "textures/particle/b_glow.png")         end
	if itemName:match("copper_lantern")     then glow(0.05 * l, -0.2, -0.2, "textures/particle/copper_glow.png")    end

end

if swingCountPrev ~= P:getSwingCount(context.player) and context.mainHand and itemName == "bell" then
	S:playSound("block.bell.use", 0.3)
end
swingCountPrev = P:getSwingCount(context.player)

if itemName == "pink_petals" or itemName == "wildflowers" or itemName == "leaf_litter" then
	local particle_ticker = function(p)
		p.dx = p.dx + 0.005 * M:sin(playerAge * 0.3) * dt
	end
	local flower = ""
	if itemName == "wildflowers" then flower = "wild_flowers" else flower = itemName end

	if swingMHandPrev ~= context.swingMHand and context.mainHand then
		S:playSound("block.leaf_litter.place", 0.7)
        particle(0.75 * l, -0.2,  -0.9, "textures/particle/firefly.png", 0.4, particle_ticker)
        particle(0.75 * l, -0.2,  -0.9, "textures/particle/firefly.png", 0.4, particle_ticker)
        particle(0.65 * l, -0.25, -0.9, "textures/particle/" .. flower .. "_1.png", 0.3, particle_ticker)
        particle(0.65 * l, -0.25, -0.9, "textures/particle/" .. flower .. "_1.png", 0.3, particle_ticker)
        particle(0.65 * l, -0.25, -0.9, "textures/particle/" .. flower .. "_2.png", 0.3, particle_ticker)
        particle(0.65 * l, -0.25, -0.9, "textures/particle/" .. flower .. "_2.png", 0.3, particle_ticker)
        particle(0.65 * l, -0.25, -0.9, "textures/particle/" .. flower .. "_4.png", 0.2, particle_ticker)
        particle(0.65 * l, -0.25, -0.9, "textures/particle/" .. flower .. "_4.png", 0.2, particle_ticker)
    end
end
if context.mainHand then swingMHandPrev = context.swingMHand else swingOHandPrev = context.swingOHand end

-- == SWING SPEED ==
if isSpearTag                                   then itemSwingSpeed:put(I:getName(context.item), 15) end
if isShovel                                     then itemSwingSpeed:put(I:getName(context.item), 14) end
if itemName == "trident" or itemName == "mace"  then itemSwingSpeed:put(I:getName(context.item), 12) end

-- == TRIDENT AND SPEAR POSE ==
if useAction == "trident" then
    M:rotateZ(mat, 170 * l * Easings:easeOutBack(M:clamp(context.mainHand and tridentM or tridentMO * 1.5, 0, 1)))
    M:moveZ(mat, -0.08 * Easings:easeOutBack(M:clamp(context.mainHand and tridentM or tridentMO * 1.5, 0, 1)))
    M:rotateY(mat,  40 * l)
    M:rotateX(mat, -90 * Easings:easeOutBack(M:sin(context.mainHand and riptideCounter or riptideCounterO * 3.14)))
    M:rotateZ(mat, -45 * l * Easings:easeOutBack(M:sin(context.mainHand and riptideCounter or riptideCounterO * 3.14)))
end

if useAction == "spear" then
    M:moveZ(mat, -0.1)
    M:rotateY(mat, 10 * l)
end

-- == BOW STATE ==
local easedBowSec  = Easings:easeOutBack(bowCountSec)
local easedBowSecO = Easings:easeOutBack(bowCountSecO)
local bc           = context.mainHand and easedBowSec or easedBowSecO

usingItem:put("minecraft:bow",    bc >= 0.1)
useDuration:put("minecraft:bow",  Easings:cubicEase(bc) * 20)

-- == INSPECT ANIMATION ==
if KeyBindManager:isKeyPressed(${inspectKeybind} ~= 0 and ${inspectKeybind} or 67) then
    inspectionSpin = inspectionSpin + 0.025 * dt
else
    inspectionSpin = 0
end
inspectionSpin = M:clamp(inspectionSpin, 0, 1)

if isSword or isPickaxe or isAxe or useAction == "trident" and context.mainHand then
    M:moveX(mat, -0.2 * l * inspectionCounter)
    M:rotateX(mat, -360 * Easings:easeInOutBack(inspectionSpin), 0, 0, 0.15)
end
prevAge = P:getAge(context.player)

-- == SOME POSITIONS ==
if
    matched("bucket", true)
    or (isUsingItem and useAction == "eat" and foodPack)
then
    M:moveX(mat, -0.05 * l)
    M:rotateX(mat, -8)
    M:rotateY(mat, -10 * l)
    M:rotateZ(mat, 6 * l)
end

if matched("bucket", true) then
    M:moveY(mat, 0.025)
    M:moveX(mat, -0 * l)
    M:moveZ(mat, -0.1)
    M:rotateY(mat, 180)
    M:rotateX(mat, -82.5)
    M:rotateZ(mat, -20 * l)
    if itemName == "milk_bucket" then
        M:rotateX(mat, -0 * easedFoodCounter)
        M:rotateZ(mat, 30 * l * easedFoodCounter)
        M:rotateY(mat, 0 * l * easedFoodCounter)
        M:moveX(mat, 0 * l * easedFoodCounter)
        M:moveY(mat, 0.1 * easedFoodCounter)
        M:moveZ(mat, 0.02 * easedFoodCounter)
    end
end

if
    I:isOf(context.item, Items:get("bucket_of_frog:frog_bucket_cold"))
    or I:isOf(context.item, Items:get("bucket_of_frog:frog_bucket_warm"))
    or I:isOf(context.item, Items:get("bucket_of_frog:frog_bucket_temperate"))
then
    M:moveY(mat, 0.025)
    M:moveX(mat, -0 * l)
    M:moveZ(mat, -0.1)
    M:rotateY(mat, 180)
    M:rotateX(mat, -82.5)
    M:rotateZ(mat, -20 * l)
end

if itemName == "dragon_head" then
	M:moveY(mat, 0.25)
    M:rotateZ(mat, 6 * l)
    M:rotateY(mat, 160 * l)
elseif isSkull then
	M:moveX(mat, -0.1 * l)
    M:moveY(mat, 0.11)
    M:rotateZ(mat, 15 * l)
    M:rotateY(mat, -85 * l)
    M:rotateX(mat, -55)
end

if isShovel then
	M:moveX(mat, -0.09 * l)
	M:rotateY(mat, 80 * l)
end

-- === PACK COMPATIBILITY ===
if IsItemCompat then
    Positions = Positions or {}
    if Positions and next(Positions) then pose(Positions, true) end

    ItemsUndoAdjusts = ItemsUndoAdjusts or {}
    if ItemsUndoAdjusts and next(ItemsUndoAdjusts) then pose(ItemsUndoAdjusts, true) end
end

-- === PACKS CORRECTIONS ===
if w3di and a3ds and (itemName:match("_banner_pattern") or itemName == "name_tag") then
    M:rotateX(mat, -(M:clamp(playerPitch / 2.5, -20, 90) + ptAngle + ywAngle * 0.5), 0, -0.13, 0)
end

if itemName == "shears" and gousPoses then
    if not context.bl then
        M:moveZ(mat, 0.1)
        M:rotateY(mat, 180)
    end
    M:rotateZ(mat, 45)
end

if rvTorches and matched("candle", true) then
    renderAsBlock:put(I:getName(context.item), false)
    M:moveX(mat, -0.05 * l)
    M:rotateX(mat, -8)
    M:rotateY(mat, -10 * l)
    M:rotateZ(mat, 6 * l)
end

if (torchesPack or w3di) and matched("lanterns") then
    M:rotateX(mat, M:clamp(playerPitch / 2.5, -20, 90) + ptAngle, 0, 0.4, 0)
    M:rotateZ(mat, ywAngle * -1, 0, 0.4, 0)
end

if glowing3Darmors then
    if matched("chest_armor") then
        M:rotateX(mat, -(M:clamp(playerPitch / 2.5, -15, 80) + ptAngle + ywAngle * 0.3), 0, 0.1, 0.1)
        M:rotateZ(mat, ywAngle * 0.5, -0.129, -0.004, 0.495)
    elseif matched("leg_armor") then
        M:rotateZ(mat, M:clamp(playerPitch / 2.5, -15, 80) + ptAngle + ywAngle * 0.3, 0, 0.44, 0.55)
    elseif itemName == "elytra" and not w3di then
        M:rotateX(mat, M:clamp(playerPitch / 2.5, -20, 90) + ptAngle + ywAngle * 0.5, 0, -0.13, 0)
	    M:rotateZ(mat, ywAngle * -0.7, -0.1 * l, 0, 0.1)
    end
end