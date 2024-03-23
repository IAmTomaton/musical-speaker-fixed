--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local MusicalSpeaker = require("script.musical-speaker")
local Gui = require("script.gui.gui")
local Event = require("__stdlib__/stdlib/event/event")
MusicalSpeaker.registerEvents()
Gui.registerEvents()
Event.on_init(
    function()
        global.speakers = {}
        global.gui = {}
        global.speakerTemplates = {stores = {}, currentStore = nil, templates = {}}
    end
)
Event.on_configuration_changed(
    function()
        for speakerId in pairs(global.speakers) do
            local speaker = global.speakers[speakerId]
            if speaker then
                MusicalSpeaker.reset(speaker)
            end
        end
    end
)
return ____exports
