extends EnemyState

var dash_time_left = 0.0
var dash_speed: Vector2

func enter():
	pass
	#enemy.abilities[enemy.name]["dash"]["cooldown_left"] = enemy.abilities["dash"]["cooldown"]
	#dash_time_left = enemy.abilities["dash"]["duration"]
	#dash_speed = enemy.abilities["dash"]["distance"] / enemy.abilities["dash"]["duration"] * enemy.last_direction.normalized()
	
func physics_process_state(delta: float) -> void:
	if dash_time_left > 0:
		enemy.position += dash_speed * min(delta, dash_time_left) # Refactor to use moveandslide ig
		enemy.position = enemy.position.clamp(Vector2.ZERO, enemy.screen_size)
		dash_time_left -= delta
	else:
		transitioned.emit(self, "EnemyIdle")

func exit():
	pass
