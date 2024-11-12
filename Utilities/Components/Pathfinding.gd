class_name Pathfinding extends Node2D

@export var velocity_component: Velocity

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
		
func set_target(target: Vector2):
	self.navigation_agent.target_position = target

func follow_path():
	if self.navigation_agent.is_navigation_finished():
		self.velocity_component.stop()
		return 
	
	var direction = (navigation_agent.get_next_path_position() - self.global_position).normalized()
	self.velocity_component.maximizeVelocity(direction)
	self.navigation_agent.set_velocity_forced(self.velocity_component.current_velocity)
	return direction
