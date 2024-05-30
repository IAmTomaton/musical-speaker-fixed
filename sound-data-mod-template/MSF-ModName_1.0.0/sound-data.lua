--[[
The returned table should have the following structure:

soundData = {
	{
		name = "category-0-name",
		instruments = {
			{
				name = "instrument-0-name",
				notes = {
					{ name="note-0-name", filename = "__MSF-ModName__/sound/file-0.ogg" },
					{ name="note-1-name", filename = "__MSF-ModName__/sound/file-1.ogg" },
					{ name="note-2-name", filename = "__MSF-ModName__/sound/file-2.ogg" },
					...
				}
			},
			{
				name = "instrument-1-name",
				notes = {
					...
				}
			},
			...
		}
	},
	{
		name = "category-1-name",
		instruments = {
			...
		}
	},
	...
}

The table is an array of categories.
The category table must contain the category name (field "name") and an array of instruments (field "instruments").
The instrument table must contain the instrument name (field "name") and an array of notes (field "notes").
The note table must contain the note name (field "name") and the path to the ogg format sound file (field "filename").

]]--

soundData = {}

return soundData
