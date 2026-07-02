-- by omnis._.
-- tables for logic positioning

-- === ITEMS LISTS ===
ItemLists = {
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

-- === TAGS ===
ItemsTag = {
    default = {
        "doors", "bars", "fences", "walls", "fence_gates", "chains", "trapdoors", "glass_panes", "banners",
        "beds", "candles", "small_flowers", "lightning_rods", "shulker_boxes", "compasses", "spears",
        "wooden_shelves", "hanging_signs", "signs", "copper_golem_statues", "lanterns", "buttons", "rails",
        "chiseled_bookshelf", "pickaxes", "axes", "hoes", "shovels", "bundles", "bookshelf_books", "music_discs",
        "boats", "chest_boats", "swords", "head_armor", "chest_armor", "leg_armor", "foot_armor", "arrows",
        "ingots", "raw_materials", "nuggets", "harnesses", "dyes", "skulls"
    },
    registry = {
        pressure_plates       = {"_pressure_plate"},
        carpets               = {"_carpet"},
        beds                  = {"bed"},
        amethyst_cristals     = {"amethyst_bud", "amethyst_cluster"},
        small_plants          = {"_grass", "crimson_roots", "warped_roots", "nether_sprouts"},
        mushrooms             = {"_mushroom", "_fungus$"},
        corals                = {"_coral$", "_coral_fan"},
        bushes                = {"bush"},
        tulips                = {"tulip"},
        seeds                 = {"seeds"},
        ground_cover          = {"pink_petals", "wildflowers", "leaf_litter"},
        froglights            = {"froglight"},
        campfires             = {"campfire"},
        torches               = {"^torch$", "soul_torch", "copper_torch", "redstone_torch"},
        furnaces              = {"^furnace$", "blast_furnace", "smoker"},
        anvils                = {"anvil"},
        ender_items           = {"ender_eye", "ender_pearl"},
        minecarts             = {"minecart"},
        pistons               = {"piston"},
        ejectors              = {"dropper", "dispenser", "crafter"},
        buckets               = {"bucket"},
        horse_armors          = {"horse_armor"},
        nautilus_armors       = {"nautilus_armor"},
        eggs                  = {"^egg$", "blue_egg", "brown_egg"},
        potatoes              = {"potato"},
        bowl_foods            = {"bowl", "_stew", "_soup"},
        bottles_drink         = {"potion", "bottle", "dragon_breath"},
        muttons               = {"mutton"},
        rabbits               = {"^rabbit$", "cooked_rabbit"},
        fishes                = {"cod$","cooked_cod", "salmon$", "cooked_salmon", "tropical_fish$"},
        spider_eyes           = {"spider_eye"},
        carrots               = {"carrot"},
        bricks                = {"brick$", "nether_brick", "resin_brick$"},
        ink_sacs              = {"ink_sac"},
        scutes                = {"_scute"},
        balls                 = {"slime_ball", "clay_ball", "magma_cream"},
        powders               = {"^redstone$", "gunpowder", "glowstone_dust", "^sugar$"},
        smithing_templates    = {"smithing_template"},
        chests                = {"chest$"},
        spawn_eggs            = {"spawn_egg"},
        apples                = {"apple"},
        coals                 = {"coal$"},
        rods                  = {"fishing_rod", "on_a_stick"},
        hanging_plants        = {"spore_blossom", "hanging_roots", "pale_hanging_moss", "weeping_vines"},
        berries               = {"berries"},
        beefs                 = {"beef", "porkchop", "rotten_flesh"},
        chickens              = {"^chicken$", "cooked_chicken"},
        keys                  = {"key"},
        shards                = {"amethyst_shard", "echo_shard"},
        banner_patterns       = {"banner_pattern"},
        saplings              = {"_sapling", "mangrove_propagule"},
        azaleas               = {"^azalea$", "^flowering_azalea$"},
    }
}

-- === RESOURCE PACKS COMPATIBILITY ===

-- == Compatible Resource Packs ==
PackCompat = {
    freshDiscs          = {"music_discs", "disc_fragment_5"},
    glowing3Dtotem      = {"totem_of_undying"},
    glowing3Darmors     = {"head_armor", "chest_armor", "leg_armor", "foot_armor", "horse_armors", "elytra"},
    just3Darmors        = {"head_armor", "chest_armor", "leg_armor", "foot_armor", "horse_armors", "wolf_armor", "nautilus_armors", "elytra"},
    freshSeeds          = {"seeds"},
    bensBundle          = {"bundles"},
    gousPoses           = {"shears"},
    better3Dbooks       = {"bookshelf_books"},
    fyoncle3Dtrims      = {"smithing_templates"},
    rvChests            = {"chests", "shulker_boxes", "barrel"},
    rvTorches           = {"torches", "lanterns", "repeater", "comparator", "campfires", "candles"},
    refinedTorches      = {"torches", "lanterns", "campfires", "candles", "repeater", "comparator"},
    refinedBuckets      = {"buckets"},
    refinedTotem        = {"totem_of_undying"},
    visualEffects       = {"torch"},
    freshFoods = {
        "apples", "chorus_fruit", "melon_slice", "carrots", "potatoes", "beetroot", "spider_eye", "berries", "bowl_foods", "cake",
        "bread", "cookie", "pumpkin_pie", "beefs", "chickens", "muttons", "rabbits", "pufferfish", "dried_kelp", "fishes", "pressure_plates"
    },
    freshOresIngots = {
        "redstone", "coals", "raw_materials", "emerald", "lapis_lazuli", "ingots", "diamond", "quartz", "netherite_scrap",
        "amethyst_shard", "amethyst_cristals", "nuggets", "echo_shard", "bricks", "pointed_dripstone", "flint", "resin_clump"
    },
    freshFlowersPlants = {
        "pale_hanging_moss", "mushrooms", "small_plants", "small_flowers", "cactus_flower", "ground_cover", "spore_blossom",
        "bamboo", "sugar_cane", "vine", "sunflower", "lilac", "peony", "pitcher_plant", "bushes", "hanging_roots",
        "dripleaf", "sculk_vein", "glow_lichen", "lily_pad", "seagrass", "sea_pickle", "kelp", "fern", "small_plants",
        "corals", "weeping_vines", "twisting_vines", "saplings"
    },
    a3ds = {
        -- Natural Blocks
        "pale_hanging_moss", "saplings", "mushrooms", "small_plants", "fern", "small_flowers", "cactus_flower",
        "bushes", "ground_cover", "bamboo", "sugar_cane", "hanging_roots", "frogspawn", "twisting_vines", "vine", "peony",
        "sunflower", "lilac", "pitcher_plant", "glow_lichen", "lily_pad", "azalea", "flowering_azalea", "weeping_vines",
        -- Functional Blocks
        "bell", "armor_stand", "item_frame", "glow_item_frame", "painting", "ender_items",
        -- Redstone Blocks
        "string", "minecarts", "boats", "chest_boats",
        -- Tools
        "flint_and_steel", "fire_charge", "bone_meal", "shears", "brush", "name_tag", "lead", "bundles", "compass", "map",
        "writable_book", "firework_rocket", "saddle", "harnesses", "rods", "goat_horn",
        -- Combat
        "totem_of_undying", "snowball", "eggs",
        -- Ingredients
        "coals", "raw_materials", "emerald", "lapis_lazuli", "diamond", "quartz", "honeycomb", "resin_clump", "rabbit_hide",
        "netherite_scrap", "stick", "flint", "bone", "leather", "nautilus_shell", "heart_of_the_sea", "blaze_rod",  "dyes",
        "ink_sacs", "balls", "prismarine_crystals", "bricks", "paper", "book", "firework_star", "powders", "nether_star",
        "breeze_rod", "blaze_powder", "sugar", "rabbit_foot", "ghast_tear", "banner_patterns", "smithing_templates", "ingots",
        "keys", "enchanted_book", "echo_shard", "amethyst_shard", "nuggets"
    },
    wNature = {
        "oak_sapling", "azalea", "flowering_azalea", "mushrooms", "fern", "dead_bush", "oxeye_daisy", "cornflower",
        "dandelion", "poppy", "blue_orchid", "allium", "azure_bluet", "tulips", "lily_of_the_valley"
    },
    w3di = {
        -- Natural Blocks
        "turtle_egg",
        -- Functional Blocks
        "torches", "lanterns", "campfires", "end_crystal", "flower_pot", "armor_stand", "signs", "ender_items",
        -- Redstone Blocks
        "repeater", "comparator", "lever",
        -- Tools
        "buckets", "rods", "flint_and_steel", "fire_charge", "bone_meal", "shears", "name_tag", "elytra", "firework_rocket", "goat_horn",
        "lead", "bundles", "compasses", "clock", "map", "bookshelf_books", "wind_charge", "boats", "chest_boats", "music_discs",
        -- Combat
        "mace", "nautilus_armors", "totem_of_undying", "snowball", "eggs",
        -- Foods & Potions
        "apples", "chorus_fruit", "melon_slice", "carrots", "potatoes", "beetroot", "spider_eye", "berries", "bowl_foods", "cake",
        "bread", "cookie", "pumpkin_pie", "beefs", "chickens", "muttons", "rabbits", "pufferfish", "dried_kelp", "fishes", "bottles_drink",
        -- Ingredients
        "coals", "raw_materials", "emerald", "lapis_lazuli", "diamond", "breeze_rod", "shulker_shell", "blaze_powder",
        "nuggets", "ingots", "netherite_scrap", "stick", "flint", "bone", "feather", "quartz", "amethyst_shard", "loom_patterns",
        "honeycomb", "scutes", "slime_ball", "clay_ball", "prismarine_crystals", "sugar", "nautilus_shell", "heart_of_the_sea",
        "blaze_rod", "disc_fragment_5", "bricks", "powders",
        -- Spawn Eggs
        "spawn_eggs"
    },
    w3Dfoods = {
        "apples", "chorus_fruit", "melon_slice", "carrots", "potatoes", "beetroot", "spider_eye", "berries", "bowl_foods", "cake",
        "bread", "cookie", "pumpkin_pie", "beefs", "chickens", "muttons", "rabbits", "pufferfish", "dried_kelp", "fishes"
    }
}

-- == Active Resource Packs ==
ActivePacks = {}
    a3ds               = ${a3ds}                and (table.insert(ActivePacks, "a3ds") or true)
    w3di               = ${w3di}                and (table.insert(ActivePacks, "w3di") or true)
    w3Dfoods           = ${w3Dfoods}            and (table.insert(ActivePacks, "w3Dfoods") or true)
    wNature            = ${wNature}             and (table.insert(ActivePacks, "wNature") or true)
    rvChests           = ${rvChests}            and (table.insert(ActivePacks, "rvChests") or true)
    rvTorches          = ${rvTorches}           and (table.insert(ActivePacks, "rvTorches") or true)
    refinedTorches     = ${refinedTorches}      and (table.insert(ActivePacks, "refinedTorches") or true)
    refinedBuckets     = ${refinedBuckets}      and (table.insert(ActivePacks, "refinedBuckets") or true)
    refinedTotem       = ${refinedTotem}        and (table.insert(ActivePacks, "refinedTotem") or true)
    glowing3Dtotem     = ${glowing3Dtotem}      and (table.insert(ActivePacks, "glowing3Dtotem") or true)
    glowing3Darmors    = ${glowing3Darmors}     and (table.insert(ActivePacks, "glowing3Darmors") or true)
    just3Darmors       = ${just3Darmors}        and (table.insert(ActivePacks, "just3Darmors") or true)
    bensBundle         = ${bensBundle}          and (table.insert(ActivePacks, "bensBundle") or true)
    freshDiscs         = ${freshDiscs}          and (table.insert(ActivePacks, "freshDiscs") or true)
    freshFoods         = ${freshFoods}          and (table.insert(ActivePacks, "freshFoods") or true)
    freshSeeds         = ${freshSeeds}          and (table.insert(ActivePacks, "freshSeeds") or true)
    freshOres          = ${freshOresIngots}     and (table.insert(ActivePacks, "freshOresIngots") or true)
    freshFlowers       = ${freshFlowersPlants}  and (table.insert(ActivePacks, "freshFlowersPlants") or true)
    better3Dbooks      = ${better3Dbooks}       and (table.insert(ActivePacks, "better3Dbooks") or true)
    fyoncle3Dtrims     = ${fyoncle3Dtrims}      and (table.insert(ActivePacks, "fyoncle3Dtrims") or true)
    gousPoses          = ${gousPoses}           and (table.insert(ActivePacks, "gousPoses") or true)
    classicToolsFusion = ${classicToolsFusion}  and (table.insert(ActivePacks, "classicToolsFusion") or true)
    beashAnimations    = ${beashAnimations}     and (table.insert(ActivePacks, "beashAnimations") or true)
    nneSwords          = ${nneSwords}           and (table.insert(ActivePacks, "nneSwords") or true)
    vfx                = ${vfx}                 and (table.insert(ActivePacks, "visualEffects") or true)