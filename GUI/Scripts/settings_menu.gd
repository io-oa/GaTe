class_name SettingsMenu
extends Control

@onready var exit_settings_button: Button = $MarginContainer/VBoxContainer/Exit_Settings_Button

signal exit_settings_menu

func _ready() -> void:
	exit_settings_button.button_down.connect(on_exit_settings_pressed)
	set_process(false)

func on_exit_settings_pressed() -> void:
	exit_settings_menu.emit()
	SettingsSignalBus.emit_set_settings_dictionary(SettingsDataContainer.create_storage_dictionary())
	set_process(false)
