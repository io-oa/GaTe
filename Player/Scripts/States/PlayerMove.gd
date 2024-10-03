extends PlayerState

var anim_directions = {
	"idle": [ # list of [animation name, horizontal flip]
		["side_right_idle", false],
		["45front_right_idle", false],
		["front_idle", false],
		["45front_left_idle", false],
		["side_left_idle", false],
		["45back_left_idle", false],
		["back_idle", false],
		["45back_right_idle", false],
	],

	"walk": [
		["side_right_walk", false],
		["45front_right_walk", false],
		["front_walk", false],
		["45front_left_walk", false],
		["side_left_walk", false],
		["45back_left_walk", false],
		["back_walk", false],
		["45back_right_walk", false],
	],
}

func physics_process_state(delta):
	var motion = Vector2()
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	motion.y /= 2
	motion = motion.normalized() * player.MOTION_SPEED
	#warning-ignore:return_value_discarded
	#if Input.is_action_pressed("player_dash") and Time.get_ticks_msec() > cooldowns["dash"][1]:
		#dash(_delta)
		#cooldowns["dash"][1] = Time.get_ticks_msec() + cooldowns["dash"][0]

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

