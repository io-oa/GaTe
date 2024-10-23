extends Node2D
@onready var game_menu = $TileMapLayer/Player/CanvasLayer/Game_Menu

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		game_menu.testEsc()
