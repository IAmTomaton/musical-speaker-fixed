--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local util = require("util")
local closeButton, mainContent
function closeButton(extra)
    return util.merge({{type = "sprite-button", style = "frame_action_button", sprite = "utility/close_white"}, extra or ({})})
end
function mainContent(extra)
    return util.merge({{type = "frame", style = "inside_shallow_frame_with_padding", direction = "vertical"}, extra or ({})})
end
local function window(args)
    local window = args.parent.add({type = "frame", direction = "vertical"})
    window.auto_center = true
    window.visible = true
    local titleBar = window.add({type = "flow", direction = "horizontal"})
    titleBar.style.horizontally_stretchable = true
    titleBar.style.horizontal_spacing = 8
    local titleBarText = titleBar.add({type = "label", caption = args.caption, style = "frame_title"})
    titleBarText.drag_target = window
    local pusher = titleBar.add({type = "empty-widget", style = "draggable_space_header"})
    pusher.style.height = 24
    pusher.style.horizontally_stretchable = true
    pusher.drag_target = window
    local cb
    if not args.noCloseButton then
        cb = titleBar.add(
            closeButton()
        )
    end
    local mc
    if not args.noMainContent then
        mc = window.add(
            mainContent()
        )
    end
    return {element = window, titleBar = titleBar, closeButton = cb, mainContent = mc}
end
local function panel(args)
    local element = args.parent.add({type = "flow", direction = args.direction or "vertical", style = args.style})
    if args.line then
        element.add({type = "line", direction = ((element.direction == "horizontal") and "vertical") or "horizontal"})
    end
    return {element = element, content = element}
end
local function labelledPanel(args)
    local element = panel(args).element
    local caption = element.add({type = "label", caption = args.caption, style = args.captionStyle or "heading_2_label"})
    local content = element.add({type = "flow", direction = args.direction or "horizontal"})
    return {element = element, caption = caption, content = content}
end
____exports.default = {window = window, closeButton = closeButton, mainContent = mainContent, panel = panel, labelledPanel = labelledPanel}
return ____exports
