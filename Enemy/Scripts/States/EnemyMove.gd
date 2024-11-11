extends EnemyState

func physics_process_state(_delta: float):
	var target: Vector2 = enemy.player_node.global_position
	enemy.rotation = target.normalized().angle()
	enemy.pathfinding_component.set_target(target)
	var direction: Vector2 = enemy.pathfinding_component.follow_path()
	enemy.velocity_component.move(enemy)
	enemy.rotation = direction.angle()
