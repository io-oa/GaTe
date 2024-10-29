class_name Player extends CharacterBody2D

const MOTION_SPEED: float = 400 # Pixels/second.

var screen_size: Vector2
var last_direction = Vector2(1, 0)
var weapon: Weapon

var abilities = {
	"dash": {
		"cooldown": 2.0,
		"cooldown_left": 0.0,
		"distance": 200.0,
		"duration": 0.2
	}
}

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
	
	"basic_attack": [
		["side_right_attack", false],
		["45front_right_attack", false],
		["front_attack", false],
		["45front_left_attack", false],
		["side_left_attack", false],
		["45back_left_attack", false],
		["back_attack", false],
		["45back_right_attack", false],
	]
}
	
func _ready():
	GameGlobals.SCREEN_SIZE = get_viewport_rect().size
	weapon = $weapon.get_child(0)
	weapon.connect("hit_enemy", _on_weapon_hit)
	
func _physics_process(_delta):
	pass

func _process(delta):
	$Position.text = str([position.x, position.y])
	
	if Input.is_action_pressed("attack"):
		$AnimationPlayer.play("attackAnimation")
	
	for ability in abilities:
		abilities[ability]["cooldown_left"] = max(abilities[ability]["cooldown_left"] - delta, 0.0)
	
func update_animation(anim_set):
	var angle = rad_to_deg(last_direction.angle()) + 22.5
	var slice_dir = floor(angle / 45)

	$Sprite2D.play(anim_directions[anim_set][slice_dir][0])
	$Sprite2D.flip_h = anim_directions[anim_set][slice_dir][1]
	
func _on_weapon_hit(enemy: Enemy) -> void:
	enemy.take_damage()
		
