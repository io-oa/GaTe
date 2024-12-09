class_name HUDResource extends Resource

const UPGRADE_BUTTON_TEXT: String = "[center][b]%s[/b]\n%s\n%s[/center]"
const LEVEL_DISPLAY_TEXT: String = "[font_size=40][center]%s[/center][/font_size]"
const STAT_DISPLAY_TEXT: String = "[center][b]%s[/b][/center]"
const END_GAME_TIMER_TEXT: String = "[center][b]Boss Fight Time: %02d:%02d[/b][/center]"
const TIMER_DISPLAY_TEXT: String = "[font_size=30][center][b]%02d:%02d[/b][/center][/font_size]"
const KILL_COUNTER_TEXT: String = "[center]%s[/center]"

const MAIN_MENU_PATH: String = "res://GUI/main_menu.tscn"

const upgrades = {
	"projectile_size": {
		"type": "stat",
		"name": "Projectile Size",
		"icon": preload("res://Main/Assets/mod_projectile_size.png"),
		"amount": 0.25,
		"description": "Increases the size of your projectiles"
	},
	"critical_chance": {
		"type": "stat",
		"name": "Critical Chance",
		"icon": preload("res://Main/Assets/mod_crit.png"),
		"amount": 0.1,
		"description": "Adds a chance to double your damage on hit"
	},
	"damage": {
		"type": "stat",
		"name": "Damage",
		"icon": preload("res://Main/Assets/mod_damage.png"),
		"amount": 0.1,
		"description": "Increases your damage by a percentage"
	},
	"shockwave": {
		"type": "projectile",
		"name": "Shockwave",
		"icon": preload("res://Main/Assets/mod_shockwave.png"),
		"description": "Sends shockwaves in both directions horizontally",
		"cooldown": 1.0,
		"duplicate_x": true,
		"follow_attack_direction": false,
		"spread_around": 1,
		"scene_path": "res://Attacks/Projectiles/Shockwave/Shockwave.tscn"
	},
	"lightning_orb": {
		"type": "projectile",
		"name": "Lightning Orb",
		"icon": preload("res://Main/Assets/mod_lightning_orb.png"),
		"description": "Shoots lightning orbs around",
		"cooldown": 2.0,
		"duplicate_x": false,
		"follow_attack_direction": false,
		"spread_around": 3,
		"scene_path": "res://Attacks/Projectiles/LightningOrb/Lightning_Orb.tscn"
	}
}
