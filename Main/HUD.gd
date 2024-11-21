extends Node 

const LEVEL_DISPLAY_TEXT = "[font_size=40][center]%s[/center][/font_size]"

@export var player: Player

@onready var hp_bar: TextureProgressBar = $HealthBarContainer/MarginContainer/PlayerHealthBar
@onready var exp_bar: TextureProgressBar = $ExpBarContainer/MarginContainer/PlayerExpBar
@onready var level_display: RichTextLabel = $LevelDisplayContainer/MarginContainer/LevelDisplay
@onready var upgrade_choices: Panel = $UpgradeChoices

func _ready() -> void:
	exp_bar.value = player.current_level_points / player.points_to_next_level * 100
	hp_bar.value = player.health_component.get_health_percentage()
	level_display.text = LEVEL_DISPLAY_TEXT % player.level
	player.level_up.connect(_on_player_level_up)
	player.exp_change.connect(_on_player_exp_change)
	player.health_component.health_changed.connect(_on_health_changed)
	
func _on_health_changed(previous_health: float, current_health: float, max_health: float) -> void:
	hp_bar.value = player.health_component.get_health_percentage()

func _on_player_level_up(level: int):
	level_display.text = LEVEL_DISPLAY_TEXT % player.level
	get_tree().paused = true
	upgrade_choices.visible = true

func _on_player_exp_change():
	exp_bar.value = player.current_level_points / player.points_to_next_level * 100
