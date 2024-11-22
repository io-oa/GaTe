class_name Entity extends CharacterBody2D

@export var attack_range: float = 400.0

var time_lived: float = 0.0
var ally_flag: int = 0
var state_machine: StateMachine = StateMachine.new()

var stat_modifiers: Dictionary = {
	"projectile_size": 1.0,
	"critical_chance": 0.0,
	"damage": 1.0
}
