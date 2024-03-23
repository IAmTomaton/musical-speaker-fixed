--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local Events = require("__stdlib__/stdlib/event/event")
local ____gui_2Dtoolkit = require("script.gui.gui-toolkit")
local GuiToolkit = ____gui_2Dtoolkit.default
local CircuitConditionSelectElement = require("script.gui.circuit-condition-select-element")
local MusicalSpeaker = require("script.musical-speaker")
local ____sounds = require("script.sounds")
local categories = ____sounds.categories
local L, passToGui, writeSettingsToSpeaker, readSettingsFromSpeaker, onClick, onEntitySelectChanged, onSliderValueChanged, onSelectionChanged, onPlayerLeave, onGuiOpened, onGuiClosed
function L(str, ...)
    local formatArgs = {...}
    return {
        str,
        table.unpack(formatArgs)
    }
end
function passToGui(guiHandler)
    return function(args)
        local gui = global.gui[args.player_index]
        if gui and gui.window.visible then
            guiHandler(gui, args)
        end
    end
end
function ____exports.create(player)
    local gui = {}
    gui.player = player
    local ____ = GuiToolkit.window(
        {
            parent = player.gui.screen,
            caption = L("entity-name.musical-speaker")
        }
    )
    local element = ____.element
    local closeButton = ____.closeButton
    local mainContent = ____.mainContent
    gui.window = element
    gui.closeButton = closeButton
    local previewPanel = GuiToolkit.panel({parent = mainContent}).content
    previewPanel.style.horizontal_align = "center"
    previewPanel.style.vertical_align = "center"
    gui.preview = previewPanel.add({type = "entity-preview"})
    gui.preview.style.width = 400
    gui.preview.style.height = 149
    local volumePanel = GuiToolkit.panel({parent = mainContent, direction = "horizontal"}).content
    volumePanel.add(
        {
            type = "label",
            caption = L("gui-programmable-speaker.volume")
        }
    )
    gui.volumeSlider = volumePanel.add({type = "slider", minimum_value = 1, maximum_value = 100})
    gui.volumeSlider.style.horizontally_stretchable = true
    local circuitNetworkPanel = GuiToolkit.labelledPanel(
        {
            parent = mainContent,
            line = true,
            caption = L("gui-programmable-speaker.circuit-connection-settings"),
            captionStyle = "bold_label",
            direction = "vertical"
        }
    ).content
    gui.enabledConditionSelect = CircuitConditionSelectElement.create(circuitNetworkPanel)
    local soundSelectPanel = GuiToolkit.panel({parent = circuitNetworkPanel, direction = "horizontal"}).content
    gui.categorySelect = soundSelectPanel.add(
        {
            type = "drop-down",
            items = __TS__ArrayMap(
                categories,
                function(____, category) return L(
                    "musical-speaker-category." .. tostring(category.name)
                ) end
            )
        }
    )
    gui.instrumentSelect = soundSelectPanel.add({type = "drop-down"})
    gui.noteSelect = soundSelectPanel.add({type = "drop-down"})
    local volumeFromCircuitPanel = GuiToolkit.labelledPanel(
        {
            parent = circuitNetworkPanel,
            caption = L("musical-speaker.volume-control-condition")
        }
    ).content
    gui.volumeControlSelect = volumeFromCircuitPanel.add({type = "choose-elem-button", elem_type = "signal"})
    return gui
end
function ____exports.updateNoteSelectOptions(gui)
    local selectedCategory = categories[gui.categorySelect.selected_index] or categories[1]
    local selectedInstrument = selectedCategory.instruments[gui.instrumentSelect.selected_index] or selectedCategory.instruments[1]
    gui.instrumentSelect.items = __TS__ArrayMap(
        selectedCategory.instruments,
        function(____, instrument) return L(
            "musical-speaker-instrument." .. tostring(instrument.name)
        ) end
    )
    gui.noteSelect.items = __TS__ArrayMap(
        selectedInstrument.notes,
        function(____, note) return L(
            "musical-speaker-note." .. tostring(note.name)
        ) end
    )
end
function writeSettingsToSpeaker(gui)
    if not gui.speaker then
        error("Tried to write to nothing!", 0)
    end
    MusicalSpeaker.setSettings(gui.speaker, {volume = gui.volumeSlider.slider_value, enabledCondition = {first_signal = gui.enabledConditionSelect.firstSignalChooser.elem_value}, categoryId = gui.categorySelect.selected_index - 1, instrumentId = gui.instrumentSelect.selected_index - 1, noteId = gui.noteSelect.selected_index - 1, volumeControlSignal = gui.volumeControlSelect.elem_value})
end
function readSettingsFromSpeaker(gui)
    if not gui.speaker then
        error("Tried to open a null speaker!", 0)
    end
    local settings = MusicalSpeaker.refreshSettings(gui.speaker)
    gui.volumeSlider.slider_value = settings.volume
    gui.enabledConditionSelect.firstSignalChooser.elem_value = settings.enabledCondition.first_signal
    gui.volumeControlSelect.elem_value = settings.volumeControlSignal
    gui.categorySelect.selected_index = settings.categoryId + 1
    ____exports.updateNoteSelectOptions(gui)
    gui.instrumentSelect.selected_index = settings.instrumentId + 1
    ____exports.updateNoteSelectOptions(gui)
    gui.noteSelect.selected_index = settings.noteId + 1
end
function ____exports.open(gui, speaker)
    gui.speaker = speaker
    readSettingsFromSpeaker(gui)
    gui.preview.entity = speaker.combinator
    gui.window.visible = true
    gui.player.opened = gui.window
end
function ____exports.close(gui)
    gui.speaker = nil
    gui.preview.entity = nil
    gui.window.visible = false
    if gui.player.opened_gui_type == defines.gui_type.custom then
        gui.player.opened = nil
    end
end
function ____exports.destroy(gui)
    gui.window.destroy()
end
function onClick(gui, args)
    if args.element.index == gui.closeButton.index then
        ____exports.close(gui)
    end
end
function onEntitySelectChanged(gui, args)
    writeSettingsToSpeaker(gui)
end
function onSliderValueChanged(gui, args)
    writeSettingsToSpeaker(gui)
end
function onSelectionChanged(gui, args)
    writeSettingsToSpeaker(gui)
    ____exports.updateNoteSelectOptions(gui)
    if args.element.index == gui.noteSelect.index then
        local note = categories[gui.categorySelect.selected_index].instruments[gui.instrumentSelect.selected_index].notes[gui.noteSelect.selected_index]
        if note and note.filename then
        end
    end
end
function onPlayerLeave(args)
    if global.gui[args.player_index] ~= nil then
        local gui = global.gui[args.player_index]
        if gui then
            ____exports.destroy(gui)
        end
        global.gui[args.player_index] = nil
    end
end
function onGuiOpened(args)
    if args.entity and (args.entity.name == "musical-speaker") then
        local player = game.players[args.player_index]
        local gui = global.gui[args.player_index]
        if not gui then
            gui = ____exports.create(player)
            global.gui[args.player_index] = gui
        end
        local speaker = global.speakers[args.entity.unit_number]
        if not speaker then
            player.print("That's not a musical speaker!")
        else
            ____exports.open(gui, speaker)
        end
    end
end
function onGuiClosed(gui, args)
    if args.gui_type == defines.gui_type.custom then
        if args.element and (args.element.index == gui.window.index) then
            ____exports.close(gui)
        end
    end
end
local EventType = defines.events
function ____exports.registerEvents()
    Events.register({EventType.on_player_left_game, EventType.on_player_removed, EventType.on_player_kicked}, onPlayerLeave)
    Events.register({EventType.on_gui_opened}, onGuiOpened)
    Events.register(
        {EventType.on_gui_closed},
        passToGui(onGuiClosed)
    )
    Events.register(
        {EventType.on_gui_value_changed},
        passToGui(onSliderValueChanged)
    )
    Events.register(
        {EventType.on_gui_elem_changed},
        passToGui(onEntitySelectChanged)
    )
    Events.register(
        {EventType.on_gui_selection_state_changed},
        passToGui(onSelectionChanged)
    )
    Events.register(
        {EventType.on_gui_click},
        passToGui(onClick)
    )
end
return ____exports
