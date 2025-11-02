Locales = {}

Locales['en'] = {
    -- General
    ['menu_opened'] = 'Radial menu opened',
    ['menu_closed'] = 'Radial menu closed',
    ['access_denied'] = 'Access Denied',
    ['no_permission'] = 'You don\'t have permission to do this',
    ['player_not_found'] = 'Player not found',
    ['action_completed'] = 'Action completed successfully',
    
    -- Player Actions
    ['player_info'] = 'Player Information',
    ['player_id'] = 'Player ID: %s',
    ['player_name'] = 'Name: %s',
    ['player_job'] = 'Job: %s (%s)',
    ['player_money'] = 'Cash: $%s',
    ['player_bank'] = 'Bank: $%s',
    ['hands_up'] = 'Hands Up',
    ['ragdoll'] = 'Ragdoll',
    ['show_id'] = 'Show ID',
    ['walk_styles'] = 'Walk Styles',
    ['check_pockets'] = 'Check Pockets',
    
    -- Vehicle Actions
    ['no_vehicle'] = 'No vehicle nearby',
    ['toggle_engine'] = 'Toggle Engine',
    ['engine_on'] = 'Engine turned on',
    ['engine_off'] = 'Engine turned off',
    ['vehicle_doors'] = 'Vehicle Doors',
    ['front_left'] = 'Front Left',
    ['front_right'] = 'Front Right',
    ['back_left'] = 'Back Left',
    ['back_right'] = 'Back Right',
    ['open_trunk'] = 'Open Trunk',
    ['open_hood'] = 'Open Hood',
    ['toggle_lights'] = 'Toggle Lights',
    ['repair_vehicle'] = 'Repair Vehicle',
    ['vehicle_repaired'] = 'Vehicle repaired successfully',
    ['impound_vehicle'] = 'Impound Vehicle',
    ['vehicle_diagnostic'] = 'Vehicle Diagnostic',
    ['engine_health'] = 'Engine Health: %.0f%%',
    ['body_health'] = 'Body Health: %.0f%%',
    
    -- Job Actions - Police
    ['handcuff'] = 'Handcuff',
    ['handcuffed'] = 'You handcuffed %s',
    ['search_player'] = 'Search Player',
    ['searching'] = 'Searching %s',
    ['fine_player'] = 'Fine Player',
    ['fine_amount'] = 'Fine Amount',
    ['fine_reason'] = 'Fine Reason',
    ['fine_issued'] = 'You fined %s $%s',
    ['fine_received'] = 'You were fined $%s for: %s',
    ['insufficient_funds'] = 'Player doesn\'t have enough money',
    ['jail_player'] = 'Jail Player',
    ['drag_player'] = 'Drag Player',
    ['put_in_vehicle'] = 'Put in Vehicle',
    ['check_license'] = 'Check License',
    ['license_check'] = 'License check interface would open here',
    
    -- Job Actions - EMS
    ['heal_player'] = 'Heal Player',
    ['healed'] = 'You have been healed',
    ['you_healed'] = 'You healed %s',
    ['revive_player'] = 'Revive Player',
    ['revived'] = 'You have been revived',
    ['you_revived'] = 'You revived %s',
    ['check_pulse'] = 'Check Pulse',
    ['pulse_normal'] = 'Player pulse is normal',
    ['put_stretcher'] = 'Put on Stretcher',
    
    -- Job Actions - Mechanic
    ['not_mechanic'] = 'You are not a mechanic',
    
    -- Items
    ['no_item'] = 'You don\'t have this item',
    ['item_used'] = 'You used %s',
    ['quick_items'] = 'Quick Items',
    ['open_inventory'] = 'Open Inventory',
    ['items_disabled'] = 'Quick items are disabled',
    
    -- Emotes
    ['emotes'] = 'Emotes',
    ['dance'] = 'Dance',
    ['greetings'] = 'Greetings',
    ['misc'] = 'Miscellaneous',
    ['stop_animation'] = 'Stop Animation',
    ['wave'] = 'Wave',
    ['salute'] = 'Salute',
    ['thumbs_up'] = 'Thumbs Up',
    ['sit'] = 'Sit',
    ['lean'] = 'Lean',
    ['cross_arms'] = 'Cross Arms',
    
    -- GPS
    ['gps'] = 'GPS',
    ['gps_set'] = 'Waypoint set to %s',
    ['gps_cleared'] = 'Waypoint cleared',
    ['clear_waypoint'] = 'Clear Waypoint',
    ['hospital'] = 'Hospital',
    ['police_station'] = 'Police Station',
    ['garage'] = 'Garage',
    ['bank'] = 'Bank',
    ['shop'] = 'Shop',
    
    -- Walk Styles
    ['normal'] = 'Normal',
    ['confident'] = 'Confident',
    ['tough'] = 'Tough',
    ['femme'] = 'Femme',
    ['gangster'] = 'Gangster',
    ['posh'] = 'Posh',
    ['walk_style_changed'] = 'Walk style set to %s',
    
    -- Target Menu
    ['no_players'] = 'No players nearby',
    ['select_target'] = 'Select Target',
    ['player'] = 'Player',
    ['target_actions'] = 'Target Actions',
    
    -- Medical
    ['medical_action'] = 'Medical Action',
    
    -- Police
    ['police_action'] = 'Police Action',
    
    -- Notifications
    ['cannot_open_menu'] = 'You cannot open the menu right now',
    ['menu_unavailable'] = 'Menu unavailable',
    ['feature_disabled'] = 'This feature is disabled',
    
    -- Menu Categories
    ['player_menu'] = 'Player',
    ['vehicle_menu'] = 'Vehicle',
    ['job_actions'] = 'Job Actions',
    ['no_job_actions'] = 'No job actions available',
}

-- Add more languages here
Locales['es'] = {
    -- Spanish translations
    ['menu_opened'] = 'Menú radial abierto',
    ['menu_closed'] = 'Menú radial cerrado',
    ['access_denied'] = 'Acceso Denegado',
    ['no_permission'] = 'No tienes permisos para hacer esto',
    -- Add more Spanish translations...
}

Locales['fr'] = {
    -- French translations
    ['menu_opened'] = 'Menu radial ouvert',
    ['menu_closed'] = 'Menu radial fermé',
    ['access_denied'] = 'Accès Refusé',
    ['no_permission'] = 'Vous n\'avez pas la permission de faire cela',
    -- Add more French translations...
}

function _U(str, ...)
    if Locales[Config.Locale] and Locales[Config.Locale][str] then
        return string.format(Locales[Config.Locale][str], ...)
    else
        return 'Translation [' .. Config.Locale .. '][' .. str .. '] does not exist'
    end
end