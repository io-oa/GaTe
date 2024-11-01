extends PlayerState

func physics_process_state(_delta: float):
	var motion = Vector2()
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	#motion.y /= 2
	motion = motion.normalized() * player.MOTION_SPEED
	
	player.set_velocity(motion)
	player.move_and_slide()
	player.position = player.position.clamp(Vector2.ZERO, GameGlobals.SCREEN_SIZE)
	

	if Input.is_action_pressed("player_dash") and player.abilities["dash"]["cooldown_left"] == 0:
		transitioned.emit(self, "PlayerDash")
		
	if motion.length() > 0:
		var angle = rad_to_deg(atan2(motion.y, motion.x)) + 90
		player.character_model.rotation_degrees.y = -angle
		player.character_anim_player.play("walkcycle_1")
		player.last_direction = motion.normalized()
	else:
		transitioned.emit(self, "PlayerIdle")
