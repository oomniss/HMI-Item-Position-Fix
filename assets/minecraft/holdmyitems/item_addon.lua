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
local easedBowSec           = Easings:easeOutBack(bowCountSec)
local easedBowSecO          = Easings:easeOutBack(bowCountSecO)
local bc                    = context.mainHand and easedBowSec or easedBowSecO
local easedMapSmoother      = Easings:easeInOutBack(mapSmoother)
local easedMapZoomer        = Easings:easeInOutBack(mapZoomer)
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

local function tags(itemsTags)
	for _, i in ipairs(itemsTags) do
		if I:isIn(context.item, Tags:getFabricTag(i)) or I:isIn(context.item, Tags:getVanillaTag(i)) then
			return true
		end
	end
	return false
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
-- Pincel
brushSpeedM = brushSpeedM + (M:sin(foodCountSec * 4.14) * brushCounter) * context.deltaTime * 30
brushSpeedM = brushSpeedM - GRAVITY * brushAngleM * context.deltaTime * 30
brushSpeedM = brushSpeedM * M:pow(DAMPING, context.deltaTime * 30)
brushAngleM = brushAngleM + brushSpeedM * context.deltaTime * 30

brushSpeedO = brushSpeedO + (M:sin(foodCountSecO * 4.14) * brushCounterO) * context.deltaTime * 30
brushSpeedO = brushSpeedO - GRAVITY * brushAngleO * context.deltaTime * 30
brushSpeedO = brushSpeedO * M:pow(DAMPING, context.deltaTime * 30)
brushAngleO = brushAngleO + brushSpeedO * context.deltaTime * 30

-- Pitch
pitchSpeed = pitchSpeed + ((P:getSpeed(context.player) * 22 * walkSmoother * -1) - (M:sin(context.mainHandSwingProgress * 3.14)) * 8 + fall * 3 + M:sin(sneak * 3.14) * 0.3 + (P:getPitch(context.player) - prevPitch)) * INTENSITY * context.deltaTime * 30
if useAction == "block" and context.mainHand and not tags({"swords"}) then
    pitchSpeed = pitchSpeed + 10 * M:sin(shieldDisable * 3.14) * INTENSITY * context.deltaTime * 30
    pitchSpeed = pitchSpeed + 12 * M:sin(shieldM      * 3.14) * INTENSITY * context.deltaTime * 30
end
pitchSpeed = pitchSpeed + ((-20 * M:sin(canDismountCounter   * 3.14) * spearCounterM) + (20 * M:sin(canKnockbackCounter * 3.14) * spearCounterM) + (12 * M:sin(inspectionCounter * 3.14)) + (15 * M:sin(spearCounterM       * 3.14)) + (-10 * M:clamp(M:sin(Easings:easeInBack(hitImpactCounter) * 6.28), 0, 1)) + ( 40 * M:clamp(M:sin(M:clamp(mainHandSwitch * 1.5 * sp, 0, 1) * 6.28), 0, 1))) * INTENSITY * context.deltaTime * 30
pitchSpeed = pitchSpeed - GRAVITY * pitchAngle * context.deltaTime * 30
pitchSpeed = pitchSpeed * M:pow(DAMPING, context.deltaTime * 30)
pitchAngle = pitchAngle + pitchSpeed * context.deltaTime * 30

pitchSpeedO = pitchSpeedO + ((P:getSpeed(context.player) * 22 * walkSmoother * -1) - (M:sin(context.offHandSwingProgress * 3.14)) * 8 + fall * 3 + M:sin(sneak * 3.14) * 0.3 + (P:getPitch(context.player) - prevPitch)) * INTENSITY * context.deltaTime * 30
if useAction == "block" and not context.mainHand and not tags({"swords"}) then
    pitchSpeedO = pitchSpeedO + 10 * M:sin(shieldDisable * 3.14) * INTENSITY * context.deltaTime * 30
    pitchSpeedO = pitchSpeedO + 12 * M:sin(shieldO      * 3.14) * INTENSITY * context.deltaTime * 30
end
pitchSpeedO = pitchSpeedO + ((-20 * M:sin(canDismountCounterO   * 3.14) * spearCounterO) + (20 * M:sin(canKnockbackCounterO * 3.14) * spearCounterO) + (15 * M:sin(spearCounterO * 3.14)) + ( 40 * M:clamp(M:sin(M:clamp(offHandSwitch * 1.5 * spo, 0, 1) * 6.28), 0, 1))) * INTENSITY * context.deltaTime * 30
pitchSpeedO = pitchSpeedO - GRAVITY * pitchAngleO * context.deltaTime * 30
pitchSpeedO = pitchSpeedO * M:pow(DAMPING, context.deltaTime * 30)
pitchAngleO = pitchAngleO + pitchSpeedO * context.deltaTime * 30

-- Yaw
yawSpeed = yawSpeed + (M:sin(walk) * 3 * walkSmoother+ (M:sin(context.mainHandSwingProgress * 3.14)) * 8+ M:sin(swimCounter * swimSmoother) * 3+ M:sin(mainHandSwitch * 6.28) * 3+ P:getYaw(context.player) - prevYaw) * INTENSITY * context.deltaTime * 30
yawSpeed = yawSpeed - GRAVITY * yawAngle * context.deltaTime * 30
yawSpeed = yawSpeed * M:pow(DAMPING, context.deltaTime * 30)
yawAngle = yawAngle + yawSpeed * context.deltaTime * 30

yawSpeedO = yawSpeedO + (M:sin(walk) * 3 * walkSmoother + (M:sin(context.offHandSwingProgress * 3.14)) * 8 + M:sin(swimCounter * swimSmoother) * 3 + M:sin(offHandSwitch * 6.28) * 3 + P:getYaw(context.player) - prevYaw) * INTENSITY * context.deltaTime * 30
yawSpeedO = yawSpeedO - GRAVITY * yawAngleO * context.deltaTime * 30
yawSpeedO = yawSpeedO * M:pow(DAMPING, context.deltaTime * 30)
yawAngleO = yawAngleO + yawSpeedO * context.deltaTime * 30

-- == TOOL ANIMATIONS ==
context.swingProgress = tags({"pickaxes"}) and easeCustom(context.swingProgress) or easeCustomSec(context.swingProgress)

if context.swingProgress < 0.70016 then
    swing_rot = M:sin(M:clamp(context.swingProgress, 0, 0.308) * 5.1)
else
    swing_rot = M:sin(M:clamp(context.swingProgress, 0.70016, 1) * 5.1 - 2)
end
swing_rot = swing_rot * swing_rot * swing_rot

if context.swingProgress < 0.65245 then
    swing_sword_tilt = M:sin(M:clamp(context.swingProgress, 0, 0.16675) * 3.14 * 3)
else
    swing_sword_tilt = M:sin(M:clamp(context.swingProgress, 0.65245, 1) * 4.4 - 1.3)
end

if context.swingProgress < 0.65594 then
    swing_hit_second = M:sin(M:clamp(context.swingProgress, 0.16561, 0.32991) * 4.78 * 2 + 4.7)
else
    swing_hit_second = M:sin(M:clamp(context.swingProgress, 0.65594, 0.82025) * 4.78 * 2 - 4.7)
end

if useAction == "spear" then
    M:rotateZ(mat, -180 * Easings:easeInOutBack(M:clamp(sw * 2, 0, 1)) * l)
    M:moveZ(mat, -0.2 	* Easings:easeInOutSine(Easings:easeInOutBack(sc * 0.8)))
    M:moveY(mat, -0.05 	* Easings:easeInOutBack(scd))
    M:rotateX(mat, -70 	* Easings:easeInOutBack(sc * 0.8))
    M:rotateX(mat, -8 	* Easings:easeInOutBack(scd))
    M:rotateY(mat, 60 	* Easings:easeInOutBack(sc * 0.8) * l)
    M:rotateY(mat, -30 	* Easings:easeInOutBack(scd) * l)
    M:rotateY(mat, -60 	* Easings:easeOutBack(sck) * sck * l)
    M:moveY(mat, -0.25 	* M:clamp(M:sin(Easings:easeInOutSine(hic) * 6.28), 0, 1))
end

if (useAction ~= "block" and useAction ~= "crossbow") or tags({"swords"}) then
    M:moveZ(mat, -0.05 	* swing_rot)
    M:moveY(mat, -0.05 	* swing_rot)
    M:rotateX(mat, 10 	* swing_rot)
    M:rotateX(mat, -30 	* swing_rot)
    M:rotateX(mat, -10 	* swing_hit)

    if not tags({"swords"}) then
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

	elseif tags({"swords"}) then
		M:moveY(mat, -0.1 * Easings:easeInOutBack(swing))
		M:rotateX(mat, -60 * Easings:easeInOutBack(swing))
    end

    if tags({"shovels"}) then
        M:moveY(mat, 0.12 * swing_sword_tilt)
        M:moveZ(mat, 0.05 * swing_sword_tilt)
        M:rotateX(mat, 10 * swing_sword_tilt)
        M:rotateX(mat, -30 * swingOverall)
        M:rotateX(mat, 20 * swing_rot)
        M:rotateX(mat, 10 * swing_hit_second)
    end

    if useAction == "bow" then
        M:moveX(mat, -0.065 * l)
    end
end

-- == PHYSICS ==
if
	itemName == "bell"
	or itemName == "end_crystal"
	or itemName == "pink_petals"
	or itemName == "leaf_litter"
	or itemName == "wildflowers"
	or I:isLantern(context.item)
	or tags({"hanging_signs"})
then
	if itemName == "pink_petals" or itemName == "wildflowers" or itemName == "leaf_litter" then
		M:rotateX(mat, M:clamp(P:getPitch(context.player) / 2.5, -20, 90) + ptAngle + ywAngle * 0.5, 0, -0.13, 0)
	end
	if itemName == "bell" or itemName == "end_crystal" or I:isLantern(context.item) then
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
	if tags({"hanging_signs"}) then
		M:rotateX(mat, M:clamp(P:getPitch(context.player) / 2.5, -35, 90) + ptAngle, 0, 0.55, 0)
		M:rotateZ(mat, ywAngle * -1, 0, 0.55, 0)
	end
elseif itemName == "painting" or itemName == "item_frame" or itemName == "glow_item_frame" then
	context.swingProgress = 0
	M:rotateX(mat, M:clamp(P:getPitch(context.player) / 2.5, -25, 90) + ptAngle, 0, 0.45, 0)
	M:rotateZ(mat, ywAngle * -1, 0, 0.55, 0)
else
	if
		not I:isBlock(context.item)
		and not I:isEmpty(context.item)
		and useAction == "none"
		and useAction ~= "crossbow"
	then
		if tags({"axes"}) or itemName == "mace" then
			local ptAngleMultiplier = (itemName == "mace" and 0.2) or 0.15
			M:rotateX(mat, -20 * M:sin(context.equipProgress * context.equipProgress * context.equipProgress) + (ptAngle * ptAngleMultiplier), 0.3 * l, -0.3, 0)
		else
			M:rotateX(mat, -20 * M:sin(context.equipProgress * context.equipProgress * context.equipProgress) + (ptAngle * 0.05), 0.3 * l, -0.4, 0)
		end
	end
	if (tags({"axes"}) or itemName == "mace") and useAction ~= "crossbow" then
		M:rotateX(mat, (P:getPitch(context.player) * -0.05) + ptAngle * 0.2, 0, -0.2, 0)
	elseif useAction ~= "crossbow" then
		M:rotateX(mat, (P:getPitch(context.player) * -0.025) + ptAngle * 0.1, 0, -0.2, 0)
	end
end

-- == EAT & DRINK ANIMATION ==
if (useAction == "drink" or useAction == "eat" or useAction == "toot_horn") and context.mainHand then
    M:moveX(mat, 0.02 	* l * foodCount)
    M:moveZ(mat, -0.05 	* foodCount)
    if useAction == "eat" or useAction == "toot_horn" then
        M:rotateX(mat, -23 * foodCount * foodCount)
        M:rotateZ(mat, -12 * l * foodCount * foodCount)
    end
    M:rotateY(mat, -50 * l * foodCount * foodCount)
    if useAction == "drink" then
        M:rotateX(mat, 15 * foodCount * foodCount)
    end
end

if (useAction == "drink" or useAction == "eat" or useAction == "toot_horn") and not context.mainHand then
	M:moveX(mat, 0.02 	* l * foodCountO)
	M:moveZ(mat, -0.05 	* foodCountO)
	if useAction == "eat" or useAction == "toot_horn" then
		M:rotateX(mat, -23 * foodCountO * foodCountO)
		M:rotateZ(mat, -12 * l * foodCountO * foodCountO)
	end
	M:rotateY(mat, -50 * l * foodCountO * foodCountO)
	if useAction == "drink" then
		M:rotateX(mat, 15 * foodCountO * foodCountO)
	end
end

global.foodCount    = 0.0
global.foodCountO   = 0.0

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
		tags({"bundles", "skulls", "music_discs", "nuggets"})
		or itemName == "ender_pearl"
		or itemName == "ender_eye"
		or I:isThrowable(context.item)
	) and useAction ~= "trident"
then
    M:rotateX(mat, -10 * switchAnimationVariable)
    M:moveY(mat,  0.62 * switchAnimationVariable)
    M:moveY(mat,  M:clamp(0.1 * fall, 0, 255))

    local eased = Easings:easeInOutBack(M:clamp(activeSwitch * 1.65, 0, 1))

    if tags({"nuggets"}) then
        if switchEvent then S:playSound("entity.experience_orb.pickup", 0.3) end
        M:moveY(mat, -0.07)
        M:rotateX(mat, 360 * eased, 0, 0.1, 0)

    elseif tags({"music_discs"}) then
        if switchEvent then S:playSound("entity.context.player.attack.weak", 0.3) end
        M:rotateZ(mat, 360 * eased, -0.1 * l, 0.25, 0)

    else
        if switchEvent then S:playSound("entity.context.player.attack.weak", 0.3) end
        local clampedSwitch = M:clamp(activeSwitch * 1.2, 0, 1)
        M:rotateZ(mat, -7 * l * M:sin(M:clamp(clampedSwitch, 0.0943, 0.66791) * 10.605 - 0.8))
    end
end

-- == MAP ANIMATION ==
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
if
	itemName == "brewing_stand"
	or itemName == "lava_bucket"
	or itemName == "torch"
	or itemName:match("_torch")
	or tags({"lanterns"})
then
	if
		itemName == "brewing_stand" or itemName == "torch" 	then glow(0.5 * l, 0.6, 0.5, "textures/particle/orange_glow.png")
		elseif itemName == "copper_torch" 					then glow(0.5 * l, 0.6, 0.5, "textures/particle/copper_glow.png")
		elseif itemName == "soul_torch" 					then glow(0.5 * l, 0.6, 0.5, "textures/particle/blue_glow.png")
		elseif itemName == "redstone_torch" 				then glow(0.5 * l, 0.6, 0.5, "textures/particle/red_glow.png")
		elseif itemName == "lantern" 						then glow(0.45 * l, 0.15, 0.5, "textures/particle/orange_glow.png")
		elseif itemName == "soul_lantern" 					then glow(0.45 * l, 0.15, 0.5, "textures/particle/blue_glow.png")
		elseif itemName:match("copper_lantern") 			then glow(0.45 * l, 0.15, 0.5, "textures/particle/copper_glow.png")
		elseif itemName == "lava_bucket" 					then glow(-0.05 * l, 0, 0, "textures/particle/orange_glow.png")
	end
end

if swingCountPrev ~= P:getSwingCount(context.player) and context.mainHand and itemName == "bell" then
	S:playSound("block.bell.use", 0.3)
end
swingCountPrev = P:getSwingCount(context.player)

if itemName == "pink_petals" or itemName == "wildflowers" or itemName == "leaf_litter" then
	local particle_ticker = function(p)
		p.dx = p.dx + 0.005 * M:sin(P:getAge(context.player) * 0.3) * context.deltaTime * 30
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
if tags({"spears"}) then itemSwingSpeed:put(context.item, 15) end
if tags({"shovels"}) then itemSwingSpeed:put(context.item, 14) end
if itemName == "trident" or itemName == "mace" then itemSwingSpeed:put(context.item, 12) end

-- == TRIDENT AND SPEAR POSE ==
if useAction == "trident" then
    M:rotateZ(mat, 170 * l * Easings:easeOutBack(M:clamp(context.mainHand and tridentM or tridentMO * 1.5, 0, 1)))
    M:moveZ(mat,  -0.1)
    M:rotateY(mat,  40 * l)
    M:rotateX(mat, -90 * Easings:easeOutBack(M:sin(context.mainHand and riptideCounter or riptideCounterO * 3.14)))
    M:rotateZ(mat, -45 * l * Easings:easeOutBack(M:sin(context.mainHand and riptideCounter or riptideCounterO * 3.14)))
end
if useAction == "spear" then
    M:moveZ(mat, -0.1)
    M:rotateY(mat, 10 * l)
end

-- == BLOCK ROTATION ANIMATION ==
if tags({"hanging_signs", "doors", "skulls", "signs"}) then
	applyBlockRotation:put(I:getName(context.item), false)
end

-- == BOW STATE ==
usingItem:put("minecraft:bow",    bc >= 0.1)
useDuration:put("minecraft:bow",  Easings:cubicEase(bc) * 20)

-- == SOME POSITIONS ==
if itemName == "dragon_head" then
	M:moveY(mat, 0.25)
    M:rotateZ(mat, 6 * l)
    M:rotateY(mat, 160 * l)
elseif tags({"skulls"}) then
	M:moveX(mat, -0.1 * l)
    M:moveY(mat, 0.11)
    M:rotateZ(mat, 15 * l)
    M:rotateY(mat, -85 * l)
    M:rotateX(mat, -55)
end

if tags({"shovels"}) then
	M:moveX(mat, -0.09 * l)
	M:rotateY(mat, 80 * l)
end