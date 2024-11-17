extends Node

var SCREEN_SIZE: Vector2
var PROJECTILES: Node
var EFFECTS: Node
enum ALLY_FLAGS{
	player = 1 << 0,
	enemy = 1 << 1
}

func is_ally(flag1: int, flag2: int):
	return (flag1 & flag2) != 0

func normalize_angle_360(angle: float) -> float:
	return fmod(angle + 360, 360)

signal on_enemy_death(game_scaling: Node)
