--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____signal_2Descaping = require("script.signal-escaping")
local SIGNAL_PLACEHOLDER_NAME_PREFIX = ____signal_2Descaping.SIGNAL_PLACEHOLDER_NAME_PREFIX
local makeVirtualSignalPlaceholder
function makeVirtualSignalPlaceholder(base)
    local newSignal = table.deepcopy(base)
    newSignal.name = tostring(SIGNAL_PLACEHOLDER_NAME_PREFIX) .. tostring(base.name)
    newSignal.order = "zzz[do-not-use]"
    newSignal.icon = "__core__/graphics/empty.png"
    newSignal.icon_size = 1
    newSignal.icon_mipmaps = 0
    return newSignal
end
data:extend(
    {
        makeVirtualSignalPlaceholder(data.raw["virtual-signal"]["signal-anything"]),
        makeVirtualSignalPlaceholder(data.raw["virtual-signal"]["signal-each"]),
        makeVirtualSignalPlaceholder(data.raw["virtual-signal"]["signal-everything"])
    }
)
return ____exports
