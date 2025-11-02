Config = {}

-- General Settings
Config.Framework = 'esx' -- ESX framework
Config.Locale = 'en'
Config.Debug = false

-- Radial Menu Settings
Config.RadialKey = 'F1' -- Key to open radial menu
Config.DisableControlAction = 245 -- Chat control to disable
Config.MenuSize = 'md' -- sm, md, lg
Config.MenuPosition = 'bottom-right' -- top-left, top-right, bottom-left, bottom-right

-- Target Settings
Config.UseTarget = true -- Enable ox_target integration
Config.TargetDistance = 3.0
Config.TargetIcon = 'fas fa-hand-paper'

-- Inventory Settings
Config.UseOxInventory = true
Config.EnableQuickUse = true -- Quick use items from radial menu

-- Vehicle Settings
Config.VehicleOptions = {
    engine = true, -- Toggle engine
    doors = true, -- Open/close doors
    trunk = true, -- Open trunk
    hood = true, -- Open hood
    windows = true, -- Roll windows up/down
    lights = true, -- Toggle lights
}

-- Player Settings
Config.PlayerOptions = {
    showId = true, -- Show player ID
    showJob = true, -- Show job
    showMoney = true, -- Show money
    ragdoll = true, -- Enable ragdoll
    surrender = true, -- Hands up animation
    dance = true, -- Dance menu
    walkstyles = true, -- Walking styles
}

-- Job Settings
Config.JobMenus = {
    police = {
        enabled = true,
        items = {
            {label = 'Handcuff', action = 'handcuff', icon = 'fas fa-lock'},
            {label = 'Search Player', action = 'search', icon = 'fas fa-search'},
            {label = 'Fine Player', action = 'fine', icon = 'fas fa-money-bill'},
            {label = 'Jail Player', action = 'jail', icon = 'fas fa-gavel'},
            {label = 'Drag Player', action = 'drag', icon = 'fas fa-arrows-alt'},
            {label = 'Put in Vehicle', action = 'putinvehicle', icon = 'fas fa-car'},
            {label = 'Check License', action = 'checklicense', icon = 'fas fa-id-card'},
        }
    },
    ambulance = {
        enabled = true,
        items = {
            {label = 'Heal Player', action = 'heal', icon = 'fas fa-medkit'},
            {label = 'Revive Player', action = 'revive', icon = 'fas fa-heartbeat'},
            {label = 'Check Pulse', action = 'checkpulse', icon = 'fas fa-heart'},
            {label = 'Put on Stretcher', action = 'stretcher', icon = 'fas fa-procedures'},
        }
    },
    mechanic = {
        enabled = true,
        items = {
            {label = 'Repair Vehicle', action = 'repair', icon = 'fas fa-wrench'},
            {label = 'Impound Vehicle', action = 'impound', icon = 'fas fa-truck'},
            {label = 'Check Vehicle Status', action = 'diagnostic', icon = 'fas fa-clipboard-check'},
        }
    }
}

-- Animation Categories
Config.Animations = {
    dance = {
        {label = 'Dance 1', dict = 'anim@amb@nightclub@dancers@solomun_entourage@', anim = 'mi_dance_facedj_17_v1_female^1'},
        {label = 'Dance 2', dict = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_a@', anim = 'high_center'},
        {label = 'Dance 3', dict = 'anim@amb@nightclub@mini@dance@dance_solo@male@var_b@', anim = 'high_center_down'},
    },
    greetings = {
        {label = 'Wave', dict = 'anim@mp_player_intcelebrationmale@wave', anim = 'wave'},
        {label = 'Salute', dict = 'anim@mp_player_intcelebrationmale@salute', anim = 'salute'},
        {label = 'Thumbs Up', dict = 'anim@mp_player_intcelebrationmale@thumbs_up', anim = 'thumbs_up'},
    },
    misc = {
        {label = 'Sit', dict = 'anim@amb@business@bgen@bgen_no_work@', anim = 'sit_phone_phoneputdown_idle_nowork'},
        {label = 'Lean', dict = 'amb@world_human_leaning@female@wall@back@hand_up@idle_a', anim = 'idle_a'},
        {label = 'CrossArms', dict = 'amb@world_human_hang_out_street@female_arms_crossed@idle_a', anim = 'idle_a'},
    }
}

-- Quick Items (from ox_inventory)
Config.QuickItems = {
    {label = 'Bandage', item = 'bandage', icon = 'fas fa-band-aid'},
    {label = 'Water', item = 'water', icon = 'fas fa-tint'},
    {label = 'Bread', item = 'bread', icon = 'fas fa-bread-slice'},
    {label = 'Phone', item = 'phone', icon = 'fas fa-mobile-alt'},
    {label = 'Radio', item = 'radio', icon = 'fas fa-walkie-talkie'},
}

-- Emote Wheel Settings
Config.EmoteWheel = {
    enabled = true,
    categories = {'dance', 'greetings', 'misc'}
}

-- GPS Locations
Config.GPSLocations = {
    {label = 'Hospital', coords = vector3(307.7, -1433.4, 29.8), icon = 'fas fa-hospital'},
    {label = 'Police Station', coords = vector3(425.1, -979.5, 30.7), icon = 'fas fa-shield-alt'},
    {label = 'Garage', coords = vector3(215.9, -810.1, 30.7), icon = 'fas fa-car'},
    {label = 'Bank', coords = vector3(150.3, -1040.2, 29.4), icon = 'fas fa-university'},
    {label = 'Shop', coords = vector3(25.7, -1347.3, 29.5), icon = 'fas fa-shopping-cart'},
}

-- Radial Menu Structure
Config.RadialMenus = {
    main = {
        {
            id = 'player',
            label = 'Player',
            icon = 'fas fa-user',
            type = 'client',
            event = 'radialmenu:client:openPlayerMenu'
        },
        {
            id = 'vehicle',
            label = 'Vehicle',
            icon = 'fas fa-car',
            type = 'client',
            event = 'radialmenu:client:openVehicleMenu',
            shouldClose = false
        },
        {
            id = 'job',
            label = 'Job Actions',
            icon = 'fas fa-briefcase',
            type = 'client',
            event = 'radialmenu:client:openJobMenu'
        },
        {
            id = 'items',
            label = 'Quick Items',
            icon = 'fas fa-boxes',
            type = 'client',
            event = 'radialmenu:client:openItemsMenu'
        },
        {
            id = 'emotes',
            label = 'Emotes',
            icon = 'fas fa-theater-masks',
            type = 'client',
            event = 'radialmenu:client:openEmoteMenu'
        },
        {
            id = 'gps',
            label = 'GPS',
            icon = 'fas fa-map-marker',
            type = 'client',
            event = 'radialmenu:client:openGPSMenu'
        }
    }
}