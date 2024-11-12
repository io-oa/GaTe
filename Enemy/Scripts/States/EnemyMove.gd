extends EnemyState

func physics_process_state(_delta: float):
	enemy.player_node.global_position
	enemy.pathfinding_component.set_target(enemy.player_pos)
	enemy.player_direction = enemy.pathfinding_component.follow_path()
	enemy.velocity_component.move(enemy)
	enemy.rotation = enemy.player_direction.angle()
