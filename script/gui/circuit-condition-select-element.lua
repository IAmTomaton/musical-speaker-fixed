--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____gui_2Dtoolkit = require("script.gui.gui-toolkit")
local GuiToolkit = ____gui_2Dtoolkit.default
local util = require("util")
local ConditionComparator = {}
ConditionComparator.LESS_THAN = 1
ConditionComparator[ConditionComparator.LESS_THAN] = "LESS_THAN"
ConditionComparator.GREATER_THAN = 2
ConditionComparator[ConditionComparator.GREATER_THAN] = "GREATER_THAN"
ConditionComparator.EQUAL_TO = 3
ConditionComparator[ConditionComparator.EQUAL_TO] = "EQUAL_TO"
ConditionComparator.GREATER_THAN_OR_EQUAL_TO = 4
ConditionComparator[ConditionComparator.GREATER_THAN_OR_EQUAL_TO] = "GREATER_THAN_OR_EQUAL_TO"
ConditionComparator.LESS_THAN_OR_EQUAL_TO = 5
ConditionComparator[ConditionComparator.LESS_THAN_OR_EQUAL_TO] = "LESS_THAN_OR_EQUAL_TO"
ConditionComparator.NOT_EQUAL_TO = 6
ConditionComparator[ConditionComparator.NOT_EQUAL_TO] = "NOT_EQUAL_TO"
local comparatorStrings = {"<", ">", "=", "≥", "≤", "≠"}
function ____exports.create(parent, name)
    local element = {}
    local panel = GuiToolkit.labelledPanel({parent = parent, caption = {name}}).content
    panel.style.vertical_align = "center"
    element.firstSignalChooser = panel.add({type = "choose-elem-button", elem_type = "signal"})
    element.comparatorChooser = panel.add({type = "drop-down", items = comparatorStrings, selected_index = 2, style = "circuit_condition_comparator_dropdown"})
    element.secondConstantButton = panel.add({type = "button", style = element.firstSignalChooser.style.name, caption = "0"})
    element.secondConstantButton.tags.value = 0
    element.secondConstantButton.style.font_color = {r = 255, g = 255, b = 255}
    element.secondSignalChooser = panel.add({type = "choose-elem-button", elem_type = "signal"})
    element.secondSignalChooser.visible = false
    element.comparatorChooser.enabled = false
    element.secondSignalChooser.enabled = false
    return element
end
function ____exports.getSettings(element)
    local secondSignal
    if element.secondConstantButton.visible then
        secondSignal = element.secondConstantButton.tags.value
    else
        secondSignal = element.secondSignalChooser.elem_value
    end
    return {firstSignal = element.firstSignalChooser.elem_value, comparator = element.comparatorChooser.selected_index, secondSignal = secondSignal}
end
function ____exports.setSettings(element, newValue)
    element.firstSignalChooser.elem_value = newValue.firstSignal
    element.comparatorChooser.selected_index = newValue.comparator
    if type(newValue.secondSignal) == "number" then
        element.secondConstantButton.caption = util.format_number(newValue.secondSignal, true)
        element.secondConstantButton.tags.value = newValue.secondSignal
        element.secondConstantButton.visible = true
        element.secondSignalChooser.visible = false
    else
        element.secondSignalChooser.elem_value = newValue.secondSignal
        element.secondConstantButton.visible = false
        element.secondSignalChooser.visible = true
    end
end
return ____exports
