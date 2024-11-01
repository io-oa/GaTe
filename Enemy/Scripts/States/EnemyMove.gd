extends EnemyState

func physics_process_state(_delta: float):
	var motion = Vector2()
	var direction = (enemy.player_node.global_position - enemy.position).normalized()
	motion = direction * enemy.MOTION_SPEED
	
	enemy.rotation_degrees = rad_to_deg(direction.angle())
	
	enemy.set_velocity(motion)
	enemy.move_and_slide()
	enemy.position = enemy.position.clamp(Vector2.ZERO, GameGlobals.SCREEN_SIZE)

	var dir = enemy.velocity
	
	if dir.length() > 0:
		pass
	else:
		transitioned.emit(self, "EnemyIdle")
