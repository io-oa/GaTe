class_name StateMachine extends Node

var initial_state: Callable
var current_state: Callable
var states: Array[Callable] = []

func add_states(_states: Array[Callable]):
	self.states.append_array(_states)
	self.initial_state = self.states[0]
	if not self.current_state and self.initial_state:
		self.current_state = initial_state
	
func run():
	if self.current_state:
		self.current_state.call()

func set_current_state(state: Callable):
	self.current_state = state
	
func _process(delta) -> void:
	pass

func _physics_process(delta) -> void:
	pass
