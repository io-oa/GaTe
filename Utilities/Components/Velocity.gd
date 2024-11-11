class_name Velocity extends Node

@export var max_speed: float = 200

var current_velocity: Vector2 = Vector2(0, 0)

func stop():
	self.current_velocity = Vector2(0, 0)
	
func maxVelocity(direction: Vector2):
	return self.max_speed * direction

func maximizeVelocity(direction: Vector2):
	self.current_velocity = maxVelocity(direction)
	
func move(entity: CharacterBody2D):
	entity.velocity = self.current_velocity
	entity.move_and_slide()
