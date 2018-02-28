local gridConfig = '6x6'
local gridStack = {}
local registeredLayouts = {}
local menubarIcon

function saveGridConfig(newGridConfig)
    gridConfig = newGridConfig
end

function getGridConfig()
    return gridConfig
end

function popGrid()
    local poppedElement = table.remove(gridStack)
    if poppedElement == nil then
        return
    end
    hs.grid.setGrid(poppedElement, nil, nil)
end

function pushGrid(gridGeometry)
    local currentGrid = hs.grid.getGrid()
    table.insert(gridStack, currentGrid)
    hs.grid.setGrid(gridGeometry, nil, nil)
end

function moveWindowsByApplication(appName, gridGeometry, screen)
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

function addLayout(name, layout)
    registeredLayouts[name] = layout
end

function activateLayout(name)
    if registeredLayouts[name] == nil then
        return
    end

    local layout = registeredLayouts[name]
    for index, config in ipairs(layout) do
        moveWindowsByApplication(config["app"], config["grid"], config["screen"])
    end
end

function loadMenubarIcon()
    local iconPath = hs.configdir .. "/windowLayouts/icons"
    return hs.image.imageFromPath(iconPath .. "/window-restore.pdf"):setSize({ w = 16, h = 16 })
end

function initMenubarIcon()
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

windowLayouts.initialize = function(gridConfig)
    saveGridConfig(gridConfig)
    initMenubarIcon()
end

windowLayouts.registerLayout = function(name, layout)
    addLayout(name, layout)
end

return windowLayouts
