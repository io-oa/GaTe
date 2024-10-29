extends EnemyState

func physics_process_state(delta):
	var motion = Vector2()
	var direction_vector = enemy.player_node.global_position - enemy.position
	var direction = direction_vector.normalized()
	motion = direction * enemy.MOTION_SPEED

	enemy.rotation_degrees = rad_to_deg(direction.angle())
	
	enemy.set_velocity(motion)
	enemy.move_and_slide()
	enemy.position = enemy.position.clamp(Vector2.ZERO, GameGlobals.SCREEN_SIZE)

	var dir = enemy.velocity
	
	if Input.is_action_pressed("player_dash") and enemy.abilities["dash"]["cooldown_left"] == 0:
		pass
		#transitioned.emit(self, "EnemyDash")
		
	
	if dir.length() > 0:
		pass
	else:
		transitioned.emit(self, "EnemyIdle")
