class_name Attack extends Area2D

@export var damage: float = 10.0
@export_range(0.001, 100) var attack_timer: float = 0.1
@export var lock_position_on_fire: bool = true
@export var projectile_scenes: Array[Resource]

@onready var hitbox: CollisionShape2D = $CollisionShape2D
@onready var firing: bool = false
@onready var cooldown: float = 0
@onready var locked_rotation: float = 0
@onready var locked_position: Vector2 = Vector2(0,0)

var attacker: Node2D

func _ready() -> void:
	self.attacker = get_owner()
	damage = damage * self.attacker.stat_modifiers["damage"]
	hitbox.set_deferred("disabled", true)
	
func fire(attacker: Node2D) -> void:
	if not firing:
		firing = true
		locked_rotation = self.global_rotation
		if lock_position_on_fire:
			locked_position = self.get_parent().global_position
		for projectile_scene_wrapper in projectile_scenes:
			if projectile_scene_wrapper.cooldown_left > 0:
				continue
			var projectile_rotation = self.global_rotation
			if not projectile_scene_wrapper.follow_attack_direction: 
				projectile_rotation = 0
			if projectile_scene_wrapper.duplicate_x:
				var new_projectile = projectile_scene_wrapper.projectile.instantiate()
				GameGlobals.PROJECTILES.add_child(new_projectile)
				new_projectile.scale = Vector2(new_projectile.scale.x, -new_projectile.scale.y)
				new_projectile.spawn(self.global_position, projectile_rotation + PI, self.attacker.ally_flag, self.attacker.stat_modifiers)
			var new_projectile = projectile_scene_wrapper.projectile.instantiate()
			GameGlobals.PROJECTILES.add_child(new_projectile)
			new_projectile.spawn(self.global_position, projectile_rotation, self.attacker.ally_flag, self.attacker.stat_modifiers)
			projectile_scene_wrapper.cooldown_left = projectile_scene_wrapper.cooldown
		cooldown = attack_timer
		hitbox.set_deferred("disabled", false)
	
func _process(_delta: float) -> void:
	for projectile in projectile_scenes:
		projectile.cooldown_left = max(0, projectile.cooldown_left - _delta)
	if firing:
		set_global_rotation(locked_rotation)
		set_global_position(locked_position)
		cooldown = max(0, cooldown - _delta)
		if cooldown == 0:
			firing = false
			set_global_position(self.get_parent().global_position)
			hitbox.set_deferred("disabled", true)
	
