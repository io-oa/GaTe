class_name Health extends Node2D

signal died()
signal health_changed(previous_health: float, current_health: float, max_health: float)

@export var max_health: float = 42.0:
	set(new_max_health):
		max_health = new_max_health
		current_health = min(self.current_health, self.max_health)

var current_health: float:
	set(new_health):
		var previous_health: float = current_health
		current_health = clamp(new_health, 0, max_health)
		health_changed.emit(previous_health, current_health, max_health)
		if (current_health == 0 && !dead):
			dead = true
			died.emit()

var dead: bool

func init_health() -> void:
	self.dead = false
	self.current_health = self.max_health

func damage(dmg: float) -> void:
	self.current_health = current_health - dmg
	#print(self.get_parent().name, "Took %f dmg." % dmg)
