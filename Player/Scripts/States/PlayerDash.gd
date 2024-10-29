extends PlayerState

var dash_time_left = 0.0
var dash_speed: Vector2

func enter():
	player.abilities["dash"]["cooldown_left"] = player.abilities["dash"]["cooldown"]
	dash_time_left = player.abilities["dash"]["duration"]
	dash_speed = player.abilities["dash"]["distance"] / player.abilities["dash"]["duration"] * player.last_direction.normalized()
	
func physics_process_state(delta: float) -> void:
	if dash_time_left > 0:
		player.position += dash_speed * min(delta, dash_time_left) # Refactor to use moveandslide ig
		player.position = player.position.clamp(Vector2.ZERO, player.screen_size)
		dash_time_left -= delta
	else:
		transitioned.emit(self, "PlayerIdle")

func exit():
	pass
