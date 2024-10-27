extends PlayerState

func physics_process_state(delta):
	var motion = Vector2()
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	#motion.y /= 2
	motion = motion.normalized() * player.MOTION_SPEED

	player.set_velocity(motion)
	player.move_and_slide()
	player.position = player.position.clamp(Vector2.ZERO, player.screen_size)
	
	var dir = player.velocity
	
	if Input.is_action_pressed("player_dash") and player.abilities["dash"]["cooldown_left"] == 0:
		transitioned.emit(self, "PlayerDash")
		
	if dir.length() > 0:
		player.last_direction = dir
		player.update_animation("walk")
	else:
		transitioned.emit(self, "PlayerIdle")
