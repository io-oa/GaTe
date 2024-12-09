class_name Credits
extends Control

signal exit_credits_menu

func _on_exit_pressed() -> void:
	exit_credits_menu.emit()
	set_process(false)
