class_name HUDResource extends Resource

const UPGRADE_BUTTON_TEXT: String = "[center][b]%s[/b]\n%s\n%s[/center]"
const LEVEL_DISPLAY_TEXT: String = "[font_size=40][center]%s[/center][/font_size]"

const stat_upgrades = {
	"projectile_size": {
		"name": "Projectile Size",
		"icon": preload("res://Main/Assets/mod_projectile_size.png"),
		"amount": 0.1,
		"description": "Increases the size of your projectiles"
	},
	"critical_chance": {
		"name": "Critical Chance",
		"icon": preload("res://Main/Assets/mod_crit.png"),
		"amount": 0.1,
		"description": "Adds a chance to double your damage on hit"
	},
	"damage": {
		"name": "Damage",
		"icon": preload("res://Main/Assets/mod_damage.png"),
		"amount": 0.1,
		"description": "Increases your damage by a percentage"
	}
}
