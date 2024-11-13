class_name Projectile extends CharacterBody2D

@export var damage: float = 10.0
@export var max_range: float = 1000.0
@export var max_hits: int = 1
@export var impact_scene: PackedScene

@onready var hitbox: Area2D = $Area2D
@onready var travel_animation: AnimatedSprite2D = $TravelAnimation
@onready var hits_remaining: int = max_hits
@onready var velocity_component: Velocity = $Velocity
	
var start_position: Vector2
var end_position: Vector2
var attacker: Node2D
var travelled: float = 0
	
func spawn(attacker: Node2D, projectile_rotation: float) -> void:
	self.attacker = attacker
	self.start_position = self.attacker.global_position
	self.global_rotation = projectile_rotation
	self.global_position = self.start_position
	#self.end_position = self.start_position + Vector2(travel_range, 0).rotated(self.global_rotation)
	velocity_component.maximizeVelocity(Vector2(1, 0).rotated(self.global_rotation))
	travel_animation.play("travelling")
	
func _physics_process(delta: float) -> void:
	var last_position: Vector2 = self.position
	velocity_component.move_collide(self, delta)
	travelled = min(max_range, travelled + last_position.distance_to(self.position))
	
	if travelled == max_range:
		queue_free()
		
func _on_area_2d_area_entered(area: Area2D) -> void:
	if attacker != area.get_parent():
		hits_remaining -= 1
		if impact_scene:
			var impact_effect = impact_scene.instantiate()
			GameGlobals.EFFECTS.add_child(impact_effect)
			impact_effect.position = self.position
		if hits_remaining == 0:
			queue_free()
