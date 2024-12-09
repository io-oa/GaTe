class_name FireElemental extends Entity

@onready var player_node: Node2D = get_node("/root/Main/Player")
@onready var health_component: Health = $Health
@onready var velocity_component: Velocity = $Velocity
@onready var pathfinding_component: Pathfinding = $Pathfinding
@onready var attack: Attack = $BasicAttack
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var scaling: Node = $GameScaling

func _ready():
	ally_flag = GameGlobals.ALLY_FLAGS.enemy
	health_component.init_health()
	state_machine.add_states([state_move, state_attack])
	
func _process(_delta: float):
	attack.global_rotation = (player_node.global_position - self.global_position).normalized().angle()
	state_machine.run()
	time_lived += _delta

func _on_death() -> void:
	GameGlobals.enemy_death.emit(self.scaling)
	queue_free()
		
func state_move():
	self.pathfinding_component.set_target(self.player_node.global_position)
	var direction = self.pathfinding_component.follow_path()
	self.velocity_component.move(self)
	if direction:
		GameGlobals.update_animation_4dir(animations, "walk", snapped(GameGlobals.normalize_angle_360(rad_to_deg(direction.angle())), 1))
	if self.position.distance_to(player_node.global_position) < self.attack_range:
		state_machine.set_current_state(state_attack)
		
func state_attack():
	if self.attack.cooldown > 0:
		self.state_machine.set_current_state(state_move)
		return
	self.attack.fire(self)
	

	
