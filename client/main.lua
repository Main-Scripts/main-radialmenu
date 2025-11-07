local ESX = exports["es_extended"]:getSharedObject()
local PlayerData = {}
local currentVehicle = nil
local isInVehicle = false
local isDead = false
local isHandcuffed = false

-- Initialize
CreateThread(function()
    while ESX.GetPlayerData().job == nil do
        Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
    InitializeRadialMenu()
end)

-- Initialize Radial Menu with ox_lib
function InitializeRadialMenu()
    -- Register all submenus first
    RegisterPlayerMenu()
    RegisterVehicleMenu()
    RegisterJobMenu()
    RegisterItemsMenu()
    RegisterEmoteMenu()
    RegisterGPSMenu()
    RegisterWalkStyleMenu()
    RegisterVehicleDoorsMenu()
    RegisterEmoteCategoryMenus()
    
    -- Build main radial menu items
    local mainMenuItems = {}
    
    for _, item in pairs(Config.RadialMenus.main) do
        table.insert(mainMenuItems, {
            id = item.id,
            label = item.label,
            icon = item.icon,
            menu = item.id .. '_menu'
        })
    end
    
    -- Add main menu items to global radial
    lib.addRadialItem(mainMenuItems)
end

-- Register Player Menu
function RegisterPlayerMenu()
    local menuItems = {}
    
    if Config.PlayerOptions and Config.PlayerOptions.showId then
        table.insert(menuItems, {
            label = 'Show ID',
            icon = 'fas fa-id-card',
            onSelect = function()
                ESX.TriggerServerCallback('radialmenu:getPlayerData', function(data)
                    if data then ShowPlayerInfo(data) end
                end)
            end
        })
    end
    
    if Config.PlayerOptions and Config.PlayerOptions.ragdoll then
        table.insert(menuItems, {
            label = 'Ragdoll',
            icon = 'fas fa-male',
            onSelect = function()
                ToggleRagdoll()
            end
        })
    end
    
    if Config.PlayerOptions and Config.PlayerOptions.surrender then
        table.insert(menuItems, {
            label = 'Hands Up',
            icon = 'fas fa-hands',
            onSelect = function()
                PlaySurrenderAnim()
            end
        })
    end
    
    if Config.PlayerOptions and Config.PlayerOptions.walkstyles then
        table.insert(menuItems, {
            label = 'Walk Styles',
            icon = 'fas fa-walking',
            menu = 'walkstyle_menu'
        })
    end
    
    table.insert(menuItems, {
        label = 'Open Inventory',
        icon = 'fas fa-search',
        onSelect = function()
            ExecuteCommand('inventory')
        end
    })
    
    lib.registerRadial({
        id = 'player_menu',
        items = menuItems
    })
end

-- Register Vehicle Menu
function RegisterVehicleMenu()
    local menuItems = {}
    
    if Config.VehicleOptions.engine then
        table.insert(menuItems, {
            label = 'Toggle Engine',
            icon = 'fas fa-power-off',
            onSelect = function()
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if vehicle == 0 then vehicle = GetClosestVehicle() end
                if vehicle then ToggleVehicleEngine(vehicle) end
            end
        })
    end
    
    if Config.VehicleOptions.doors then
        table.insert(menuItems, {
            label = 'Vehicle Doors',
            icon = 'fas fa-door-open',
            menu = 'vehicle_doors'
        })
    end
    
    if Config.VehicleOptions.trunk then
        table.insert(menuItems, {
            label = 'Open Trunk',
            icon = 'fas fa-box-open',
            onSelect = function()
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if vehicle == 0 then vehicle = GetClosestVehicle() end
                if vehicle then ToggleVehicleDoor(vehicle, 5) end
            end
        })
    end
    
    if Config.VehicleOptions.hood then
        table.insert(menuItems, {
            label = 'Open Hood',
            icon = 'fas fa-car-crash',
            onSelect = function()
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if vehicle == 0 then vehicle = GetClosestVehicle() end
                if vehicle then ToggleVehicleDoor(vehicle, 4) end
            end
        })
    end
    
    if Config.VehicleOptions.lights then
        table.insert(menuItems, {
            label = 'Toggle Lights',
            icon = 'fas fa-lightbulb',
            onSelect = function()
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if vehicle == 0 then vehicle = GetClosestVehicle() end
                if vehicle then ToggleVehicleLights(vehicle) end
            end
        })
    end
    
    lib.registerRadial({
        id = 'vehicle_menu',
        items = menuItems
    })
end

-- Register Job Menu
function RegisterJobMenu()
    if not PlayerData.job or not Config.JobMenus[PlayerData.job.name] then
        lib.registerRadial({
            id = 'job_menu',
            items = {{label = 'No Job Actions', icon = 'fas fa-times'}}
        })
        return
    end
    
    local jobConfig = Config.JobMenus[PlayerData.job.name]
    local menuItems = {}
    
    for _, item in pairs(jobConfig.items) do
        table.insert(menuItems, {
            label = item.label,
            icon = item.icon,
            onSelect = function()
                ExecuteJobAction(item.action)
            end
        })
    end
    
    lib.registerRadial({
        id = 'job_menu',
        items = menuItems
    })
end

-- Register Items Menu
function RegisterItemsMenu()
    local menuItems = {}
    
    if Config.UseOxInventory and Config.QuickItems then
        for _, item in pairs(Config.QuickItems) do
            table.insert(menuItems, {
                label = item.label,
                icon = item.icon,
                onSelect = function()
                    TriggerServerEvent('radialmenu:server:useItem', item.item)
                end
            })
        end
    end
    
    table.insert(menuItems, {
        label = 'Open Inventory',
        icon = 'fas fa-boxes',
        onSelect = function()
            ExecuteCommand('inventory')
        end
    })
    
    lib.registerRadial({
        id = 'items_menu',
        items = menuItems
    })
end

-- Register Emote Menu
function RegisterEmoteMenu()
    local menuItems = {}
    
    if Config.Animations then
        for category, emotes in pairs(Config.Animations) do
            table.insert(menuItems, {
                label = string.upper(string.sub(category, 1, 1)) .. string.sub(category, 2),
                icon = 'fas fa-theater-masks',
                menu = 'emote_category_' .. category
            })
        end
    end
    
    table.insert(menuItems, {
        label = 'Stop Animation',
        icon = 'fas fa-stop',
        onSelect = function()
            ClearPedTasks(PlayerPedId())
        end
    })
    
    lib.registerRadial({
        id = 'emotes_menu',
        items = menuItems
    })
end

-- Register GPS Menu
function RegisterGPSMenu()
    local menuItems = {}
    
    if Config.GPSLocations then
        for _, location in pairs(Config.GPSLocations) do
            table.insert(menuItems, {
                label = location.label,
                icon = location.icon,
                onSelect = function()
                    SetNewWaypoint(location.coords.x, location.coords.y)
                    lib.notify({
                        title = 'GPS Set',
                        description = 'Waypoint set to ' .. location.label,
                        type = 'success'
                    })
                end
            })
        end
    end
    
    table.insert(menuItems, {
        label = 'Clear Waypoint',
        icon = 'fas fa-times',
        onSelect = function()
            SetWaypointOff()
            lib.notify({
                title = 'GPS Cleared',
                description = 'Waypoint cleared',
                type = 'inform'
            })
        end
    })
    
    lib.registerRadial({
        id = 'gps_menu',
        items = menuItems
    })
end

-- Register Walk Style Menu
function RegisterWalkStyleMenu()
    local walkStyles = {
        {label = 'Normal', value = 'move_m@casual@d'},
        {label = 'Confident', value = 'move_m@confident'},
        {label = 'Tough', value = 'move_m@tough_guy@'},
        {label = 'Femme', value = 'move_f@femme@'},
        {label = 'Gangster', value = 'move_m@gangster@ng'},
        {label = 'Posh', value = 'move_m@posh@'},
    }
    
    local menuItems = {}
    for _, style in pairs(walkStyles) do
        table.insert(menuItems, {
            label = style.label,
            icon = 'fas fa-walking',
            onSelect = function()
                RequestAnimSet(style.value)
                while not HasAnimSetLoaded(style.value) do
                    Wait(0)
                end
                SetPedMovementClipset(PlayerPedId(), style.value, 0.25)
                lib.notify({
                    title = 'Walk Style Changed',
                    description = 'Walk style set to ' .. style.label,
                    type = 'success'
                })
            end
        })
    end
    
    lib.registerRadial({
        id = 'walkstyle_menu',
        items = menuItems
    })
end

-- Register Vehicle Doors Menu
function RegisterVehicleDoorsMenu()
    local doors = {
        {label = 'Front Left', door = 0},
        {label = 'Front Right', door = 1},
        {label = 'Back Left', door = 2},
        {label = 'Back Right', door = 3},
    }
    
    local menuItems = {}
    for _, doorInfo in pairs(doors) do
        table.insert(menuItems, {
            label = doorInfo.label,
            icon = 'fas fa-door-open',
            onSelect = function()
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if vehicle == 0 then vehicle = GetClosestVehicle() end
                if vehicle then ToggleVehicleDoor(vehicle, doorInfo.door) end
            end
        })
    end
    
    lib.registerRadial({
        id = 'vehicle_doors',
        items = menuItems
    })
end

-- Register Emote Category Menus
function RegisterEmoteCategoryMenus()
    if not Config.Animations then return end
    
    for category, emotes in pairs(Config.Animations) do
        local menuItems = {}
        
        for _, emote in pairs(emotes) do
            table.insert(menuItems, {
                label = emote.label,
                icon = 'fas fa-play',
                onSelect = function()
                    PlayEmote(emote.dict, emote.anim)
                end
            })
        end
        
        lib.registerRadial({
            id = 'emote_category_' .. category,
            items = menuItems
        })
    end
end

-- Register all submenus
function RegisterAllSubmenus()
    -- This function is now replaced by individual registration functions above
end

-- Update player data
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    Wait(1000)
    InitializeRadialMenu()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    -- Re-register job menu with new job
    RegisterJobMenu()
end)

-- Main Radial Menu
function OpenRadialMenu()
    if isDead or isHandcuffed then
        lib.notify({
            title = 'Cannot Open Menu',
            description = 'You cannot open the menu right now',
            type = 'error'
        })
        return
    end

    -- The radial menu is controlled by ox_lib's keybind system
    -- We only need to ensure items are registered
end

function BuildMainMenu()
    local menuItems = {}
    
    for _, item in pairs(Config.RadialMenus.main) do
        if item.id == 'job' then
            -- Only show job menu if player has a job with menu items
            if PlayerData.job and Config.JobMenus[PlayerData.job.name] and Config.JobMenus[PlayerData.job.name].enabled then
                table.insert(menuItems, {
                    label = item.label,
                    icon = item.icon,
                    onSelect = function()
                        TriggerEvent(item.event)
                    end
                })
            end
        elseif item.id == 'vehicle' then
            -- Only show vehicle menu if player is near a vehicle or in one
            if isInVehicle or GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 or GetClosestVehicle() then
                table.insert(menuItems, {
                    label = item.label,
                    icon = item.icon,
                    onSelect = function()
                        TriggerEvent(item.event)
                    end
                })
            end
        else
            table.insert(menuItems, {
                label = item.label,
                icon = item.icon,
                onSelect = function()
                    TriggerEvent(item.event)
                end
            })
        end
    end
    
    return menuItems
end

-- Helper Functions
function GetClosestVehicle()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local vehicles = GetGamePool('CVehicle')
    local closestVehicle = nil
    local closestDistance = math.huge
    
    for _, vehicle in pairs(vehicles) do
        local vehicleCoords = GetEntityCoords(vehicle)
        local distance = #(playerCoords - vehicleCoords)
        
        if distance < closestDistance and distance < 5.0 then
            closestDistance = distance
            closestVehicle = vehicle
        end
    end
    
    return closestVehicle
end

function ShowPlayerInfo(data)
    lib.notify({
        title = 'Player Information',
        description = string.format('Name: %s\nJob: %s\nID: %s\nMoney: $%s\nBank: $%s', 
            data.name, data.job, GetPlayerServerId(PlayerId()), data.money, data.bank),
        type = 'inform',
        duration = 10000
    })
end

function ToggleRagdoll()
    local playerPed = PlayerPedId()
    SetPedToRagdoll(playerPed, 5000, 5000, 0, 0, 0, 0)
end

function PlaySurrenderAnim()
    local playerPed = PlayerPedId()
    RequestAnimDict('random@mugging3')
    while not HasAnimDictLoaded('random@mugging3') do
        Wait(0)
    end
    TaskPlayAnim(playerPed, 'random@mugging3', 'handsup_standing_base', 8.0, -8.0, -1, 49, 0, 0, 0, 0)
end

function ToggleVehicleEngine(vehicle)
    local isEngineOn = GetIsVehicleEngineRunning(vehicle)
    SetVehicleEngineOn(vehicle, not isEngineOn, false, true)
    
    lib.notify({
        title = 'Engine',
        description = isEngineOn and 'Engine turned off' or 'Engine turned on',
        type = 'inform'
    })
end

function ToggleVehicleDoor(vehicle, door)
    if GetVehicleDoorAngleRatio(vehicle, door) > 0.0 then
        SetVehicleDoorShut(vehicle, door, false)
    else
        SetVehicleDoorOpen(vehicle, door, false, false)
    end
end

function ToggleVehicleLights(vehicle)
    local lightsOn = GetVehicleLightsState(vehicle)
    SetVehicleLights(vehicle, lightsOn == 1 and 0 or 2)
end

function PlayEmote(dict, anim)
    local playerPed = PlayerPedId()
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
    TaskPlayAnim(playerPed, dict, anim, 8.0, -8.0, -1, 0, 0, 0, 0, 0)
end

function ExecuteJobAction(action)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    if action == 'handcuff' or action == 'search' or action == 'fine' or action == 'jail' or 
       action == 'drag' or action == 'putinvehicle' or action == 'heal' or action == 'revive' then
        
        ESX.TriggerServerCallback('radialmenu:getNearbyPlayers', function(players)
            if #players == 0 then
                lib.notify({
                    title = 'No Players',
                    description = 'No players nearby',
                    type = 'error'
                })
                return
            end
            
            local targetOptions = {}
            for _, player in pairs(players) do
                table.insert(targetOptions, {
                    label = player.name .. ' (ID: ' .. player.id .. ')',
                    value = player.id
                })
            end
            
            local input = lib.inputDialog('Select Target', {
                {type = 'select', label = 'Player', options = targetOptions, required = true}
            })
            
            if input and input[1] then
                ExecuteTargetAction(action, input[1])
            end
        end, playerCoords)
    else
        ExecuteDirectAction(action)
    end
end

function ExecuteTargetAction(action, targetId)
    if action == 'handcuff' then
        TriggerServerEvent('radialmenu:server:handcuffPlayer', targetId)
    elseif action == 'search' then
        TriggerServerEvent('radialmenu:server:searchPlayer', targetId)
    elseif action == 'fine' then
        local input = lib.inputDialog('Fine Player', {
            {type = 'number', label = 'Amount', required = true, min = 1, max = 50000},
            {type = 'input', label = 'Reason', required = true}
        })
        
        if input and input[1] and input[2] then
            TriggerServerEvent('radialmenu:server:finePlayer', targetId, input[1], input[2])
        end
    elseif action == 'heal' then
        TriggerServerEvent('radialmenu:server:healPlayer', targetId)
    elseif action == 'revive' then
        TriggerServerEvent('radialmenu:server:revivePlayer', targetId)
    end
end

function ExecuteDirectAction(action)
    if action == 'checklicense' then
        -- Open license check interface
        lib.notify({
            title = 'License Check',
            description = 'License check interface would open here',
            type = 'inform'
        })
    elseif action == 'checkpulse' then
        lib.notify({
            title = 'Pulse Check',
            description = 'Player pulse is normal',
            type = 'success'
        })
    elseif action == 'diagnostic' then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if vehicle == 0 then
            vehicle = GetClosestVehicle()
        end
        
        if vehicle then
            local engineHealth = GetVehicleEngineHealth(vehicle)
            local bodyHealth = GetVehicleBodyHealth(vehicle)
            
            lib.notify({
                title = 'Vehicle Diagnostic',
                description = string.format('Engine: %.0f%%\nBody: %.0f%%', 
                    engineHealth/10, bodyHealth/10),
                type = 'inform',
                duration = 5000
            })
        end
    end
end

-- ox_target Integration
if Config.UseTarget then
    CreateThread(function()
        -- Player targeting
        exports.ox_target:addGlobalPlayer({
            {
                name = 'radialmenu_player',
                icon = Config.TargetIcon,
                label = 'Radial Menu',
                onSelect = function(data)
                    OpenPlayerTargetMenu(data.entity)
                end,
                distance = Config.TargetDistance
            }
        })
        
        -- Vehicle targeting
        exports.ox_target:addGlobalVehicle({
            {
                name = 'radialmenu_vehicle',
                icon = 'fas fa-car',
                label = 'Vehicle Options',
                onSelect = function(data)
                    currentVehicle = data.entity
                    TriggerEvent('radialmenu:client:openVehicleMenu')
                end,
                distance = Config.TargetDistance
            }
        })
    end)
end

function OpenPlayerTargetMenu(targetPed)
    local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(targetPed))
    
    local menuItems = {}
    
    if PlayerData.job and PlayerData.job.name == 'police' then
        table.insert(menuItems, {
            label = 'Handcuff',
            icon = 'fas fa-lock',
            onSelect = function()
                TriggerServerEvent('radialmenu:server:handcuffPlayer', targetId)
            end
        })
        
        table.insert(menuItems, {
            label = 'Search',
            icon = 'fas fa-search',
            onSelect = function()
                TriggerServerEvent('radialmenu:server:searchPlayer', targetId)
            end
        })
    end
    
    if PlayerData.job and PlayerData.job.name == 'ambulance' then
        table.insert(menuItems, {
            label = 'Heal',
            icon = 'fas fa-medkit',
            onSelect = function()
                TriggerServerEvent('radialmenu:server:healPlayer', targetId)
            end
        })
        
        table.insert(menuItems, {
            label = 'Revive',
            icon = 'fas fa-heartbeat',
            onSelect = function()
                TriggerServerEvent('radialmenu:server:revivePlayer', targetId)
            end
        })
    end
    
    if #menuItems > 0 then
        lib.registerRadial({
            id = 'target_player_menu',
            items = menuItems
        })
    end
end

-- Client Events
RegisterNetEvent('radialmenu:client:healPlayer')
AddEventHandler('radialmenu:client:healPlayer', function()
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
    lib.notify({
        title = 'Healed',
        description = 'You have been healed',
        type = 'success'
    })
end)

RegisterNetEvent('radialmenu:client:repairVehicle')
AddEventHandler('radialmenu:client:repairVehicle', function(plate)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then
        vehicle = GetClosestVehicle()
    end
    
    if vehicle then
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineOn(vehicle, true, true, false)
    end
end)

RegisterNetEvent('radialmenu:client:teleportToPlayer')
AddEventHandler('radialmenu:client:teleportToPlayer', function(coords)
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, true)
end)

RegisterNetEvent('radialmenu:client:cleanup')
AddEventHandler('radialmenu:client:cleanup', function(playerId)
    -- Cleanup any active states
end)

-- Status Updates
AddEventHandler('esx:onPlayerDeath', function()
    isDead = true
end)

AddEventHandler('esx:onPlayerSpawn', function()
    isDead = false
end)

AddEventHandler('esx_policejob:handcuff', function()
    isHandcuffed = not isHandcuffed
end)

-- Vehicle Enter/Exit
CreateThread(function()
    while true do
        Wait(1000)
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if vehicle ~= 0 then
            if not isInVehicle then
                isInVehicle = true
                currentVehicle = vehicle
            end
        else
            if isInVehicle then
                isInVehicle = false
                currentVehicle = nil
            end
        end
    end
end)