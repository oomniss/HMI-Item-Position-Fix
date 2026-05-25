-- by omnis._.

local mat         = context.matrices
local l           = context.mainHand and 1 or -1
local itemName    = I:getName(context.item):gsub("minecraft:", "")
local skinModel   = (${skinModel} and "Alex") or "Steve"

-- === FUNCTIONS ===
if not ItemsTag or not ItemsTag.default or not ItemsTag.registry or not Tags then
    return
end
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
local itemCompat = getitemCompat()

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

local function renderBlock(render, items)
    if itemCompat then return end

    for _, i in ipairs(items) do
        if matched(i) then
            renderAsBlock:put(I:getName(context.item), render)
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
            M:scale(mat, x or 0, y or 0, z or 0)
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
    aliumove                    = { m = {0.1, nil, -0.045},       s  = {1.4} },
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
    swords                      = { m = {0.01, nil, -0.025},     r = {nil, -5, nil} },
    mace                        = { m = {0.025, -0.06, -0.025},   r = {nil, -5, nil} },
    shield                      = { m = {-0.035, 0.06, 0.005},    r = {-1.5, -22.5, nil}, s = {0.8, 1, 1} },
    head_armor                  = { m = {nil, -0.11, -0.005} },
    foot_armor                  = { m = {nil, -0.11, -0.005} },
    leg_armor                   = { m = {nil, -0.035, -0.005} },
    wolf_armor                  = { m = {-0.005, -0.285, -0.015} },
    snowball                    = { m = {nil, -0.06, nil} },
    eggs                        = { m = {nil, -0.06, nil} },
    arrows                      = { m = {nil, -0.09, 0.02} },
    bow                         = { m = {-0.095, nil, 0.07},       r = {nil, -25.5, -10.5} },
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

-- === HOLD MY ACTIONS ===
-- Extracted from the Hold My Actions resource pack (item_Pose.lua)
-- Credits: ZAIFIX

global.crossBowM            = 0.0;
global.swordAttack2         = 0;
global.swordAttack          = 0;
global.crossBowSecM         = 0.0;
global.crossBowO            = 0.0;
global.crossBowSecO         = 0.0;
global.walk                 = 0.0;
global.blockRender          = true;
global.walkSmoother         = 0.0;
global.swimSmoother         = 0.0;
global.swimCounter          = 0.0;
global.mainHandSwitch       = 0.0;
global.offHandSwitch        = 0.0;
global.swingCountPrev       = 0;
global.swingOHandPrev       = false;
global.swingMHandPrev       = false;
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
global.mainHandSwitch       = 0.0;
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

local GRAVITY               = 0.04
local DAMPING               = 0.85
local INTENSITY             = 0.15
local sp                    = I:getUseAction(P:getMainItem(context.player)) == "spear" and 1 or 0;
local spo                   = I:getUseAction(P:getOffhandItem(context.player)) == "spear" and 1 or 0;
local sc                    = context.mainHand and spearCounterM or spearCounterO
local scd                   = context.mainHand and canDismountCounter or canDismountCounterO
local sck                   = context.mainHand and canKnockbackCounter or canKnockbackCounterO
local sw                    = context.mainHand and mainHandSwitch or offHandSwitch
local hic                   = context.mainHand and Easings:easeInOutSine(hitImpactCounter) or hitImpactCounterO
local dt                    = context.deltaTime * 30
local playerSpeed           = P:getSpeed(context.player)
local playerPitch           = P:getPitch(context.player)
local playerYaw             = P:getYaw(context.player)
local playerAge             = P:getAge(context.player)
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

local function posInHands(mainHand, offHand)
    return context.mainHand and mainHand or offHand
end

-- == CALC ==
local isSword        = matched({"swords"})
local isShovel       = matched({"shovels"})
local isAxe          = matched({"axes"})
local isHangingSign  = matched({"hanging_signs"})
local isPickaxe      = matched({"pickaxes"})
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

local ywAngle = (context.mainHand and yawAngle) or yawAngleO
local ptAngle = (context.mainHand and pitchAngle) or pitchAngleO

-- == RESOURCE PACKS ==
local rvTorches         = ${rvTorches}
local refinedTorches    = ${refinedTorches}
local glowing3Darmors   = ${glowing3Darmors}
local a3ds              = ${a3ds}
local w3di              = ${w3di}
local w3Dfoods          = ${w3Dfoods}
local refinedBuckets    = ${refinedBuckets}
local freshFoods        = ${freshFoods}
local freshPlants       = ${freshPlants}
local gousPoses         = ${gousPoses}
local nneSwords         = ${nneSwords}
local beashAnimations   = ${beashAnimations}
local torchesPack       = rvTorches or refinedTorches
local foodPack          = freshFoods or w3di or w3Dfoods

-- == SWING ANIMATION ==
if isPickaxe then
    context.swingProgress = easeCustom(context.swingProgress)
else
    context.swingProgress = easeCustomSec(context.swingProgress)
end

local swing_rot
if context.swingProgress < 0.70016 then
    swing_rot = M:sin(M:clamp(context.swingProgress, 0, 0.308) * 5.1)
else
    swing_rot = M:sin(M:clamp(context.swingProgress, 0.70016, 1) * 5.1 - 2)
end

local swing_sword_tilt
if context.swingProgress < 0.65245 then
    swing_sword_tilt = M:sin(M:clamp(context.swingProgress, 0, 0.16675) * 3.14 * 3)
else
    swing_sword_tilt = M:sin(M:clamp(context.swingProgress, 0.65245, 1) * 4.4 - 1.3)
end

swing_rot             = swing_rot * swing_rot * swing_rot
local swing           = M:clamp(M:sin(context.swingProgress * 4.78), 0, 1)
local swing_hit       = M:sin(M:clamp(context.swingProgress, 0.16561, 0.49422) * 4.78 * 2 + 4.7)
local swingOverall    = M:sin(context.swingProgress * 3.14)

local swing_hit_second
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

if (useAction ~= "block" and useAction ~= "crossbow") or isSword or itemName == "stick" then
    M:moveZ(mat, -0.05 * swing_rot)
    M:moveY(mat, -0.05 * swing_rot)
    M:rotateX(mat, 10 * swing_rot)
    M:rotateX(mat, -30 * swing_rot)
    M:rotateX(mat, -10 * swing_hit)

    if not (isSword or itemName == "stick") then
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
        local mace_followUp = M:clamp((context.swingProgress - 0.5) * 20, 0, 1) * M:clamp((1 - context.swingProgress) * 4, 0, 1)
        M:moveY(mat, 0.12 * swing_sword_tilt)
        M:moveZ(mat, 0.1 * swing_sword_tilt)
        M:moveY(mat, 0.2 * swing_sword_tilt)
        M:moveZ(mat, -0.4 * swing_sword_tilt)
        M:rotateX(mat, 10 * swing_sword_tilt)
        M:moveZ(mat, 0.1 * swing_sword_tilt)
        M:rotateX(mat, -30 * swingOverall)
        M:rotateX(mat, -20 * swing_rot)
        M:rotateX(mat, -40 * swing_hit_second)
        M:rotateX(mat, -30 * swing_hit_second)
        M:rotateX(mat, 20 * swing_rot)
        M:rotateX(mat, 50 * swing_rot)
        M:rotateX(mat, 30 * mace_followUp)
    end
    if isSword or itemName == "stick" then
        swing = M:sin(context.swingProgress * 3.14)
        if nneSwingMode == 2 and swordAttack then
            M:moveY(mat, -0.1 * Easings:easeInOutBack(swing))
            M:moveZ(mat, 0.3 * Easings:easeInOutBack(swing))
            M:rotateX(mat, -30 * Easings:easeInOutBack(swing))
        else
            M:moveZ(mat, -0.05 * Easings:easeInOutBack(swing))
            M:moveY(mat, ${trident_item_y} * Easings:easeInOutBack(swing))
            M:rotateX(mat, ${trident_item_rx} * Easings:easeInOutBack(swing))
        end
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
    if a3ds then
        M:rotateX(mat, -25)
        M:moveY(mat, -0.65)
    end
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

-- == EAT AND DRINK ANIMATION ==
local function applyTransform(op, progress, exp, x, y, z)
    local t = M:pow(progress, exp)

    if x then op.x(x * t) end
    if y then op.y(y * t) end
    if z then op.z(z * t) end
end

local moves = {
    x = function(v) M:moveX(context.matrices, v * l) end,
    y = function(v) M:moveY(context.matrices, v) end,
    z = function(v) M:moveZ(context.matrices, v) end
}
local rotates = {
    x = function(v) M:rotateX(context.matrices, v) end,
    y = function(v) M:rotateY(context.matrices, v * l) end,
    z = function(v) M:rotateZ(context.matrices, v * l) end
}

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

    applyTransform(moves, progress, 1, 0.02, moveVals.y, moveVals.z)
    applyTransform(moves, progress, 1, moveVals.x, nil, nil)

    if use == "eat" or use == "toot_horn" then
        local ex = rotatePos and m(-23, rotatePos[1]) or -23
        local ez = rotatePos and m(-12, rotatePos[3]) or -12
        applyTransform(rotates, progress, 2,  ex,  nil,  ez)
    end

    applyTransform(rotates, progress, 2,  rotateVals.x,  rotateVals.y,  rotateVals.z)

    if use == "drink" then
        local dx = rotatePos and m(15, rotatePos[1]) or 15
        applyTransform(rotates, progress, 2,  dx,  nil,  nil)
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
        move = {0.15, 0.15, -0.15}, rotate = {nil, nil, -1.5}, scale = {0.8, 0.8, 0.8}
    },
    {
        pack = function() return w3di and not refinedBuckets end,
        items = {"milk_bucket"},
        move = {-0.07, 0.05, -0.11}, rotate = {-5, -85, 5}, scale = {0.6, 0.6, 0.6}
    },
    {
        pack = function() return w3Dfoods and not (w3di or freshFoods) end,
        transforms = {
            { {"apple", "chorus_fruit", "potato", "beetroot", "bread"}, m = {nil, nil, -0.05}, r = {0, 0, 0}, matches = true },
            { {"cookie", "melon_slice", "glow_berries", "dried_kelp", "beef", "porkchop", "mutton", "rotten_flesh"}, m = {nil, 0.1, -0.05}, r = {0, 0, 0}, matches = true },
            { {"soup", "stew"}, m = {nil, 0.12, -0.1}, r = {5, 0, 0}, matches = true },
            { {"pumpkin_pie"}, m = {nil, 0.1, -0.15}, r = {0, 0, 0} },
            { {"spider_eye"}, m = {0.05, nil, -0.05}, r = {0, 0, 0} },
            { {"carrot", "golden_carrot"}, m = {0.05, 0.15, 0}, r = {0, 0, 0} },
        }
    },
    -- Without packs
    {
        pack = function() return not (w3di or refinedBuckets) end,
        items = {"milk_bucket"},
        move = {0.25, 0.137, -0.3}
    },
    {
        pack = function() return not (w3di or refinedBuckets) and useAction == "drink" end,
        move = {-0.04, -0.015, nil}
    },
    {
        pack = function() return not (w3di or freshFoods) and useAction == "eat" end,
        move = {nil, -0.05, 0.1}
    }
}

local caseMatched = false
for _, case in ipairs(specialCases) do
    if case.pack() then
        if case.transforms then
            for _, transform in ipairs(case.transforms) do
                for _, item in ipairs(transform[1]) do
                    if matched(item, transform.matches) then
                        eatDrinkAnimation(useAction, progress, transform.m, transform.r, transform.s)
                        caseMatched = true
                        break
                    end
                end
            end
        elseif (case.items ~= nil and matched(case.items)) or case.items == nil then
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
if useAction == "brush" and context.mainHand then
    M:moveZ(mat, -0.03 * Easings:easeInOutBack(brushCounter))
    M:rotateX(mat, -30 * Easings:easeInOutBack(brushCounter))
    M:rotateZ(mat, 15 * l * M:sin((foodCountSec - 0.5) * 4.14) * Easings:easeInOutBack(brushCounter))
    M:rotateZ(mat, l * brushAngleM)
end
if useAction == "brush" and not context.mainHand then
    M:moveZ(mat, -0.03 * Easings:easeInOutBack(brushCounterO))
    M:rotateX(mat, -30 * Easings:easeInOutBack(brushCounterO))
    M:rotateZ(mat, 15 * l * M:sin((foodCountSecO - 0.5) * 4.14) * Easings:easeInOutBack(brushCounterO))
    M:rotateZ(mat, l * brushAngleO)
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
local switchAnimationVariable = Easings:easeInBack(M:sin(M:clamp((context.mainHand and mainHandSwitch) or offHandSwitch, 0.09723, 0.60632) * 3.24 * 1.65 - 0.1))
if
	(
		matched({"bundles", "skulls", "music_discs", "nuggets", "ender_pearl", "ender_eye"})
        or (glowing3Darmors and matched({"head_armor"}))
		or I:isThrowable(context.item)
	) and useAction ~= "trident"
then
    M:rotateX(mat, -10 * switchAnimationVariable)
    M:moveY(mat, 0.62 * switchAnimationVariable)
    M:moveY(mat, M:clamp(0.1 * fall, 0, 255))

    local switchEvent = (context.mainHand and mainHandSwitchEvent) or offHandSwitchEvent

    if I:isIn(context.item, Tags:getFabricTag("nuggets")) then
        if switchEvent then
            S:playSound("entity.experience_orb.pickup", 0.3)
        end
        M:moveY(mat, -0.07)
        M:rotateX(mat, 360 * Easings:easeInOutBack((context.mainHand and M:clamp(mainHandSwitch * 1.65, 0, 1)) or M:clamp(offHandSwitch * 1.65, 0, 1)), 0, 0.1, 0)
    elseif I:isIn(context.item, Tags:getFabricTag("music_discs")) then
        if switchEvent then
            S:playSound("entity.context.player.attack.weak", 0.3)
        end
        M:rotateZ(mat, 360 * Easings:easeInOutBack((context.mainHand and M:clamp(mainHandSwitch * 1.65, 0, 1)) or M:clamp(offHandSwitch * 1.65, 0, 1)), -0.1 * l, 0.25, 0)
    else
        if switchEvent then
            S:playSound("entity.context.player.attack.weak", 0.3)
        end
        local clampedSwitch = (context.mainHand and M:clamp(mainHandSwitch * 1.2, 0, 1)) or M:clamp(offHandSwitch * 1.2, 0, 1)
        M:rotateZ(mat, -7 * l * M:sin(M:clamp(clampedSwitch, 0.0943, 0.66791) * 7.07 * 1.5 - 0.8))
    end
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

if (context.mainHand and mainHandSwitchEvent) or offHandSwitchEvent then
    S:playSound("context.item.armor.equip_leather", 0.2)
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

-- == INSPECT ANIMATION ==
if KeyBindManager:isKeyPressed(${inspectKeybind} ~= 0 and ${inspectKeybind} or 67) then
    inspectionSpin = inspectionSpin + 0.025 * context.deltaTime * 30
else
    inspectionSpin = 0
end
inspectionSpin = M:clamp(inspectionSpin, 0, 1)

if (isSword or isPickaxe or I:isIn(context.item, Tags:getVanillaTag("axes")) or useAction == "trident" or itemName == "stick") and context.mainHand then
    M:moveX(mat, -0.2 * l * inspectionCounter)
    M:rotateX(mat, -360 * Easings:easeInOutBack(inspectionSpin), 0, 0, 0.15)
end
prevAge = P:getAge(context.player)

-- == SWING SPEED ==
if isSpearTag                                   then itemSwingSpeed:put(I:getName(context.item), 15) end
if isShovel                                     then itemSwingSpeed:put(I:getName(context.item), 14) end
if itemName == "trident" or itemName == "mace"  then itemSwingSpeed:put(I:getName(context.item), 12) end

-- == TRIDENT AND SPEAR POSE ==
if I:getUseAction(context.item) == "trident" then
    M:rotateY(mat, 60 * l)
    M:moveZ(mat, posInHands(-0.025, -0.22))
    M:moveX(mat, posInHands(-0.045, 0.04))
    M:rotateY(mat, -95 * l * Easings:easeOutBack(M:clamp(context.mainHand and tridentM or tridentMO * 1.5, 0, 1)))
    M:rotateX(mat, 174 * Easings:easeOutBack(M:clamp(context.mainHand and tridentM or tridentMO * 1.5, 0, 1)))
    M:moveZ(mat, posInHands(-0.045, -0.22) * Easings:easeOutBack(M:clamp(context.mainHand and tridentM or tridentMO * 1.5, 0, 1)))
    M:moveX(mat, posInHands(0.04, 0.245) * l * Easings:easeOutBack(M:clamp(context.mainHand and tridentM or tridentMO * 1.5, 0, 1)))
    M:moveY(mat, 0.15 * Easings:easeOutBack(M:clamp(context.mainHand and tridentM or tridentMO * 1.5, 0, 1)))
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

if bc < 0.1 then
    usingItem:put("minecraft:bow", false)
else
    usingItem:put("minecraft:bow", true)
end
useDuration:put("minecraft:bow", Easings:cubicEase(bc) * 20)

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

-- === HOLD MY ACTIONS ITEM_ADDON DEPOSITION ===
if not I:isEmpty(context.item) and not I:isBlock(context.item) then
    if not (
        tag == "swords" or tag == "shovels" or tag == "pickaxes" or tag == "axes" or tag == "hoes" or tag == "buckets" or
        itemName == "mace" or itemName == "trident" or itemName == "stick" or itemName == "bamboo" or itemName == "bone"
    ) or (tag == "buckets" and refinedBuckets) then
        M:moveZ(mat, 0.1)
        M:moveX(mat, -0.073 * l)
        M:rotateY(mat, -5 * l)
        M:rotateZ(mat, 7 * l)
	end
end

if context.mainHand then
    if tag == "swords" or tag == "pickaxes" or tag == "axes" or tag == "hoes" or itemName == "stick" then
        M:scale(mat, 1/1.2, 1/1.2, 1/1.2)
        M:rotateY(mat, 5.5)
        M:moveZ(mat, 0.06)
        M:moveY(mat, 0.035)
        M:moveX(mat, -0.025)
        M:rotateZ(mat, 2)
	end
    if tag == "shovels" then
        M:scale(mat, 1/1.2, 1/1.2, 1/1.2)
        M:rotateZ(mat, 4)
        M:rotateY(mat, -4)
        M:rotateX(mat, -10)
        M:moveY(mat, 0.08)
        M:moveZ(mat, 0.08)
        M:moveX(mat, 0.02)
    end
    if tag == "spears" then
        M:rotateZ(mat, -10)
        M:rotateX(mat, -10)
        M:moveX(mat, 0.060)
        M:moveY(mat, 0.080)
        M:moveZ(mat, -0.060)
    end
    if refinedBuckets then
        if itemName == "powder_snow_bucket" then
            M:rotateX(mat, 4)
            M:rotateZ(mat, 12)
            M:moveX(mat, 0.1)
            M:moveZ(mat, 0.11)
            M:moveY(mat, -0.23)
        elseif tag == "buckets" and itemName ~= "bucket" then
            M:rotateZ(mat, 4)
            M:rotateY(mat, 12)
            M:moveY(mat, -0.15)
            M:moveZ(mat, -0.029)
            M:moveX(mat, 0.2)
        end
        M:moveX(mat, -0.025)
        M:rotateY(mat, -6)
    else
        if itemName == "bucket" then
            M:moveX(mat, -0.2)
            M:moveZ(mat, 0.029)
            M:moveY(mat, 0.15)
            M:rotateY(mat, -12)
            M:rotateZ(mat, -4)
        end
    end
else
    if tag == "swords" or tag == "pickaxes" or tag == "axes" or tag == "hoes" or itemName == "stick" then
        M:scale(mat, 1/1.1, 1/1.1, 1/1.1)
        M:rotateX(mat, -5)
        M:rotateY(mat, -8)
        M:moveZ(mat, 0.05)
        M:moveY(mat, 0.028)
        M:moveX(mat, 0.025)
    end
    if tag == "shovels" then
        M:scale(mat, 1/1.2, 1/1.2, 1/1.2)
        M:rotateY(mat, 4)
        M:moveZ(mat, -0.06)
        M:rotateX(mat, -15)
        M:moveY(mat, -0.08)
        M:moveX(mat, -0.02)
    end
    if tag == "spears" then
        M:rotateZ(mat, 10)
        M:rotateX(mat, -10)
        M:moveX(mat, -0.1)
        M:moveY(mat, 0.05)
        M:moveZ(mat, -0.2)
    end
    if refinedBuckets then
        if itemName == "powder_snow_bucket" then
            M:rotateX(context.matrices, 4)
            M:rotateZ(context.matrices, -8)
            M:moveX(context.matrices, -0.06)
            M:moveZ(context.matrices, 0.06)
            M:moveY(context.matrices, -0.26)
        elseif tag == "buckets" then
            M:rotateX(context.matrices, 4)
            M:rotateZ(context.matrices, 12)
            M:moveX(context.matrices, 0.1)
            M:moveZ(context.matrices, 0.11)
            M:moveY(context.matrices, -0.23)
        end
    else
       if itemName == "bucket" then
            M:moveX(mat, 0.1)
            M:moveZ(mat, 0.09)
            M:moveY(mat, 0.17)
            M:rotateY(mat, 12)
            M:rotateZ(mat, -4)
        end
    end
end

if itemName == "mace" then
	M:scale(mat, 1/1.1, 1/1.1, 1/1.1)
	M:moveZ(mat, 0.05)
	M:moveY(mat, -0.05)
	M:rotateX(mat, 5)
	M:rotateY(mat, 5.5)
    M:moveX(mat, -0.05 * l)
end

if itemName == "trident" then
	M:moveX(mat, 0.1 * l)
	M:moveZ(mat, -0.1 * l)
end
