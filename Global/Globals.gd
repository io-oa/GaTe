extends Node

var SCREEN_SIZE: Vector2
var PROJECTILES: Node
var EFFECTS: Node
var score:int
var player_name:String

#Constants
var INT64_MAX = (1 << 63) - 1

const MAP_VERTICES: PackedVector2Array = [
		Vector2(-5000, -5000),	#	TOP LEFT
		Vector2(-5000, 5000),	#	BOTTOM LEFT
		Vector2(5000, 5000),	#	BOTTOM RIGHT
		Vector2(5000, -5000)	#	TOP RIGHT
]

enum ALLY_FLAGS{
	player = 1 << 0,
	enemy = 1 << 1
}

#Helpers
func is_ally(flag1: int, flag2: int):
	return (flag1 & flag2) != 0

func normalize_angle_360(angle: float) -> float:
	return fmod(angle + 360, 360)
	
func update_animation_4dir(sprite: AnimatedSprite2D, animation: String, angle: float):
	if angle > 315.0 or angle < 45.0:
		sprite.play(animation + "_right")
	elif angle >= 45.0 and angle <= 135.0:
		sprite.play(animation + "_down")
	elif angle > 135.0 and angle < 225.0:
		sprite.play(animation + "_left")
	elif angle >= 225.0 and angle <= 315.0:
		sprite.play(animation + "_up")

func pick_random_keys(dict: Dictionary, n_keys: int) -> Array[String]:
	var key_array: Array = dict.keys()
	var picked_keys: Array[String] = []
	for i in range(n_keys):
		if key_array.size() > 0:
			var picked_key = key_array[randi() % key_array.size()]
			key_array.erase(picked_key)
			picked_keys.append(picked_key)
	return picked_keys
	
signal on_enemy_death(game_scaling: Node)
