class_name MainMenu
extends Control

@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button
@onready var load_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Load_Button 
@onready var settings_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Settings_Button 
@onready var credits_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Credits_Button 
@onready var exit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button 
@onready var margin_container: MarginContainer = $MarginContainer
@onready var settings_menu: SettingsMenu = $Settings_Menu
@export var start_level = preload("res://Main/Main.tscn")


func _ready() -> void:
	handle_connecting_signals()
	
func handle_connecting_signals() -> void:
	start_button.button_down.connect(on_start_pressed)
	load_button.button_down.connect(on_load_pressed)
	settings_button.button_down.connect(on_settings_pressed)
	credits_button.button_down.connect(on_credits_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	settings_menu.exit_settings_menu.connect(on_exit_settings)


	
func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)
	
func on_load_pressed() -> void:
	pass

func on_settings_pressed() -> void:
	margin_container.visible = false
	settings_menu.visible = true

func on_exit_settings() -> void:
	margin_container.visible = true
	settings_menu.visible = false
	
func on_credits_pressed() -> void:
	pass
	
func on_exit_pressed() -> void:
	get_tree().quit()
