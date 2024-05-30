--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
____exports.categories = {}
local mapping = nil
local programmableSpeakerInstruments = nil

function initMapping()
	mapping = {}
	programmableSpeakerInstruments = {}
	__TS__ArrayForEach(
		____exports.categories,
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
end

function ____exports.getProgrammableSpeakerInstrumentId(categoryId, instrumentId, noteId)
	if mapping == nil then
		initMapping()
	end
	
	if mapping[categoryId] == nil then
		game.print(string.format("Unknown category %d!", categoryId))
		return 0
	end
	if mapping[categoryId][instrumentId] == nil then
		game.print(string.format("Unknown instrument %d in category %d!", instrumentId, categoryId))
		return 0
	end

	programmableSpeakerInstrumentId = mapping[categoryId][instrumentId]
	
	if noteId >= #programmableSpeakerInstruments[programmableSpeakerInstrumentId + 1].notes then
		game.print(string.format("Unknown note %d in instrument %d in category %d!", noteId, instrumentId, categoryId))
	end
	
	return programmableSpeakerInstrumentId
end

function addCategory(category)
	table.insert(____exports.categories, category)
end

remote.add_interface("musical-speaker-fixed", {addCategory = addCategory})

return ____exports
