--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____sounds = require("script.sounds")
local categories = ____sounds.categories
local getProgrammableSpeakerInstrumentId = ____sounds.getProgrammableSpeakerInstrumentId
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
        resetControlSignal = unescapeSignal(m[CombinatorSlot.RESET_CONTROL_SIGNAL].signal),
        categoryId = getCountOrDefault(CombinatorSlot.CATEGORY_ID, 0),
        categoryIdControlSignal = unescapeSignal(m[CombinatorSlot.CATEGORY_ID_CONTROL_SIGNAL].signal),
        instrumentId = getCountOrDefault(CombinatorSlot.INSTRUMENT_ID, 0),
        instrumentIdControlSignal = unescapeSignal(m[CombinatorSlot.INSTRUMENT_ID_CONTROL_SIGNAL].signal),
        noteId = getCountOrDefault(CombinatorSlot.NOTE_ID, 0),
        noteIdControlSignal = unescapeSignal(m[CombinatorSlot.NOTE_ID_CONTROL_SIGNAL].signal),
    }
    if settings.categoryId >= #categories then
        settings.categoryId = 0
    end
	
    if #categories == 0 or settings.instrumentId >= #categories[settings.categoryId + 1].instruments then
        settings.instrumentId = 0
    end
	
    if  #categories == 0 or #categories[settings.categoryId + 1].instruments == 0 or
		settings.noteId >= #categories[settings.categoryId + 1].instruments[settings.instrumentId + 1].notes then
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
        {
            index = CombinatorSlot.RESET_CONTROL_SIGNAL,
            signal = escapeSignal(settings.resetControlSignal or EMPTY_SIGNAL),
            count = 0
        },
        {index = CombinatorSlot.CATEGORY_ID, signal = {type = "virtual", name = "signal-C"}, count = settings.categoryId},
		{
            index = CombinatorSlot.CATEGORY_ID_CONTROL_SIGNAL,
            signal = escapeSignal(settings.categoryIdControlSignal or EMPTY_SIGNAL),
            count = 0
        },
		{index = CombinatorSlot.INSTRUMENT_ID, signal = {type = "virtual", name = "signal-I"}, count = settings.instrumentId},
		{
            index = CombinatorSlot.INSTRUMENT_ID_CONTROL_SIGNAL,
            signal = escapeSignal(settings.instrumentIdControlSignal or EMPTY_SIGNAL),
            count = 0
        },
		{index = CombinatorSlot.NOTE_ID, signal = {type = "virtual", name = "signal-N"}, count = settings.noteId},
		{
            index = CombinatorSlot.NOTE_ID_CONTROL_SIGNAL,
            signal = escapeSignal(settings.noteIdControlSignal or EMPTY_SIGNAL),
            count = 0
        },
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
	
	local notePlayer = game.surfaces[speaker.combinator.surface_index].create_entity{
		name = "musical-speaker-note-player",
		position = speaker.combinator.position,
		parameters = {allow_polyphony = false, playback_globally = true, playback_volume = speaker.settings.volume / 100},
		alert_parameters = {alert_message = "", show_alert = false, show_on_map = true},
		force = speaker.combinator.force
	}
	
    local controlBehavior = notePlayer.get_or_create_control_behavior()
    controlBehavior.circuit_condition = {condition = speaker.settings.enabledCondition}
    speaker.notePlayer = {entity = notePlayer, controlBehavior = controlBehavior}
    notePlayer.destructible = false
    notePlayer.connect_neighbour({wire = defines.wire_type.red, target_entity = speaker.combinator})
    notePlayer.connect_neighbour({wire = defines.wire_type.green, target_entity = speaker.combinator})
    local programmableSpeakerInstrument = getProgrammableSpeakerInstrumentId(speaker.settings.categoryId, speaker.settings.instrumentId, speaker.settings.noteId)
	controlBehavior.circuit_parameters = {signal_value_is_pitch = false, note_id = speaker.settings.noteId, instrument_id = programmableSpeakerInstrument}
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
        if speaker and speaker.notePlayer and speaker.notePlayer.entity.valid then
			local currentlyPlaying = speaker.notePlayer.controlBehavior.circuit_condition.fulfilled
			if currentlyPlaying then
				local changed = false
				local settings = speaker.settings
				if settings.resetControlSignal and settings.resetControlSignal.name then
					changed = (speaker.combinator.get_merged_signal(settings.resetControlSignal) or 0) > 0
				end
				local newSettings = {}
				
				if settings.volumeControlSignal and settings.volumeControlSignal.name then
					local volume = speaker.combinator.get_merged_signal(settings.volumeControlSignal) or 100
					if (volume < 0) then
						game.print(string.format("Volume cannot be negative %d!", volume))
					end
					if (volume >= 0 and settings.volume ~= volume) then
						settings.volume = volume
						changed = true
					end
				end
				
				if settings.categoryIdControlSignal and settings.categoryIdControlSignal.name then
					local categoryId = speaker.combinator.get_merged_signal(settings.categoryIdControlSignal) or 0
					if (categoryId < 0) then
						game.print(string.format("Category cannot be negative %d!", categoryId))
					end
					if (categoryId >= 0 and settings.categoryId ~= categoryId) then
						settings.categoryId = categoryId
						changed = true
					end
				end
				
				if settings.instrumentIdControlSignal and settings.instrumentIdControlSignal.name then
					local instrumentId = speaker.combinator.get_merged_signal(settings.instrumentIdControlSignal) or 0
					if (instrumentId < 0) then
						game.print(string.format("Instrument cannot be negative %d!", instrumentId))
					end
					if (instrumentId >= 0 and settings.instrumentId ~= instrumentId) then
						settings.instrumentId = instrumentId
						changed = true
					end
				end
				
				if settings.noteIdControlSignal and settings.noteIdControlSignal.name then
					local noteId = speaker.combinator.get_merged_signal(settings.noteIdControlSignal) or 0
					if (noteId < 0) then
						game.print(string.format("Note cannot be negative %d!", noteId))
					end
					if (noteId >= 0 and settings.noteId ~= noteId) then
						settings.noteId = noteId
						changed = true
					end
				end
				
				if not speaker.isPlaying or changed then
					____exports.setSettings(
						speaker,
						settings
					)
					speaker.isPlaying = true
				end
			elseif speaker.isPlaying then
				speaker.isPlaying = false
				____exports.reset(speaker)
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
CombinatorSlot.CATEGORY_ID_CONTROL_SIGNAL = 10
CombinatorSlot[CombinatorSlot.CATEGORY_ID_CONTROL_SIGNAL] = "CATEGORY_ID_CONTROL_SIGNAL"
CombinatorSlot.INSTRUMENT_ID_CONTROL_SIGNAL = 11
CombinatorSlot[CombinatorSlot.INSTRUMENT_ID_CONTROL_SIGNAL] = "INSTRUMENT_ID_CONTROL_SIGNAL"
CombinatorSlot.NOTE_ID_CONTROL_SIGNAL = 12
CombinatorSlot[CombinatorSlot.NOTE_ID_CONTROL_SIGNAL] = "NOTE_ID_CONTROL_SIGNAL"
CombinatorSlot.RESET_CONTROL_SIGNAL = 13
CombinatorSlot[CombinatorSlot.RESET_CONTROL_SIGNAL] = "RESET_CONTROL_SIGNAL"
EMPTY_SIGNAL = {type = "item", name = nil}
function ____exports.registerEvents()
    Event.register({defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built, defines.events.on_entity_cloned, defines.events.script_raised_revive}, onBuilt)
    Event.register({defines.events.script_raised_destroy, defines.events.on_entity_destroyed}, onDestroyed)
    Event.on_nth_tick(1, checkCircuitSignals)
    Event.register({defines.events.on_entity_settings_pasted}, onEntitySettingsPasted)
end
return ____exports
