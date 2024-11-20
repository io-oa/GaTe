extends Control
@onready var resume_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Resume_Button
@onready var settings_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Settings_Button
@onready var exit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button
@onready var margin_container: MarginContainer = $MarginContainer
@onready var settings_menu: SettingsMenu = $Settings_Menu
@export var main_menu_path: String = "res://GUI/main_menu.tscn"

func _ready() -> void:
	handle_connecting_signals()
	
func handle_connecting_signals() -> void:
	resume_button.button_down.connect(on_start_pressed)
	settings_button.button_down.connect(on_settings_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	settings_menu.exit_settings_menu.connect(on_exit_settings)
	
var _is_paused:bool = false:
	set = set_paused

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_is_paused = !_is_paused

func set_paused(value:bool) -> void:
	_is_paused = value
	get_tree().paused =_is_paused
	visible = _is_paused
	
func on_start_pressed() -> void:
	_is_paused = false
	
func on_settings_pressed() -> void:
	margin_container.visible = false
	settings_menu.visible = true

func on_exit_settings() -> void:
	margin_container.visible = true
	settings_menu.visible = false
	
func on_exit_pressed() -> void:
	_is_paused = false
	get_tree().paused = false
	get_tree().change_scene_to_file(main_menu_path)
