-- Main Radialmenu Database Schema
-- This file contains the database tables required for the radialmenu resource
-- Execute this SQL in your database before starting the resource

-- Create radial_logs table for logging all radial menu actions
CREATE TABLE IF NOT EXISTS `radial_logs` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `player_identifier` varchar(60) NOT NULL,
    `target_identifier` varchar(60) DEFAULT NULL,
    `action` varchar(50) NOT NULL,
    `amount` int(11) DEFAULT NULL,
    `reason` text DEFAULT NULL,
    `vehicle_plate` varchar(20) DEFAULT NULL,
    `timestamp` datetime NOT NULL,
    PRIMARY KEY (`id`),
    KEY `player_identifier` (`player_identifier`),
    KEY `target_identifier` (`target_identifier`),
    KEY `action` (`action`),
    KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create radial_user_settings table for storing user preferences
CREATE TABLE IF NOT EXISTS `radial_user_settings` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(60) NOT NULL,
    `radial_key` varchar(20) DEFAULT 'F1',
    `menu_position` varchar(20) DEFAULT 'bottom-right',
    `menu_size` varchar(10) DEFAULT 'md',
    `enabled_features` text DEFAULT NULL,
    `quick_items` text DEFAULT NULL,
    `created_at` timestamp NULL DEFAULT current_timestamp(),
    `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create radial_favorites table for storing user's favorite menu items
CREATE TABLE IF NOT EXISTS `radial_favorites` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(60) NOT NULL,
    `menu_item` varchar(50) NOT NULL,
    `display_order` int(3) DEFAULT 0,
    `created_at` timestamp NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    KEY `identifier` (`identifier`),
    KEY `menu_item` (`menu_item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create radial_animations table for custom animations
CREATE TABLE IF NOT EXISTS `radial_animations` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `label` varchar(100) NOT NULL,
    `category` varchar(30) NOT NULL,
    `dict` varchar(100) NOT NULL,
    `anim` varchar(100) NOT NULL,
    `duration` int(11) DEFAULT -1,
    `flag` int(3) DEFAULT 0,
    `is_active` tinyint(1) DEFAULT 1,
    `created_by` varchar(60) DEFAULT NULL,
    `created_at` timestamp NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `name` (`name`),
    KEY `category` (`category`),
    KEY `is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default animations
INSERT INTO `radial_animations` (`name`, `label`, `category`, `dict`, `anim`, `duration`, `flag`) VALUES
('wave', 'Wave', 'greetings', 'anim@mp_player_intcelebrationmale@wave', 'wave', 3000, 0),
('salute', 'Salute', 'greetings', 'anim@mp_player_intcelebrationmale@salute', 'salute', 3000, 0),
('thumbsup', 'Thumbs Up', 'greetings', 'anim@mp_player_intcelebrationmale@thumbs_up', 'thumbs_up', 3000, 0),
('dance1', 'Dance 1', 'dance', 'anim@amb@nightclub@dancers@solomun_entourage@', 'mi_dance_facedj_17_v1_female^1', -1, 1),
('dance2', 'Dance 2', 'dance', 'anim@amb@nightclub@mini@dance@dance_solo@female@var_a@', 'high_center', -1, 1),
('dance3', 'Dance 3', 'dance', 'anim@amb@nightclub@mini@dance@dance_solo@male@var_b@', 'high_center_down', -1, 1),
('sit', 'Sit', 'misc', 'anim@amb@business@bgen@bgen_no_work@', 'sit_phone_phoneputdown_idle_nowork', -1, 1),
('lean', 'Lean on Wall', 'misc', 'amb@world_human_leaning@female@wall@back@hand_up@idle_a', 'idle_a', -1, 1),
('crossarms', 'Cross Arms', 'misc', 'amb@world_human_hang_out_street@female_arms_crossed@idle_a', 'idle_a', -1, 1),
('handsup', 'Hands Up', 'misc', 'random@mugging3', 'handsup_standing_base', -1, 49);

-- Create radial_job_permissions table for job-specific permissions
CREATE TABLE IF NOT EXISTS `radial_job_permissions` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `job_name` varchar(50) NOT NULL,
    `action` varchar(50) NOT NULL,
    `min_grade` int(3) DEFAULT 0,
    `is_enabled` tinyint(1) DEFAULT 1,
    `created_at` timestamp NULL DEFAULT current_timestamp(),
    `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `job_action` (`job_name`, `action`),
    KEY `job_name` (`job_name`),
    KEY `action` (`action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default job permissions
INSERT INTO `radial_job_permissions` (`job_name`, `action`, `min_grade`, `is_enabled`) VALUES
('police', 'handcuff', 0, 1),
('police', 'search', 0, 1),
('police', 'fine', 1, 1),
('police', 'jail', 2, 1),
('police', 'drag', 0, 1),
('police', 'putinvehicle', 0, 1),
('police', 'checklicense', 0, 1),
('ambulance', 'heal', 0, 1),
('ambulance', 'revive', 0, 1),
('ambulance', 'checkpulse', 0, 1),
('ambulance', 'stretcher', 1, 1),
('mechanic', 'repair', 0, 1),
('mechanic', 'impound', 1, 1),
('mechanic', 'diagnostic', 0, 1);

-- Create radial_gps_locations table for custom GPS locations
CREATE TABLE IF NOT EXISTS `radial_gps_locations` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `label` varchar(100) NOT NULL,
    `x` float NOT NULL,
    `y` float NOT NULL,
    `z` float NOT NULL,
    `icon` varchar(50) DEFAULT 'fas fa-map-marker',
    `category` varchar(30) DEFAULT 'general',
    `job_restricted` varchar(50) DEFAULT NULL,
    `is_active` tinyint(1) DEFAULT 1,
    `created_at` timestamp NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `name` (`name`),
    KEY `category` (`category`),
    KEY `job_restricted` (`job_restricted`),
    KEY `is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default GPS locations
INSERT INTO `radial_gps_locations` (`name`, `label`, `x`, `y`, `z`, `icon`, `category`) VALUES
('hospital', 'Hospital', 307.7, -1433.4, 29.8, 'fas fa-hospital', 'emergency'),
('police_station', 'Police Station', 425.1, -979.5, 30.7, 'fas fa-shield-alt', 'government'),
('garage', 'Public Garage', 215.9, -810.1, 30.7, 'fas fa-car', 'transport'),
('bank', 'Bank', 150.3, -1040.2, 29.4, 'fas fa-university', 'financial'),
('shop', '24/7 Shop', 25.7, -1347.3, 29.5, 'fas fa-shopping-cart', 'shopping'),
('lsc', 'Los Santos Customs', -356.9, -134.8, 39.0, 'fas fa-wrench', 'vehicle'),
('airport', 'Los Santos Airport', -1037.0, -2737.6, 20.2, 'fas fa-plane', 'transport'),
('vinewood', 'Vinewood Sign', 692.5, 588.5, 130.5, 'fas fa-star', 'landmark');

-- Create indexes for better performance
CREATE INDEX idx_radial_logs_player_action ON radial_logs(player_identifier, action);
CREATE INDEX idx_radial_logs_timestamp ON radial_logs(timestamp DESC);
CREATE INDEX idx_radial_user_settings_identifier ON radial_user_settings(identifier);
CREATE INDEX idx_radial_favorites_identifier ON radial_favorites(identifier, display_order);
CREATE INDEX idx_radial_animations_category ON radial_animations(category, is_active);
CREATE INDEX idx_radial_job_permissions_job ON radial_job_permissions(job_name, is_enabled);
CREATE INDEX idx_radial_gps_locations_active ON radial_gps_locations(is_active, category);