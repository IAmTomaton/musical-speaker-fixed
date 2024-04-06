--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local categories = require("script.sound-data")
local mapping = {}
local programmableSpeakerInstruments = {}
__TS__ArrayForEach(
    categories,
    function(____, category, categoryIndex)
		mapping[categoryIndex] = {}
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
                mapping[categoryIndex][instrumentIndex] = programmableSpeakerIndex - 1
            end
        )
    end
)
function ____exports.getProgrammableSpeakerInstrumentId(categoryId, instrumentId, noteId)
	if mapping[categoryId] == nil then
		game.print(string.format("Unknown category %d!", categoryId))
		return mapping[0][0]
	end
	if mapping[categoryId][instrumentId] == nil then
		game.print(string.format("Unknown instrument %d in category %d!", instrumentId, categoryId))
		return mapping[categoryId][0]
	end

	programmableSpeakerInstrumentId = mapping[categoryId][instrumentId]
	
	if noteId >= #programmableSpeakerInstruments[programmableSpeakerInstrumentId + 1].notes then
		game.print(string.format("Unknown note %d in instrument %d in category %d!", noteId, instrumentId, categoryId))
	end
	
	return programmableSpeakerInstrumentId
end
____exports.categories = categories
____exports.programmableSpeakerInstruments = programmableSpeakerInstruments
return ____exports
