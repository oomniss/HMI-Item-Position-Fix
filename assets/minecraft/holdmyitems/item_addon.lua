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

local swing_rot
local swing_sword_tilt
local swing_hit_second
local l                     = (context.bl and 1) or -1
local GRAVITY               = 0.04
local DAMPING               = 0.85
local INTENSITY             = 0.15
local dt                    = context.deltaTime * 30
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
local itemName              = I:getName(context.item):gsub("minecraft:", "")

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

local function matched(items, match)
    local list = type(items) == "table" and items or {items}

    local function check(item)
        if match then
            if itemName:find(item) then
                return true
            end
        end
        return itemName == item
            or I:isIn(context.item, Tags:getFabricTag(item))
            or I:isIn(context.item, Tags:getVanillaTag(item))
    end

    for _, i in ipairs(list) do
        if check(i) then
            return true
        end
    end
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
		0, 200 + (20 * M:sin(P:getAge(context.player) * 0.2))
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
pitchSpeed = pitchSpeed + ((P:getSpeed(context.player) * 22 * walkSmoother * -1) - (M:sin(context.mainHandSwingProgress * 3.14)) * 8 + fall * 3 + M:sin(sneak * 3.14) * 0.3 + (P:getPitch(context.player) - prevPitch)) * INTENSITY * dt
if useAction == "block" and context.mainHand and not isSword then
    pitchSpeed = pitchSpeed + 10 * M:sin(shieldDisable * 3.14) * INTENSITY * dt
    pitchSpeed = pitchSpeed + 12 * M:sin(shieldM      * 3.14) * INTENSITY * dt
end
pitchSpeed = pitchSpeed + ((-20 * M:sin(canDismountCounter   * 3.14) * spearCounterM) + (20 * M:sin(canKnockbackCounter * 3.14) * spearCounterM) + (12 * M:sin(inspectionCounter * 3.14)) + (15 * M:sin(spearCounterM       * 3.14)) + (-10 * M:clamp(M:sin(Easings:easeInBack(hitImpactCounter) * 6.28), 0, 1)) + ( 40 * M:clamp(M:sin(M:clamp(mainHandSwitch * 1.5 * sp, 0, 1) * 6.28), 0, 1))) * INTENSITY * dt
pitchSpeed = pitchSpeed - GRAVITY * pitchAngle * dt
pitchSpeed = pitchSpeed * M:pow(DAMPING, dt)
pitchAngle = pitchAngle + pitchSpeed * dt

pitchSpeedO = pitchSpeedO + ((P:getSpeed(context.player) * 22 * walkSmoother * -1) - (M:sin(context.offHandSwingProgress * 3.14)) * 8 + fall * 3 + M:sin(sneak * 3.14) * 0.3 + (P:getPitch(context.player) - prevPitch)) * INTENSITY * dt
if useAction == "block" and not context.mainHand and not isSword then
    pitchSpeedO = pitchSpeedO + 10 * M:sin(shieldDisable * 3.14) * INTENSITY * dt
    pitchSpeedO = pitchSpeedO + 12 * M:sin(shieldO      * 3.14) * INTENSITY * dt
end
pitchSpeedO = pitchSpeedO + ((-20 * M:sin(canDismountCounterO   * 3.14) * spearCounterO) + (20 * M:sin(canKnockbackCounterO * 3.14) * spearCounterO) + (15 * M:sin(spearCounterO * 3.14)) + ( 40 * M:clamp(M:sin(M:clamp(offHandSwitch * 1.5 * spo, 0, 1) * 6.28), 0, 1))) * INTENSITY * dt
pitchSpeedO = pitchSpeedO - GRAVITY * pitchAngleO * dt
pitchSpeedO = pitchSpeedO * M:pow(DAMPING, dt)
pitchAngleO = pitchAngleO + pitchSpeedO * dt

-- Yaw
yawSpeed = yawSpeed + (M:sin(walk) * 3 * walkSmoother+ (M:sin(context.mainHandSwingProgress * 3.14)) * 8+ M:sin(swimCounter * swimSmoother) * 3+ M:sin(mainHandSwitch * 6.28) * 3+ P:getYaw(context.player) - prevYaw) * INTENSITY * dt
yawSpeed = yawSpeed - GRAVITY * yawAngle * dt
yawSpeed = yawSpeed * M:pow(DAMPING, dt)
yawAngle = yawAngle + yawSpeed * dt

yawSpeedO = yawSpeedO + (M:sin(walk) * 3 * walkSmoother + (M:sin(context.offHandSwingProgress * 3.14)) * 8 + M:sin(swimCounter * swimSmoother) * 3 + M:sin(offHandSwitch * 6.28) * 3 + P:getYaw(context.player) - prevYaw) * INTENSITY * dt
yawSpeedO = yawSpeedO - GRAVITY * yawAngleO * dt
yawSpeedO = yawSpeedO * M:pow(DAMPING, dt)
yawAngleO = yawAngleO + yawSpeedO * dt

-- == RESOURCE PACKS ==

local rvTorches             = ${rvTorches}
local refinedTorches        = ${refinedTorches}
local torchesPack           = rvTorches or refinedTorches
local glowing3Darmors		= ${glowing3Darmors}
local glowing3Dtotem		= ${glowing3Dtotem}
local a3ds					= ${a3ds}
local w3di					= ${w3di}
local refinedBuckets		= ${refinedBuckets}
local freshFoods			= ${freshFoods}
local better3Dbooks			= ${better3Dbooks}
local bensBundle			= ${bensBundle}
local fyoncle3Dtrims	    = ${fyoncle3Dtrims}
local gousPoses			    = ${gousPoses}
local nneSwords			    = ${nneSwords}
local beashAnimations	    = ${beashAnimations}

-- == INVERTED AXIS CHECKING ==
local invertAxisRules = {
    {
        pack = better3Dbooks and w3di,
        items = {"^book$", "enchanted_book", "writable_book", "written_book"},
    },
    {
        pack = glowing3Darmors,
        items = {"_helmet"},
    },
    {
        pack = glowing3Dtotem,
        items = {"totem_of_undying"},
    },
    {
        pack = freshFoods,
        items = {"cake", "pumpkin_pie", "bowl", "_stew", "_soup"},
    },
    {
        pack = fyoncle3Dtrims,
        items = {"_smithing_template"},
    },
    {
        pack = w3di and bensBundle,
        items = {"bundle"},
    },
    {
        pack = w3di and a3ds,
        items = {
            "shears", "ender_pearl", "ender_eye", "firework_rocket", "boats", "name_tag", "banner_pattern", "stick",
            "blaze_rod", "breeze_rod", "totem_of_undying", "bone"
        },
    }
}

local invertedAxis = false
for _, rule in ipairs(invertAxisRules) do
    if rule.pack and matched(rule.items, true) then
        invertedAxis = true
        break
    end
end

-- == TOOL ANIMATIONS ==
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

    if invertedAxis then
        M:moveX(mat, -0.05 * swing_rot)
        M:moveY(mat, -0.05 * swing_rot)
    else
        M:moveZ(mat, -0.05 * swing_rot)
        M:moveY(mat, -0.05 * swing_rot)
        M:rotateX(mat, 10 * swing_rot)
        M:rotateX(mat, -30 * swing_rot)
        M:rotateX(mat, -10 * swing_hit)
    end

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

        elseif not invertedAxis then
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
if matched({"bell", "end_crystal", "pink_petals", "leaf_litter", "wildflowers"}) or I:isLantern(context.item) or isHangingSign then
	if matched({"pink_petals", "wildflowers", "leaf_litter"}) then
		M:rotateX(mat, M:clamp(P:getPitch(context.player) / 2.5, -20, 90) + ptAngle + ywAngle * 0.5, 0, -0.13, 0)
	end
	if matched({"end_crystal", "bell"}) or I:isLantern(context.item) then
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
			M:rotateX(mat, M:clamp(P:getPitch(context.player) / 2.5, -20, 90) + ptAngle, -0.1 * l, 0.4, 0.1)
			M:rotateZ(mat, ywAngle * -1, -0.1 * l, 0.4, 0.1)
		else
			M:rotateX(mat, M:clamp(P:getPitch(context.player) / 2.5, -20, 90) + ptAngle, 0, 0.4, 0)
			M:rotateZ(mat, ywAngle * -1, 0, 0.4, 0)
		end
	end
	if isHangingSign then
		M:rotateX(mat, M:clamp(P:getPitch(context.player) / 2.5, -35, 90) + ptAngle, 0, 0.55, 0)
		M:rotateZ(mat, ywAngle * -1, 0, 0.55, 0)
	end
elseif itemName == "painting" or itemName == "item_frame" or (itemName == "glow_item_frame" and not a3ds) then
	context.swingProgress = 0
	M:rotateX(mat, M:clamp(P:getPitch(context.player) / 2.5, -25, 90) + ptAngle, 0, 0.45, 0)
	M:rotateZ(mat, ywAngle * -1, 0, 0.55, 0)
elseif glowing3Darmors and matched({"chest_armor"}) then
    M:rotateX(mat, -(P:getPitch(context.player) * 0.09 + ptAngle * 0.6), -0.129, -0.004, 0.495)
    M:rotateZ(mat, ywAngle * 0.5, -0.129, -0.004, 0.495)
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
		M:rotateX(mat, (P:getPitch(context.player) * -0.05) + ptAngle * 0.2, 0, -0.2, 0)
	elseif useAction ~= "crossbow" then
		M:rotateX(mat, (P:getPitch(context.player) * -0.025) + ptAngle * 0.1, 0, -0.2, 0)
	end
end

if itemName == "elytra" and glowing3Darmors and not w3di then
    M:rotateX(mat, M:clamp(P:getPitch(context.player) / 2.5, -20, 90) + ptAngle + ywAngle * 0.5, 0, -0.13, 0)
	M:rotateZ(mat, ywAngle * -0.7, -0.1 * l, 0, 0.1)
end

-- == EAT & DRINK ANIMATION ==
-- Animations Helpers
local move = {
    x = function(v) M:moveX(mat, v * l) end,
    y = function(v) M:moveY(mat, v) end,
    z = function(v) M:moveZ(mat, v) end
}
local rotate = {
    x = function(v) M:rotateX(mat, v) end,
    y = function(v) M:rotateY(mat, v * l) end,
    z = function(v) M:rotateZ(mat, v * l) end
}

local function applyTransform(op, progress, exp, x, y, z)
    local t = M:pow(progress, exp)

    if x then op.x(x * t) end
    if y then op.y(y * t) end
    if z then op.z(z * t) end
end

-- Animation
local function eatDrinkAnimation(use, progress, movePos, rotatePos)
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
end
local progress = context.mainHand and foodCount or foodCountO

local specialCases = {
    -- Without Packs
    {
        check = function() return not (w3di or a3ds) and matched("goat_horn") end,
        move = {nil, nil, nil}, rotate = {nil, -12, nil}
    },
    {
        check = function() return not (freshFoods or w3di) and matched("sweet_berries") end,
        move = {nil, nil, 0.05}, rotate = {nil, 10, nil}
    },
    {
        check = function() return not (w3di or refinedBuckets) and matched("milk_bucket") end,
        move = {0.15, 0.14, -0.18}, rotate = {nil, -60, 5}
    },
    {
        check = function() return not (w3di or freshFoods) and itemName ~= "milk_bucket" end,
        move = {-0.05, -0.07, 0.05}
    },
    -- With Packs
    {
        check = function() return freshFoods and w3di and matched({"_soup", "_stew"}) end,
        move = {0.15, -0.05, -0.1}, rotate = {-5, -10, 30}
    },
    {
        check = function() return freshFoods and w3di and matched("spider_eye") end,
        move = {0.1, 0.05, 0.05}, rotate = {nil, nil, nil}
    },
	{
		check = function() return w3di and refinedBuckets and matched("milk_bucket") end,
		move = {-0.3, 0.2, 0.15}, rotate = {-20, -60, -10}
	},
	{
		check = function() return not w3di and refinedBuckets and matched("milk_bucket") end,
		move = {0.02, 0.06, -0.1}, rotate = {nil, -60, nil}
	},
    {
		check = function() return w3di and matched("milk_bucket") end,
		move = {nil, -0.05, -0.1}, rotate = {-10, -30, -55}
	},
    {
		check = function() return w3di and not freshFoods and matched("sweet_berries") end,
		move = {nil, nil, 0.05}
	}
}

local caseMatched = false
for _, case in ipairs(specialCases) do
    if case.check() then
        eatDrinkAnimation(useAction, progress, case.move, case.rotate)
        caseMatched = true
		break
    end
end

if not caseMatched and (useAction == "eat" or useAction == "drink" or useAction == "toot_horn") then
    eatDrinkAnimation(useAction, progress)
end

global.foodCount          = 0.0;
global.foodCountO         = 0.0;
local easedFoodCounter    = Easings:easeInQuart(context.mainHand and foodCount or foodCountO)

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

if I:isOf(context.item, Items:get("minecraft:filled_map")) then
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
		p.dx = p.dx + 0.005 * M:sin(P:getAge(context.player) * 0.3) * dt
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
if isSpearTag then itemSwingSpeed:put(context.item, 15) end
if isShovel then itemSwingSpeed:put(context.item, 14) end
if itemName == "trident" or itemName == "mace" then itemSwingSpeed:put(context.item, 12) end

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

if itemName:match("bucket") and not (refinedBuckets and w3di) then
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

-- === PACKS CORRECTIONS ===

if w3di and a3ds and (itemName:match("_banner_pattern") or itemName == "name_tag") then
    M:rotateX(mat, -(M:clamp(P:getPitch(context.player) / 2.5, -20, 90) + ptAngle + ywAngle * 0.5), 0, -0.13, 0)
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