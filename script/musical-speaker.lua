--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____sounds = require("script.sounds")
local categories = ____sounds.categories
local getProgrammableSpeakerInstrumentId = ____sounds.getProgrammableSpeakerInstrumentId
local ____templates = require("script.templates")
local getTemplate = ____templates.getTemplate
local Event = require("__stdlib__/stdlib/event/event")
local ____signal_2Descaping = require("script.signal-escaping")
local escapeSignal = ____signal_2Descaping.escapeSignal
local unescapeSignal = ____signal_2Descaping.unescapeSignal
local CombinatorSlot, EMPTY_SIGNAL, readSettings, onDestroyed, onBuilt, checkCircuitSignals, onEntitySettingsPasted
function ____exports.create(combinator)
    local speaker = {
        combinator = combinator,
        notePlayer = nil,
        isPlaying = false,
        settings = readSettings(combinator),
        controlBehavior = combinator.get_or_create_control_behavior()
    }
    ____exports.setSettings(speaker, speaker.settings)
    script.register_on_entity_destroyed(combinator)
    return speaker
end
function readSettings(combinator)
    local m = {}
    __TS__ArrayForEach(
        combinator.get_or_create_control_behavior().parameters,
        function(____, p) return (function(o, i, v)
            o[i] = v
            return v
        end)(m, p.index, p) end
    )
    local function getCountOrDefault(slot, defaultValue)
        return (m[slot].signal.name and m[slot].count) or defaultValue
    end
    local volume = getCountOrDefault(CombinatorSlot.VOLUME, 100)
    local settings = {
        volume = volume,
        volumeControlSignal = unescapeSignal(m[CombinatorSlot.VOLUME_CONTROL_SIGNAL].signal),
        enabledCondition = {
            first_signal = unescapeSignal(m[CombinatorSlot.ENABLED_FIRST_SIGNAL].signal),
            comparator = ">",
            constant = 0
        },
        categoryId = getCountOrDefault(CombinatorSlot.CATEGORY_ID, 0),
        instrumentId = getCountOrDefault(CombinatorSlot.INSTRUMENT_ID, 0),
        noteId = getCountOrDefault(CombinatorSlot.NOTE_ID, 0)
    }
    if settings.categoryId >= #categories then
        settings.categoryId = 0
    end
    if settings.instrumentId >= #categories[settings.categoryId + 1].instruments then
        settings.instrumentId = 0
    end
    if settings.noteId >= #categories[settings.categoryId + 1].instruments[settings.instrumentId + 1].notes then
        settings.noteId = 0
    end
    return settings
end
function ____exports.refreshSettings(speaker)
    return (function(o, i, v)
        o[i] = v
        return v
    end)(
        speaker,
        "settings",
        readSettings(speaker.combinator)
    )
end
function ____exports.setSettings(speaker, settings)
    speaker.settings = settings
    local parameters = {
        {index = CombinatorSlot.VOLUME, signal = {type = "virtual", name = "signal-V"}, count = settings.volume},
        {
            index = CombinatorSlot.VOLUME_CONTROL_SIGNAL,
            signal = escapeSignal(settings.volumeControlSignal or EMPTY_SIGNAL),
            count = 0
        },
        {
            index = CombinatorSlot.ENABLED_FIRST_SIGNAL,
            signal = escapeSignal(settings.enabledCondition.first_signal or EMPTY_SIGNAL),
            count = 0
        },
        {index = CombinatorSlot.CATEGORY_ID, signal = {type = "virtual", name = "signal-C"}, count = settings.categoryId},
        {index = CombinatorSlot.INSTRUMENT_ID, signal = {type = "virtual", name = "signal-I"}, count = settings.instrumentId},
        {index = CombinatorSlot.NOTE_ID, signal = {type = "virtual", name = "signal-N"}, count = settings.noteId}
    }
    local controlBehavior = speaker.controlBehavior
    controlBehavior.parameters = parameters
    controlBehavior.enabled = false
    ____exports.reset(speaker)
end
function ____exports.reset(speaker)
    if not speaker.combinator.valid then
        error("Lolwhat", 0)
    end
    if speaker.notePlayer and speaker.notePlayer.entity.valid then
        speaker.notePlayer.entity.destroy()
    end
    speaker.isPlaying = false
    local blueprint = getTemplate({globalPlayback = true, volume = speaker.settings.volume})
    local ghosts = blueprint.build_blueprint({surface = speaker.combinator.surface, force = speaker.combinator.force, position = speaker.combinator.position})
    if #ghosts ~= 1 then
        error("This should be impossible", 0)
    end
    local _, notePlayer = ghosts[1].silent_revive()
    if not notePlayer then
        error("Failed to revive ghost", 0)
    end
    local controlBehavior = notePlayer.get_or_create_control_behavior()
    controlBehavior.circuit_condition = {condition = speaker.settings.enabledCondition}
    speaker.notePlayer = {entity = notePlayer, controlBehavior = controlBehavior}
    notePlayer.destructible = false
    notePlayer.connect_neighbour({wire = defines.wire_type.red, target_entity = speaker.combinator})
    notePlayer.connect_neighbour({wire = defines.wire_type.green, target_entity = speaker.combinator})
    local programmableSpeakerInstrument = getProgrammableSpeakerInstrumentId(speaker.settings.categoryId, speaker.settings.instrumentId)
    if not programmableSpeakerInstrument then
        game.print("Unknown instrument!")
    else
        controlBehavior.circuit_parameters = {signal_value_is_pitch = false, note_id = speaker.settings.noteId, instrument_id = programmableSpeakerInstrument}
    end
end
function ____exports.destroy(speaker)
    if speaker.notePlayer and speaker.notePlayer.entity.valid then
        speaker.notePlayer.entity.destroy()
    end
    if speaker.combinator.valid then
        speaker.combinator.destroy()
    end
end
function onDestroyed(args)
    if not args.unit_number then
        return
    end
    local speaker = global.speakers[args.unit_number]
    if speaker then
        ____exports.destroy(speaker)
        global.speakers[args.unit_number] = nil
    end
end
function onBuilt(args)
    local entity
    if args.created_entity ~= nil then
        entity = args.created_entity
    elseif args.entity ~= nil then
        entity = args.entity
    else
        entity = args.destination
    end
    if (entity.name == "musical-speaker") and entity.unit_number then
        global.speakers[entity.unit_number] = ____exports.create(entity)
    end
end
function checkCircuitSignals(args)
    for speakerId, speaker in pairs(global.speakers) do
        if speaker then
            if speaker.notePlayer then
                local currentlyPlaying = speaker.notePlayer.controlBehavior.circuit_condition.fulfilled
                if currentlyPlaying then
                    if not speaker.isPlaying then
                        local settings = speaker.settings
                        if settings.volumeControlSignal and settings.volumeControlSignal.name then
                            local volume = speaker.combinator.get_merged_signal(settings.volumeControlSignal) or 100
                            if (volume ~= 0) and (settings.volume ~= volume) then
                                ____exports.setSettings(
                                    speaker,
                                    __TS__ObjectAssign({}, settings, {volume = volume})
                                )
                            end
                        end
                        speaker.isPlaying = true
                    end
                elseif speaker.isPlaying then
                    speaker.isPlaying = false
                    if speaker.settings.categoryId ~= 16 then
                        ____exports.reset(speaker)
                    end
                end
            end
        end
    end
end
function onEntitySettingsPasted(args)
    if args.destination.unit_number then
        local speaker = global.speakers[args.destination.unit_number]
        if speaker then
            ____exports.refreshSettings(speaker)
            ____exports.reset(speaker)
        end
    end
end
CombinatorSlot = {}
CombinatorSlot.VOLUME = 1
CombinatorSlot[CombinatorSlot.VOLUME] = "VOLUME"
CombinatorSlot.VOLUME_CONTROL_SIGNAL = 2
CombinatorSlot[CombinatorSlot.VOLUME_CONTROL_SIGNAL] = "VOLUME_CONTROL_SIGNAL"
CombinatorSlot.ENABLED_FIRST_SIGNAL = 3
CombinatorSlot[CombinatorSlot.ENABLED_FIRST_SIGNAL] = "ENABLED_FIRST_SIGNAL"
CombinatorSlot.CATEGORY_ID = 7
CombinatorSlot[CombinatorSlot.CATEGORY_ID] = "CATEGORY_ID"
CombinatorSlot.INSTRUMENT_ID = 8
CombinatorSlot[CombinatorSlot.INSTRUMENT_ID] = "INSTRUMENT_ID"
CombinatorSlot.NOTE_ID = 9
CombinatorSlot[CombinatorSlot.NOTE_ID] = "NOTE_ID"
EMPTY_SIGNAL = {type = "item", name = nil}
function ____exports.registerEvents()
    Event.register({defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built, defines.events.on_entity_cloned, defines.events.script_raised_revive}, onBuilt)
    Event.register({defines.events.script_raised_destroy, defines.events.on_entity_destroyed}, onDestroyed)
    Event.on_nth_tick(1, checkCircuitSignals)
    Event.register({defines.events.on_entity_settings_pasted}, onEntitySettingsPasted)
end
return ____exports
