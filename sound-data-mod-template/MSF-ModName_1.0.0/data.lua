soundData = require("sound-data")
soundDataTable = data.raw["programmable-speaker"]["musical-speaker-note-player"].soundDataTable

for key, value in pairs(soundData) do
	table.insert(soundDataTable, value)
end
