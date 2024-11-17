extends Node 

@export var player: Player

@onready var hp_bar: TextureProgressBar = $Info/HBoxContainer/Bars/PlayerHealth
@onready var upgrade_choices: Panel = $UpgradeChoices

func _ready() -> void:
	player.level_up.connect(_on_player_level_up)
	player.health_component.health_changed.connect(_on_health_changed)
	
func _on_health_changed(previous_health: float, current_health: float, max_health: float) -> void:
	hp_bar.value = player.health_component.get_health_percentage()

func _on_player_level_up():
	upgrade_choices.visible = true
