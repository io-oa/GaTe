class_name Player extends CharacterBody2D

signal level_up()

const MOTION_SPEED: float = 400.0

@onready var character_anim_player: AnimationPlayer = $View/SVContainer/SV/Duck/AnimationPlayer
@onready var character_model: Node3D = $View/SVContainer/SV/Duck
@onready var attack: Attack = $BasicAttack
@onready var health_component: Health = $Health

var last_direction = Vector2(1, 0)
var ally_flag: int = GameGlobals.ALLY_FLAGS.player
var level:	int = 0
var points_to_next_level = 50
var current_level_points = 0

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
	
func _physics_process(_delta):
	pass

func _process(delta: float):
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

func update_points(points: int):
	while points > 0:
		var points_needed = self.points_to_next_level - self.current_level_points
		if points >= points_needed:
			points -= points_needed
			self.level += 1
			current_level_points = 0
			level_up.emit()
		else:
			self.current_level_points += points
			points = 0
