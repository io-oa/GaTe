@tool
extends Node

const MAP_VERTICES: PackedVector2Array = [
		Vector2(-5000, -5000),	#	TOP LEFT
		Vector2(-5000, 5000),	#	BOTTOM LEFT
		Vector2(5000, 5000),	#	BOTTOM RIGHT
		Vector2(5000, -5000)	#	TOP RIGHT
]

const NAVIGATION_POLY_INDICES: PackedInt32Array = [0, 1, 2, 3]

@export var enemy_scenes: Array[PackedScene]

@onready var navigation_region: NavigationRegion2D = $NavigationRegion2D

var score

func _process(delta: float) -> void:
	#print(self.navigation_region.navigation_polygon.vertices)
	pass
	
func _ready():
	set_navigation_poly()
	new_game()
	
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()

func new_game():
	score = 0
	$StartTimer.start()

func _on_score_timer_timeout():
	score += 1

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	if (get_tree().get_nodes_in_group("Enemies").size() < 1):
		for enemy_scene in enemy_scenes:
			var enemy = enemy_scene.instantiate()
			var enemy_spawn_location = $MobPath/MobSpawnLocation
			enemy_spawn_location.progress_ratio = randf()
			enemy.position = enemy_spawn_location.position
			add_child(enemy)
			enemy.add_to_group("Enemies")

func set_navigation_poly() -> bool:
	var navigation_polygon: NavigationPolygon = NavigationPolygon.new()
	navigation_polygon.vertices = self.MAP_VERTICES
	navigation_polygon.add_polygon(self.NAVIGATION_POLY_INDICES)
	self.navigation_region.navigation_polygon = navigation_polygon
	return true
