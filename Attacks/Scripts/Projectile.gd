class_name Projectile extends Area2D

@export var time: float = 0.5
@export var travel_range: float = 400
@export var max_hits: int = 1

@onready var hitbox: CollisionShape2D = $CollisionShape2D
@onready var hits_remaining: int = max_hits
@onready var speed_coef: float = 1 / time

var start_position: Vector2
var end_position: Vector2
var t = 0.0
var shooter: Node2D

func spawn(_shooter: Node2D) -> void:
	shooter = _shooter
	start_position = shooter.global_position
	self.global_rotation = shooter.global_rotation - PI / 2
	self.global_position = self.start_position
	self.end_position = self.start_position + Vector2(travel_range, 0).rotated(global_rotation)
	
func _process(delta: float) -> void:
	t += delta * speed_coef
	t = clamp(t, 0.0, 1.0) 
	self.global_position = self.global_position.lerp(end_position, t)
	if t == 1.0:
		queue_free()
	
func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		hits_remaining -= 1
		if hits_remaining == 0:
			queue_free()
