extends EnemyState


# Called when the node enters the scene tree for the first time.
func enter():
	enemy.velocity = Vector2()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process_state(delta):
	if true:
		transitioned.emit(self, "PlayerMove")
	elif Input.is_action_pressed("player_dash") and enemy.abilities["dash"]["cooldown_left"] == 0:
		pass
		#transitioned.emit(self, "PlayerDash")

func physics_process_state(delta: float) -> void:
	enemy.set_velocity(Vector2())
	enemy.move_and_slide()
	enemy.position = enemy.position.clamp(Vector2.ZERO, GameGlobals.SCREEN_SIZE)
