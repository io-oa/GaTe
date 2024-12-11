class_name Alien extends Entity

@onready var player_node: Node2D = get_node("/root/Main/Player")
@onready var health_component: Health = $Health
@onready var velocity_component: Velocity = $Velocity
@onready var pathfinding_component: Pathfinding = $Pathfinding
@onready var animation_player = $AnimationPlayer
@onready var scaling: Node = $GameScaling
@onready var attack: Attack = $BasicAttack
@onready var blink_attack: Attack = $BlinkAttack
@onready var laser_attack: Attack = $LaserAttack

const BLINK_COOLDOWN = 3.0
var blink_timer = BLINK_COOLDOWN
const LASER_COOLDOWN = 5.0
var laser_timer = LASER_COOLDOWN

func _ready():
	ally_flag = GameGlobals.ALLY_FLAGS.enemy
	health_component.init_health()
	state_machine.add_states([state_attack])
	animation_player.play("hover")
	
func _process(_delta: float):
	attack.global_rotation = (player_node.global_position - self.global_position).normalized().angle()
	state_machine.run()
	time_lived += _delta
	blink_timer = max(0, blink_timer - _delta)
	laser_timer = max(0, laser_timer - _delta)
	if is_zero_approx(blink_timer) and not laser_attack.firing:
		self.position = GameGlobals.find_valid_position(-300.0)
		blink_attack.fire(self)
		blink_timer = BLINK_COOLDOWN
	
func _on_death() -> void:
	GameGlobals.boss_death.emit(self)
		
func state_move():
	pass
		
func state_attack():
	if self.laser_attack.firing:
		self.laser_attack.visible = true
		self.laser_attack.locked_rotation += PI * get_process_delta_time()
	else:
		self.laser_attack.visible = false
	if self.position.distance_to(player_node.global_position) < self.attack_range:
		self.attack.fire(self)
		if is_zero_approx(laser_timer) and randi() % 2:
			self.laser_attack.fire(self)
			laser_timer = LASER_COOLDOWN
		
func _on_health_health_changed(previous_health: float, current_health: float, max_health: float) -> void:
	GameGlobals.HUD.boss_hp_bar.value = self.health_component.get_health_percentage()
