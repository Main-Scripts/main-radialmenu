# Main Radialmenu - Advanced ESX Radial Menu

A comprehensive and feature-rich radial menu system for ESX servers, integrating with ox_inventory, ox_lib, oxmysql, and ox_target for a complete gameplay experience.

## 🌟 Features

### 🎯 Core Features
- **ox_lib Integration**: Modern UI components with radial menu system
- **ox_target Integration**: Context-based interactions with players and vehicles
- **ox_inventory Integration**: Quick item usage and inventory management
- **oxmysql Integration**: Database logging and user preferences
- **ESX Framework**: Full integration with ESX for job-based actions

### 👤 Player Actions
- Player information display (ID, job, money)
- Animation system with multiple categories (dance, greetings, misc)
- Walking styles selection
- Ragdoll and surrender animations
- Quick inventory access

### 🚗 Vehicle Features
- Engine toggle
- Door controls (individual doors, trunk, hood)
- Light controls
- Window operations
- Mechanic-specific repair options

### 👮 Job-Specific Actions

#### Police
- Handcuff players
- Search players
- Issue fines
- Jail players
- Drag players
- Put players in vehicles
- License checks

#### EMS/Ambulance
- Heal players
- Revive players
- Check pulse
- Stretcher operations

#### Mechanic
- Repair vehicles
- Vehicle diagnostics
- Impound vehicles

### 🗺️ GPS & Navigation
- Predefined locations (Hospital, Police Station, etc.)
- Waypoint setting and clearing
- Custom location support

### 📦 Quick Items
- Configurable quick-use items
- Direct inventory integration
- Item usage tracking

## 📋 Requirements

- **ESX Legacy** (latest version)
- **ox_lib** (latest version)
- **ox_inventory** (latest version)
- **ox_target** (latest version)
- **oxmysql** (latest version)

## 🛠️ Installation

### 1. Download and Extract
```bash
cd resources
git clone https://github.com/Main-Scripts/main-radialmenu.git
```

### 2. Database Setup
Execute the `database.sql` file in your MySQL database:
```sql
mysql -u username -p database_name < database.sql
```

### 3. Server Configuration
Add to your `server.cfg`:
```cfg
ensure ox_lib
ensure ox_inventory
ensure ox_target
ensure oxmysql
ensure main-radialmenu
```

### 4. Dependencies Check
Make sure all required resources are started **before** main-radialmenu:
```cfg
# Correct order
start ox_lib
start ox_inventory
start ox_target
start oxmysql
start es_extended
start main-radialmenu
```

## ⚙️ Configuration

### Basic Settings (`config.lua`)

#### General Settings
```lua
Config.RadialKey = 'F1' -- Key to open radial menu
Config.MenuPosition = 'bottom-right' -- Menu position
Config.MenuSize = 'md' -- Menu size (sm, md, lg)
Config.UseTarget = true -- Enable ox_target integration
```

#### Job Configuration
Enable/disable job-specific features:
```lua
Config.JobMenus = {
    police = {
        enabled = true,
        items = {
            {label = 'Handcuff', action = 'handcuff', icon = 'fas fa-lock'},
            -- Add more items...
        }
    }
}
```

#### Vehicle Options
```lua
Config.VehicleOptions = {
    engine = true, -- Toggle engine
    doors = true, -- Open/close doors
    trunk = true, -- Open trunk
    hood = true, -- Open hood
}
```

#### Quick Items
```lua
Config.QuickItems = {
    {label = 'Bandage', item = 'bandage', icon = 'fas fa-band-aid'},
    {label = 'Water', item = 'water', icon = 'fas fa-tint'},
    -- Add more items...
}
```

## 🎮 Usage

### Opening the Menu
- **Default**: Press `F1` to open the radial menu
- **ox_target**: Right-click on players/vehicles for context menu

### Menu Navigation
- **Mouse**: Move mouse to highlight options
- **Click**: Select highlighted option
- **ESC**: Close menu

### Key Features

#### Player Menu
- View player information
- Access animations and emotes
- Change walking styles
- Quick ragdoll/surrender

#### Vehicle Menu
- Control engine, doors, lights
- Access trunk and hood
- Mechanic repair options

#### Job Actions
- Context-sensitive based on player job
- Permission-based access
- Action logging to database

#### Quick Items
- Fast access to frequently used items
- One-click item usage
- Inventory integration

## 🔧 Advanced Configuration

### Custom Animations
Add custom animations in the config:
```lua
Config.Animations = {
    custom = {
        {label = 'My Animation', dict = 'dict_name', anim = 'anim_name'},
    }
}
```

### Custom GPS Locations
```lua
Config.GPSLocations = {
    {label = 'Custom Location', coords = vector3(x, y, z), icon = 'fas fa-star'},
}
```

### Database Customization
The resource creates several tables for advanced features:
- `radial_logs` - Action logging
- `radial_user_settings` - User preferences
- `radial_favorites` - Favorite menu items
- `radial_animations` - Custom animations
- `radial_job_permissions` - Job permissions
- `radial_gps_locations` - Custom GPS locations

## 🐛 Troubleshooting

### Common Issues

#### Menu Not Opening
- Check if ox_lib is properly installed and started
- Verify the keybind in config matches your preference
- Check F8 console for errors

#### Job Actions Not Working
- Ensure player has the correct job assigned
- Check job permissions in database
- Verify ESX job system is working

#### Target System Not Working
- Ensure ox_target is installed and running
- Check Config.UseTarget is set to true
- Verify target distance settings

#### Database Errors
- Ensure oxmysql is properly configured
- Check database connection settings
- Verify all tables are created

### Console Commands
```
# Debug mode
setr radial_debug true

# Restart resource
restart main-radialmenu

# Check dependencies
ensure ox_lib
```

## 📊 Performance

### Optimizations
- Event-driven architecture
- Minimal tick usage
- Efficient database queries
- Resource cleanup on disconnect

### Resource Usage
- **Client**: ~0.01ms average
- **Server**: ~0.02ms average
- **Database**: Optimized with indexes

## 🤝 Support

### Getting Help
1. Check this README first
2. Review the configuration files
3. Check server console for errors
4. Join our Discord for support

### Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Credits

- **ESX Framework** - Core framework
- **Overextended** - ox_lib, ox_inventory, ox_target, oxmysql
- **Community** - Testing and feedback

## 📋 Changelog

### v1.0.0
- Initial release
- Full ESX integration
- ox_lib radial menu system
- ox_target context menus
- ox_inventory integration
- Database logging system
- Job-specific actions
- Vehicle controls
- Animation system
- GPS waypoints

---

**Made with ❤️ by Main-Scripts**

For more resources and support, visit our [GitHub](https://github.com/Main-Scripts)
