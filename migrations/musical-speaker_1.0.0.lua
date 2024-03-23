--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
for ____, force in ipairs(game.forces) do
    if force.technologies["circuit-network"].researched then
        force.recipes["musical-speaker"].enabled = true
    end
end
