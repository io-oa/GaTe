extends Node2D

@export var health_component: Health

@onready var hp_bar: TextureProgressBar = $HpBar

func _ready() -> void:
	if health_component:
		health_component.health_changed.connect(_on_health_changed)
	
func _process(delta: float) -> void:
	global_rotation = 0.0

func _on_health_changed(previous_health: float, current_health: float, max_health: float) -> void:
	hp_bar.value = self.health_component.get_health_percentage()
	print(self.get_parent().name, " Took %f dmg" % (previous_health - current_health))
