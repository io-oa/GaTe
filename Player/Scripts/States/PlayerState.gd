class_name PlayerState extends Node

signal transitioned(state: PlayerState, new_state_name: String)

@onready var player : Player = get_owner()

func _ready():
	pass

func enter():
	pass

func process_state(delta: float):
	pass

func physics_process_state(delta: float):
	pass

func exit():
	pass
