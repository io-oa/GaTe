class_name Player extends Entity

signal level_up(level: int)
signal exp_change()
signal stat_change()

const MOTION_SPEED: float = 400.0

@onready var animations: AnimatedSprite2D = $Animations
@onready var blink_sound: AudioStreamPlayer = $blink/AudioStreamPlayer
@onready var blink_effect_scene: PackedScene = preload("res://Player/Assets/BlinkEffect.tscn")
@onready var attack_indicator: Sprite2D = $AttackDirectionIndicator
@onready var basic_attack: Attack = $BasicAttack
@onready var auto_projectiles: Attack = $AutomaticProjectiles
@onready var health_component: Health = $Health

#Misc
var last_direction = Vector2.RIGHT


#Leveling
var level: int = 0
var points_to_next_level: float = 50.0
var current_level_points: float = 0.0
var level_up_queue: Array[Callable]

#Abilities
var dash_time_left: float = 0.0
var dash_speed: Vector2

var abilities: Dictionary = {
	"blink":{ 
		"cooldown": 2.0,
		"cooldown_left": 0.0,
		"distance": 350.0,
		"duration": 0.0
	}
}
func game_over():
	get_tree().paused = true
	Scenes.switch_to(Scenes.GAME_OVER)

func _ready():
	ally_flag = GameGlobals.ALLY_FLAGS.player
	self.add_to_group("Player")
	self.health_component.died.connect(game_over)
	self.health_component.init_health()
	GameGlobals.enemy_death.connect(_on_enemy_killed)
	state_machine.add_states([state_idle, state_move])
	
func _physics_process(_delta):
	pass

func _process(delta: float):
	self.state_machine.run()
	if self.level_up_queue.size() > 0:
		self.level_up_queue.pop_front().call()
		
	var mouse_direction: Vector2 = (get_global_mouse_position() - self.position).normalized()
	self.basic_attack.global_rotation = mouse_direction.angle()
	self.auto_projectiles.global_rotation = mouse_direction.angle()
	self.attack_indicator.rotation = mouse_direction.angle()
	
	#Attacks
	if auto_projectiles.projectile_scenes.size() > 0:
		self.auto_projectiles.fire(self)
	
	if Input.is_action_pressed("attack") and is_zero_approx(self.basic_attack.cooldown):
		self.basic_attack.fire(self)
		GameGlobals.update_animation_4dir(self.animations, "attack", snapped(GameGlobals.normalize_angle_360(rad_to_deg(self.basic_attack.global_rotation)), 1))
	
	#Abilities
	if Input.is_action_pressed("blink") and abilities["blink"]["cooldown_left"] == 0:
		self.blink()
	for ability in self.abilities:
		self.abilities[ability]["cooldown_left"] = max(self.abilities[ability]["cooldown_left"] - delta, 0.0)
		
func _on_enemy_killed(scaling: Node):
	update_points(scaling.points_on_kill)
	GameGlobals.enemies_killed += 1

func update_points(points: float):
	while points > 0:
		var points_needed = self.points_to_next_level - self.current_level_points
		if points >= points_needed:
			points -= points_needed
			self.level += 1
			self.current_level_points = 0
			self.points_to_next_level += 20
			self.level_up_queue.append(level_up.emit.bind(self.level))
		else:
			self.current_level_points += points
			points = 0
		exp_change.emit()

func state_idle():
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") \
	or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down"):
		self.state_machine.set_current_state(state_move)
	else:
		GameGlobals.update_animation_4dir(self.animations, "idle", snapped(GameGlobals.normalize_angle_360(rad_to_deg(last_direction.angle())), 1))

	self.set_velocity(Vector2.ZERO)
	self.move_and_slide()
	self.position = self.position.clamp(GameGlobals.MAP_VERTICES[0], GameGlobals.MAP_VERTICES[2])
		
func state_move():
	var motion_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()

	self.set_velocity(motion_direction * self.MOTION_SPEED)
	self.move_and_slide()
	self.position = self.position.clamp(GameGlobals.MAP_VERTICES[0], GameGlobals.MAP_VERTICES[2])
		
	if motion_direction.length() > 0:
		GameGlobals.update_animation_4dir(self.animations, "walk", snapped(GameGlobals.normalize_angle_360(rad_to_deg(motion_direction.angle())), 1))
		self.last_direction = motion_direction
	else:
		self.state_machine.set_current_state(state_idle)

func blink():
	blink_sound.play()
	var blink_effect = blink_effect_scene.instantiate()
	GameGlobals.EFFECTS.add_child(blink_effect)
	blink_effect.position = self.position
	
	self.position = Vector2(self.position.x + abilities["blink"]["distance"] * self.last_direction.x,
		position.y + abilities["blink"]["distance"] * self.last_direction.y
	).clamp(GameGlobals.MAP_VERTICES[0], GameGlobals.MAP_VERTICES[2])
	
	blink_effect = blink_effect_scene.instantiate()   
	blink_effect.reverse = true             
	GameGlobals.EFFECTS.add_child(blink_effect)
	blink_effect.position = self.position
	
	abilities["blink"]["cooldown_left"] = abilities["blink"]["cooldown"]
