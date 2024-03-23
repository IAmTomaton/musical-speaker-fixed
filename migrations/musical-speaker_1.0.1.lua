--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local MusicalSpeaker = require("script.musical-speaker")
if global.speakers then
    for speakerId in pairs(global.speakers) do
        local speaker = global.speakers[speakerId]
        if speaker then
            if speaker.notePlayer and (speaker.notePlayer.name ~= nil) then
                speaker.notePlayer.destroy()
                speaker.notePlayer = nil
            end
            speaker.controlBehavior = speaker.combinator.get_or_create_control_behavior()
            MusicalSpeaker.reset(speaker)
        end
    end
end
return ____exports
