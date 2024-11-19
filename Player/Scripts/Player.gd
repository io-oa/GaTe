class_name Player extends CharacterBody2D

signal level_up(level: int)
signal exp_change()

const MOTION_SPEED: float = 400.0

@onready var character_anim_player: AnimationPlayer = $View/SVContainer/SV/Duck/AnimationPlayer
@onready var character_model: Node3D = $View/SVContainer/SV/Duck
@onready var attack: Attack = $BasicAttack
@onready var health_component: Health = $Health

#Misc
var state_machine: StateMachine = StateMachine.new()
var last_direction = Vector2(1, 0)
var ally_flag: int = GameGlobals.ALLY_FLAGS.player

#Leveling
var level: int = 0
var points_to_next_level: float = 50.0
var current_level_points: float = 0.0
var level_up_queue: Array[Callable]

#Abilities
var dash_time_left: float = 0.0
var dash_speed: Vector2

var abilities: Dictionary = {
	"dash": {
		"cooldown": 2.0,
		"cooldown_left": 0.0,
		"distance": 200.0,
		"duration": 0.2
	}
}
	
func _ready():
	self.add_to_group("Player")
	GameGlobals.SCREEN_SIZE = get_viewport_rect().size
	GameGlobals.PROJECTILES = get_node(^"/root/Main/Projectiles")
	GameGlobals.EFFECTS = get_node(^"/root/Main/Effects")
	self.health_component.init_health()
	GameGlobals.on_enemy_death.connect(_on_enemy_killed)
	state_machine.add_states([state_idle, state_move, state_dash])
	
func _physics_process(_delta):
	pass

func _process(delta: float):
	state_machine.run()
	if level_up_queue.size() > 0:
		level_up_queue.pop_front().call()
	if self.health_component.dead:
		$Info/Test.text = "XD"
		
	var mouse_direction: Vector2 = (get_global_mouse_position() - self.position).normalized()
	attack.global_rotation = mouse_direction.angle()
	$Gun.global_rotation = mouse_direction.angle() + PI / 8
	$Gun.global_position = self.global_position
	
	if Input.is_action_pressed("attack"):
		#var angle = rad_to_deg(atan2(mouse_direction.y, mouse_direction.x)) - 90.0
		#self.character_model.rotation_degrees.y = -angle
		attack.fire(self)	
		
	for ability in abilities:
		abilities[ability]["cooldown_left"] = max(abilities[ability]["cooldown_left"] - delta, 0.0)
		
func _on_enemy_killed(scaling: Node):
	update_points(scaling.points_on_kill)
	print(self.level)

func update_points(points: float):
	while points > 0:
		var points_needed = self.points_to_next_level - self.current_level_points
		if points >= points_needed:
			points -= points_needed
			self.level += 1
			self.current_level_points = 0
			self.level_up_queue.append(level_up.emit.bind(self.level))
		else:
			self.current_level_points += points
			points = 0
		exp_change.emit()

func state_idle():
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") \
	or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down"):
		state_machine.set_current_state(state_move)
	elif Input.is_action_pressed("player_dash") and self.abilities["dash"]["cooldown_left"] == 0:
		state_machine.set_current_state(state_dash)
	else:
		pass
	self.set_velocity(Vector2())
	self.move_and_slide()
	self.position = self.position.clamp(GameGlobals.MAP_VERTICES[0], GameGlobals.MAP_VERTICES[2])
		
func state_dash():
	if state_machine.entered:
		self.abilities["dash"]["cooldown_left"] = self.abilities["dash"]["cooldown"]
		dash_time_left = self.abilities["dash"]["duration"]
		dash_speed = self.abilities["dash"]["distance"] / self.abilities["dash"]["duration"] * self.last_direction.normalized()
	if dash_time_left > 0:
		self.position += dash_speed * min(get_process_delta_time(), dash_time_left) # Refactor to use moveandslide ig
		self.position = self.position.clamp(GameGlobals.MAP_VERTICES[0], GameGlobals.MAP_VERTICES[2])
		dash_time_left -= get_process_delta_time()
	else:
		state_machine.set_current_state(state_idle)
		
func state_move():
	var motion = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()

	self.set_velocity(motion * self.MOTION_SPEED)
	self.move_and_slide()
	self.position = self.position.clamp(GameGlobals.MAP_VERTICES[0], GameGlobals.MAP_VERTICES[2])

	if Input.is_action_pressed("player_dash") and self.abilities["dash"]["cooldown_left"] == 0:
		state_machine.set_current_state(state_dash)
		
	if motion.length() > 0:
		self.character_anim_player.play("walkcycle_1")
		self.last_direction = motion
	else:
		state_machine.set_current_state(state_idle)
