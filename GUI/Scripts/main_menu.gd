class_name MainMenu
extends Control

@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button
@onready var leaderboard_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Leaderboard_Button
@onready var settings_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Settings_Button 
@onready var credits_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Credits_Button 
@onready var exit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button 
@onready var margin_container: MarginContainer = $MarginContainer
@onready var settings_menu: SettingsMenu = $Settings_Menu
@onready var leaderboard: Leaderboard = $Leaderboard

func _ready() -> void:
	handle_connecting_signals()
	
func handle_connecting_signals() -> void:
	start_button.button_down.connect(on_start_pressed)
	leaderboard_button.button_down.connect(on_leaderboard_pressed)
	settings_button.button_down.connect(on_settings_pressed)
	credits_button.button_down.connect(on_credits_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	settings_menu.exit_settings_menu.connect(on_exit_settings)
	leaderboard.exit_leaderboard_menu.connect(on_exit_leaderboard)

func on_start_pressed() -> void:
	Scenes.switch_to(Scenes.GAME)
	
func on_leaderboard_pressed() -> void:
	margin_container.visible = false
	leaderboard.visible = true

func on_exit_leaderboard() -> void:
	margin_container.visible = true
	leaderboard.visible = false

func on_settings_pressed() -> void:
	margin_container.visible = false
	settings_menu.visible = true

func on_exit_settings() -> void:
	margin_container.visible = true
	settings_menu.visible = false
	
func on_credits_pressed() -> void:
	pass
	
func on_exit_pressed() -> void:
	OS.kill(OS.get_process_id())
