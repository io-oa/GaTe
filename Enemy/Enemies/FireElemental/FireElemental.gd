class_name FireElemental extends CharacterBody2D

var walk_anim: Array[String] = [
		"walk_right",
		"walk_left",
		"walk_down",
		"walk_up"
]

@export var attack_range: float = 400.0 

@onready var player_node: Node2D = get_node("/root/Main/Player")
@onready var health_component: Health = $Health
@onready var velocity_component: Velocity = $Velocity
@onready var pathfinding_component: Pathfinding = $Pathfinding
@onready var attack: Attack = $BasicAttack
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var scaling: Node = $GameScaling

var time_lived: float = 0.0
var ally_flag: int = GameGlobals.ALLY_FLAGS.enemy
var state_machine: StateMachine = StateMachine.new()

func _ready():
	health_component.init_health()
	state_machine.add_states([state_move, state_attack])
	
func _process(_delta: float):
	state_machine.run()
	time_lived += _delta
	
	attack.global_rotation = (player_node.global_position - self.global_position).angle()

func _on_death() -> void:
	GameGlobals.on_enemy_death.emit(self.scaling)
	queue_free()

func update_animation(angle: float):
	if angle > 315.0 or angle < 45.0:
		animations.play("walk_right")
	elif angle > 45.0 and angle < 135.0:
		animations.play("walk_down")
	elif angle > 135.0 and angle < 225.0:
		animations.play("walk_left")
	elif angle > 225.0 and angle < 315.0:
		animations.play("walk_up")
		
func state_move():
	self.pathfinding_component.set_target(self.player_node.global_position)
	var direction = self.pathfinding_component.follow_path()
	self.velocity_component.move(self)
	if direction:
		self.update_animation(GameGlobals.normalize_angle_360(rad_to_deg(direction.angle())))
	if self.position.distance_to(player_node.global_position) < self.attack_range:
		state_machine.set_current_state(state_attack)
		
func state_attack():
	self.attack.fire(self)
	if self.attack.cooldown > 0:
		self.state_machine.set_current_state(state_move)
	

	
