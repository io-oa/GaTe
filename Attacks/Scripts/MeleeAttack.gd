class_name MeleeAttack extends Area2D

@export var attack_timer: float = 0.1
@export var lock_position_on_fire: bool = true
@export var projectile_scenes: Array[PackedScene]

@onready var hitbox: CollisionShape2D = $CollisionShape2D
@onready var firing: bool = false
@onready var cooldown: float = 0
@onready var locked_rotation: float = 0
@onready var locked_position: Vector2 = Vector2(0,0)

var attacker: Node2D

func _ready() -> void:
	hitbox.set_deferred("disabled", true)
	
func fire(attacker: Node2D) -> void:
	if not firing:
		firing = true
		locked_rotation = self.global_rotation
		if lock_position_on_fire:
			locked_position = self.get_parent().global_position
		self.attacker = attacker
		for projectile_scene in projectile_scenes:
			var new_projectile = projectile_scene.instantiate()
			GameGlobals.PROJECTILES.add_child(new_projectile)
			new_projectile.spawn(self.attacker, self.global_rotation)
		cooldown = attack_timer
		hitbox.set_deferred("disabled", false)
	
func _process(_delta: float) -> void:
	if firing:
		set_global_rotation(locked_rotation)
		set_global_position(locked_position)
		cooldown = max(0, cooldown - _delta)
		if cooldown == 0:
			firing = false
			set_global_position(self.get_parent().global_position)
			hitbox.set_deferred("disabled", true)
	
