extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_confirm_pressed() -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db($MarginContainer/AudioControl/VBoxContainer/HSlider.value))
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
