extends Node

const GAME: String = "res://Main/Main.tscn"
const MAIN_MENU: String = "res://GUI/main_menu.tscn"
const GAME_OVER: String = "res://Main/Game_over/game_over.tscn"

func switch_to(scene_name: String):
	var scene: PackedScene = load(scene_name)
	get_tree().call_deferred("change_scene_to_packed", scene)
