--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local createTemplate, findStackToUse
function createTemplate(settings)
    local stack = findStackToUse()
    stack.set_stack("blueprint")
    stack.set_blueprint_entities({{entity_number = 1, name = "musical-speaker-note-player", position = {0, 0}, parameters = {allow_polyphony = false, playback_globally = settings.globalPlayback, playback_volume = settings.volume / 100}, alert_parameters = {alert_message = "", show_alert = false, show_on_map = true}}})
    return stack
end
function findStackToUse()
    local currentStore = global.speakerTemplates.currentStore
    if currentStore and currentStore.valid then
        local inventory = currentStore.get_inventory(defines.inventory.chest)
        local stack = inventory.find_empty_stack()
        if stack then
            return stack
        end
    end
    local newStore = game.get_surface("nauvis").create_entity({name = "musical-speaker-template-store", force = game.forces.neutral, position = {x = 0, y = 0}})
    if not newStore then
        error("Failed to create a new template store", 0)
    end
    global.speakerTemplates.currentStore = newStore
    return ({
        newStore.get_inventory(defines.inventory.chest).find_empty_stack()
    })[1]
end
local function getKey(store)
    return __TS__ArrayJoin({store.globalPlayback, store.volume}, "-")
end
function ____exports.getTemplate(settings)
    local key = getKey(settings)
    local stack = global.speakerTemplates.templates[key]
    if (not stack) or (not stack.valid) then
        stack = (function(o, i, v)
            o[i] = v
            return v
        end)(
            global.speakerTemplates.templates,
            key,
            createTemplate(settings)
        )
    end
    return stack
end
return ____exports
