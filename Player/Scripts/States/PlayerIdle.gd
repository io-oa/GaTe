extends PlayerState


# Called when the node enters the scene tree for the first time.
func enter():
	player.velocity = Vector2()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process_state(delta):
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") \
	or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down"):
		transitioned.emit(self, "PlayerMove")
	elif Input.is_action_pressed("player_dash") and player.abilities["dash"]["cooldown_left"] == 0:
		transitioned.emit(self, "PlayerDash")
	else:
		player.update_animation("idle")

func physics_process_state(delta: float) -> void:
	player.set_velocity(Vector2())
	player.move_and_slide()
	player.position = player.position.clamp(Vector2.ZERO, GameGlobals.SCREEN_SIZE)
