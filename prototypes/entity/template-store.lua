--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local util = require("util")
local base = data.raw.container["wooden-chest"]
local ____debug = false
local templateStore = {
    type = "container",
    name = "musical-speaker-template-store",
    icon = base.icon,
    icon_size = base.icon_size,
    icon_mipmaps = base.icon_mipmaps,
    picture = (____debug and base.picture) or util.empty_sprite(),
    inventory_size = 200,
    collision_mask = nil,
    flags = ((____debug and (function() return nil end)) or (function() return {"hidden", "hide-alt-info", "no-automated-item-insertion", "no-automated-item-removal", "no-copy-paste", "not-blueprintable", "not-deconstructable", "not-flammable", "not-on-map", "not-upgradable", "not-selectable-in-game"} end))()
}
data:extend({templateStore})
return ____exports
