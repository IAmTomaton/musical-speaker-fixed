local Event = require("__stdlib__/stdlib/event/event")

soundData = require("sound-data")

Event.on_init(
    function()
		for key, value in pairs(soundData) do
			remote.call("musical-speaker-fixed", "addCategory", value)
		end
    end
)