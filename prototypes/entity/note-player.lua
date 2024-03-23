--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____sounds = require("script.sounds")
local programmableSpeakerInstruments = ____sounds.programmableSpeakerInstruments
local util = require("util")
local emptyWires = {wire = {}, shadow = {}}
local baseSpeaker = data.raw["programmable-speaker"]["programmable-speaker"]
local ____debug = false
local notePlayer = table.deepcopy(baseSpeaker)
notePlayer.name = "musical-speaker-note-player"
notePlayer.minable = nil
notePlayer.flags = {"not-on-map", "hidden", "not-flammable", "not-deconstructable", "player-creation", "no-copy-paste", "not-flammable", "not-upgradable", "not-selectable-in-game", "placeable-off-grid"}
notePlayer.collision_mask = {}
notePlayer.collision_box = nil
notePlayer.energy_source = baseSpeaker.energy_source
notePlayer.energy_usage_per_tick = baseSpeaker.energy_usage_per_tick
notePlayer.instruments = programmableSpeakerInstruments
if not ____debug then
    notePlayer = __TS__ObjectAssign(
        {},
        notePlayer,
        {
            circuit_wire_connection_point = emptyWires,
            sprite = util.empty_sprite(),
            circuit_connector_sprites = __TS__ObjectAssign({}, baseSpeaker.circuit_connector_sprites),
            draw_circuit_wires = false,
            draw_copper_wires = false,
            selectable_in_game = false,
            selection_priority = nil
        }
    )
end
data:extend({notePlayer})
return ____exports
