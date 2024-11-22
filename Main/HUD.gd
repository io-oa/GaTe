extends Node 

@export var player: Player

@onready var hp_bar: TextureProgressBar = $HealthBarContainer/MarginContainer/PlayerHealthBar
@onready var exp_bar: TextureProgressBar = $ExpBarContainer/MarginContainer/PlayerExpBar
@onready var level_display: RichTextLabel = $LevelDisplayContainer/MarginContainer/LevelDisplay
@onready var upgrade_choices_menu: Panel = $UpgradeChoices
@onready var upgrade_options_container: HBoxContainer = $UpgradeChoices/HBoxContainer
@onready var upgrade_buttons: Array[Node] = upgrade_options_container.get_children()
@onready var resource: HUDResource = preload("res://Resources/HUD/HUDResource.tres")

func _ready() -> void:
	exp_bar.value = player.current_level_points / player.points_to_next_level * 100
	hp_bar.value = player.health_component.get_health_percentage()
	level_display.text = resource.LEVEL_DISPLAY_TEXT % player.level
	player.level_up.connect(_on_player_level_up)
	player.exp_change.connect(_on_player_exp_change)
	player.health_component.health_changed.connect(_on_health_changed)
	
func _on_health_changed(previous_health: float, current_health: float, max_health: float) -> void:
	hp_bar.value = player.health_component.get_health_percentage()

func _on_player_level_up(level: int):
	level_display.text = resource.LEVEL_DISPLAY_TEXT % player.level
	get_tree().paused = true
	upgrade_choices_menu.visible = true
	var picked_upgrades: Array[String] = GameGlobals.pick_random_keys(resource.stat_upgrades, 3)
	for i in upgrade_buttons.size():
		upgrade_buttons[i].set_properties(picked_upgrades[i])
		
func _on_player_exp_change():
	exp_bar.value = player.current_level_points / player.points_to_next_level * 100
