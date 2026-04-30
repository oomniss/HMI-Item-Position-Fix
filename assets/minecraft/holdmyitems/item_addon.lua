local l           = context.mainHand and 1 or -1
local itemName    = I:getName(context.item):gsub("minecraft:", "")
local mat         = context.matrices
local holdMyActions = ${holdMyActions}

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

-- == HOLD MY ACTIONS POSITIONS CORRECTIONS (item_addon) ==
if holdMyActions then
    if not I:isEmpty(context.item) and not I:isBlock(context.item) then
        if not (matched({"swords", "shovels", "pickaxes", "axes", "hoes", "mace", "trident", "stick", "bamboo", "bone"}) or matched("bucket", true)) then
            M:moveZ(mat, 0.1)
            M:moveX(mat, -0.073 * l)
            M:rotateY(mat, -5 * l)
            M:rotateZ(mat, 7 * l)
        end
    end

    if context.mainHand then
        if matched({"swords", "pickaxes", "axes", "hoes"}) or matched("stick") then
        M:scale(mat, 1/1.2, 1/1.2, 1/1.2)
        M:rotateX(mat, 0)
        M:rotateY(mat, 5.5)
        M:moveZ(mat, 0.06)
        M:moveY(mat, 0.035)
        M:moveX(mat, -0.025)
        M:rotateZ(mat, 2)
        end
    end

    if not context.mainHand then
        if matched({"swords", "pickaxes", "axes", "hoes"}) or matched("stick") then
        M:scale(mat, 1/1.1, 1/1.1, 1/1.1)
        M:rotateX(mat, -5)
        M:rotateY(mat, -8)
        M:moveZ(mat, 0.05)
        M:moveY(mat, 0.028)
        M:moveX(mat, 0.025)
        M:rotateZ(mat, 0)
        end
    end


    -- Fixes

    if matched("mace") then
        M:scale(mat, 1/1.1, 1/1.1, 1/1.1)
        M:moveZ(mat, 0.05)
        M:moveY(mat, -0.05)
        M:moveX(mat, 0)
        M:rotateX(mat, 5)
        M:rotateY(mat, 5.5)
        M:rotateZ(mat, 0)
    end

    if context.mainHand and matched({"shovels"}) then
        M:scale(mat, 1/1.2, 1/1.2, 1/1.2)
        M:rotateZ(mat, 4)
        M:rotateY(mat, -4)
        M:rotateX(mat, -10)
        M:moveY(mat, 0.08)
        M:moveZ(mat, 0.08)
        M:moveX(mat, 0.02)
    end

    if not context.mainHand and matched({"shovels"}) then
        M:scale(mat, 1/1.2, 1/1.2, 1/1.2)
        M:rotateY(mat, 4)
        M:moveZ(mat, -0.06)
        M:rotateX(mat, -15)
        M:moveY(mat, -0.08)
        M:moveX(mat, -0.02)
    end

    if matched("trident") and context.mainHand then
        M:moveX(mat, 0.1)
        M:moveZ(mat, -0.1)
        else if matched("trident") then
        M:moveX(mat, -0.1)
        M:moveZ(mat, -0.1)
        end
    end

    if matched("mace") and context.mainHand then
        M:moveX(mat, -0.05)
        else if matched("mace") then
        M:moveX(mat, 0.05)
        end
    end

    -- Spears

    if matched({"spears"}) and context.mainHand then
        M:rotateZ(mat, -10)
        M:rotateX(mat, -10)
        M:rotateY(mat, 0)
        M:moveX(mat, 0.060)
        M:moveY(mat, 0.080)
        M:moveZ(mat, -0.060)
    end

    if matched({"spears"}) and not context.mainHand then
        M:rotateZ(mat, 10)
        M:rotateX(mat, -10)
        M:rotateY(mat, 0)
        M:moveX(mat, -0.1)
        M:moveY(mat, 0.05)
        M:moveZ(mat, -0.2)
    end

    if context.mainHand then
    if itemName == "bucket" then
            M:moveX(mat, -0.2)
            M:moveZ(mat, 0.029)
            M:moveY(mat, 0.15)
            M:rotateY(mat, -12)
            M:rotateZ(mat, -4) 
            end
    end

    if not context.mainHand then
        if itemName == "bucket" then
            M:moveX(mat, 0.1)
            M:moveZ(mat, 0.09)
            M:moveY(mat, 0.17)
            M:rotateY(mat, 12)
            M:rotateZ(mat, -4)
        end
    end

end