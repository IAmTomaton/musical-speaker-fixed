--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local categories = require("./sound-data")
local mapping = {}
local programmableSpeakerInstruments = {}
__TS__ArrayForEach(
    categories,
    function(____, category, categoryIndex)
        __TS__ArrayForEach(
            category.instruments,
            function(____, instrument, instrumentIndex)
                local programmableSpeakerIndex = __TS__ArrayPush(
                    programmableSpeakerInstruments,
                    {
                        name = instrument.name,
                        notes = __TS__ArrayMap(
                            instrument.notes,
                            function(____, note) return {name = note.name, sound = {filename = note.filename, preload = false}} end
                        )
                    }
                )
                mapping[(tostring(categoryIndex) .. "-") .. tostring(instrumentIndex)] = programmableSpeakerIndex - 1
            end
        )
    end
)
function ____exports.getProgrammableSpeakerInstrumentId(categoryId, instrumentId)
    return mapping[(tostring(categoryId) .. "-") .. tostring(instrumentId)]
end
____exports.categories = categories
____exports.programmableSpeakerInstruments = programmableSpeakerInstruments
return ____exports
