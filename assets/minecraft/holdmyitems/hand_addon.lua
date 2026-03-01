-- by omnis._.

local itemName = I:getName(context.item):gsub("minecraft:", "")
local matrices = context.matrices
local l = context.bl and 1 or -1

------ AJUSTES DE PACKS ------

local activePacks = {}
    if ${w3di} then table.insert(activePacks, "w3di") end
    if ${rvTorchs} then table.insert(activePacks, "rvTorchs") end
    if ${freshOresIngots} then table.insert(activePacks, "freshOresIngots") end

local function packActive(respack)
    for _, pack in ipairs(activePacks) do
        if pack == respack then return true end
    end
    return false
end
local function applyAdj(adjustments)
    for _, adj in ipairs(adjustments) do
        for _, i in ipairs(adj.items) do
            if itemName:match(i) then
                if adj.m then
                    if adj.m[1] then M:moveX(matrices, adj.m[1] * l) end
                    if adj.m[2] then M:moveY(matrices, adj.m[2]) end
                    if adj.m[3] then M:moveZ(matrices, adj.m[3]) end
                end
                if adj.r then
                    if adj.r[1] then M:rotateX(matrices, adj.r[1]) end
                    if adj.r[2] then M:rotateY(matrices, adj.r[2] * l) end
                    if adj.r[3] then M:rotateZ(matrices, adj.r[3] * l) end
                end
                if adj.s then
                    if adj.s[1] or adj.s[2] or adj.s[3] then M:scale(matrices, adj.s[1], adj.s[2], adj.s[3]) end
                end
            end
        end
    end
end

if packActive("w3di") then
    -- R&V Torches
    if packActive("rvTorchs") then
        applyAdj({
            { items = {"^torch", "soul_torch"}, m = {nil, nil, -0.05}, r = {nil, nil, -10} },
        })
    end
    -- Fresh Ores & Ingots
    if packActive("freshOresIngots") then
        applyAdj({
        { items = {"^diamond$", "emerald$", "lapis_lazuli$", "quartz$", "nugget", "amethyst_shard", "ingot", "brick$", "netherite_scrap", "redstone", "raw", "coal$", "flint$"},
          m = {0.09, 0.09, -0.05}, r = {nil, nil, -10} }
    })
    end
end

------ OUTROS AJUSTES ------

-- Plantas de Pendurar
applyAdj({
    { items = {"weeping_vines", "hanging_roots", "pale_hanging_moss", "spore_blossom"}, m = {nil, 0.35, -0.05} },
})