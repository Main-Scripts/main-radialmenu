local ESX = exports["es_extended"]:getSharedObject()

-- Server Events

-- Player Actions
RegisterNetEvent('radialmenu:server:healPlayer', function(targetId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(targetId)
    
    if not xPlayer or not xTarget then return end
    
    if xPlayer.job.name == 'ambulance' then
        TriggerClientEvent('radialmenu:client:healPlayer', targetId)
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Medical Action',
            description = 'You healed ' .. xTarget.getName(),
            type = 'success'
        })
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Access Denied',
            description = 'You don\'t have permission to do this',
            type = 'error'
        })
    end
end)

RegisterNetEvent('radialmenu:server:revivePlayer', function(targetId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(targetId)
    
    if not xPlayer or not xTarget then return end
    
    if xPlayer.job.name == 'ambulance' then
        TriggerClientEvent('esx_ambulancejob:revive', targetId)
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Medical Action',
            description = 'You revived ' .. xTarget.getName(),
            type = 'success'
        })
        
        -- Log to database
        MySQL.insert('INSERT INTO radial_logs (player_identifier, target_identifier, action, timestamp) VALUES (?, ?, ?, ?)', {
            xPlayer.identifier,
            xTarget.identifier,
            'revive',
            os.date('%Y-%m-%d %H:%M:%S')
        })
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Access Denied',
            description = 'You don\'t have permission to do this',
            type = 'error'
        })
    end
end)

-- Police Actions
RegisterNetEvent('radialmenu:server:handcuffPlayer', function(targetId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(targetId)
    
    if not xPlayer or not xTarget then return end
    
    if xPlayer.job.name == 'police' then
        TriggerClientEvent('esx_policejob:handcuff', targetId)
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Police Action',
            description = 'You handcuffed ' .. xTarget.getName(),
            type = 'success'
        })
        
        -- Log to database
        MySQL.insert('INSERT INTO radial_logs (player_identifier, target_identifier, action, timestamp) VALUES (?, ?, ?, ?)', {
            xPlayer.identifier,
            xTarget.identifier,
            'handcuff',
            os.date('%Y-%m-%d %H:%M:%S')
        })
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Access Denied',
            description = 'You don\'t have permission to do this',
            type = 'error'
        })
    end
end)

RegisterNetEvent('radialmenu:server:searchPlayer', function(targetId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(targetId)
    
    if not xPlayer or not xTarget then return end
    
    if xPlayer.job.name == 'police' then
        -- Open target's inventory for searching
        TriggerClientEvent('ox_inventory:openInventory', src, 'player', targetId)
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Police Action',
            description = 'Searching ' .. xTarget.getName(),
            type = 'inform'
        })
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Access Denied',
            description = 'You don\'t have permission to do this',
            type = 'error'
        })
    end
end)

RegisterNetEvent('radialmenu:server:finePlayer', function(targetId, amount, reason)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(targetId)
    
    if not xPlayer or not xTarget then return end
    
    if xPlayer.job.name == 'police' then
        if xTarget.getMoney() >= amount then
            xTarget.removeMoney(amount)
            TriggerClientEvent('ox_lib:notify', targetId, {
                title = 'Fine Received',
                description = 'You were fined $' .. amount .. ' for: ' .. reason,
                type = 'warning'
            })
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Fine Issued',
                description = 'You fined ' .. xTarget.getName() .. ' $' .. amount,
                type = 'success'
            })
            
            -- Log to database
            MySQL.insert('INSERT INTO radial_logs (player_identifier, target_identifier, action, amount, reason, timestamp) VALUES (?, ?, ?, ?, ?, ?)', {
                xPlayer.identifier,
                xTarget.identifier,
                'fine',
                amount,
                reason,
                os.date('%Y-%m-%d %H:%M:%S')
            })
        else
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Insufficient Funds',
                description = 'Player doesn\'t have enough money',
                type = 'error'
            })
        end
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Access Denied',
            description = 'You don\'t have permission to do this',
            type = 'error'
        })
    end
end)

-- Vehicle Repair (Mechanic)
RegisterNetEvent('radialmenu:server:repairVehicle', function(plate)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if xPlayer.job.name == 'mechanic' then
        TriggerClientEvent('radialmenu:client:repairVehicle', src, plate)
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Vehicle Repaired',
            description = 'You repaired the vehicle',
            type = 'success'
        })
        
        -- Charge for repair
        xPlayer.addMoney(250)
        
        -- Log to database
        MySQL.insert('INSERT INTO radial_logs (player_identifier, action, vehicle_plate, timestamp) VALUES (?, ?, ?, ?)', {
            xPlayer.identifier,
            'vehicle_repair',
            plate,
            os.date('%Y-%m-%d %H:%M:%S')
        })
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Access Denied',
            description = 'You are not a mechanic',
            type = 'error'
        })
    end
end)

-- Item Usage
RegisterNetEvent('radialmenu:server:useItem', function(itemName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then return end
    
    local item = exports.ox_inventory:GetItem(src, itemName, nil, true)
    
    if item and item.count > 0 then
        exports.ox_inventory:UseItem(src, itemName, 1)
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Item Used',
            description = 'You used ' .. item.label,
            type = 'success'
        })
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'No Item',
            description = 'You don\'t have this item',
            type = 'error'
        })
    end
end)

-- Get Player Data
ESX.RegisterServerCallback('radialmenu:getPlayerData', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        cb(nil)
        return 
    end
    
    local playerData = {
        name = xPlayer.getName(),
        job = xPlayer.job.label,
        grade = xPlayer.job.grade_label,
        money = xPlayer.getMoney(),
        bank = xPlayer.getAccount('bank').money,
        identifier = xPlayer.identifier
    }
    
    cb(playerData)
end)

-- Get Nearby Players
ESX.RegisterServerCallback('radialmenu:getNearbyPlayers', function(source, cb, coords)
    local players = {}
    local src = source
    
    for k, v in pairs(ESX.GetExtendedPlayers()) do
        if v.source ~= src then
            local targetCoords = GetEntityCoords(GetPlayerPed(v.source))
            local distance = #(vector3(coords.x, coords.y, coords.z) - targetCoords)
            
            if distance <= 10.0 then
                table.insert(players, {
                    id = v.source,
                    name = v.getName(),
                    coords = targetCoords
                })
            end
        end
    end
    
    cb(players)
end)

-- Admin Functions
RegisterNetEvent('radialmenu:server:adminTeleport', function(targetId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin' then
        local targetCoords = GetEntityCoords(GetPlayerPed(targetId))
        TriggerClientEvent('radialmenu:client:teleportToPlayer', src, targetCoords)
    end
end)

-- Database functions
function CreateRadialTables()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `radial_logs` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `player_identifier` varchar(60) NOT NULL,
            `target_identifier` varchar(60) DEFAULT NULL,
            `action` varchar(50) NOT NULL,
            `amount` int(11) DEFAULT NULL,
            `reason` text DEFAULT NULL,
            `vehicle_plate` varchar(20) DEFAULT NULL,
            `timestamp` datetime NOT NULL,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
    
    print('^2[RadialMenu]^7 Database tables created successfully')
end

-- Initialize database on resource start
CreateThread(function()
    CreateRadialTables()
end)

-- Cleanup on player disconnect
AddEventHandler('esx:playerDropped', function(playerId, reason)
    -- Clean up any active states for the player
    TriggerClientEvent('radialmenu:client:cleanup', -1, playerId)
end)