-- by omnis._.

local l = context.bl and 1 or -1
local item = context.item
local matrices = context.matrices
local itemName = I:getName(item):gsub("minecraft:", "")
local AlexModel = ${AlexSkinModel}
local isItemUsing = false

if P:isUsingItem(context.player) then
    if (
        I:getUseAction(item) == "drink" or
        I:getUseAction(item) == "eat" or
        I:getUseAction(item) == "trident" 
    ) then 
        isItemUsing = true 
    else 
        isItemUsing = false 
    end
end

------ COMPATIBILIDADE ------

local packCompatibility = {
    rvTorchs = {"torch", "^lantern$", "soul_lantern", "copper_lantern", "campfire", "candle", "repeater", "comparator"},
    freshPaintings = {"painting"},
    freshSeeds = {"_seeds"},
    bensBundle = {"_bundle"},
    w3di = {
        -- Blocos Funcionais
        "torch", "^lantern$", "soul_lantern", "copper_lantern", "campfire", "end_crystal", "flower_pot", "armor_stand", "_sign", "ender_eye",
        -- Blocos de Redstone
        "redstone$", "repeater", "comparator", "lever",
        -- Ferramentas
        "bucket", "fishing_rod", "flint_and_steel", "fire_charge", "bone_meal", "shears", "name_tag",
        "lead", "bundle", "compass", "clock", "map", "book", "wind_charge", "ender_pearl", "elytra",
        "firework_rocket", "carrot_on_a_stick", "warped_fungus_on_a_stick", "goat_horn", "music_disc",
        "_boat", "_raft",
        -- Combate
        "mace", "nautilus_armor", "totem_of_undying", "snowball", "^egg$", "brown_egg", "blue_egg",
        -- Alimentos e Poções
        "apple", "chorus_fruit", "melon_slice", "carrot", "potato", "beetroot",
        "bread", "cookie", "pumpkin_pie", "beef", "porkchop", "chicken", "mutton", "rabbit", 
        "cod", "salmon", "tropical_fish", "pufferfish", "_stew", "rotten_flesh", "spider_eye", 
        "dried_kelp", "sweet_berries", "glow_berries", "potion",
        -- Ingredientes
        "coal", "raw", "emerald", "lapis_lazuli", "diamond$", "quartz$", "amethyst_shard",
        "nugget", "ingot", "netherite_scrap", "stick$", "flint$", "bone$", "feather", 
        "honeycomb", "scute", "slime_ball", "clay_ball", "prismarine_crystals",
        "nautilus_shell", "heart_of_the_sea", "blaze_rod", "breeze_rod", "shulker_shell",
        "disc_fragment_5", "bowl", "^brick$", "bottle", "glowstone_duster", "gunpowder",
        "dragon_breath", "blaze_powder", "sugar$", "_banner_pattern",
        -- Ovos Geradores
        "spawn_egg"
    },
    freshFlowersPlants = {
        "pale_hanging_moss", "_sapling", "mangrove_propagule", "azalea", "_mushroom$",
        "_fungus$", "_grass", "fern", "bush", "dandelion", "poppy", "blue_orchid", "allium",
        "azure_bluet", "tulip", "oxeye_daisy", "cornflower", "lily_of_the_valley", "torchflower",
        "cacutus_flower", "eyeblossom", "wither_rose", "pink_petals", "wildflowers", "leaf_litter",
        "spore_blossom", "bamboo", "sugar_cane", "roots", "nether_sprouts", "weeping_vines",
        "twisting_vines", "vine", "sunflower", "lilac", "peony", "pitcher_plant", "_dripleaf",
        "glow_lichen", "lily_pad", "seagrass", "sea_pickle", "kelp", "_coral", "sculk_vein"
    },
    freshFoods = {
        "apple", "chorus_fruit", "melon_slice", "carrot", "potato", "beetroot",
        "bread", "cookie", "pumpkin_pie", "beef", "porkchop", "chicken", "mutton", "rabbit", 
        "cod", "salmon", "tropical_fish", "pufferfish", "_stew", "rotten_flesh", "spider_eye", 
        "dried_kelp", "sweet_berries", "glow_berries"
    },
    glowing3Darmors = {
        "copper_helmet", "copper_chestplate", "copper_leggings", "copper_boots",
        "iron_helmet", "iron_chestplate", "iron_leggings", "iron_boots",
        "gold_helmet", "gold_chestplate", "gold_leggings", "gold_boots",
        "diamond_helmet", "diamond_chestplate", "diamond_leggings", "diamond_boots",
        "netherite_helmet", "netherite_chestplate", "netherite_leggings", "netherite_boots",
        "horse_armor"
    },
    freshOresIngots = {
        "redstone$", "coal", "raw", "emerald", "lapis_lazuli", "diamond", "quartz$",
        "amethyst_shard", "_amethyst_bud", "amethyst_cluster", "nugget", "_ingot",
        "netherite_scrap", "flint$", "resin_clump", "echo_shard", "resin_brick", "^brick$",
        "nether_brick"
    }
}

local activePacks = {}
    if ${w3di} then table.insert(activePacks, "w3di") end
    if ${rvTorchs} then table.insert(activePacks, "rvTorchs") end
    if ${glowing3Darmors} then table.insert(activePacks, "glowing3Darmors") end
    if ${freshFlowersPlants} then table.insert(activePacks, "freshFlowersPlants") end
    if ${freshFoods} then table.insert(activePacks, "freshFoods") end
    if ${freshPaintings} then table.insert(activePacks, "freshPaintings") end
    if ${freshOresIngots} then table.insert(activePacks, "freshOresIngots") end
    if ${freshSeeds} then table.insert(activePacks, "freshSeeds") end
    if ${bensBundle} then table.insert(activePacks, "bensBundle") end

local function compat(itemID)
    for _, pack in ipairs(activePacks) do
        if packCompatibility[pack] then
            for _, item in ipairs(packCompatibility[pack]) do
                if itemID:match(item) then return true end
            end
        end
    end
    return false
end

------ FUNÇÕES ------

local function verifyList(list, sufixes)
    for _, material in ipairs(list) do
        for _, sufix in ipairs(sufixes) do
            if I:isOf(item, Items:get("minecraft:" .. material .. sufix)) then
                return true
            end
        end
    end
    return false
end

local function verifyItems(sufixes)
    for _, sufix in ipairs(sufixes) do
        if itemName:match(sufix) then
            return true
        end
    end
    return false
end

local function isInList(list)
    for _, itemId in ipairs(list) do
        if itemName == itemId then return true end
    end
    return false
end

local function move(x, y, z)
    if not compat(itemName) then
        if x then M:moveX(matrices, x * l) end
        if y then M:moveY(matrices, y) end
        if z then M:moveZ(matrices, z) end
    end
end

local function rotate(rx, ry, rz)
    if not compat(itemName) then
        if rx then M:rotateX(matrices, rx) end
        if ry then M:rotateY(matrices, ry * l) end
        if rz then M:rotateZ(matrices, rz * l) end
    end
end

local function scale(sx, sy, sz)
    if not compat(itemName) then
        if sx or sy or sz then M:scale(matrices, sx, sy, sz) end
    end
end

local function skinModel(posAlex, posSteve)
    if AlexModel then return posAlex else return posSteve end
end

------ LISTAS DE ITENS ------

local itemLists = {
    hangingPlants = {"spore_blossom", "hanging_roots", "pale_hanging_moss", "weeping_vines"},
    woods = {
        "oak", "spruce", "birch", "jungle", "acacia", "dark_oak", 
        "mangrove", "cherry", "pale_oak", "bamboo", "crimson", "warped"
    },
    flowers = {
        "dandelion", "poppy", "blue_orchid", "allium", "azure_bluet",
        "oxeye_daisy", "cornflower", "lily_of_the_valley", "torchflower", "cactus_flower",
        "closed_eyeblossom", "open_eyeblossom", "wither_rose", 
        "sunflower", "lilac", "rose_bush", "peony", "pitcher_plant", "azalea",
        "flowering_azalea", "nether_wart"
    },
    foods = {
        "apple", "golden_apple", "enchanted_golden_apple", "chorus_fruit", "melon_slice",
        "carrot", "golden_carrot", "potato", "baked_potato", "poisonous_potato", "beetroot",
        "bread", "cookie", "pumpkin_pie", "beef", "porkchop", "chicken", "mutton", "rabbit", 
        "cod", "salmon", "tropical_fish", "pufferfish", "cooked_beef", "cooked_porkchop", "cooked_chicken", 
        "cooked_mutton", "cooked_rabbit", "cooked_cod", "cooked_salmon", "mushroom_stew", "rabbit_stew", 
        "beetroot_soup", "suspicious_stew", "rotten_flesh", "spider_eye", "dried_kelp", "honeycomb", "sweet_berries", "glow_berries", "bowl"
    },
    sprites2D = {
        -- Blocos Coloridos
        "candle",
        -- Blocos Naturais
        "small_amethyst_bud", "glow_lichen", "vine", "pitcher_pod", "lily_pad",
        "frogspawn", "sniffer_egg", "kelp", "seagrass", "twisting_vines",
        -- Blocos Funcionais
        "armor_stand", "glow_item_frame", "ender_eye", "fire_charge", "bone_meal", "name_tag", "lead",
        "cauldron", "ladder",
        -- Blocos de Redstone
        "redstone", "string", "comparator", "repeater", "tripwire_hook", "hopper", 
        -- Ferramentas
        "bundle", "compass", "recovery_compass", "map", "wind_charge", "ender_pearl",
        "elytra", "saddle", "goat_horn", "firework_rocket", "flint_and_steel", "brush", "clock",
        -- Combate
        "turtle_helmet", "wolf_armor", "totem_of_undying", "arrow", "spectral_arrow", "tipped_arrow",
        "snowball", "egg", "brown_egg", "blue_egg", "writable_book",
        -- Ingreditentes
        "coal", "charcoal", "raw_iron", "raw_copper", "raw_gold", "emerald", "lapis_lazuli", "diamond",
        "quartz", "amethyst_shard", "netherite_scrap", "flint", "wheat", "feather", "leather", "rabbit_hide", "resin_clump", "ink_sac",
        "glow_ink_sac", "turtle_scute", "armadillo_scute", "slime_ball", "clay_ball", "prismarine_shard", "prismarine_crystals",
        "nautilus_shell", "heart_of_the_sea", "nether_star", "shulker_shell", "popped_chorus_fruit", "echo_shard",
        "disc_fragment_5", "nether_brick", "resin_brick", "paper", "firework_star", "glowstone_dust", "book",
        "gunpowder", "fermented_spider_eye", "blaze_powder", "sugar", "glistering_melon_slice", "magma_cream", "ghast_tear",
        "phantom_membrane", "trial_key", "ominous_trial_key", "enchanted_book"   
    }
}

------ VERIFICAÇÃO DE TIPOS ------

local is2D = (
    verifyItems({
        "music_disc_", "_dye", "_banner_pattern", "_pottery_sherd", "_smithing_template", "_spawn_egg",
        "_bundle", "_harness", "_candle", "_nugget", "_ingot", "_helmet", "_chestplate", "_leggings", "_boots",
        "_horse_armor", "_seeds", "rail", "minecart", "nautilus_armor"
    }) or
    verifyList(itemLists.woods, {"_sign"}) or
    isInList(itemLists.sprites2D) or 
    isInList({"brick", "rabbit_foot", "iron_bars"})
)
local isException = (
    (
    verifyList(itemLists.foods, {""}) or
    verifyItems({
        "_door", "_hanging_sign", "_boat", "_raft", "^lantern$", "soul_lantern", "copper_lantern", "_golem_statue",
        "_pickaxe", "_shovel", "_hoe", "_axe", "_sword", "rail", "bucket", "_head", "_skull", "_dye",
        "_spear", "torch", "button", "chain"
    }) or
    isInList({
        "bamboo", "painting", "item_frame", "bell", "fishing_rod", "spyglass", 
        "carrot_on_a_stick", "warped_fungus_on_a_stick", "mace", "trident", "honey_bottle", "ominous_bottle",
        "potion", "splash_potion", "lingering_potion", "experience_bottle", "dragon_breath", "glass_bottle",
        "stick", "bone", "blaze_rod", "breeze_rod", "pink_petals", "wildflowers", "leaf_litter", "shears", "shield",
        "bow", "crossbow", "lever", "cocoa_beans", "sculk_vein"
    })
    )
)

------ AJUSTE GERAL PARA BLOCOS ------

if not isException then
    move(skinModel(0.17, 0.175), nil, 0.07)
    if not (
        is2D or
        verifyList(itemLists.flowers, {""}) or
        verifyItems({
            "_coral", "_sapling", "_fungus", "_roots", "_tulip", "_bush", "_grass", "fern", "_mushroom", "glass_pane",
            "_dripleaf"
        }) or
        isInList({
            "mangrove_propagule", "medium_amethyst_bud", "large_amethyst_bud", "amethyst_cluster", "pointed_dripstone", "nether_sprouts",
            "cobweb"
        })
    ) then
        if I:isBlock(item) and 
            not verifyItems({
                "_fence", "_wall", "_bed", "_banner$", "end_rod", "grindstone", "anvil", "brewing_stand", "conduit", "scaffolding", 
                "lightning_rod", "flower_pot", "decorated_pot", "_shelf", "dragon_egg", "heavy_core", "pressure_plate",
                "chorus_plant", "turtle_egg", "cocoa_beans", "sea_pickle", "copper_bars", "cake"
            }) 
        then
            move(skinModel(-0.103, -0.063), 0.085, 0.15)
            rotate(0, -69.7, -2.5)
            scale(0.9, 0.9, 0.9)
        else
            move(nil, 0.08, nil)
            rotate(4, -31, -5)
        end
    end
end

------ AJUSTES PARA SPRITES 2D ------

if is2D then
    move(skinModel(-0.14, -0.1), 0.04, -0.105)
    rotate(nil, 5, -8)
    -- Rotação
    if (
        isInList({
            "small_amethyst_bud", "pitcher_pod", "lily_pad", "glow_lichen"
        }) or
        itemName:match("_seeds")
    ) then
        rotate(nil, -33, -1.9)
    end
end

------ AJUSTES DE BLOCOS EM 90 OU 180 GRAUS ------

-- 90
if isInList({
    "piston", "sticky_piston", "barrel"
}) then
    move(-0.03, 0.38, -0.05)
    M:rotateX(matrices, 90)
end

-- 180
if (
    isInList({
        "lectern", "chiseled_bookshelf", "crafter", "furnace", "dispenser", "dropper", "loom", "smoker", "blast_furnace"
    }) or 
    itemName:match("_shelf")
) then
    move(-0.3, nil, 0.3)
    M:rotateY(matrices, 180 * l)
    if itemName:match("_shelf") then move(skinModel(0.02, 0), nil, skinModel(-0.07, -0.13)) end
end

------ AJUSTES POR CATEGORIA ------

-- Blocos de Construção

-- Cercas
if itemName:match("_fence") then move(skinModel(-0.02, 0), nil, 0.05) end
-- Muros
if itemName:match("_wall") then move(skinModel(-0.02, 0), nil, 0.05) end
-- Botoes
if itemName:match("_button") then move(skinModel(0.215, 0.245), 0.035, 0.07) rotate(8.2, -31, -5) scale(1.3, 1.3, 1.3) end
-- Portoes
if itemName:match("_fence_gate") then move(skinModel(-0.02, 0), -0.1, -0.03) end
-- Barras
if itemName:match("_bars") then move(skinModel(-0.02, 0.01), nil, 0.04) end
if itemName == "iron_bars" then move(nil, nil, -0.05) end
-- Correntes
if itemName:match("_chain") then move(skinModel(0.08, 0.1), 0.026, nil) rotate(0.4, nil, -14.7) end
if itemName:match("^waxed") and itemName:match("_copper_chain") then move(skinModel(-0.03, -0.02), nil, 0.049) end

-- Blocos Coloridos

-- Paineis de Vidro
if itemName:match("glass_pane") then move(skinModel(-0.1, -0.07), 0.1, -0.12) rotate(nil, nil, -6) end
-- Banners
if itemName:match("_banner$") then move(skinModel(-0.14, -0.13), 0.13, 0.17) rotate(nil, -90, nil) end
-- Velas
if itemName:match("candle") then move(l == 1 and 0.02 or skinModel(0.05, 0.05), 0.03, -0.03) end
-- Camas
if itemName:match("_bed") then move(-0.2, nil, 0.3) end

-- Blocos Naturais

-- Mudas, Corais, Fungos, Raizes, Cogumelos, Flores, Matos, Espeleotema e Teia de Aranha
if (
    verifyItems({"_coral", "_sapling", "_fungus", "_roots", "_tulip", "_bush", "_grass", "fern", "_mushroom"}) or
    verifyList(itemLists.flowers, {""}) or
    isInList({"mangrove_propagule", "medium_amethyst_bud", "large_amethyst_bud", "amethyst_cluster", "pointed_dripstone", "nether_sprouts", "cobweb"})
) then 
    move(skinModel(-0.05, -0.047), 0.06, skinModel(-0.1, -0.08))
    rotate(4, nil, -5)
end
-- Arbusto e Samambaia
if itemName == "bush" then move(0.045, nil, skinModel(0.02, 0.05)) end
if itemName == "fern" then move(skinModel(0.01, 0), nil, nil) end
-- Plantaformas
if itemName == "small_dripleaf" then move(skinModel(-0.052, -0.03), nil, -0.083) end
if itemName == "big_dripleaf" then move(skinModel(-0.058, -0.027), nil, -0.163) end
-- Plantas de pendurar
if verifyList(itemLists.hangingPlants, {""}) then move(nil, -0.53, nil) rotate(4, nil, -5) end
if itemName == "spore_blossom" then move(-0.07, nil, nil) end
-- Cana de Açúcar
if itemName == "sugar_cane" then move(l == 1 and 0.022 or 0.036, nil, skinModel(0, 0.016)) rotate(nil, nil, -7) end
-- Ovos de Sapo
if itemName == "frogspawn" then move(skinModel(0, 0.04), 0.03, -0.03) end
-- Plantocha
if itemName == "torchflower" then move(skinModel(0.056, 0.048), 0.061, skinModel(0.07, 0.12)) end
-- Girassol
if itemName == "sunflower" then move(l == 1 and -0.1 or -0.07, nil, l == 1 and skinModel(0.32, 0.35) or skinModel(-0.07, -0.06)) 
    rotate(nil, l == 1 and -120 or 30, nil) end
-- Azalea e Azalea Florescente
if itemName == "azalea" or itemName == "flowering_azalea" then move(skinModel(0.01, 0), nil, skinModel(-0.01, 0.02)) end
-- Planta do Coro
if itemName == "chorus_plant" then move(l == 1 and skinModel(0.02, 0.043) or skinModel(-0.01, 0.03), -0.1, nil) end
-- Pepino-do-Mar
if itemName == "sea_pickle" then move(skinModel(0.07, 0.09), -0.07, -0.03) rotate(nil, 0.5, nil) scale(1.5, 1.5, 1.5) end
-- Trepadeiras Choronas
if itemName == "weeping_vines" then move(skinModel(-0.02, 0), skinModel(-0.3, -0.2), skinModel(-0.1, 0)) end
-- Ghast Seco
if itemName == "dried_ghast" then move(-0.3, nil, 0.3) rotate(nil, 180, nil) end
-- Vagem de Planta Ancestral
if itemName == "pitcher_pod" then move(l == 1 and -0.05 or skinModel(0.08, 0.15), 0.104, skinModel(0.07, 0.07)) end
-- Fungo do Nether
if itemName == "nether_wart" then move(l == 1 and 0.04 or skinModel(0.03, 0.02), skinModel(0.03, 0.04), 0.12) rotate(4, -31, nil) end
-- Vitoria-Regia
if itemName == "lily_pad" then move(nil, 0.2, nil) rotate(101.5, nil, -6) end
-- Bambu
if itemName == "bamboo" then move(skinModel(0.02, 0.04), nil, skinModel(0.02, 0)) end
-- Trepadeira, Líquen Brilhante e Veio de Sculk
if itemName == "vine" then move(skinModel(-0.12, -0.15), -0.3, nil) rotate(10, 90, nil) end
if itemName == "glow_lichen" then move(skinModel(-0.15, -0.17), -0.2, nil) rotate(10, 90, nil) end
if itemName == "sculk_vein" then move(-0.16, -0.119, nil) rotate(11.6, 58.8, -8.5) end
-- Alga
if itemName == "kelp" then move(l == 1 and 0.17 or -0.1, -0.03, -0.04) end
-- Erva Marinha
if itemName == "seagrass" then move(skinModel(0.04, 0.06), skinModel(0.06, 0.04), -0.035) end
-- Trepadeiras Retorcidas
if itemName == "twisting_vines" then move(l == 1 and skinModel(0.095, 0.128) or skinModel(-0.01, 0.02), skinModel(0.06, 0.02), -0.03) end
-- Cristal de Ametista Pequeno
if itemName == "small_amethyst_bud" then move(nil, 0.105, 0.09) end
-- Ovo de Tartaruga
if itemName == "turtle_egg" then move(skinModel(0.02, 0.046), -0.08, -0.06) scale(1.3, 1.3, 1.3) end
-- Ovo de Farejador
if itemName == "sniffer_egg" then move(l == 1 and -0.02 or skinModel(0.11, 0.1), 0.03, -0.03) end
-- Sementes
if itemName:match("_seeds") then move(l == 1 and -0.03 or 0.02, 0.08, skinModel(0.07, 0.1)) end
if itemName == "beetroot_seeds" then move(skinModel(0.04, 0.02), 0.03, -0.02) rotate(nil, -5, nil) end
if itemName == "torchflower_seeds" then move(l == 1 and skinModel(0.2, 0.18) or skinModel(0.22, 0.2), 0.03, -0.049) rotate(5, nil, 0.9) end
if itemName == "cocoa_beans" then move(skinModel(0.18, 0.2), -0.186, 0.145) rotate(8.8, -30, -3.4) scale(1.5, 1.5, 1.5) end

-- Blocos Funcionais

-- Tochas
if isInList({"torch", "soul_torch", "redstone_torch", "copper_torch"}) then move(skinModel(-0.01, 0.02), 0.04, 0.02) rotate(7.5, nil, -5) scale(1.2, 1.2, 1.2) end
-- Bigornas
if itemName:match("anvil") then move(skinModel(-0.31, -0.28), nil, nil) rotate(nil, 90, nil) end
-- Para-raios
if itemName:match("lightning_rod") then move(skinModel(-0.02, -0.01), nil, skinModel(0.02, 0.05)) end
-- Golens de Cobre
if itemName:match("golem_statue") then move(-0.04, nil, -0.05) end
-- Placas
if itemName:match("_sign") and not itemName:match("hanging_sign") then move(l == 1 and 0.02 or 0.05, nil, nil) end
-- Vara do End
if itemName == "end_rod" then move(skinModel(0.01, 0.02), nil, skinModel(0.02, 0.05)) scale(1.3, 1.3, 1.3) end
-- Rebolo
if itemName == "grindstone" then move(skinModel(0, 0.035), 0.33, -0.08) rotate(90, nil, nil) end
-- Cristal do End
if itemName == "end_crystal" then move(-0.15, -0.1, 0.15) end
-- Conduto
if itemName == "conduit" then move(skinModel(-0.05, -0.06), skinModel(-0.07, -0.04), skinModel(0.08, 0.16)) end
-- Andaime
if itemName == "scaffolding" then move(skinModel(0, 0.01), -0.27, nil) rotate(nil, nil, skinModel(0, -3.5)) end
-- Vaso
if itemName == "flower_pot" then move(skinModel(-0.02, 0), nil, 0.05) end
-- Ovo do Dragao
if itemName == "dragon_egg" then move(skinModel(0, 0.03), -0.04, nil) end
-- Olho de Ender e Perola de Ender
if itemName == "ender_eye" or itemName == "ender_pearl" then move(l == 1 and 0.02 or 0.05, -0.02, -0.05) end
-- Escada de Mao
if itemName == "ladder" then move(skinModel(0.05, 0.03), 0.03, -0.03) end
-- Moldura Brilhante
if itemName == "glow_item_frame" then move(l == 1 and 0.02 or 0.04, nil, -0.03) end
-- Suporte de Armaduras
if itemName == "armor_stand" then move(l == 1 and 0.05 or skinModel(0.02, 0.055), 0.03, -0.07) end
-- Caldeirao
if itemName == "cauldron" then move(l == 1 and skinModel(0.06, 0.05) or 0.02, nil, -0.03) end

-- Blocos de Redstone

-- Carrinhos
if itemName:match("minecart") then move(l == 1 and skinModel(0.06, 0) or skinModel(0.025, 0), nil, skinModel(-0.06, -0.05)) end
-- Trilhos
if itemName:match("rail") then move(skinModel(0.2, 0.2), nil, 0.06) end
-- Redstone
if itemName == "redstone" then move(skinModel(0.03, 0.02), nil, nil) end
-- Funil e Gancho de Armadilha
if itemName == "hopper" or itemName == "tripwire_hook" then move(0.04, nil, -0.03) end
-- Alavanca
if itemName == "lever" then move(-0.42, 0.045, -0.125) rotate(9.5, 101, nil) scale(2.2, 2.2, 2.2) end
-- Linha
if itemName == "string" then move(l == 1 and 0 or skinModel(0.09, 0.07), nil, -0.03) end

-- Ferramentas

-- Barcos
if verifyItems({"_boat", "_raft"}) then move(0.1, 0.08, -0.05) end
-- Picaretas, Machados, Pas e Enxadas
if verifyItems({"pickaxe", "shovel", "hoe", "axe"}) then move(skinModel(0.02, 0.04), nil, -0.05) end
if itemName:match("shovel") then move(-0.05, -0.105, skinModel(0.072, 0.08)) rotate(nil, 5, nil) end
-- Trouxas
if itemName:match("bundle") then move(l == 1 and skinModel(0.01, -0.01) or (skinModel(0.04, 0.02)), nil, -0.02) end
-- Baldes
if not isItemUsing then
    if itemName:match("bucket") then move(nil, -0.2, nil) end
end
-- Discos
if itemName:match("music_disc") then move(l == 1 and 0.05 or skinModel(0.02, 0), -0.08, -0.05) end
-- Disco 11
if itemName == "music_disc_11" then move(nil, 0.04, nil) end
-- Vara de Pesca
if itemName == "fishing_rod" then move(skinModel(0.01, 0.03), 0.03, nil) rotate(nil, nil, -5.5) end
-- Varas com Cenoura
if itemName == "carrot_on_a_stick" then move(skinModel(0.06, 0.1), skinModel(0.06, 0.02), nil) rotate(nil, 4, -10.8) end
-- Varas com Fungo Distorcido
if itemName == "warped_fungus_on_a_stick" then move(skinModel(0.122, 0.16), 0.02, 0.04) rotate(nil, 2.2, -5.5) end
-- Pederneira
if itemName == "flint_and_steel" then move(l == 1 and -0.1 or 0.07, l == 1 and 0 or 0.03, l == 1 and -0.07 or -0.03) rotate(nil, -10, 8) end
-- Tesoura
if itemName == "shears" then move(skinModel(0.16 * l, 0.2 * l), -0.05, l == 1 and -0.07 or 0.05) end
-- Pincel
if itemName == "brush" then move (skinModel(-0.01, -0.02), nil, skinModel(-0.02, 0.03)) rotate(nil, -10, 8) end
-- Relogio
if itemName == "clock" then move(skinModel(0.03, 0.02), nil, -0.02) end
-- Bola de Fogo
if itemName == "fire_charge" then move(skinModel(-0.02, -0.03), nil, 0.03) end
-- Bussola da Retomada
if itemName == "recovery_compass" then move(skinModel(0.04, 0.03), nil, -0.05) end
-- Bussola
if itemName == "compass" then move(skinModel(0.01, -0.01), nil, nil) end
-- Livro e Pena
if itemName == "writable_book" then move(-0.03, nil, -0.05) end
-- Fogo de Artificio
if itemName == "firework_rocket" then move(-0.05 * l, nil, -0.03) end
-- Farinha de Osso e Etiqueta
if itemName == "bone_meal" or itemName == "name_tag" then move(l == 1 and 0 or 0.05, nil, -0.06) end
-- Laço
if itemName == "lead" then move(l == 1 and 0 or skinModel(0.05, 0), nil, -0.06) end
-- Relógio
if itemName == "clock" then move(0.01, 0.03, -0.03) end
-- Luneta
if itemName == "spyglass" then rotate(nil, nil, -10) end
-- Projétil de Vento
if itemName == "wind_charge" then move(l == 1 and skinModel(0.055, 0.04) or skinModel(0.02, 0), -0.08, -0.04) end
-- Sela, Arreios
if itemName == "saddle" or itemName == "goat_horn" or itemName:match("_harness") then move(nil, nil, -0.06) end

-- Combate

-- Espadas e Maca
if itemName:match("_sword") or itemName == "mace" then move(skinModel(0.03, 0.04), nil, -0.02) end
-- Lanças
if itemName:match("_spear") then move(0.01, nil, 0.02) end
-- Tridente
if not isItemUsing then
    if itemName == "trident" then move(skinModel(-0.09, -0.04), nil, 0.07) end
end
-- Escudo
if itemName == "shield" then rotate(nil, nil, -8) end
-- Armaduras
if verifyItems({"helmet", "chestplate", "leggings", "boots"}) then move(skinModel(0, -0.01), 0.04, nil) end
if itemName:match("helmet") then move(0.04, -0.14, -0.05) end
if itemName:match("leggings") then move(0.05, -0.078, -0.06) end
if itemName:match("boots") then move(0.04, -0.11, -0.06) end
-- Armaduras de Cavalo
if itemName:match("_horse_armor") then move(l == 1 and 0.03 or -0.05, nil, nil) end
-- Armaduras de Lobo
if itemName == "wolf_armor" then move(l == 1 and 0 or skinModel(0.06, 0.05), -0.12, -0.06) end
-- Armaduras de Náutilus
if itemName:match("_nautilus_armor") then move(l == 1 and 0 or 0.06, nil, -0.05) end
-- Bola de Neve, Ovos e Projetil de Vento
if itemName == "egg" or itemName == "snowball" or isInList({"blue_egg", "brown_egg"}) then move(skinModel(0.03, 0.01), -0.04, skinModel(-0.03, -0.02)) end
-- Totem da Imortalidade
if itemName == "totem_of_undying" then move(skinModel(0.04, 0.03), nil, -0.05) end
-- Flechas
if itemName == "arrow" or itemName == "spectral_arrow" or itemName == "tipped_arrow" then move(nil, nil, -0.02) end

-- Alimentos e Poções

if not isItemUsing then
    -- Geral
    if verifyList(itemLists.foods, {""}) then move(skinModel(0.06, 0.09), 0.05, -0.07) rotate(nil, 5, -8) end
    -- Bifes e Costeletas de Porco
    if itemName:match("beef") or itemName:match("porckchop") then move(0.03, nil, nil) end
    if itemName:match("beef") then move(l == 1 and 0 or -0.08, nil, nil) end
    -- Cenouras
    if itemName:match("carrot") then move(nil, -0.04, nil) end
    -- Carneiro
    if itemName:match("mutton") then move(l == 1 and 0.08 or -0.05, 0.02, -0.02) end
    -- Coelho
    if itemName:match("rabbit$") then move(l == 1 and -0.03 or 0.05, -0.08, -0.03) end
    -- Sopas
    if itemName:match("stew") or itemName:match("soup") or itemName == "bowl" then move(skinModel(0.01, 0.02), -0.08, -0.02) end
    if itemName == "rabbit_stew" then move(nil, 0.03, nil) end
    -- Fatia de Melancia
    if itemName == "melon_slice" then move(l == 1 and 0.07 or -0.07, nil, nil) end
    -- Bagas Doces
    if itemName == "sweet_berries" then move(nil, nil, 0.07) end
    -- Fruta do Coro
    if itemName == "chorus_fruit" then move(l == 1 and -0.03 or 0.04, nil, nil) end
    -- Batata e Batata Envenenada
    if itemName == "potato" or itemName == "poisonous_potato" then move(l == 1 and 0.06 or -0.05, -0.03, 0.01) end
    -- Beterraba
    if itemName == "beetroot" then move(l == 1 and 0 or -0.08, nil, 0.05) end
    -- Algas Secas
    if itemName == "dried_kelp" then move(nil, nil, -0.02) end
    -- Biscoito
    if itemName == "cookie" then move(skinModel(0.015, 0.02), -0.05, -0.03) end
    -- Olho de Aranha
    if itemName == "spider_eye" then move(l == 1 and -0.04 or 0.05, nil, nil) end
    -- Baiacu
    if itemName == "pufferfish" then move(skinModel(-0.02, -0.03), nil, nil) end
    -- Pão
    if itemName == "bread" and AlexModel then move(nil, nil, -0.01) end
    -- Poções, Bebidas e Frascos
    if verifyItems({
        "honey_bottle", "ominous_bottle","potion", "experience_bottle", "dragon_breath", "glass_bottle",
        "splash_potion", "lingering_potion"
    }) then move(l == 1 and skinModel(0.05, 0.08) or skinModel(0.08, 0.1), skinModel(0.03, 0.05), skinModel(-0.09, -0.07)) rotate(nil, 5, -8) end
    if itemName == "ominous_bottle" then move(l == 1 and skinModel(0.02, 0.01) or skinModel(-0.02, -0.01), nil, nil) end
    if itemName == "splash_potion" or itemName == "lingering_potion" then move(nil, -0.02, nil) end
end

-- Ingredientes

if isInList({
    "emerald", "lapis_lazuli", "nether_brick"
}) or verifyItems({
    "_ingot", "^brick$", "resin_brick"
}) then
    move(nil, -0.03, -0.05)
end

-- Mover para trás
if (
    itemName:match("raw") or 
    itemName:match("coal") or 
    itemName:match("_banner_pattern") or
    itemName:match("_pottery_sherd") or
    itemName:match("_smithing_template") or
    itemName:match("_key") or
    isInList({
        "quartz", "amethyst_shard", "netherite_scrap", "diamond", "flint", "wheat", "feather",
        "leather", "rabbit_hide", "prismarine_shard", "heart_of_the_sea", "nether_star",
        "shulker_shell", "echo_shard", "book", "fermented_spider_eye", "blaze_powder",
        "glistering_melon_slice", "phantom_membrane", "enchanted_book", "copper_nugget",
        "stick"
})) then move(skinModel(0.01, 0), nil, -0.06) end

-- Mover para a direita
if (
    itemName:match("_banner_pattern") or
    itemName:match("_pottery_sherd") or
    itemName:match("_smithing_template") or
    isInList({
        "diamond", "quartz", "amethyst_shard", "flint", "wheat", "feather", "stick", "bone",
        "leather", "rabbit_hide", "heart_of_the_sea", "blaze_rod", "breeze_rod", "book",
        "phantom_membrane", "enchanted_book", "emerald", "copper_nugget"
})) then move(0.03, nil, nil) end

-- Mover para baixo
if isInList({
    "turtle_scute", "armadillo_scute", "disc_fragment_5", "ghast_tear", "copper_nugget",
    "iron_nugget", "gold_nugget"
}) then move(nil, -0.07, nil) end

-- Mover para a esquerda na mão secundária
if (
    itemName:match("coal") or
    itemName:match("raw") or
    isInList({
        "netherite_scrap", "resin_clump", "prismarine_shard", "nether_star", "shulker_shell", "echo_shard",
        "fermented_spider_eye", "blaze_powder", "glistering_melon_slice", "trial_key", "ominous_trial_key"
    })
) then move(l == 1 and 0 or 0.05, nil, nil) end

-- Corantes
if itemName:match("_dye") then move(skinModel(0.2, 0.2), 0.06, 0.03) end
-- Esmeralda
if itemName == "emerald" and AlexModel then move(0.01, nil, nil) end
-- Escama de Tartaruga
if itemName == "turtle_scute" then move(-0.02, nil, nil) end
-- Resina
if itemName == "resin_clump" then move(nil, nil, -0.03) end
-- Bolsas de Tinta
if itemName == "ink_sac" or itemName == "glow_ink_sac" then move(0.03, -0.06, -0.05) end
-- Slime
if itemName == "slime_ball" then move(0.03, -0.03, -0.05) end
-- Pedaço de Prismarinho e Estrela do Nether
if itemName == "prismarine_shard" or itemName == "nether_star" then move(0.01, nil, nil) end
-- Cristais de Prismarinho
if itemName == "prismarine_crystals" then move(nil, -0.04, -0.05) end
-- Concha de Náutilo
if itemName == "nautilus_shell" then move(l == 1 and 0.085 or -0.02, nil, -0.06) end
-- Núcleo Pesado
if itemName == "heavy_core" then move(skinModel(-0.02, 0), nil, 0.06) end
-- Pepitas
if itemName == "copper_nugget" and AlexModel then move(l == 1 and 0.06 or 0.02, nil, -0.04) end
if itemName == "iron_nugget" then move(nil, nil, -0.02) end
if itemName == "gold_nugget" then move(0.03, 0.01, -0.05) end
-- Frasco de Experiência
if itemName == "experience_bottle" then move(nil, nil, -0.02) end
-- Osso
if itemName == "bone" then move(nil, -0.35, nil) end
-- Bola de Slime
if itemName == "slime_ball" and AlexModel then move(0.01, nil, nil) end
-- Varas de Blaze e Breeze
if (itemName == "blaze_rod" or itemName == "breeze_rod") and AlexModel then move(-0.03, nil, nil) end
-- Fatia de Melancia Reluzente
if itemName == "glistering_melon_slice" then move(skinModel(-0.03, -0.05), nil, nil) end

-- Ovos Geradores

local adjust = {
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
}
for _, egg in ipairs(adjust) do
    if itemName == egg .. "_spawn_egg" then move(skinModel(0.065, 0.04), nil, -0.06) end
end

if itemName:match("_spawn_egg") and not isInList(adjust) then move(-0.02, nil, nil) end