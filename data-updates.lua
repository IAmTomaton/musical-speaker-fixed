require("lualib_bundle");

function getSpeakerInstruments(soundData)
	local programmableSpeakerInstruments = {}
	__TS__ArrayForEach(
		soundData,
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
				end
			)
		end
	)
	return programmableSpeakerInstruments
end

-- Load sound data from other mods
local notePlayer = data.raw["programmable-speaker"]["musical-speaker-note-player"]
notePlayer.instruments = getSpeakerInstruments(notePlayer.soundDataTable)
