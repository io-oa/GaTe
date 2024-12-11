extends Control

@onready var menu_back_button: Button = $MarginContainer/VBoxGameOver/VBoxGameOver/MenuBackButton
@onready var play_again: Button = $MarginContainer/VBoxGameOver/VBoxGameOver/PlayAgain

func _ready() -> void:
	GameGlobals.res_cursor()
	get_tree().paused = false
	menu_back_button.pressed.connect(on_menu_back_btn)
	play_again.pressed.connect(on_play_again_btn)

func on_menu_back_btn() -> void:
	Scenes.switch_to(Scenes.MAIN_MENU)
	GameGlobals.reset_vars()

func on_play_again_btn() -> void:
	Scenes.switch_to(Scenes.GAME)
	GameGlobals.reset_vars()
