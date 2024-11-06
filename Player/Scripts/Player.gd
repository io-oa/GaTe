class_name Player extends CharacterBody2D

const MOTION_SPEED: float = 400 # Pixels/second.

var screen_size: Vector2
var last_direction = Vector2(1, 0)

@onready var character_anim_player: AnimationPlayer = $View/SVContainer/SV/Duck/AnimationPlayer
@onready var character_model: Node3D = $View/SVContainer/SV/Duck
@onready var weapon: Weapon = $Held/Weapon.get_child(0)
@onready var weapon_anim_player = $Held/Weapon/WeapAnimPlayer
@onready var attack = $MeleeAttack
@onready var projectile_container = $ProjectileContainer

var abilities = {
	"dash": {
		"cooldown": 2.0,
		"cooldown_left": 0.0,
		"distance": 200.0,
		"duration": 0.2
	}
}
	
func _ready():
	self.add_to_group("Player")
	weapon.monitorable = false
	GameGlobals.SCREEN_SIZE = get_viewport_rect().size
	GameGlobals.PROJECTILES = get_node(^"/root/Main/Projectiles")
	$Health.init_health()
	
func _physics_process(_delta):
	pass

func _process(delta: float):
	if $Health.dead:
		$Info/Test.text = "XD"
		
	var direction: Vector2 = (self.position - get_global_mouse_position()).normalized()
	var angle: float = rad_to_deg(atan2(direction.y, direction.x)) - 90
	attack.rotation_degrees = angle
	
	if Input.is_action_pressed("attack"):
		attack.fire()		
		#weapon.monitorable = true
		#character_model.rotation_degrees.y = -angle
		#weapon_anim_player.play("swordAttack")
		
	for ability in abilities:
		abilities[ability]["cooldown_left"] = max(abilities[ability]["cooldown_left"] - delta, 0.0)
		
func _on_weapon_hit(enemy: Enemy) -> void:
	enemy.take_damage()

func _on_weap_anim_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "swordAttack":
		weapon.monitorable = false
