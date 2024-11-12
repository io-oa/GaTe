extends PlayerState

func physics_process_state(_delta: float):
	var motion = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()

	player.set_velocity(motion * player.MOTION_SPEED)
	player.move_and_slide()
	player.position = player.position.clamp(Vector2.ZERO, GameGlobals.SCREEN_SIZE)

	if Input.is_action_pressed("player_dash") and player.abilities["dash"]["cooldown_left"] == 0:
		transitioned.emit(self, "PlayerDash")
		
	if motion.length() > 0:
		#player.global_rotation = motion.angle()
		player.character_anim_player.play("walkcycle_1")
		player.last_direction = motion
	else:
		transitioned.emit(self, "PlayerIdle")
