class_name Enemy extends CharacterBody2D

const MOTION_SPEED: float = 400.0 # Pixels/second.

@export var attack_range: float = 400.0 

@onready var player_node: Node2D = get_node("/root/Main/Player")
@onready var health_component: Health = $Health
@onready var velocity_component: Velocity = $Velocity
@onready var pathfinding_component: Pathfinding = $Pathfinding
@onready var hp_bar: TextureProgressBar = $HealthBar/TextureProgressBar
@onready var attack: Attack = $BasicAttack

var player_pos: Vector2 = Vector2(0.0, 0.0)
var player_direction: Vector2 = Vector2(0.0, 0.0)

func _ready():
	health_component.init_health()
	var enemy_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(enemy_types[randi() % enemy_types.size()])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	$HealthBar.global_rotation = 0.0
	
	self.player_pos = player_node.global_position
	attack.global_rotation = player_direction.angle()

	if self.position.distance_to(self.player_pos) < self.attack_range:
		attack.fire(self)	

func _on_death() -> void:
	queue_free()

func _on_health_changed(previous_health: float, current_health: float, max_health: float) -> void:
	hp_bar.value = self.health_component.get_health_percentage()
	print(self.name, "Took %f dmg" % (previous_health - current_health))
