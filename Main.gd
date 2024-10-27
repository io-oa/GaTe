extends Node

@export var mob_scene: PackedScene
var score

func _ready():
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
	if(get_tree().get_nodes_in_group("Mobs").size() < 1):
		var mob = mob_scene.instantiate()
		var mob_spawn_location = $MobPath/MobSpawnLocation
		mob_spawn_location.progress_ratio = randf()
		mob.position = mob_spawn_location.position
		add_child(mob)
		mob.add_to_group("Mobs")
