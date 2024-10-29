class_name EnemyState extends Node

signal transitioned(state: EnemyState, new_state_name: String)

@onready var enemy : Enemy = get_owner()

func _ready():
	pass

func enter():
	pass

func process_state(delta: float) -> void:
	pass

func physics_process_state(delta: float) -> void:
	pass

func exit():
	pass
