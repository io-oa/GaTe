class_name Velocity extends Node

@export var max_speed: float = 200

var current_velocity: Vector2 = Vector2(0, 0)

func stop():
	self.current_velocity = Vector2(0, 0)
	
func maxVelocity(direction: Vector2):
	return self.max_speed * direction

func maximizeVelocity(direction: Vector2):
	self.current_velocity = maxVelocity(direction)
	
func move_collide(entity: CharacterBody2D, delta: float, slide: bool = true) -> KinematicCollision2D:
	var collision: KinematicCollision2D = entity.move_and_collide(self.current_velocity * delta)
	if collision and slide:
		self.current_velocity = entity.velocity.slide(collision.get_normal())
		entity.velocity = self.current_velocity
	return collision

func move(entity: CharacterBody2D):
	entity.velocity = self.current_velocity
	entity.move_and_slide()
