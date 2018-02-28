local gridConfig = '6x6'
local gridStack = {}
local registeredLayouts = {}
local menubarIcon

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
-- @param string name
-- @param layout
--
local function addLayout(name, layout)
    registeredLayouts[name] = layout
end

--- Activate a registered layout by its name
-- @param string name
--
local function activateLayout(name)
    if registeredLayouts[name] == nil then
        return
    end

    local layout = registeredLayouts[name]
    for index, config in ipairs(layout) do
        moveWindowsByApplication(config["app"], config["grid"], config["screen"])
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
        local menubarEntries = {}
        for name, layout in pairs(registeredLayouts) do
            table.insert(menubarEntries, {
                title = name,
                fn = function()
                    activateLayout(name)
                end
            })
        end
        return menubarEntries
    end)
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
end

--- Register a new layout with the system, which is displayed in the corresponding menubar menu
-- @param string name
-- @param table layout
--
windowLayouts.registerLayout = function(name, layout)
    addLayout(name, layout)
end

return windowLayouts
