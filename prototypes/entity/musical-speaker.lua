--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local util = require("util")
local baseSpeaker = data.raw["programmable-speaker"]["programmable-speaker"]
local speaker = __TS__ObjectAssign(
    {},
    baseSpeaker,
    {
        type = "constant-combinator",
        name = "musical-speaker",
        icon = "__musical-speaker-fixed__/graphics/icons/musical-speaker.png",
        flags = {
            table.unpack(
                __TS__ArrayConcat(
                    {
                        table.unpack(baseSpeaker.flags)
                    },
                    {"not-rotatable", "hide-alt-info"}
                )
            )
        },
        sprites = baseSpeaker.sprite,
        item_slot_count = 40,
        activity_led_sprites = util.empty_sprite(),
        activity_led_light_offsets = {{0, 0}, {0, 0}, {0, 0}, {0, 0}},
        circuit_wire_connection_points = {baseSpeaker.circuit_wire_connection_point, baseSpeaker.circuit_wire_connection_point, baseSpeaker.circuit_wire_connection_point, baseSpeaker.circuit_wire_connection_point}
    }
)
data:extend({speaker})
return ____exports
