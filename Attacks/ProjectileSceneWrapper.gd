class_name ProjectileSceneWrapper extends Resource

@export var projectile: PackedScene
@export var cooldown: float = 1.0
@export var duplicate_x: bool = false
@export var follow_attack_direction: bool = true

var projectile_name: String = ""
var cooldown_left: float = 0.0

func get_projectile_name() -> String:
	if projectile:
		var scene_path = projectile.resource_path
		var scene_name = scene_path.get_file().get_basename()
		return scene_name
	return ""

func _init(projectile_path: String = "", cooldown: float = 1.0, duplicate_x: bool = false, follow_attack_direction: bool = true):
	if not projectile_path.is_empty():
		self.projectile = load(projectile_path)
	else:
		self.projectile = null
	self.cooldown = cooldown
	self.duplicate_x = duplicate_x
	self.follow_attack_direction = follow_attack_direction
	self.projectile_name = get_projectile_name()
