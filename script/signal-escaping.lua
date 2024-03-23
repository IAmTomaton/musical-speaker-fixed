--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
____exports.SIGNAL_PLACEHOLDER_NAME_PREFIX = "musical-speaker-signal-placeholder-"
function ____exports.escapeSignal(signal)
    local ____switch3 = signal.name
    if ____switch3 == "signal-anything" then
        goto ____switch3_case_0
    elseif ____switch3 == "signal-each" then
        goto ____switch3_case_1
    elseif ____switch3 == "signal-everything" then
        goto ____switch3_case_2
    end
    goto ____switch3_case_default
    ::____switch3_case_0::
    do
    end
    ::____switch3_case_1::
    do
    end
    ::____switch3_case_2::
    do
        return __TS__ObjectAssign(
            {},
            signal,
            {
                name = tostring(____exports.SIGNAL_PLACEHOLDER_NAME_PREFIX) .. tostring(signal.name)
            }
        )
    end
    ::____switch3_case_default::
    do
        return signal
    end
    ::____switch3_end::
end
function ____exports.unescapeSignal(signal)
    if (signal and signal.name) and __TS__StringStartsWith(signal.name, ____exports.SIGNAL_PLACEHOLDER_NAME_PREFIX) then
        return __TS__ObjectAssign(
            {},
            signal,
            {
                name = __TS__StringSubstring(signal.name, #____exports.SIGNAL_PLACEHOLDER_NAME_PREFIX)
            }
        )
    else
        return signal
    end
end
return ____exports
