--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
require("prototypes.entity.musical-speaker")
require("prototypes.entity.note-player")
require("prototypes.entity.template-store")
require("prototypes.item.musical-speaker")
require("prototypes.item.note-player")
require("prototypes.recipe.musical-speaker")
require("prototypes.signal.signal-placeholders")
data.raw["programmable-speaker"]["programmable-speaker"].fast_replaceable_group = "programmable-speaker"
__TS__ArrayPush(data.raw.technology["circuit-network"].effects, {type = "unlock-recipe", recipe = "musical-speaker"})
return ____exports
