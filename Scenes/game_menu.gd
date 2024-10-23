extends Control


func resume():
	get_tree().paused = false
	hide()

func pause():
	get_tree().paused = true
	show()

func testEsc():
	if Input.is_action_just_pressed("Pause"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _process(delta: float) -> void:
	testEsc()

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Options_menu.tscn")

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_resume_pressed() -> void:
	resume()

func _ready() -> void:
	hide()
