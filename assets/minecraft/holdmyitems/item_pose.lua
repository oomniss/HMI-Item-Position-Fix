-- by omnis._.
local HMIversion = context == nil and "5.0" or "5.1+"

if HMIversion == "5.1+" then
    item                  = context.item
    matrices              = context.matrices
    player                = context.player
    mainHand              = context.mainHand
    deltaTime             = context.deltaTime
    swingProgress         = context.swingProgress
    mainHandSwingProgress = context.mainHandSwingProgress
    offHandSwingProgress  = context.offHandSwingProgress
    swingMHand            = context.swingMHand
    swingOHand            = context.swingOHand
    equipProgress         = context.equipProgress
    particles             = context.particles
    hand                  = context.hand
    bl                    = context.bl
end

local mat         = matrices
local l           = mainHand and 1 or -1
local itemName    = I:getName(item):gsub("minecraft:", "")
local skinModel   = (${skinModel} and "Alex") or "Steve"

-- === FUNCTIONS ===
if not ItemsTag or not ItemLists or not PackCompat then
    return
end
local function getTag()
    for _, tag in ipairs(ItemsTag.default) do
        if I:isIn(item, Tags:getVanillaTag(tag)) or I:isIn(item, Tags:getFabricTag(tag)) then
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

local itemCompatCache = { [0] = {}, [1] = {} }
local function getitemCompat()
    if itemCompatCache[0][itemName] then
        return false
    end
    if itemCompatCache[1][itemName] then
        return true
    end

    for _, rp in ipairs(ActivePacks) do
        if PackCompat[rp] then
            for _, i in ipairs(PackCompat[rp]) do
                if i == tag or i == itemName then
                    itemCompatCache[1][itemName] = rp
                    return true
                end
            end
        end
    end
    itemCompatCache[0][itemName] = true
    return false
end
local itemCompat = getitemCompat()

local function matched(items, matches)
    local list = type(items) == "table" and items or {items}

    local function check(i)
        if itemName == i or tag == i then
            return true
        end
        if matches and itemName:match(i) then
            return true
        end
    end

    for _, i in ipairs(list) do
        if check(i) then return true end
    end
    return false
end

local function renderBlock(render, items)
    if itemCompat then return end

    for _, i in ipairs(items) do
        if matched(i) then
            renderAsBlock:put(I:getName(item), render)
            return
        end
    end
end

local function move(x, y, z)
    if not itemCompat then
        M:moveX(mat, (x or 0) * l)
        M:moveY(mat, y or 0)
        M:moveZ(mat, z or 0)
    end
end
local function rotate(x, y, z)
    if not itemCompat then
        M:rotateX(mat, x or 0)
        M:rotateY(mat, (y or 0) * l)
        M:rotateZ(mat, (z or 0) * l)
    end
end
local function scale(x, y, z)
    if not itemCompat then
        if x ~= nil and y == nil and z == nil then
            M:scale(mat, x, x, x)
        else
            M:scale(mat, x or 1, y or 1, z or 1)
        end
    end
end

-- === NOT RENDER AS BLOCK ===
renderBlock(
    false,
    {"weeping_vines", "vine", "ladder", "signs", "tripwire_hook", "string", "bars", "resin_clump", "glass_panes", "sugar_cane"}
)

-- === ITEM TYPE CHECKING ===
local isException   = matched(ItemLists.except, true) or itemCompat or tag == "hanging_plants"
local is2D          = matched(ItemLists.sprites2D, true) or tag == "spawn_eggs"
local general2D     = not isException and is2D
local general3D     = not (isException or is2D) or matched({"_bulb", "crafting_table", "waxed.*rod", "waxed.*chest", "waxed.*chain", "waxed.*door"}, true)

-- === GENERAL ADJUST ===
if general3D then
    move(0.05, -0.075, -0.1)
    rotate(-4, 18, -1)
elseif general2D then
    move(0.03, 0.04, -0.075)
    rotate(-6.5, -5.5, -1)
end

if skinModel == "Steve" then
    move(0.035, nil, nil)
end

-- === INDIVIDUAL ADJUSTS ===
local positions = {
    -- Building Blocks
    doors                       = { m = {0.01, -0.445, 0.345},    r = {2.5, -113, 3.5}, s = {1.15} },
    bars                        = { m = {nil, nil, -0.01} },
    fences                      = { m = {0.175, -0.085, -0.075},  r = {-3.5, -5.5, -1} },
    walls                       = { m = {0.175, -0.085, -0.075},  r = {-3.5, -5.5, -1} },
    fence_gates                 = { m = {0.17, -0.185, -0.09},    r = {-4.5, -5, -1.5} },
    chains                      = { m = {0.06, nil, -0.01} },
    trapdoors                   = { m = {0.18, -0.08, -0.065},    r = {-7.5, -6, nil} },
    pressure_plates             = { m = {0.18, -0.08, -0.065},    r = {-7.5, -6, nil} },
    -- Colored Blocks
    carpets                     = { m = {0.18, -0.08, -0.065},    r = {-7.5, -6, nil} },
    glass_panes                 = { m = {-0.01, 0.01, nil},       s  = {0.75} },
    banners                     = { m = {0.045, 0.06, 0.02},      r = {-5, -95, nil},   s = {1.25} },
    beds                        = { m = {-0.225, -0.015, -0.005}, r = {7.5, 95, nil} },
    candles                     = { m = {0.37, -0.175, -0.215},   r = {-5.5, -6.5, -1}, s = {2.2} },
    -- Natural Blocks
    hanging_plants              = { m = {0.105, -0.59, -0.025} },
    amethyst_cristals           = { m = {0.04, nil, -0.005} },
    small_amethyst_bud          = { m = {nil, -0.03, 0.015} },
    small_plants                = { m = {0.05, nil, nil} },
    fern                        = { m = {0.06, nil, -0.01} },
    large_fern                  = { m = {0.06, nil, -0.01} },
    pointed_dripstone           = { m = {0.06, nil, -0.01} },
    mushrooms                   = { m = {0.08, nil, -0.04},       s  = {1.3} },
    corals                      = { m = {0.055, nil, -0.025} },
    cobweb                      = { m = {0.055, nil, -0.025} },
    bushes                      = { m = {0.055, nil, -0.025} },
    lilac                       = { m = {0.055, nil, -0.025} },
    peony                       = { m = {0.055, nil, -0.025} },
    pitcher_plant               = { m = {0.055, nil, -0.025} },
    torchflower                 = { m = {0.01, 0.035, 0.07},      r = {nil, -35, nil} },
    alium                       = { m = {0.1, nil, -0.045},       s  = {1.4} },
    tulips                      = { m = {0.1, nil, -0.045},       s  = {1.4} },
    wither_rose                 = { m = {0.08, nil, -0.065},      s  = {1.4} },
    small_flowers               = { m = {0.09, nil, -0.055},      s  = {1.4} },
    saplings                    = { m = {0.075, nil, -0.045},     s  = {1.25} },
    cactus_flower               = { m = {0.07, nil, -0.03},       s  = {1.2} },
    bamboo                      = { m = {0.49, -0.115, -0.26},    r = {-5, -5.5, -0.5},    s = {3, 1.2, 2.5} },
    sugar_cane                  = { m = {-0.06, -0.07, nil} },
    twisting_vines              = { m = {0.085, nil, nil} },
    vine                        = { m = {-0.11, -0.245, 0.08},    r = {-5, 84.5, -1.5},    s = {1, 1, 0.3} },
    glow_lichen                 = { m = {-0.11, -0.245, 0.08},    r = {-5, 84.5, -1.5},    s = {1, 1, 0.3} },
    sculk_vein                  = { m = {-0.11, -0.245, 0.08},    r = {-5, 84.5, -1.5},    s = {1, 1, 0.3} },
    sunflower                   = { m = {l == 1 and -0.08 or -0.02, nil, l == 1 and 0.33 or -0.07}, r = {nil, l == 1 and -131.5 or 30, nil} },
    small_dripleaf              = { m = {0.06, nil, -0.015} },
    big_dripleaf                = { m = {0.065, nil, -0.09} },
    chorus_plant                = { m = {0.06, -0.145, -0.09},    s  = {1.65} },
    frogspawn                   = { m = {0.17, -0.08, -0.08},     r = {-6.5, -5.5, -1} },
    turtle_egg                  = { m = {0.25, -0.165, -0.19},    r = {-5.5, -5.5, -0.5},  s = {1.7} },
    sniffer_egg                 = { m = {0.175, -0.08, -0.05},    r = {-6.5, -5.5, -1} },
    dried_ghast                 = { m = {-0.2, -0.06, 0.27},      r = {-4, 175, nil},      s = {1.25} },
    seeds                       = { m = {-0.025, -0.07, -0.01} },
    pitcher_pod                 = { m = {-0.025, -0.07, -0.01} },
    torchflower_seeds           = { m = {-0.025, -0.1, -0.01} },
    cocoa_beans                 = { m = {0.18, -0.275, 0.145},    r = {0.5, -21.5, -1},    s = {1.7} },
    nether_wart                 = { m = {0.105, 0.015, 0.085},    r = {nil, -23.5, nil} },
    seagrass                    = { m = {0.08, 0.015, 0.085},     r = {nil, -23.5, nil} },
    kelp                        = { m = {0.08, 0.015, 0.085},     r = {nil, -23.5, nil} },
    lily_pad                    = { m = {-0.02, -0.01, -0.11},    r = {90, nil, nil},      s = {1, 1, 0.385} },
    sea_pickle                  = { m = {0.155, nil, 0.05},       r = {nil, -23.5, nil},   s = {1.5} },
    ground_cover                = { m = {nil, -0.19, -0.05},      r = {-72.5, 0.5, -1} },
    azaleas                     = { m = {0.105, -0.085, -0.065} },
    -- Functional Blocks
    froglights                  = { m = {-0.04, nil, 0.025} },
    shulker_boxes               = { m = {-0.04, nil, 0.025} },
    campfires                   = { m = {0.21, -0.085, -0.095},   r = {-4, -5.5, -1},      s = {1.25} },
    lightning_rods              = { m = {0.18, -0.1, 0.02},       r = {-1, -23, nil},      s = {1.3} },
    torches                     = { m = {0.08, -0.15, -0.075},    r = {-4.5, -5, -1},      s = {1.38} },
    end_rod                     = { m = {0.195, -0.025, 0.03},    r = {nil, -24, nil},     s = {1.5} },
    grindstone                  = { m = {0.215, 0.365, -0.08},    r = {90, nil, 22.5},     s = {1.35} },
    furnaces                    = { m = {-0.305, nil, 0.27},      r = {-180, nil, 180} },
    lectern                     = { m = {-0.305, nil, 0.27},      r = {-180, nil, 180} },
    barrel                      = { m = {-0.305, nil, 0.27},      r = {-180, nil, 180} },
    anvils                      = { m = {-0.11, -0.08, -0.13},    r = {10, 84.5, -16} },
    brewing_stand               = { m = {-0.11, -0.08, -0.13},    r = {10, 84.5, -16} },
    end_crystal                 = { m = {-0.125, -0.065, 0.23},   r = {nil, -29.5, nil} },
    conduit                     = { m = {0.275, -0.285, -0.125},      r = {-5.5, -6, -1},      s = {1.9} },
    scaffolding                 = { m = {0.13, -0.265, 0.025},    r = {nil, -23, nil} },
    flower_pot                  = { m = {0.19, -0.035, 0.05},     r = {-1.5, -24, nil},    s = {1.4} },
    wooden_shelves              = { m = {-0.315, -0.005, 0.28},   r = {0.5, 157, nil} },
    hanging_signs               = { m = {0.06, -0.745, 0.19},     r = {-29, -5.5, -1} },
    signs                       = { m = {-0.02, nil, 0.015} },
    ender_items                 = { m = {-0.045, nil, 0.03} },
    copper_golem_statues        = { m = {-0.005, 0.515, -0.385},  r = {175.5, -131.5, -3}, s = {1.4} },
    lanterns                    = { m = {0.035, -0.585, 0.095},   r = {-21.5, nil, nil} },
    glow_item_frame             = { m = {nil, -0.53, 0.225},      r = {-37, nil, nil} },
    item_frame                  = { m = {-0.01, -0.535, 0.175},   r = {-29, nil, nil} },
    painting                    = { m = {-0.025, -0.62, 0.155},   r = {-25, nil, nil} },
    bell                        = { m = {-0.105, -0.61, 0.19},    r = {-18.5, -27.5, -7.5}, s = {1.2} },
    armor_stand                 = { m = {0.015, 0.03, nil} },
    cauldron                    = { m = {0.165, -0.16, -0.07},    r = {-5.5, -4.5, nil} },
    -- Redstone Blocks
    minecarts                   = { m = {-0.055} },
    pistons                     = { m = {-0.33, 0.03, 0.29},      r = {nil, 180, nil} },
    repeater                    = { m = {0.2, -0.075, -0.065},    r = {-5.5, -6, -0.5},     s = {1.25} },
    comparator                  = { m = {0.2, -0.075, -0.065},    r = {-5.5, -6, -0.5},     s = {1.25} },
    lever                       = { m = {-0.47, -0.06, -0.1},     r = {nil, 100, nil},      s = {2} },
    buttons                     = { m = {0.235, -0.105, -0.115},  r = {-7, -6, -0.5},       s = {1.4} },
    hopper                      = { m = {0.18, -0.09, -0.085},    r = {-5.5, -5.5, nil} },
    string                      = { m = {-0.05, -0.005, 0.015} },
    rails                       = { m = {0.165, -0.085, -0.09},   r = {-5.5, -5, -1.5} },
    crafter                     = { m = {-0.305, nil, 0.27},      r = {-180, nil, 180} },
    chiseled_bookshelf          = { m = {-0.305, nil, 0.27},      r = {-180, nil, 180} },
    -- Tools & Utilities
    fishing_rod                 = { m = {0.02, 0.04, -0.035},     r = {nil, -5.5, nil} },
    carrot_on_a_stick           = { m = {0.02, 0.04, -0.035},     r = {nil, -5.5, nil} },
    warped_fungus_on_a_stick    = { m = {0.02, 0.075, -0.07},     r = {nil, -5.5, nil} },
    pickaxes                    = { m = {0.025, -0.115, -0.04},   r = {nil, -8.5, nil} },
    axes                        = { m = {0.025, -0.115, -0.06},   r = {nil, -8.5, nil} },
    hoes                        = { m = {0.025, -0.115, -0.06},   r = {nil, -8.5, nil} },
    shovels                     = { m = {0, -0.165, 0.01},        r = {-4, 5, -12.5} },
    flint_and_steel             = { m = {-0.105, nil, nil} },
    fire_charge                 = { m = {-0.025, -0.035, 0.03} },
    shears                      = { m = {0.03, -0.075, -0.065},   r = {-55, -4, 50} },
    brush                       = { m = {nil, nil, 0.1},          s = {0.7} },
    bundles                     = { m = {-0.05, nil, 0.02} },
    recovery_compass            = { m = {-0.01, nil, nil} },
    compass                     = { m = {-0.005, -0.04, -0.005} },
    spyglass                    = { m = {-0.12, nil, 0.015},      r = {nil, -24.5, nil} },
    map                         = { m = {nil, -0.035, nil} },
    paper                       = { m = {nil, -0.035, nil} },
    bookshelf_books             = { m = {-0.065, -0.035, nil} },
    music_disc_11               = { m = {-0.01, -0.07, -0.005} },
    music_discs                 = { m = {-0.01, -0.07, 0.02} },
    wind_charge                 = { m = {-0.01, -0.07, 0.02} },
    elytra                      = { m = {nil, -0.07, nil} },
    firework_rocket             = { m = {-0.06, nil, 0.025} },
    saddle                      = { m = {-0.06, -0.04, 0.01} },
    boats                       = { m = {-0.04, 0.115, 0.025} },
    chest_boats                 = { m = {-0.04, 0.115, 0.025} },
    goat_horn                   = { m = {0.025, -0.04, nil} },
    -- Combat
    horse_armors                = { m = {0.02, -0.04, nil} },
    nautilus_armors             = { m = {-0.04, -0.075, -0.005} },
    swords                      = { m = {0.01, nil, -0.025},      r = {nil, -5, nil} },
    mace                        = { m = {0.025, -0.06, -0.025},   r = {nil, -5, nil} },
    shield                      = { m = {-0.035, 0.06, 0.005},    r = {-1.5, -22.5, nil}, s = {0.8, 1, 1} },
    head_armor                  = { m = {nil, -0.11, -0.005} },
    foot_armor                  = { m = {nil, -0.11, -0.005} },
    leg_armor                   = { m = {nil, -0.035, -0.005} },
    wolf_armor                  = { m = {-0.005, -0.285, -0.015} },
    snowball                    = { m = {nil, -0.06, nil} },
    eggs                        = { m = {nil, -0.06, nil} },
    arrows                      = { m = {nil, -0.09, -0.02} },
    bow                         = { m = {-0.03, nil, 0.07},       r = {nil, -25.5, -10.5} },
    crossbow                    = { m = {-0.12, 0.085, 0.065},    r = {nil, -11, nil} },
    -- Foods & Drinks
    potatoes                    = { m = {nil, -0.04, 0.015} },
    bowl_foods                  = { m = {nil, -0.075, -0.015} },
    bottles_drink               = { m = {-0.025, nil, nil} },
    muttons                     = { m = {l == 1 and 0 or -0.07, nil, nil} },
    sweet_berries               = { m = {nil, nil, 0.05} },
    chorus_fruit                = { m = {-0.04, nil, nil} },
    carrots                     = { m = {nil, -0.075, nil} },
    beetroot                    = { m = {nil, -0.105, nil} },
    rabbits                     = { m = {nil, -0.105, nil} },
    fishes                      = { m = {nil, -0.065, nil} },
    pufferfish                  = { m = {-0.025, -0.045, -0.01} },
    bread                       = { m = {nil, 0.03, 0.01} },
    cookie                      = { m = {nil, -0.035, nil} },
    spider_eyes                 = { m = {-0.055, -0.04, nil} },
    cake                        = { m = {0.2, -0.095, -0.085},    r = {-6.5, -5, -1}, s = {1.2} },
    lingering_potion            = { m = {-0.025, nil, 0.03} },
    splash_potion               = { m = {-0.025, nil, 0.03} },
    ominous_bottle              = { m = {0.015, nil, nil} },
    -- Ingredients
    ingots                      = { m = {-0.065, -0.075, nil} },
    bricks                      = { m = {-0.065, -0.075, nil} },
    raw_materials               = { m = {nil, -0.035, -0.01} },
    emerald                     = { m = {nil, -0.035, nil} },
    lapis_lazuli                = { m = {nil, -0.035, nil} },
    amethyst_shard              = { m = {nil, -0.05, nil} },
    nuggets                     = { m = {0.02, -0.07, -0.01} },
    blaze_rod                   = { m = {0.02, -0.24, -0.005},    r = {9, -7, nil} },
    breeze_rod                  = { m = {0.02, -0.24, -0.005},    r = {9, -7, nil} },
    stick                       = { m = {-0.01, -0.28, nil},      r = {15.5, nil, nil} },
    bone                        = { m = {nil, -0.39, nil},        r = {15.5, nil, nil} },
    ink_sacs                    = { m = {nil, -0.075, -0.01} },
    honeycomb                   = { m = {0.01, -0.04, nil} },
    resin_clump                 = { m = {-0.01, -0.075, nil} },
    scutes                      = { m = {nil, -0.105, -0.01} },
    disc_fragment_5             = { m = {nil, -0.105, -0.01} },
    balls                       = { m = {nil, -0.04, nil} },
    prismarine_shard            = { m = {-0.03, nil, nil} },
    prismarine_crystals         = { m = {-0.03, -0.075, nil} },
    nether_star                 = { m = {-0.02, nil, nil} },
    heavy_core                  = { m = {0.275, -0.12, -0.125},   r = {-5.5, -5, -1.5}, s = {1.75} },
    popped_chorus_fruit         = { m = {-0.005, -0.035, -0.015} },
    echo_shard                  = { m = {nil, nil, -0.01} },
    firework_star               = { m = {nil, -0.04, -0.01} },
    powders                     = { m = {-0.02, -0.02, 0.015} },
    rabbit_foot                 = { m = {-0.02, -0.02, 0.015} },
    ghast_tear                  = { m = {nil, -0.105, nil} },
    smithing_templates          = { m = {-0.02, nil, 0.02} },
    -- Spawn Eggs
    spawn_eggs                  = { m = {-0.01, -0.04, nil} }
}
if not itemCompat then
    local entry = positions[itemName] or positions[tag]
    if entry then
        if entry.m then move(entry.m[1], entry.m[2], entry.m[3])   end
        if entry.r then rotate(entry.r[1], entry.r[2], entry.r[3]) end
        if entry.s then scale(entry.s[1], entry.s[2], entry.s[3])  end
    end
end

-- === PHYSICS AND ANIMATIONS ===
-- Extracted from the HMI example_pack (item_Pose.lua)
-- Credits: thesapling, OrkaMC, cyber, Axolotl

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
global.foodCount            = 0.0;
global.foodCountO           = 0.0;
global.swordSwingCycle      = 0;
global.swordAttack          = false;

local swing_rot
local swing_sword_tilt
local swing_hit_second
local GRAVITY               = 0.04
local DAMPING               = 0.85
local INTENSITY             = 0.15
local dt                    = deltaTime * 30
local playerSpeed           = P:getSpeed(player)
local playerPitch           = P:getPitch(player)
local playerYaw             = P:getYaw(player)
local playerAge             = P:getAge(player)
local sp                    = I:getUseAction(P:getMainItem(player)) == "spear" and 1 or 0
local spo                   = I:getUseAction(P:getOffhandItem(player)) == "spear" and 1 or 0
local sc                    = mainHand and spearCounterM or spearCounterO
local scd                   = mainHand and canDismountCounter or canDismountCounterO
local sck                   = mainHand and canKnockbackCounter or canKnockbackCounterO
local sw                    = mainHand and mainHandSwitch or offHandSwitch
local hic                   = mainHand and Easings:easeInOutSine(hitImpactCounter) or hitImpactCounterO
local swing                 = M:sin(swingProgress * 3.14)
local swing_hit             = M:sin(M:clamp(swingProgress, 0.16561, 0.49422) * 4.78 * 2 + 4.7)
local swingOverall          = M:sin(swingProgress * 3.14)
local useAction             = I:getUseAction(item)
local isUsingItem           = P:isUsingItem(player)

if useAction == "spear" and itemName == "trident" then
    useAction = "trident"
end

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
		particles,
		false,
		x, y, z,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 1.3,
		Texture:of("minecraft", texture),
		"ITEM", hand,
		"SPAWN", "ADDITIVE",
		0, 200 + (20 * M:sin(playerAge * 0.2))
	)
end

local function particle(x, y, z, texture, size, tick)
	particleManager:addParticle(
		particles, true,
		x, y, z,
		(math.random() * 0.12 - 0.06) * l, math.random() * 0.12,
		0, 0, 0, 0, 0, 0, 0, size or 0.4,
		Texture:of("minecraft", texture),
		"SCREEN", hand,
		"OPACITY", "TRANSLUCENT_L",
		1, 255, tick
	)
end

local function posInHands(main, off)
    return l == 1 and main or off
end

-- == CALC ==
local isSword        = matched({"swords"})
local isShovel       = matched({"shovels"})
local isAxe          = matched({"axes"})
local isHangingSign  = matched({"hanging_signs"})
local isPickaxe      = matched({"pickaxes"})
local isNugget       = matched({"nuggets"})
local isMusicDisc    = matched({"music_discs"})
local isSpear        = matched({"spears"})
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
pitchSpeed = pitchSpeed + ((playerSpeed * 22 * walkSmoother * -1) - (M:sin(mainHandSwingProgress * 3.14)) * 8 + fall * 3 + M:sin(sneak * 3.14) * 0.3 + (playerPitch - prevPitch)) * INTENSITY * dt
if useAction == "block" and mainHand and not isSword then
    pitchSpeed = pitchSpeed + 10 * M:sin(shieldDisable * 3.14) * INTENSITY * dt
    pitchSpeed = pitchSpeed + 12 * M:sin(shieldM      * 3.14) * INTENSITY * dt
end
pitchSpeed = pitchSpeed + ((-20 * M:sin(canDismountCounter   * 3.14) * spearCounterM) + (20 * M:sin(canKnockbackCounter * 3.14) * spearCounterM) + (12 * M:sin(inspectionCounter * 3.14)) + (15 * M:sin(spearCounterM       * 3.14)) + (-10 * M:clamp(M:sin(Easings:easeInBack(hitImpactCounter) * 6.28), 0, 1)) + ( 40 * M:clamp(M:sin(M:clamp(mainHandSwitch * 1.5 * sp, 0, 1) * 6.28), 0, 1))) * INTENSITY * dt
pitchSpeed = pitchSpeed - GRAVITY * pitchAngle * dt
pitchSpeed = pitchSpeed * M:pow(DAMPING, dt)
pitchAngle = pitchAngle + pitchSpeed * dt

pitchSpeedO = pitchSpeedO + ((playerSpeed * 22 * walkSmoother * -1) - (M:sin(offHandSwingProgress * 3.14)) * 8 + fall * 3 + M:sin(sneak * 3.14) * 0.3 + (playerPitch - prevPitch)) * INTENSITY * dt
if useAction == "block" and not mainHand and not isSword then
    pitchSpeedO = pitchSpeedO + 10 * M:sin(shieldDisable * 3.14) * INTENSITY * dt
    pitchSpeedO = pitchSpeedO + 12 * M:sin(shieldO      * 3.14) * INTENSITY * dt
end
pitchSpeedO = pitchSpeedO + ((-20 * M:sin(canDismountCounterO   * 3.14) * spearCounterO) + (20 * M:sin(canKnockbackCounterO * 3.14) * spearCounterO) + (15 * M:sin(spearCounterO * 3.14)) + ( 40 * M:clamp(M:sin(M:clamp(offHandSwitch * 1.5 * spo, 0, 1) * 6.28), 0, 1))) * INTENSITY * dt
pitchSpeedO = pitchSpeedO - GRAVITY * pitchAngleO * dt
pitchSpeedO = pitchSpeedO * M:pow(DAMPING, dt)
pitchAngleO = pitchAngleO + pitchSpeedO * dt

-- Yaw
yawSpeed = yawSpeed + (M:sin(walk) * 3 * walkSmoother+ (M:sin(mainHandSwingProgress * 3.14)) * 8+ M:sin(swimCounter * swimSmoother) * 3+ M:sin(mainHandSwitch * 6.28) * 3+ playerYaw - prevYaw) * INTENSITY * dt
yawSpeed = yawSpeed - GRAVITY * yawAngle * dt
yawSpeed = yawSpeed * M:pow(DAMPING, dt)
yawAngle = yawAngle + yawSpeed * dt

yawSpeedO = yawSpeedO + (M:sin(walk) * 3 * walkSmoother + (M:sin(offHandSwingProgress * 3.14)) * 8 + M:sin(swimCounter * swimSmoother) * 3 + M:sin(offHandSwitch * 6.28) * 3 + playerYaw - prevYaw) * INTENSITY * dt
yawSpeedO = yawSpeedO - GRAVITY * yawAngleO * dt
yawSpeedO = yawSpeedO * M:pow(DAMPING, dt)
yawAngleO = yawAngleO + yawSpeedO * dt

local ywAngle   = (mainHand and yawAngle) or yawAngleO
local ptAngle   = (mainHand and pitchAngle) or pitchAngleO

-- == SWING ANIMATIONS ==
if isPickaxe then
    swingProgress = easeCustom(swingProgress)
else
    swingProgress = easeCustomSec(swingProgress)
end

if swingProgress < 0.70016 then
    swing_rot = M:sin(M:clamp(swingProgress, 0, 0.308) * 5.1)
else
    swing_rot = M:sin(M:clamp(swingProgress, 0.70016, 1) * 5.1 - 2)
end

if swingProgress < 0.65245 then
    swing_sword_tilt = M:sin(M:clamp(swingProgress, 0, 0.16675) * 3.14 * 3)
else
    swing_sword_tilt = M:sin(M:clamp(swingProgress, 0.65245, 1) * 4.4 - 1.3)
end

swing_rot = swing_rot * swing_rot * swing_rot

if swingProgress < 0.65594 then
    swing_hit_second = M:sin(M:clamp(swingProgress, 0.16561, 0.32991) * 4.78 * 2 + 4.7)
else
    swing_hit_second = M:sin(M:clamp(swingProgress, 0.65594, 0.82025) * 4.78 * 2 - 4.7)
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
        if itemName == "trident" or useAction == "spear" then
            M:moveZ(mat, -0.1 * swing_rot)
            M:moveY(mat, -0.05 * swing_rot)

            if useAction == "spear" then
                M:moveY(mat, -0.15 * swing_hit)
                M:rotateX(mat, -5 * swing_hit)
            end

            M:rotateX(mat, -10 * swing_rot)
            M:rotateX(mat, -15 * swing_hit)

            if itemName == "trident" then
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
        M:moveZ(mat, 0.05 * swing_sword_tilt)
        M:moveY(mat, 0.2 * swing_sword_tilt)
        M:rotateX(mat, 10 * swing_sword_tilt)
        M:rotateX(mat, -30 * swingOverall)
        M:rotateX(mat, 20 * swing_rot)
        M:rotateX(mat, 10 * swing_hit_second)
    end

    if isSword and not (beashAnimations or nneSwords) then
        M:sin(swingProgress * 3.14)
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
		elseif itemName == "bell" and not a3ds then
			M:moveX(mat, 0.15 * l)
			M:moveY(mat, -0.05)
			M:moveZ(mat, -0.1)
			M:scale(mat, 1.2, 1.2, 1.2)
			M:rotateX(mat, M:clamp(playerPitch / 2.5, -20, 90) + ptAngle, -0.1 * l, 0.4, 0.1)
			M:rotateZ(mat, ywAngle * -1, -0.1 * l, 0.4, 0.1)
        elseif not (refinedTorches or rvTorches or w3di) then
			M:rotateX(mat, M:clamp(playerPitch / 2.5, -20, 90) + ptAngle, 0, 0.4, 0)
			M:rotateZ(mat, ywAngle * -1, 0, 0.4, 0)
		end
	end
	if isHangingSign then
		M:rotateX(mat, M:clamp(playerPitch / 2.5, -35, 90) + ptAngle, 0, 0.55, 0)
		M:rotateZ(mat, ywAngle * -1, 0, 0.55, 0)
	end
elseif itemName == "painting" or itemName == "item_frame" or (itemName == "glow_item_frame" and not a3ds) then
	swingProgress = 0
    if a3ds then
        M:rotateX(mat, -25)
        M:moveY(mat, -0.65)
    end
	M:rotateX(mat, M:clamp(playerPitch / 2.5, -25, 90) + ptAngle, 0, 0.45, 0)
	M:rotateZ(mat, ywAngle * -1, 0, 0.55, 0)
else
	if
		not I:isBlock(item)
		and not I:isEmpty(item)
		and useAction == "none"
		and useAction ~= "crossbow"
	then
		if isAxe or itemName == "mace" then
			local ptAngleMultiplier = (itemName == "mace" and 0.2) or 0.15
			M:rotateX(mat, -20 * M:sin(equipProgress * equipProgress * equipProgress) + (ptAngle * ptAngleMultiplier), 0.3 * l, -0.3, 0)
		else
			M:rotateX(mat, -20 * M:sin(equipProgress * equipProgress * equipProgress) + (ptAngle * 0.05), 0.3 * l, -0.4, 0)
		end
	end
	if (isAxe or itemName == "mace") and useAction ~= "crossbow" then
		M:rotateX(mat, (playerPitch * -0.05) + ptAngle * 0.2, 0, -0.2, 0)
	elseif useAction ~= "crossbow" then
		M:rotateX(mat, (playerPitch * -0.025) + ptAngle * 0.1, 0, -0.2, 0)
	end
end

-- == EAT & DRINK ANIMATION ==
global.progress = 0.0;
progress = mainHand and foodCount or foodCountO

local foodDefault   = w3di or w3Dfoods or freshFoods
local drinkDefault  = (w3di and itemName ~= "milk_bucket") or refinedBuckets
local tootHorn      = useAction == "toot_horn"
local square        = progress * progress

local function eatDrinkDefault()
    if (useAction == "drink" or useAction == "eat" or useAction == "toot_horn") and mainHand then
        M:moveX(mat, 0.02 * l * foodCount)
        M:moveZ(mat, -0.05 * foodCount)
        if useAction == "eat" or useAction == "toot_horn" then
            M:rotateX(mat, -23 * foodCount * foodCount)
            M:rotateZ(mat, -12 * l * foodCount * foodCount)
        end
        M:rotateY(mat, -50 * l * foodCount * foodCount)

        if useAction == "drink" then
            M:rotateX(mat, 15 * foodCount * foodCount)
        end
    end

    if (useAction == "drink" or useAction == "eat" or useAction == "toot_horn") and not mainHand then
        M:moveX(mat, 0.02 * l * foodCountO)
        M:moveZ(mat, -0.05 * foodCountO)
        if useAction == "eat" or useAction == "toot_horn" then
            M:rotateX(mat, -23 * foodCountO * foodCountO)
            M:rotateZ(mat, -12 * l * foodCountO * foodCountO)
        end
        M:rotateY(mat, -50 * l * foodCountO * foodCountO)

        if useAction == "drink" then
            M:rotateX(mat, 15 * foodCountO * foodCountO)
        end
    end
end

local function drink()
    M:rotateY(mat, posInHands(-45, -50) * l * square)
    if itemName == "milk_bucket" then
        M:moveZ(mat, -0.25 * progress)
        M:moveX(mat, -0.02 * l * progress)
        M:moveY(mat, 0.13 * progress)
        M:scale(mat, 0.8, 0.8, 0.8)
    else
        M:moveZ(mat, 0.05 * progress)
        M:moveX(mat, 0.03 * l * progress)
    end
    M:rotateX(mat, posInHands(10, 18) * square)
end

local function eat()
    M:moveY(mat, -0.05 * progress)
    M:moveZ(mat, 0.05 * progress)
    M:rotateY(mat, posInHands(-45, -60) * l * square)
    M:rotateX(mat, -25 * square)
end

local function eatDrinkAnimation(items, moveValues, rotateValues, scaleValues)
    local list = type(items) == "table" and items or {items}

    local function applyIndividualTransform()
        if moveValues then
            M:moveX(mat, (moveValues[1] or 0) * progress * l)
            M:moveY(mat, (moveValues[2] or 0) * progress)
            M:moveZ(mat, (moveValues[3] or 0) * progress)
        end
        if rotateValues then
            M:rotateX(mat, (rotateValues[1] or 0) * square)
            M:rotateY(mat, (rotateValues[2] or 0) * square * l)
            M:rotateZ(mat, (rotateValues[3] or 0) * square * l)
        end
        if scaleValues then
            if scaleValues[1] ~= nil and scaleValues[2] == nil and scaleValues[3] == nil then
                M:scale(mat, scaleValues[1], scaleValues[1], scaleValues[1])
            else
                M:scale(mat, scaleValues[1] or 1, scaleValues[2] or 1, scaleValues[3] or 1)
            end
        end
    end
    local function applyTransform()
        if drinkDefault or foodDefault or tootHorn then
            eatDrinkDefault()
        end

        if useAction == "drink" then
            if not drinkDefault then drink() end
            applyIndividualTransform()
        elseif useAction == "eat" then
            if not foodDefault then eat() end
            applyIndividualTransform()
        elseif useAction == "toot_horn" then
            applyIndividualTransform()
        end
    end
    if isUsingItem and (useAction == "eat" or useAction == "drink" or useAction == "toot_horn") then
        if items == "general" then
            applyTransform()
        else
            for _, i in ipairs(list) do
                if i == itemName or i == tag then
                    applyTransform()
                end
            end
        end
    end
end

local individualAnimationAdjusts = {
    -- packs
    {
        w3di and not refinedBuckets,
        items = {"milk_bucket"}, moveValues = {posInHands(-0.2, -0.1), 0, posInHands(0.3, 0.35)}, rotateValues = {posInHands(0, -10), 20, 0}, scaleValues = {0.85}
    },
    {
        w3di and refinedBuckets,
        items = {"milk_bucket"}, moveValues = {-0.05, 0.22, -0.15}, rotateValues = {5, 0, 0}, scaleValues = {0.7}
    },
    -- without packs
    {
        not (refinedBuckets or w3di),
        items = {"milk_bucket"}, moveValues = {posInHands(0.08, 0.02), 0, -0.05}, rotateValues = {0, posInHands(-10, -5), 0}
    },
    {
        not (w3di or a3ds),
        items = {"goat_horn"}, moveValues = {0.14, nil, nil}
    }
}

local animated = false
for _, adj in ipairs(individualAnimationAdjusts) do
    if adj[1] then
        for _, i in ipairs(adj.items) do
            if i == itemName or i == tag then
                eatDrinkAnimation(adj.items, adj.moveValues, adj.rotateValues, adj.scaleValues)
                animated = true
                break
            end
        end
    end
    if animated then break end
end
if not animated then
    eatDrinkAnimation("general")
end

global.foodCount = 0.0;
global.foodCountO = 0.0;

local easedFoodCounter = Easings:easeInQuart(mainHand and foodCount or foodCountO)

-- == BRUSH ANIMATION ==
if useAction == "brush" then
	if mainHand then
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

prevPitch   = P:getPitch(player)
prevYaw     = P:getYaw(player)

if itemName == "magma_cream" then
    M:scale(mat, 1 - (fall / 5), 1 + (fall / 5), 1)
end

-- == SWITCH ANIMATION ==
local activeSwitch              = mainHand and mainHandSwitch or offHandSwitch
local switchEvent               = mainHand and mainHandSwitchEvent or offHandSwitchEvent
local switchAnimationVariable   = Easings:easeInBack(M:sin(M:clamp(activeSwitch, 0.09723, 0.60632) * 5.346 - 0.1))

if
	(
		matched({"bundles", "skulls", "music_discs", "nuggets", "ender_pearl", "ender_eye"})
        or (glowing3Darmors and matched({"head_armor"}))
		or I:isThrowable(item)
	) and itemName ~= "trident"
then
    M:rotateX(mat, -10 * switchAnimationVariable)
    M:moveY(mat,  0.62 * switchAnimationVariable)
    M:moveY(mat,  M:clamp(0.1 * fall, 0, 255))

    local eased = Easings:easeInOutBack(M:clamp(activeSwitch * 1.65, 0, 1))

    if isNugget then
        if switchEvent then S:playSound("entity.experience_orb.pickup", 0.3) end
        M:moveY(mat, -0.07)
        M:rotateX(mat, 360 * Easings:easeInOutBack((mainHand and M:clamp(mainHandSwitch * 1.65, 0, 1)) or M:clamp(offHandSwitch * 1.65, 0, 1)), 0, 0.1, 0)
    elseif isMusicDisc then
        if switchEvent then S:playSound("entity.context.player.attack.weak", 0.3) end
        M:rotateZ(mat, 360 * eased, -0.1 * l, 0.25, 0)

    else
        if switchEvent then S:playSound("entity.context.player.attack.weak", 0.3) end
        local clampedSwitch = M:clamp(activeSwitch * 1.2, 0, 1)
        M:rotateZ(mat, -7 * l * M:sin(M:clamp(clampedSwitch, 0.0943, 0.66791) * 10.605 - 0.8))
    end
end

if (mainHand and mainHandSwitchEvent) or offHandSwitchEvent then
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
if not (refinedBuckets or rvTorches or refinedTorches ) then
    if not w3di then
        if itemName == "torch" 		            then glow(0.5 * l, 0.6, 0.5, "textures/particle/orange_glow.png")       end
        if itemName == "copper_torch" 	        then glow(0.5 * l, 0.6, 0.5, "textures/particle/copper_glow.png")       end
        if itemName == "soul_torch" 			then glow(0.5 * l, 0.6, 0.5, "textures/particle/blue_glow.png")         end
        if itemName == "redstone_torch" 		then glow(0.5 * l, 0.6, 0.5, "textures/particle/red_glow.png")          end
        if itemName == "lantern" 				then glow(0.45 * l, 0.15, 0.5, "textures/particle/orange_glow.png")     end
        if itemName == "soul_lantern" 			then glow(0.45 * l, 0.15, 0.5, "textures/particle/blue_glow.png")       end
        if itemName:match("copper_lantern") 	then glow(0.45 * l, 0.15, 0.5, "textures/particle/copper_glow.png")     end
        if itemName == "lava_bucket" 			then glow(-0.05 * l, 0, 0, "textures/particle/orange_glow.png")         end
    else
        if itemName == "torch" 		            then glow(0.5 * l, 0.6, 0.5, "textures/particle/orange_glow.png")       end
        if itemName == "copper_torch" 	        then glow(0.5 * l, 0.6, 0.5, "textures/particle/copper_glow.png")       end
        if itemName == "soul_torch" 			then glow(0.5 * l, 0.6, 0.5, "textures/particle/blue_glow.png")         end
        if itemName == "redstone_torch" 		then glow(0.5 * l, 0.6, 0.5, "textures/particle/red_glow.png")          end
        if itemName == "lantern" 			    then glow(0.05 * l, -0.2, -0.2, "textures/particle/orange_glow.png")    end
        if itemName == "soul_lantern" 		    then glow(0.05 * l, -0.2, -0.2, "textures/particle/b_glow.png")         end
        if itemName:match("copper_lantern")     then glow(0.05 * l, -0.2, -0.2, "textures/particle/copper_glow.png")    end
    end
end

if swingCountPrev ~= P:getSwingCount(player) and mainHand and itemName == "bell" then
	S:playSound("block.bell.use", 0.3)
end
swingCountPrev = P:getSwingCount(player)

if itemName == "pink_petals" or itemName == "wildflowers" or itemName == "leaf_litter" then
	local particle_ticker = function(p)
		p.dx = p.dx + 0.005 * M:sin(playerAge * 0.3) * dt
	end
	local flower = ""
	if itemName == "wildflowers" then flower = "wild_flowers" else flower = itemName end

	if swingMHandPrev ~= swingMHand and mainHand then
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
if mainHand then swingMHandPrev = swingMHand else swingOHandPrev = swingOHand end

-- == SWING SPEED ==
if HMIversion == "5.1+" then
    if isSpear                                      then itemSwingSpeed:put(I:getName(item), 15) end
    if isShovel                                     then itemSwingSpeed:put(I:getName(item), 14) end
    if itemName == "trident" or itemName == "mace"  then itemSwingSpeed:put(I:getName(item), 12) end
end

-- == TRIDENT AND SPEAR ==
if useAction == "trident" and HMIversion == "5.1+" then
    M:moveX(mat, 0.1 * Easings:easeOutBack(M:clamp(tridentM * 1.5, 0, 1)))
    M:moveX(mat, -0.03 * l)
    M:rotateZ(mat, 170 * l * Easings:easeOutBack(M:clamp(mainHand and tridentM or tridentMO * 1.5, 0, 1)))
    M:rotateY(mat, 40 * l)
    M:rotateX(mat, -90 * Easings:easeOutBack(M:sin(mainHand and riptideCounter or riptideCounterO * 3.14)))
    M:rotateZ(mat, -45 * l * Easings:easeOutBack(M:sin(mainHand and riptideCounter or riptideCounterO * 3.14)))
end

if useAction == "spear" then
    M:moveZ(mat, -0.1)
    M:rotateY(mat, 10 * l)
end

-- == BOW STATE ==
local easedBowSec  = Easings:easeOutBack(bowCountSec)
local easedBowSecO = Easings:easeOutBack(bowCountSecO)
local bc           = mainHand and easedBowSec or easedBowSecO

if HMIversion == "5.1+" then
    usingItem:put("minecraft:bow",    bc >= 0.1)
    useDuration:put("minecraft:bow",  Easings:cubicEase(bc) * 20) 
end

-- == INSPECT ANIMATION ==
if KeyBindManager:isKeyPressed(${inspectKeybind} ~= 0 and ${inspectKeybind} or 67) then
    inspectionSpin = inspectionSpin + 0.025 * dt
else
    inspectionSpin = 0
end
inspectionSpin = M:clamp(inspectionSpin, 0, 1)

if isSword or isPickaxe or isAxe or useAction == "trident" and mainHand then
    M:moveX(mat, -0.2 * l * inspectionCounter)
    M:rotateX(mat, -360 * Easings:easeInOutBack(inspectionSpin), 0, 0, 0.15)
end
prevAge = P:getAge(player)

-- == SOME POSITIONS ==
if tag == "buckets" then
    M:moveX(mat, -0.05 * l)
    M:rotateX(mat, -8)
    M:rotateY(mat, -10 * l)
    M:rotateZ(mat, 6 * l)
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
    if not (w3di or refinedBuckets) then
        move(0.015, 0.085, -0.065)
        rotate(nil, -6.5, nil)
        scale(1.1)
    end
end

if
    I:isOf(item, Items:get("bucket_of_frog:frog_bucket_cold"))
    or I:isOf(item, Items:get("bucket_of_frog:frog_bucket_warm"))
    or I:isOf(item, Items:get("bucket_of_frog:frog_bucket_temperate"))
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