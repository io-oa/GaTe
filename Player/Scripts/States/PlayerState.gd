class_name PlayerState extends Node

signal transitioned(state: PlayerState, new_state_name: String)

@onready var player : Player = get_owner()

func _ready():
	pass

func enter():
	pass

func process_state(_delta: float) -> void:
	pass

func physics_process_state(_delta: float) -> void:
	pass

func exit():
	pass
