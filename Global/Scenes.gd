extends Node

const GAME: String = "res://Main/Main.tscn"
const MAIN_MENU: String = "res://GUI/main_menu.tscn"

func switch_to(scene_name: String):
	var scene: PackedScene = load(scene_name)
	get_tree().change_scene_to_packed(scene)