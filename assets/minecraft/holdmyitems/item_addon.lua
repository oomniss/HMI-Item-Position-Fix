-- by omnis._.

local mat         = context.matrices
local l           = context.mainHand and 1 or -1
local d           = (context.bl and 1) or -0.43
local itemName    = I:getName(context.item):gsub("minecraft:", "")
local isUsingItem = P:isUsingItem(context.player)
local useAction   = I:getUseAction(context.item)

-- === FUNCTIONS ===
local function getTag()
    for _, tag in ipairs(ItemsTag.default) do
        if I:isIn(context.item, Tags:getVanillaTag(tag)) or I:isIn(context.item, Tags:getFabricTag(tag)) then
            return tag
        end
    end
    for tag, entry in pairs(ItemsTag.registry) do
        for _, i in ipairs(entry) do
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

local function posInHands(mainHand, offhand)
    return context.mainHand and mainHand or offhand
end

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

-- === POSITIONS ===
if classicToolsFusion then
    positioning({
        wooden_sword    = { m = {nil, -0.035, nil} },
        stone_sword     = { m = {nil, 0.025, nil} },
        copper_sword    = { m = {nil, -0.115, nil} },
        swords          = { m = {nil, -0.05, nil} },
        wooden_spear    = { m = {nil, nil, 0.04} },
        stone_spear     = { m = {nil, nil, 0.04} },
        wooden_axe      = { m = {nil, 0.055, 0.02} },
        stone_axe       = { m = {nil, 0.055, 0.02} },
        copper_axe      = { m = {nil, 0.04, 0.03} },
        netherite_axe   = { m = {nil, 0.04, 0.03} },
        wooden_shovel   = { m = {nil, 0.135, 0.025}, s = {0.9} },
        stone_shovel    = { m = {nil, 0.135, 0.025}, s = {0.9} },
        shovels         = { m = {0.005, 0.06, 0.025} },
        wooden_pickaxe  = { m = {nil, 0.045, 0.045} },
        stone_pickaxe   = { m = {nil, 0.025, 0.045} },
        pickaxes        = { m = {nil, nil, 0.03} },
        wooden_hoe      = { m = {nil, nil, 0.05} },
        stone_hoe       = { m = {nil, nil, 0.05} },
        copper_hoe      = { m = {nil, nil, 0.045} }
    })
end

if rvTorches then
    positioning({
        repeater    = { m = {-0.045, -0.02, -0.035}, r = {-6, -16, 2.5}, renderAsBlock = false },
        comparator  = { m = {-0.045, -0.02, -0.035}, r = {-6, -16, 2.5}, renderAsBlock = false },
        torches     = { m = {0.01, -0.075, -0.035}, r = {-5, -5.5, nil} },
        lanterns    = { m = {0.005, -0.545, 0.225}, r = {-25, 21.5, nil} },
        campfires   = { m = {-0.08, 0.185, 0.255}, r = {8, -9.5, -2.5} },
        candles     = { m = {-0.05, nil, nil}, r = {-8, -10, 6}, renderAsBlock = false }
    })
end

if refinedTorches then
    positioning({
        torches   = { m = {0.035, -0.05, -0.04}, r = {-5, -4.5, nil} },
        lanterns  = { m = {-0.04, -0.44, 0.3}, r = {-38, 9, nil} },
        candles   = { m = {-0.025, 0.01, -0.01}, r = {nil, -9.5, nil}, renderAsBlock = false }
    })
end

if glowing3Dtotem then
    positioning({
        totem_of_undying = { m = {-0.015, 0.115, -0.14}, r = {-3, 50, -8.5}, s = {0.85} }
    })
end

if glowing3Darmors then
    positioning({
        horse_armors    = { m = {-0.075, -0.025, -0.015}, r = {-6.5, 84.5, -1} },
        head_armor      = { m = {-0.125, -0.165, -0.115}, r = {-4, 84.5, nil}, s = {1.3} },
        chest_armor     = { m = {nil, -0.365, 0.065}, r = {58, 180, -15}, s = {1.6} },
        leg_armor       = { m = {-0.1, -0.655, 0.18}, r = {-45-5, 90, 16.5}, s = {1.15} },
        foot_armor      = { m = {-0.085, -0.015, -0.035}, r = {-1.5, 82, nil}, s = {1.2} },
        elytra          = { m = {-0.005, -0.22, nil}, r = {-80, -9.5, 4.5} }
    })
end

if just3Darmors then
    positioning({
        horse_armors    = { m = {-0.035, -0.03, -0.045}, r = {-8, 3.5, -5.5} },
        nautilus_armors = { m = {0.03, 0.015, -0.105}, r = {-4.5, 20, nil} },
        turtle_helmet   = { m = {0.02, 0.01, 0.035}, r = {2.5, -4.5, -4} },
        head_armor      = { m = {0.005, nil, nil}, r = {8, nil, -1.5} },
        leg_armor       = { m = {0.04, nil, nil} },
        wolf_armor      = { m = {0.055, -0.125, -0.14}, r = {6.5, -15.5, 2} }
    })
end

if bensBundle then
    positioning({
        bundles = { m = {-0.04, 0.095, -0.035}, r = {-0.5, 23, -4} }
    })
end

if freshDiscs then
    positioning({
        music_discs       = { m = {0.015, -0.015, -0.08}, r = {-5.5, -5.5, -0.5} },
        disc_fragment_5   = { m = {-0.015, nil, -0.055} }
    })
end

if w3Dfoods then
    if isInList(PackCompat.w3Dfoods) then
        transform(rotate, {-5.5, -5, -1})
    end
    positioning({
        apples        = { m = {0.015, -0.005, -0.06} },
        beetroot      = { m = {0.015, -0.005, -0.06} },
        potatoes      = { m = {0.02, nil, -0.045} },
        beefs         = { m = {0.02, nil, -0.045} },
        bread         = { m = {0.02, nil, -0.045} },
        carrots       = { m = {-0.075, -0.075, -0.085} },
        muttons       = { m = {0.055, nil, -0.04} },
        bowl_foods    = { m = {0.01, 0.105, 0.12}, r = {-68, nil, nil}, s = {1.05} },
        chorus_fruit  = { m = {0.025, -0.005, -0.06} },
        melon_slice   = { m = {0.02, -0.045, -0.08} },
        sweet_berries = { m = {0.02, 0.06, -0.07} },
        glow_berries  = { m = {0.035, 0.01, -0.07} },
        dried_kelp    = { m = {-0.005, -0.005, nil} },
        chickens      = { m = {0.015, nil, -0.08} },
        rabbits       = { m = {0.02, nil, -0.04} },
        cod           = { m = {-0.03, nil, -0.06} },
        cooked_cod    = { m = {-0.03, nil, -0.06} },
        salmon        = { m = {nil, nil, -0.06} },
        cooked_salmon = { m = {nil, nil, -0.06} },
        tropical_fish = { m = {0.01, nil, -0.1} },
        pufferfish    = { m = {-0.005, nil, -0.01} },
        cake          = { m = {0.09, nil, nil} },
        pumpkin_pie   = { m = {0.03, -0.01, 0.055}, r = {nil, 40, nil} },
        spider_eye    = { m = {0.035, -0.01, -0.04} },
        cookie        = { m = {0.01, nil, nil} }
    })
end

if freshFoods then
    if tag == "pressure_plates" then -- fresh foods changes the position of all items whose ID contains "plate", so this correction is necessary
        transform(move, {0.125, -0.02, 0.345})
        transform(rotate, {-119.5, -4.5, -7.5})
    end
    if not (isUsingItem and useAction == "eat") then
        positioning({
            bowl_foods                = { m = {0.07, -0.025, -0.03}, r = {1.5, -4.5, -1} },
            beefs                     = { m = {0.06, 0.005, -0.13}, r = {-1.5, -5.5, -1} },
            muttons                   = { m = {0.025, 0.005, -0.13}, r = {-1.5, -5.5, -1}, s = {1.15} },
            apples                    = { m = {0.075, 0.015, -0.07}, r = {2, -0.5, nil} },
            melon_slice               = { m = {0.03, nil, -0.055}, r = {2, -0.5, nil} },
            glistering_melon_slice    = { m = {0.03, nil, -0.055}, r = {2, -0.5, nil} },
            potatoes                  = { m = {0.025, -0.01, -0.105}, r = {-5, -5, nil}, s = {1.15} },
            spider_eye                = { m = {-0.01, -0.13, -0.19}, r = {-5.5, 1.5, 34.5} },
            carrots                   = { m = {-0.04, -0.035, -0.05}, r = {nil, -5, 3} },
            sweet_berries             = { m = {-0.035, nil, -0.055}, r = {nil, -4, nil} },
            glow_berries              = { m = {0.015, -0.055, -0.095} },
            chorus_fruit              = { m = {0.1, -0.055, -0.085}, r = {nil, -5.5, nil} },
            beetroot                  = { m = {-0.01, -0.12, -0.165}, r = {1.5, -5.5, nil} },
            dried_kelp                = { m = {0.035, -0.025, -0.09}, r = {nil, 7.5, -1.5} },
            chickens                  = { m = {0.065, -0.04, -0.15} },
            rabbit                    = { m = {0.1, -0.045, -0.095}, r = {nil, -6, nil} },
            cooked_rabbit             = { m = {-0.025, -0.11, -0.055}, r = {-0.5, -7.5, nil} },
            cod                       = { m = {0.065, -0.04, -0.09}, r = {1.5, -5, -1.5} },
            cooked_cod                = { m = {0.065, -0.04, -0.09}, r = {1.5, -5, -1.5} },
            tropical_fish             = { m = {0.065, -0.04, -0.09}, r = {1.5, -5, -1.5} },
            salmon                    = { m = {-0.005, -0.04, -0.13}, r = {1.5, -5, -1.5} },
            cooked_salmon             = { m = {-0.005, -0.04, -0.13}, r = {1.5, -5, -1.5} },
            pufferfish                = { m = {0.075, 0.005, -0.065}, r = {15, 7.5, 9} },
            bread                     = { m = {0.07, -0.04, -0.085}, r = {1, nil, nil} },
            cookie                    = { m = {0.07, 0.005, -0.075} },
            cake                      = { m = {0.115, -0.04, nil}, r = {-6, -5, nil} },
            pumpkin_pie               = { m = {0.06, 0.02, -0.175}, r = {4.5, 3, 5.5} },
            rotten_flesh              = { m = {0.085, -0.19, -0.035}, r = {-40.5, nil, 3.5}, s = {1.15}  }
        })
    end
end

if freshSeeds then
    positioning({
        seeds = { m = {0.045, -0.115, -0.055}, r = {-8.5, 25, 5}, s = {1.05} }
    })
end

if freshOres then
    positioning({
        coals               = { m = {posInHands(0.065, 0.005), posInHands(-0.005, 0.04), posInHands(-0.13, -0.145)} },
        raw_gold            = { m = {posInHands(0, 0.015), -0.1, -0.14} },
        raw_materials       = { m = {posInHands(0, 0.015), posInHands(-0.07, -0.03), -0.14} },
        nuggets             = { m = {0.07, -0.085, -0.095}, r = {-5.5, -5.5, nil} },
        ingots              = { m = {0.025, -0.05, -0.155}, r = {-6.5, 5, nil}, s = {1.2} },
        bricks              = { m = {0.025, -0.05, -0.155}, r = {-6.5, 5, nil}, s = {1.2} },
        amethyst_cristals   = { m = {0.025, -0.06, -0.055}, r = {-5, -6, nil} },
        diamond             = { m = {0.03, 0.01, -0.165}, r = {11.5, 13, -3} },
        emerald             = { m = {0.025, -0.03, -0.23}, r = {12.5, 13, -2} },
        lapis_lazuli        = { m = {0.005, -0.14, -0.225}, r = {nil, -4.5, nil}, s = {1.1} },
        quartz              = { m = {0.025, -0.07, -0.11}, r = {-6, -5.5, nil}, s = {1.2} },
        shards              = { m = {posInHands(-0.055, 0), -0.15, -0.03}, r = {7, -5, nil} },
        netherite_scrap     = { m = {0.05, -0.09, -0.17}, r = {-5.5, -1, -16.5}, s = {1.3} },
        flint               = { m = {posInHands(0.035, -0.035), posInHands(0.07, 0.06), posInHands(-0.115, -0.125)}, r = {15, 12.5, -8}, s = {1.15} },
        resin_clump         = { m = {nil, 0.01, -0.12}, s = {1.2} },
        redstone            = { m = {0.08, -0.135, -0.175}, r = {-17, nil, nil}, s = {1.15} },
        pointed_dripstone   = { m = {0.125, -0.05, -0.075}, r = {-4.5, -4.5, -1.5} }
    })
end

if freshFlowers then
    local plantsWithBlocks = {"saplings", "small_plants", "fern", "large_fern", "bushes"}

    if isInList(plantsWithBlocks) then
        transform(move, {0.055, -0.075, -0.09})
        transform(rotate, {10.5, -6, -2.5})
    elseif itemName:match("^dead.*fan$") then
        transform(move, {nil, -0.06, -0.165})
        transform(rotate, {16, 36.5, -17})
    elseif itemName:match("^dead.*coral$") then
        transform(move, {0.055, -0.075, -0.09})
        transform(rotate, {10.5, -6, -2.5})
    else
        positioning({
            corals          = { m = {0.155, -0.06, -0.055}, r = {-6, -5, nil} },
            mushrooms       = { m = {0.02, -0.03, -0.035}, r = {-5.5, -5.5, -2} },
            small_flowers   = { m = {-0.005, -0.015, -0.015}, r = {-9.5, nil, nil} },
            ground_cover    = { m = {nil, -0.19, -0.05}, r = {-72.5, 0.5, -1} },
            bamboo          = { m = {0.02, 0.02, -0.025}, r = {-6, -5.5, -2} },
            sugar_cane      = { m = {-0.005, 0.02, -0.025}, r = {-6, -5.5, -2} },
            twisting_vines  = { m = {0.035, nil, 0.035} },
            vine            = { m = {-0.14, nil, 0.115}, r = {-9, -12, nil} },
            glow_lichen     = { m = {-0.14, nil, 0.115}, r = {-9, -12, nil} },
            sculk_vein      = { m = {-0.14, nil, 0.115}, r = {-9, -12, nil} },
            rose_bush       = { m = {nil, nil, -0.03}, r = {-7, nil, nil} },
            peony           = { m = {nil, nil, -0.03}, r = {-7, nil, nil} },
            lilac           = { m = {nil, nil, -0.03}, r = {-7, nil, nil} },
            pitcher_plant   = { m = {nil, nil, -0.03}, r = {-7, nil, nil} },
            big_dripleaf    = { m = {-0.02, nil, -0.015} },
            small_dripleaf  = { m = {nil, nil, -0.03} },
            lily_pad        = { m = {0.14, -0.1, -0.075}, r = {-5.5, -6.5, nil} },
            sea_pickle      = { m = {0.025, -0.025, -0.04}, r = {-5, -7, nil} },
            sea_grass       = { m = {0.225, -0.17, -0.18}, r = {-11, -11.5, nil} },
            kelp            = { m = {-0.045, -0.01, -0.06}, r = {14.5, -14, -9.5} }
        })
    end
end

if better3Dbooks then
    positioning({
        bookshelf_books = { r = {-12.5, -15.5, nil} }
    })
end

if fyoncle3Dtrims then
    positioning({
        smithing_templates = { m = {0.025, 0.095, -0.04}, r = {32.5, 77, -36.5} }
    })
end

if a3ds then
    if not freshFlowers then
        local plantsWithBlocks = {
            "saplings", "small_plants", "fern", "bushes", "small_flowers", "large_fern", "sunflower", "lilac",
            "rose_bush", "peony", "pitcher_plant"
        }
        if isInList(plantsWithBlocks) then
            renderAsBlock:put(I:getName(context.item), false)
            transform(move, {nil, -0.04, -0.08})
        end
        positioning({
            -- Natural Blocks
            vine                = { renderAsBlock = false },
            weeping_vines       = { renderAsBlock = false },
            twisting_vines      = { renderAsBlock = false },
            bamboo              = { m = {0.005, nil, -0.03}, r = {-5.5, -5, -1}, s = {0.8}, renderAsBlock = false },
            mushrooms           = { m = {0.01, -0.03, -0.075}, r = {-5, -4, -1} },
            azalea              = { m = {0.065, -0.095, -0.17}, r = {-6, 29, nil} },
            flowering_azalea    = { m = {0.065, -0.095, -0.17}, r = {-6, 29, nil} },
            cactus_flower       = { m = {0.03, 0.07, -0.09}, r = {-4.5, -4.5, nil} },
            sugar_cane          = { m = {0.015, nil, -0.105}, r = {nil, -5.5, nil}, s = {0.9} },
            glow_lichen         = { m = {nil, -0.21, nil} },
            lily_pad            = { m = {nil, -0.215, 0.02}, r = {-109, nil, nil}, s = {1, 0.4, 1} },
            ground_cover        = { m = {-0.035, -0.22, -0.085}, r = {-73.5, nil, nil} }
        })
    end
    positioning({
        -- Natural Blocks
        frogspawn           = { m = {-0.06, 0.04, -0.025}, r = {-4, -5.5, -2}, renderAsBlock = false },
        -- Functional Blocks
        bell                = { m = {-0.005, -0.525, 0.145}, r = {-28, nil, nil} },
        armor_stand         = { m = {nil, 0.03, nil} },
        item_frame          = { m = {-0.03, -0.62, 0.2}, r = {-39, -6, nil} },
        painting            = { m = {-0.03, -0.62, 0.2}, r = {-39, -6, nil} },
        -- Tools & Utilities
        bundles             = { m = {0.015, 0.03, -0.055}, r = {-4, -5.5, nil} },
        writable_book       = { m = {nil, nil, -0.09} },
        minecarts           = { m = {nil, 0.045, nil} },
        ender_eye           = { m = {0.03, -0.01, -0.08}, r = {-4.5, -6, nil} },
        ender_pearl         = { m = {0.01, -0.005, -0.08}, r = {-4.5, -6, nil} },
        flint_and_steel     = { m = {0.015, 0.005, -0.095}, r = {10, 2.5, -2.5}, s = {0.9} },
        bone_meal           = { m = {0.01, 0.07, -0.125}, r = {-5.5, -4, nil} },
        shears              = { r = {-7, nil, 38.5} },
        brush               = { m = {0.025, 0.05, -0.035}, r = {-4.5, -5.5, -1} },
        lead                = { m = {0.125, -0.13, -0.215}, r = {-5.5, -4, -1}, s = {0.9} },
        compass             = { m = {0.015, 0.06, -0.03}, r = {-6.5, -5, -2} },
        map                 = { m = {0.025, -0.02, -0.055}, r = {-6.5, -5, nil} },
        paper               = { m = {0.025, -0.02, -0.055}, r = {-6.5, -5, nil} },
        firework_rocket     = { m = {0.035, -0.01, -0.07}, r = {-6, -5.5, -1.5}, s = {0.9} },
        saddle              = { m = {-0.025, nil, nil} },
        boats               = { r = {nil, -37.5, nil} },
        chest_boats         = { r = {nil, -37.5, nil} },
        goat_horn           = { m = {0.015, 0.09, nil}, r = {nil, -4, -1.5} },
        -- Combat
        totem_of_undying    = { m = {0.025, -0.02, -0.055} },
        eggs                = { m = {0.03, nil, -0.085}, r = {-6, -6, nil}, s = {1.2} },
        snowball            = { m = {0.015, -0.01, -0.085}, r = {-6, -6, nil} },
        -- Ingredients
        resin_clump         = { m = {-0.005, -0.055, -0.095}, r = {-7, -4.5, nil}, renderAsBlock = false },
        coals               = { m = {nil, nil, -0.025}, r = {-8, nil, nil}, s = {0.9} },
        raw_materials       = { m = {-0.005, -0.055, -0.095}, r = {-7, -4.5, nil} },
        nuggets             = { m = {0.02, 0.03, -0.045}, r = {-6, -5, nil} },
        ingots              = { m = {-0.01, 0.005, -0.07}, r = {-6, -5.5, -1.5}, s = {0.9} },
        bricks              = { m = {-0.01, 0.005, -0.07}, r = {-6, -5.5, -1.5}, s = {0.9} },
        string              = { m = {0.05, -0.005, -0.075}, r = {-4.5, -4.5, nil}, renderAsBlock = false },
        smithing_templates  = { m = {-0.095, -0.11, -0.14}, r = {-5.5, -5, nil} },
        keys                = { m = {0.015, nil, -0.085}, r = {-6, -5.5, nil} },
        emerald             = { m = {0.015, -0.035, -0.085}, r = {-6.5, -3.5, nil} },
        lapis_lazuli        = { m = {nil, -0.06, -0.105}, r = {-6, -5.5, nil} },
        diamond             = { m = {0.015, -0.055, -0.09}, r = {-7.5, -3.5, nil} },
        quartz              = { m = {0.005, 0.07, -0.035}, r = {-6, -7, nil}, s = {0.7} },
        shards              = { m = {0.025, -0.01, -0.055}, r = {-4.5, -5.5, nil} },
        netherite_scrap     = { m = {-0.045, -0.035, -0.13}, r = {-6, -5, -1} },
        flint               = { m = {0.03, 0.06, -0.08}, r = {14.5, 12.5, -8} },
        book                = { m = {-0.135, nil, 0.085}, r = {-5, -6, -2} },
        enchanted_book      = { m = {-0.135, nil, 0.085}, r = {-5, -6, -2} },
        stick               = { m = {0.02, -0.19, -0.015}, r = {-4.5, -7, -0.5} },
        blaze_rod           = { m = {0.02, -0.19, -0.015}, r = {-4.5, -7, -0.5} },
        breeze_rod          = { m = {0.02, -0.19, -0.015}, r = {-4.5, -7, -0.5} },
        bone                = { m = {0.025, -0.04, -0.035}, r = {-5, -5.5, nil} },
        leather             = { m = {-0.01, -0.03, -0.08}, r = {-5.5, -4, -1} },
        rabbit_hide         = { m = {-0.01, -0.03, -0.08}, r = {-5.5, -4, -1} },
        honeycomb           = { m = {0.01, 0.04, -0.05}, r = {-5, -5, nil} },
        ink_sacs            = { m = {0.015, 0.015, -0.085}, r = {-4, -4.5, -1} },
        clay_ball           = { m = {posInHands(0, 0.06), nil, nil} },
        fire_charge         = { m = {0.005, 0.04, 0.005}, r = {-6, -5, nil} },
        heart_of_the_sea    = { m = {0.005, 0.04, 0.005}, r = {-6, -5, nil} },
        slime_ball          = { m = {0.02, 0.005, -0.09}, r = {-4, -3.5, nil} },
        prismarine_shard    = { m = {0.02, nil, -0.09}, r = {-6.5, -6, -1.5} },
        prismarine_crystals = { m = {0.025, 0.01, -0.14}, r = {-7.5, -6.5, nil}, s = {1.15} },
        nautilus_shell      = { m = {0.025, -0.015, -0.04}, r = {-5.5, -5, nil} },
        nether_star         = { m = {0.01, -0.135, -0.035}, r = {-6, -5.5, -2} },
        dyes                = { m = {0.02, nil, -0.105}, r = {-4, -5.5, nil} },
        firework_star       = { m = {0.03, 0.01, -0.01}, r = {-4.5, -5, -1.5} },
        magma_cream         = { m = {0.03, 0.01, -0.01}, r = {-4.5, -5, -1.5} },
        powders             = { m = {-0.01, -0.02, -0.095}, r = {-8.5, nil, nil} },
        blaze_powder        = { m = {-0.01, -0.02, -0.095}, r = {-8.5, nil, nil} },
        rabbit_foot         = { m = {-0.01, -0.005, -0.08}, r = {-5, -4.5, nil} },
        ghast_tear          = { m = {0.02, -0.02, -0.05}, r = {-5, -5, -2}, s = {1.3} },
        banner_patterns     = { m = {nil, nil, -0.175} }
    })
end

if w3di then
    positioning({
        -- Natural Blocks
        turtle_egg                = { m = {0.255, -0.18, -0.2}, r = {-5.5, -5.5, 4}, s = {1.7} },
        -- Functional Blocks
        copper_torch              = { m = {0.07, -0.15, -0.07}, r = {-4.5, -5, -1.5}, s = {1.35} },
        torches                   = { m = {0.005, -0.07, -0.08}, r = {-5, nil, -1.5} },
        lanterns                  = { m = {0.015, -0.515, 0.14}, r = {-17, -5.5, nil}, s = {0.7} },
        end_crystal               = { m = {-0.08, -0.225, -0.04} },
        flower_pot                = { m = {0.025, -0.015, -0.04}, r = {4, -5.5, 3.5} },
        armor_stand               = { m = {-0.055, -0.015, -0.08}, r = {-4, -9.5, 6} },
        signs                     = { m = {-0.035, 0.02, -0.065}, r = {-4.5, -5, 6.5} },
        -- Redstone Blocks
        repeater                  = { r = {-6.5, nil, nil} },
        comparator                = { r = {-6.5, nil, nil} },
        lever                     = { r = {8.5, nil, nil} },
        boats                     = { r = {3.5, -8, -4.5} },
        chest_boats               = { r = {3.5, -8, -4.5} },
        -- Tools & Utilities
        elytra                    = { m = {nil, -0.32, nil}, r = {-131.5, nil, nil}, condition = not just3Darmors },
        buckets                   = { m = {0.005, 0.15, -0.04}, r = {86, -151.5, -4}, s = {1.1}, condition = not refinedBuckets },
        bundles                   = { m = {-0.05, -0.015, -0.015}, r = {-6, -11, 2.5}, s = {0.9} },
        music_discs               = { m = {-0.05, nil, -0.06}, r = {-5.5, -10.5, 2.5} },
        disc_fragment_5           = { m = {-0.065, -0.045, -0.005}, r = {-5.5, -9.5, 5.5} },
        shears                    = { m = {nil, -0.085, -0.085}, r = {-40.5, 10, 24} },
        writable_book             = { m = {0.07, 0.065, -0.09}, r = {10, -26, 13} },
        written_book              = { m = {0.07, 0.065, -0.09}, r = {10, -26, 13} },
        flint_and_steel           = { m = {0.05, -0.015, -0.145}, r = {3.5, -6, 4.5} },
        lead                      = { m = {0.075, -0.03, -0.08}, r = {nil, -26, 10} },
        compasses                 = { m = {-0.005, -0.03, -0.16}, r = {5.5, -9.5, 7.5} },
        clock                     = { m = {-0.005, -0.03, -0.16}, r = {5.5, -9.5, 7.5} },
        map                       = { m = {-0.045, 0.035, -0.035}, r = {-5, -9.5, 5} },
        wind_charge               = { m = {-0.02, -0.03, -0.06}, r = {-3.5, -11, 3} },
        ender_items               = { m = {-0.015, -0.01, -0.005}, r = {-4, -10, 3} },
        goat_horn                 = { m = {-0.015, nil, -0.15}, r = {14, -9, 5.5} },
        firework_rocket           = { m = {-0.03, nil, -0.03}, r = {-6, -13.5, 4.5} },
        -- Combat
        nautilus_armors           = { m = {-0.055, 0.04, 0.01}, r = {-4.5, -9.5, 6} },
        nautilus_shell            = { m = {-0.055, 0.04, 0.01}, r = {-4.5, -9.5, 6} },
        eggs                      = { m = {0.01, -0.015, -0.05}, r = {-6, -5.5, 3} },
        snowball                  = { m = {0.01, -0.015, -0.05}, r = {-6, -5.5, 3} },
        totem_of_undying          = { m = {-0.06, nil, -0.045}, r = {-7.5, nil, nil} },
        -- Ingredients
        coals                     = { m = {-0.045, nil, nil}, r = {-4.5, -11, 4} },
        raw_materials             = { m = {-0.045, nil, -0.035}, r = {-6, -6.5, 4.5} },
        nuggets                   = { m = {-0.06, 0.055, -0.035}, r = {-7.5, -10, 6.5} },
        ingots                    = { m = {-0.03, -0.005, -0.03}, r = {-8, -21.5, 4} },
        bricks                    = { m = {-0.03, -0.005, -0.03}, r = {-8, -21.5, 4} },
        emerald                   = { m = {-0.05, 0.01, -0.035}, r = {-6, -4.5, 5.5}, s = {0.85} },
        lapis_lazuli              = { m = {-0.105, 0.08, 0.06}, r = {-5, -5.5, 5.5} },
        diamond                   = { m = {-0.045, 0.015, -0.035}, r = {-5.5, -5.5, 5.5}, s = {0.8} },
        quartz                    = { m = {-0.035, -0.005, 0.07}, r = {1, 79.5, 2} },
        amethyst_shard            = { m = {-0.05, 0.02, -0.06}, r = {-7, -9.5, 3.5} },
        netherite_scrap           = { m = {-0.05, nil, -0.08}, r = {-3, nil, nil} },
        flint                     = { m = {-0.05, -0.145, -0.12}, r = {4.5, -5.5, 4.5} },
        redstone                  = { m = {-0.1, 0.015, 0.035}, r = {-3, -11, nil} },
        book                      = { m = {-0.1, nil, -0.01}, r = {nil, -8.5, nil} },
        enchanted_book            = { m = {-0.1, nil, -0.01}, r = {nil, -8.5, nil} },
        powders                   = { m = {-0.1, 0.015, 0.035}, r = {-3, -11, nil} },
        bone_meal                 = { m = {-0.1, 0.015, 0.035}, r = {-3, -11, nil} },
        stick                     = { m = {0.01, 0.01, -0.02}, r = {-2, -2, -1.5} },
        blaze_rod                 = { m = {-0.005, 0.01, -0.02}, r = {-2, -2, -1.5} },
        breeze_rod                = { m = {-0.005, 0.01, -0.02}, r = {-2, -2, -1.5} },
        bone                      = { m = {-0.025, -0.105, -0.025}, r = {-0.5, -0.5, -1} },
        honeycomb                 = { m = {-0.07, -0.005, -0.065}, r = {-4.5, -9.5, 5.5} },
        scutes                    = { m = {-0.045, -0.005, -0.035}, r = {-7, -6, 4} },
        fire_charge               = { m = {0.015, -0.035, -0.07}, r = {-5.5, -6.5, 3.5} },
        slime_ball                = { m = {-0.05, -0.005, -0.015}, r = {-5.5, -6, 4.5} },
        clay_ball                 = { m = {-0.055, -0.01, -0.055}, r = {-6, -11, 3.5} },
        prismarine_crystals       = { m = {-0.17, 0.04, 0.105}, r = {nil, 90.5, nil}, s = {1.3} },
        heart_of_the_sea          = { m = {-0.045, 0.02, -0.02}, r = {-3.5, -6, 4}, s = {0.9} },
        shulker_shell             = { m = {-0.035, -0.055, -0.085}, r = {-5, -10, 6} },
        fermented_spider_eye      = { m = {-0.025, -0.085, -0.045}, r = {0.5, nil, 4} },
        blaze_powder              = { m = {-0.01, -0.03, -0.045}, r = {-13, -47, nil} },
        feather                   = { m = {-0.055, -0.02, -0.03}, r = {nil, -10, 6} },
        glistering_melon_slice    = { m = {-0.045, -0.03, -0.105}, r = {-5, -6, nil} },
        -- Spawn Eggs
        spawn_eggs                = { m = {-0.02, -0.015, -0.03}, r = {-6.5, -10.5, 3} }

    })
    if not (isUsingItem and useAction == "eat") then
        positioning({
            -- Foods & Drinks
            apples          = { m = {-0.05, -0.01, -0.035}, r = {-5.5, -5.5, 3} },
            chorus_fruit    = { m = {-0.05, -0.01, -0.035}, r = {-5.5, -5.5, 3} },
            melon_slice     = { m = {-0.045, -0.03, -0.105}, r = {-5, -6, nil} },
            beefs           = { m = {-0.05, -0.005, -0.025}, r = {-5, -6, 3.5} },
            potatoes        = { m = {-0.05, -0.005, -0.035}, r = {-6, -5.5, 3.5} },
            bread           = { m = {-0.05, -0.005, -0.035}, r = {-6, -5.5, 3.5} },
            bowl_foods      = { m = {0.01, -0.015, -0.105}, r = {-7, -6.5, -1} },
            bottles_drink   = { m = {-0.055, nil, -0.035}, r = {-4.5, -7, 4} },
            carrots         = { m = {-0.045, -0.085, -0.08}, r = {-9.5, -9.5, 6} },
            spider_eye      = { m = {-0.07, -0.14, -0.115}, r = {-6, -6.5, 3} },
            sweet_berries   = { m = {0.025, 0.085, -0.12}, r = {-5.5, -4.5, 7.5} },
            glow_berries    = { m = {-0.06, -0.01, -0.07} },
            dried_kelp      = { m = {-0.095, 0.02, -0.005}, r = {nil, -4, nil} },
            beetroot        = { m = {-0.045, -0.01, -0.08}, r = {-5.5, -10, 6.5} },
            chickens        = { m = {-0.06, -0.005, -0.025}, r = {-5.5, -5.5, 3.5} },
            rabbits         = { m = {-0.055, 0.01, 0.065}, r = {-5.5, -5.5, 4.5} },
            cod             = { m = {-0.115, -0.005, -0.065}, r = {-5, -7, 5} },
            cooked_cod      = { m = {-0.115, -0.005, -0.065}, r = {-5, -7, 5} },
            salmon          = { m = {-0.09, -0.005, -0.085}, r = {-5, -7, 5} },
            cooked_salmon   = { m = {-0.09, -0.005, -0.085}, r = {-5, -7, 5} },
            tropical_fish   = { m = {-0.065, -0.005, -0.075}, r = {-3, -5, 4} },
            pufferfish      = { m = {-0.075, nil, nil}, r = {-4.5, -5.5, 2.5} },
            cookie          = { m = {-0.06, -0.005, -0.02}, r = {-5, -5.5, 3.5} },
            cake            = { m = {-0.03, 0.125, -0.085}, r = {3.5, -22.5, 3}, s = {0.9} },
            pumpkin_pie     = { m = {-0.125, nil, 0.01}, r = {-7, -6, 3} }
        })
    end
end

if wNature then
    positioning({
        mushrooms           = { m = {0.245, -0.11, -0.135}, r = {-4, -5, nil}, s = {1.45} },
        tulips              = { m = {0.15, -0.065, -0.08} },
        oak_sapling         = { m = {0.115, -0.075, -0.08}, r = {-3.5, nil, nil} },
        flowering_azalea    = { m = {0.165, -0.075, -0.075}, r = {-5, -3.5, nil} },
        dead_bush           = { m = {0.22, -0.09, -0.11}, r = {-4, -6, nil}, s = {1.35} },
        fern                = { m = {0.21, -0.09, -0.11}, r = {-4, -6, nil}, s = {1.35} },
        dandelion           = { m = {0.16, -0.06, -0.11} },
        poppy               = { m = {0.06, nil, nil} },
        blue_orchid         = { m = {0.135, -0.06, -0.095} },
        allium              = { m = {-0.075, -0.055, -0.095}, r = {nil, 75.5, nil}, s = {0.9} },
        azure_bluet         = { m = {0.095, -0.06, -0.135}, r = {nil, 35.5, nil} },
        oxeye_daisy         = { m = {0.205, -0.075, -0.07}, r = {nil, -20.5, nil}, s = {1.25} },
        cornflower          = { m = {0.21, -0.055, -0.125}, s = {1.25} },
        lily_of_the_valley  = { m = {0.07, -0.09, -0.115}, r = {nil, 20, nil} }
    })
end

local pose = positions[itemName]

if pose then
    if pose["renderAsBlock"] ~= nil then
        renderAsBlock:put(I:getName(context.item), pose["renderAsBlock"])
    end
    if pose.m then transform(move, pose.m) end
    if pose.r then transform(rotate, pose.r) end
    if pose.s then
        if pose.s[1] ~= nil and pose.s[2] == nil and pose.s[3] == nil then
            M:scale(mat, pose.s[1], pose.s[1], pose.s[1])
        else
            M:scale(mat, pose.s[1], pose.s[2], pose.s[3])
        end
    end
end

-- === DE-POSITIONS ===
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

local packsDepositions = {
    a3ds = {
        -- Tools & Utilities
        shears                    = { m = {nil, -0.025, -0.065}, r = {-14.5, 2.5, -35.5} },
        writable_book             = { m = {nil, -0.1, nil}, r = {-25, nil, nil} },
        -- Combat
        totem_of_undying          = { r = {10, 190, 110, "yzx"} }
    },
    w3di = {
        -- Functional Blocks
        torches                   = { s = {1/1.35}, r = {0, 5, nil, "zyx"}, m = {-0.07, 0.085, nil}, ops = "srm", condition = itemName ~= "copper_torch" },
        lanterns                  = {
            cases = {
                [1]               = { condition = refinedTorches, m = {0.045, 0.015, -0.07}, r = {6, -13, nil}, s = {0.6} },
                [2]               = { condition = rvTorches, m = {-0.065, 0.08, 0.18}, r = {-11, nil, nil}, s = {0.6} }
            }
        },
        campfires                 = { s = {1/1.35, 1/1.35, 1/1.5}, r = {-7, -15, 75, "yzx"}, m = {-0.1, -0.15, -0.1, "xzy"}, ops = "srm" },
        armor_stand               = { s = {1/1.1}, r = {-4, 0.3, 7, "yxz"}, m = {0, 0.05, -0.07, "yzx"}, ops = "srm" },
        -- Redstone Blocks
        repeater                  = { s = {1/1.35}, r = {-7, -35, 85, "yzx"}, m = {-0.15, -0.15, 0.1, "xzy"}, ops = "srm", condition = rvTorches },
        comparator                = { s = {1/1.35}, r = {-7, -35, 85, "yzx"}, m = {-0.15, -0.15, 0.1, "xzy"}, ops = "srm", condition = rvTorches },
        -- Tools & Utilities
        music_discs               = { s = {1/1.35}, r = {-50, -95, 50, "zyx"}, m = {0.13, 0.205, 0.08, "zyx"}, ops = "srm" },
        milk_bucket               = {
            cases = {
                [1]               = { condition = isUsingItem, m = {-0.1, -0.03, 0, "zxy"}, r = {-35, -10 * d, -10, "zyx"}, s = {1/1.05}, ops = "mrs" },
                [2]               = { s = {1/1.05}, r = {209, -187, -100, "zyx"}, m = {0.01, -0.1, 0.15, "zyx"}, ops = "srm" }
            }
        },
        buckets                   = { s = {1/1.05}, r = {-165, -25, -55, "yzx"}, m = {0.12, -0.08, 0.1, "zyx"}, ops = "srm" },
        bundles                   = { s = {1/1.3}, m = {0.05, 0.05, 0.01, "zxy"}, r = {-95, 0, 5, "yxz"}, ops = "smr" },
        shears                    = {
            cases = {
                [1]               = { condition = a3ds and not gousPoses, s = {1/1.3, 1/1.4, 1/1.3}, m = {0.1, -0.05, nil, "zxy"}, r = {25, 30, 45, "yxz"}, ops = "smr" },
                [2]               = { condition = a3ds and gousPoses, m = {nil, -0.155, -0.15}, r = {-7, 10, -32.5}, s = {0.9} }
            }
        },
        elytra                    = { m = {0.025, 0.095, 0.16}, r = {58.5, -1.5, -1} },
        written_book              = { s = {1/1.1}, r = {-4, 30, 7, "yxz"}, m = {0.05, -0.05, 0.03, "yzx"}, ops = "srm" },
        bookshelf_books           = { s = {1/1.1, 1/1.2, 1/1.1}, r = {-40, 20, 30, "yxz"}, m = {-0.2, -0.07, -0.1, "yzx"}, ops = "srm" },
        boats                     = { s = {1/1.35}, r = {-4, -180, 120, "yzx"}, m = {nil, -0.15, nil}, ops = "srm" },
        chest_boats               = { s = {1/1.35}, r = {-4, -180, 120, "yzx"}, m = {nil, -0.15, nil}, ops = "srm" },
        name_tag                  = { s = {1/1.4}, r = {180, 130, nil, "zxy"}, m = {-0.1, 0.15, nil, "zyx"}, ops = "srm" },
        ender_items               = { s = {1/1.05}, m = {0.05, 0.05, nil, "zxy"}, r = {-95, 0, 5, "yxz"}, ops = "smr" },
        fishing_rod               = { s = {1/1.2}, m = {0.1, 0.1, nil}, r = {1, 10, 70, "yzx"}, ops = "smr" },
        flint_and_steel           = { s = {1/1.1}, r = {5, 10, nil, "zxy"}, ops = "srm" },
        lead                      = { s = {1/1.2, 1, 1}, r = {nil, -24.5, 10}, m = {-0.025, 0.2, nil, "xzy"}, ops = "srm" },
        compass                   = { s = {1/1.2}, r = {-4, 10, 7, "yxz"}, m = {0, -0.01, -0.03, "yzx"}, ops = "srm" },
        carrot_on_a_stick         = { s = {1/1.2}, m = {0.1, 0.1, nil}, r = {1, 60, nil, "yxz"}, ops = "smr" },
        goat_horn                 = { s = {1/1.3}, m = {0.05, -0.05, nil, "zxy"}, r = {nil, nil, 5}, ops = "smr" },
        firework_rocket           = {
            cases = {
                [1]               = { s = {1/1.2}, m = {0.03, 0, nil, "zxy"}, ops = "smr" },
                [2]               = { s = {1/1.05}, m = {0.05, 0.05, nil, "zxy"}, r = {-95, 0, 5, "yxz"}, ops = "smr" }
            }
        },
        writable_book             = {
            cases = {
                [1]               = { condition = a3ds and not better3Dbooks, s = {1/1.1}, r = {-4, 30, 7, "yxz"}, m = {0.05, -0.05, 0.03, "yzx"}, ops = "srm" },
                [2]               = { condition = a3ds and better3Dbooks, s = {1/1.1}, m = {0.02, -0.055, -0.055}, r = {1.5, nil, 6} },
                [3]               = { condition = not a3ds and better3Dbooks, s = {1/1.1}, r = {-4, 30, 7, "yxz"}, m = {0.05, -0.05, 0.03, "yzx"}, ops = "srm" }
            }
        },
        -- Combat
        totem_of_undying          = {
            cases = {
                [1]               = { condition = not glowing3Dtotem ~= not a3ds, s = {1/1.2}, m = {0.01, 0.01, 0, "yzx"}, r = {-55, 4, 9, "yxz"}, ops = "smr" },
                [2]               = { condition = glowing3Dtotem and a3ds, s = {1/1.2}, m = {-0.015, -0.005, -0.02}, r = {51, 140, 30.5}, ops = "smr" }
            }
        },
        nautilus_armors           = { s = {1/1.1}, r = {-4, 0.3, 7, "yxz"}, m = {0, 0.05, -0.07, "yzx"}, ops = "srm" },
        eggs                      = { r = {nil, nil, 5} },
        snowball                  = { r = {nil, nil, 5} },
        -- Foods & Drinks
        apples                    = { s = {1/1.05}, m = {0.05, -0.07, nil, "zxy"}, r = {0, 5, nil, "xzy"}, ops = "smr" },
        chorus_fruit              = { s = {1/1.05}, m = {0.05, -0.07, nil, "zxy"}, r = {0, 5, nil, "xzy"}, ops = "smr" },
        pufferfish                = { s = {1/1.05}, m = {0.05, -0.07, nil, "zxy"}, r = {0, 5, nil, "xzy"}, ops = "smr" },
        melon_slice               = { s = {1/1.2}, m = {0, -0.07, nil, "zxy"}, r = {0, 5, nil, "xzy"}, ops = "smr" },
        glistering_melon_slice    = { s = {1/1.2}, m = {0, -0.07, nil, "zxy"}, r = {0, 5, nil, "xzy"}, ops = "smr" },
        beefs                     = { s = {1/1.2, 1/1.4, 1/1.2}, m = {0.1, -0.07, nil, "zxy"}, r = {0, 5, nil, "xzy"}, ops = "smr" },
        muttons                   = { s = {1/1.2, 1/1.4, 1/1.2}, m = {0.1, -0.07, nil, "zxy"}, r = {0, 5, nil, "xzy"}, ops = "smr" },
        bowl_foods                = { s = {1/1.2}, r = {180, -180, -115, "zyx"}, m = {-0.2, -0.13, 0, "zyx"}, ops = "srm" },
        glow_berries              = { s = {1/1.1}, m = {-0.05, -0.02, -0.07, "yzx"}, r = {0, 5, nil, "xzy"}, ops = "smr" },
        carrot                    = { s = {1/1.05}, m = {-0.03, -0.07, nil, "zxy"}, r = {-4, -4, 8, "yxz"}, ops = "smr" },
        golden_carrot             = { s = {1/1.04}, m = {-0.01, -0.07, nil, "zxy"}, r = {-4, -4, 8, "yxz"}, ops = "smr" },
        potato                    = { m = {0.02, -0.07, nil, "zxy"}, r = {0, 5, nil, "xzy"} },
        potatoes                  = { m = {0.05, -0.07, nil, "zxy"}, r = {0, 5, nil, "xzy"} },
        beetroot                  = { s = {1/1.04}, m = {0.02, -0.07, nil, "zxy"}, r = {-4, 0, 8, "yxz"}, ops = "smr" },
        dried_kelp                = { s = {1/1.05}, m = {0.02, -0.07, nil, "zxy"}, r = {0, 5, nil, "xzy"}, ops = "smr" },
        chickens                  = { s = {1/1.15}, m = {0.1, -0.07, nil, "zxy"}, r = {0, 5, nil, "xzy"}, ops = "smr" },
        rabbits                   = { s = {1/1.15}, m = {0.1, -0.07, nil, "zxy"}, r = {0, 5, nil, "xzy"}, ops = "smr" },
        fishes                    = { s = {1/1.3, 1/1.4, 1/1.3}, m = {-0.05, 0.1, -0.07, "zzx"}, r = {0, 5, nil, "xzy"}, ops = "smr" },
        bread                     = { s = {1/1.15, 1/1.25, 1/1.15}, m = {-0.05, 0.15, -0.07, "zzx"}, r = {0, 5, nil, "xzy"}, ops = "smr" },
        cookie                    = { s = {1/1.15, 1/1.25, 1/1.15}, m = {-0.05, 0.07, -0.07, "zzx"}, r = {0, 5, nil, "xzy"}, ops = "smr" },
        cake                      = { s = {1/1.35, 1/1.35, 1/1.5}, r = {-7, -15, 75, "yzx"}, m = {-0.1, -0.15, -0.1, "xzy"}, ops = "srm" },
        pumpkin_pie               = { s = {1/1.15}, m = {0, 0, -0.07, "yzx"}, r = {0, 5, nil, "xzy"}, ops = "smr" },
        spider_eye                = { s = {1/1.1}, m = {0.04, -0.05, nil, "zxy"}, r = {0, 5, nil, "xzy"}, ops = "smr" },
        -- Ingredients
        coals                     = { s = {1, 1/1.2, 1}, m = {0.05, 0.05, nil, "zxy"}, r = {-95, 0, 5, "yxz"}, ops = "smr" },
        raw_materials             = { s = {1/1.3, 1, 1/1.3}, r = {0, 0, 5, "yxz"}, m = {0.05, -0.05, nil, "zxy"}, ops = "srm" },
        quartz                    = { s = {1/1.1}, r = {-4, 0.3, 7, "yxz"}, m = {0, 0.05,-0.07, "yzx"} },
        nuggets                   = { s = {1/1.1}, r = {-4, 0.3, 7, "yxz"}, m = {0, 0.05,-0.07, "yzx"} },
        amethyst_shard            = { s = {1/1.1}, r = {-4, 0.3, 7, "yxz"}, m = {0, 0.05,-0.07, "yzx"} },
        redstone                  = { s = {1/1.1}, r = {-4, 0.3, 7, "yxz"}, m = {0, 0.05,-0.07, "yzx"} },
        ingots                    = { s = {1/1.15}, r = {-15, 0.3, 5, "yxz"}, m = {0, 0.1, 0, "yzx"}, ops = "srm" },
        bricks                    = { s = {1/1.15}, r = {-15, 0.3, 5, "yxz"}, m = {0, 0.1, 0, "yzx"}, ops = "srm" },
        emerald                   = { s = {1/1.1, 1/1.25, 1/1.1}, r = {0, 0.3, 7, "yxz"}, m = {0.05, 0.1, -0.07, "yzx"} },
        diamond                   = { s = {1/1.1, 1/1.25, 1/1.1}, r = {0, 0.3, 7, "yxz"}, m = {0.05, 0.1, -0.07, "yzx"} },
        lapis_lazuli              = { s = {1/1.1, 1/1.25, 1/1.1}, r = {0, 0.3, 7, "yxz"}, m = {0.05, 0.1, -0.07, "yzx"} },
        netherite_scrap           = { s = {1/1.15}, r = {-15, 0.3, 5, "yxz"}, ops = "srm" },
        flint                     = { s = {1/1.3}, r = {5, 10, nil, "zxy"}, ops = "srm" },
        bone_meal                 = { s = {1/1.1}, r = {-4, 0.3, 7, "yxz"}, m = {0, 0.05, -0.07, "yzx"}, ops = "srm" },
        map                       = { s = {1/1.1}, r = {-4, 0.3, 7, "yxz"}, m = {0, 0.05, -0.07, "yzx"}, ops = "srm" },
        honeycomb                 = { s = {1/1.1}, r = {-4, 0.3, 7, "yxz"}, m = {0, 0.05, -0.07, "yzx"}, ops = "srm" },
        nautilus_shell            = { s = {1/1.1}, r = {-4, 0.3, 7, "yxz"}, m = {0, 0.05, -0.07, "yzx"}, ops = "srm" },
        powders                   = { s = {1/1.1}, r = {-4, 0.3, 7, "yxz"}, m = {0, 0.05, -0.07, "yzx"}, ops = "srm" },
        blaze_powder              = { s = {1/1.1}, r = {-4, 0.3, 7, "yxz"}, m = {0, 0.05, -0.07, "yzx"}, ops = "srm" },
        banner_patterns           = { s = {1/1.4}, r = {180, 130, nil, "zxy"}, m = {-0.1, 0.15, nil, "zyx"}, ops = "srm" },
        fire_charge               = { s = {1/1.25}, r = {nil, nil, 5}, ops = "srm" },
        stick                     = { m = {0.05, 0.07, 0.05, "yzx"}, r = {4, nil, -85, "zxy"} },
        bone                      = { m = {0.05, 0.07, 0.05, "yzx"}, r = {4, nil, -85, "zxy"} },
        blaze_rod                 = { m = {0.05, 0.07, 0.05, "yzx"}, r = {4, nil, -85, "zxy"} },
        breeze_rod                = { m = {0.05, 0.07, 0.05, "yzx"}, r = {4, nil, -85, "zxy"} },
        slime_ball                = { s = {1/1.05}, m = {0.05, -0.07, nil, "zxy"}, r = {0, 5, nil, "xzy"}, ops = "smr" },
        clay_ball                 = { m = {-0.055, 0.015, nil}, r = {-3, 0, 6} },
        heart_of_the_sea          = { s = {1/1.35}, m = {0.05, -0.07, nil, "zxy"}, r = {0, 5, nil, "xzy"} }
    }
}
if w3di then
    local w3diConditions = {
        { a3ds,              PackCompat.a3ds },
        { glowing3Dtotem,    PackCompat.glowing3Dtotem },
        { glowing3Darmors,   PackCompat.glowing3Darmors },
        { rvTorches,         PackCompat.rvTorches },
        { refinedTorches,    PackCompat.refinedTorches },
        { refinedBuckets,    PackCompat.refinedBuckets },
        { freshFoods,        PackCompat.freshFoods },
        { freshOres,         PackCompat.freshOresIngots },
        { freshDiscs,        PackCompat.freshDiscs },
        { bensBundle,        PackCompat.bensBundle },
        { better3Dbooks,     PackCompat.better3Dbooks },
        { just3Darmors,      PackCompat.just3Darmors }
    }
    for _, entry in ipairs(w3diConditions) do
        if entry[1] and isInList(entry[2]) then
            depositioning(packsDepositions["w3di"])
        end
    end
end

if a3ds then
    local a3dsConditions = {
        { freshFlowers,                  PackCompat.freshFlowersPlants },
        -- without W3DI
        { glowing3Dtotem and not w3di,   PackCompat.glowing3Dtotem },
        { gousPoses and not w3di,        PackCompat.gousPoses },
        { better3Dbooks and not w3di,    PackCompat.better3Dbooks },
    }
    for _, entry in ipairs(a3dsConditions) do
        if entry[1] and isInList(entry[2]) then
            depositioning(packsDepositions["a3ds"])
        end
    end
end

-- === PHYSICS ===
global.yawAngleO    = 0.0;
global.pitchAngleO  = 0.0;

local playerPitch   = P:getPitch(context.player)
local ywAngle       = (context.mainHand and yawAngle) or yawAngleO
local ptAngle       = (context.mainHand and pitchAngle) or pitchAngleO

if a3ds then
    if freshFlowers then
        if
            itemName == "pale_hanging_moss"
            or itemName == "weeping_vines"
            or itemName == "twisting_vines"
            or itemName == "vine"
            or itemName == "hanging_roots"
        then
            M:rotateX(mat, -(M:clamp(P:getPitch(context.player) / 1, -45, 90) + ptAngle + ywAngle * 1), 0, -0.05, 0)
            M:rotateX(mat, 75)
            M:moveZ(mat, 0.03)
            M:moveY(mat, 0.2)
        elseif itemName == "glow_lichen" then
            M:rotateZ(mat, 30 * l)
            M:rotateX(mat, -(M:clamp(P:getPitch(context.player) / 1, -45, 90) + ptAngle + ywAngle * 1), 0, -0.05, 0)
            M:moveZ(mat, 0.03)
            M:rotateX(mat, 75)
        end
    end
    if itemName == "bell" then
        M:rotateX(mat, M:clamp(playerPitch / 2.5, -20, 90) + ptAngle, -0.1 * l, 0.4, 0.1)
        M:rotateZ(mat, ywAngle * -1, -0.1 * l, 0.4, 0.1)
    end
    if w3di and (itemName == "name_tag" or tag == "banner_patterns") then
        M:rotateX(mat, -(M:clamp(playerPitch / 2.5, -20, 90) + ptAngle + ywAngle * 0.5), 0, -0.13, 0)
    end
end

if gousPoses then
    if itemName == "shears" then
        if not context.bl then
            M:moveZ(mat, 0.1)
            M:rotateY(mat, 180)
        end
        M:rotateZ(mat, 45)
    end
end

if (rvTorches or refinedTorches or w3di) and tag == "lanterns" then
    M:rotateX(mat, M:clamp(playerPitch / 2.5, -20, 90) + ptAngle, 0, 0.4, 0)
    M:rotateZ(mat, ywAngle * -1, 0, 0.4, 0)
end

if glowing3Darmors then
    if tag == "chest_armor" then
        M:rotateX(mat, -(M:clamp(playerPitch / 2.5, -15, 80) + ptAngle + ywAngle * 0.3), 0, 0.1, 0.1)
        M:rotateZ(mat, ywAngle * 0.5, -0.129, -0.004, 0.495)
    elseif tag == "leg_armor" then
        M:rotateZ(mat, M:clamp(playerPitch / 2.5, -15, 80) + ptAngle + ywAngle * 0.3, 0, 0.44, 0.55)
    elseif itemName == "elytra" and not w3di then
        M:rotateX(mat, M:clamp(playerPitch / 2.5, -20, 90) + ptAngle + ywAngle * 0.5, 0, -0.13, 0)
	    M:rotateZ(mat, ywAngle * -0.7, -0.1 * l, 0, 0.1)
    end
end