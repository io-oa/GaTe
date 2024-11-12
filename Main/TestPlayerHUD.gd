extends MarginContainer

@export var player: Player

@onready var hp_bar: TextureProgressBar = $HBoxContainer/Bars/TextureProgressBar

func _ready() -> void:
	pass
	
func _on_health_health_changed(previous_health: float, current_health: float, max_health: float) -> void:
	hp_bar.value = player.health_component.get_health_percentage()
