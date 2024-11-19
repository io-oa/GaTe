class_name Pathfinding extends Node2D

@export var velocity_component: Velocity
@export var wave_amplitude: float
@export var wave_frequency: float 

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
	
var zigzag_progress: float = 0.0
var increasing: bool = true

func set_target(target: Vector2) -> void:
	self.navigation_agent.target_position = target

func follow_path():
	if self.navigation_agent.is_navigation_finished():
		self.velocity_component.stop()
		return
	
	var direction = (navigation_agent.get_next_path_position() - self.global_position).normalized()
	self.velocity_component.maximizeVelocity(direction)
	self.navigation_agent.set_velocity_forced(self.velocity_component.current_velocity)
	return direction

func follow_path_sin(time: float):
	if self.navigation_agent.is_navigation_finished():
		self.velocity_component.stop()
		return

	var direction = (navigation_agent.get_next_path_position() - self.global_position).normalized()
	var perpendicular_dir = Vector2(-direction.y, direction.x)
	var sine_offset = sin(time * wave_frequency) * wave_amplitude
	var sin_wave_movement = direction + perpendicular_dir * sine_offset
	var final_direction = sin_wave_movement.normalized()

	self.velocity_component.maximizeVelocity(final_direction)
	self.navigation_agent.set_velocity_forced(self.velocity_component.current_velocity)
	return final_direction
	
func follow_path_zigzag(_delta: float):
	if self.navigation_agent.is_navigation_finished():
		self.velocity_component.stop()
		return 

	var direction = (navigation_agent.get_next_path_position() - self.global_position).normalized()
	var perpendicular_dir = Vector2(-direction.y, direction.x)
	if increasing:
		zigzag_progress = min(1, zigzag_progress + wave_frequency * _delta)
		if zigzag_progress == 1.0:
			increasing = false
	else:
		zigzag_progress = max(0, zigzag_progress - wave_frequency * _delta)
		if zigzag_progress == 0.0:
			increasing = true
	var zigzag_offset = lerp(-wave_amplitude, wave_amplitude, zigzag_progress)
	var zigzag_movement = direction + perpendicular_dir * zigzag_offset
	var final_direction = zigzag_movement.normalized()

	self.velocity_component.maximizeVelocity(final_direction)
	self.navigation_agent.set_velocity_forced(self.velocity_component.current_velocity)
	return final_direction
