local gridConfig = '6x6'
local gridStack = {}
local registeredLayouts = {}
local activeHotkeyBindings = {}
local menubarIcon
local menuItems

--- Save a specific grid configuration for later use
-- @param string newGridConfig
--
local function saveGridConfig(newGridConfig)
    gridConfig = newGridConfig
end

--- Return the currently save grid config
-- @return string
--
local function getGridConfig()
    return gridConfig
end

--- Restore the latest grid configuration active before the last `pushGrid`
--
local function popGrid()
    local poppedElement = table.remove(gridStack)
    if poppedElement == nil then
        return
    end
    hs.grid.setGrid(poppedElement, nil, nil)
end

--- Push the given grid onto the stack and activate it
-- @param gridGeometry
--
local function pushGrid(gridGeometry)
    local currentGrid = hs.grid.getGrid()
    table.insert(gridStack, currentGrid)
    hs.grid.setGrid(gridGeometry, nil, nil)
end

--- Move all windows of a specific application to the given grid position on the given screen
-- @param string appName
-- @param hs.geometry gridGeometry
-- @param hs.screen screen
--
local function moveWindowsByApplication(appName, gridGeometry, screen)
    local app = hs.appfinder.appFromName(appName)
    if app == nil then
        return
    end

    local windows = app:allWindows()
    if next(windows) == nil then
        return
    end

    pushGrid(getGridConfig())
    for index, window in ipairs(windows) do
        local realWindowLocation = hs.grid.getCell(gridGeometry, screen)
        window:move(realWindowLocation)
    end
    popGrid()
end

--- Add a specific layout with a given name to the system
---
-- @param string name
-- @param table apps
-- @param string|nil hotkey
-- @param string|nil icon
--
local function addLayout(name, apps, hotkey, icon)
    table.insert(registeredLayouts, {
        name = name,
        apps = apps,
        hotkey = hotkey,
        icon = icon,
    })
end

--- Check if the layout with the given name is registered
-- @param string name
--
local function isLayoutRegistered(name)
    for index, layout in ipairs(registeredLayouts) do
        if layout.name == name then
            return true
        end
    end

    return false
end

local function getLayoutByName(name)
    for index, layout in ipairs(registeredLayouts) do
        if layout.name == name then
            return layout
        end
    end

    return nil
end

--- Activate a registered layout by its name
-- @param string name
--
local function activateLayout(name)
    if not isLayoutRegistered(name) then
        return
    end

    local layout = getLayoutByName(name)
    for index, app in ipairs(layout["apps"]) do
        moveWindowsByApplication(app["name"], app["grid"], app["screen"])
    end
end

--- Initialize and load the Menubar Icon to be used
-- @return hs.image
--
local function loadMenubarIcon()
    local iconPath = hs.configdir .. "/windowLayouts/icons"
    return hs.image.imageFromPath(iconPath .. "/window-restore.pdf"):setSize({ w = 16, h = 16 })
end

--- Initialize and show the menubar icon for switching between layouts
--
local function initMenubarIcon()
    menubarIcon = hs.menubar.new()
    menubarIcon:setIcon(loadMenubarIcon())
    menubarIcon:setMenu(function()
        return menuItems
    end)
end

--- Update the menuItemsInformation and redraw the menu
--
local function updateMenuIcons()
    local menubarEntries = {}
    for index, layout in ipairs(registeredLayouts) do
        local displayString = layout["name"]
        if layout["hotkey"] ~= nil then
            displayString = displayString .. " (" .. layout["hotkey"]["mods"] .. layout["hotkey"]["key"] .. ")"
        end

        table.insert(menubarEntries, {
            title = displayString,
            image = layout["icon"],
            fn = function()
                activateLayout(layout["name"])
            end
        })
    end
    menuItems = menubarEntries
end

local function deregisterAllActiveHotkeys()
    for index, binding in ipairs(activeHotkeyBindings) do
        binding:delete();
    end
    activeHotkeyBindings = {}
end

--- Register and activate a specific hotkey
-- @param hotkey
-- @param layoutName
--
local function activateHotkey(hotkey, layoutName)
    local binding = hs.hotkey.bind(hotkey["mods"],
        hotkey["key"],
        layoutName,
        nil,
        function()
            activateLayout(layoutName)
        end,
        nil)

    table.insert(activeHotkeyBindings, binding)
end

--- Update all the registered hotkeys corresponding to layouts
--
local function updateHotkeys()
    deregisterAllActiveHotkeys()
    for index, layout in ipairs(registeredLayouts) do
        if layout["hotkey"] ~= nil then
            activateHotkey(layout["hotkey"], layout["name"])
        end
    end
end

-- Public interface
local windowLayouts = {}

--- Initialize the module using a specific grid configuration
-- This function needs to be called before calling anything else related to this module
-- @param string gridConfig
--
windowLayouts.initialize = function(gridConfig)
    saveGridConfig(gridConfig)
    initMenubarIcon()
    updateMenuIcons()
    updateHotkeys()
end

--- Register a new layout with the system, which is displayed in the corresponding menubar menu
-- @param table apps
-- @param string|nil hotkey
-- @param string|nil icon
--
windowLayouts.registerLayout = function(name, apps, hotkey, icon)
    addLayout(name, apps, hotkey, icon)
    updateMenuIcons()
    updateHotkeys()
end

return windowLayouts
