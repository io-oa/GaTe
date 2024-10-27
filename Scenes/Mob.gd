class_name Mob extends RigidBody2D

@onready var player_node: Node2D = get_node("/root/Main/Player")
@onready var velocity: float = randf_range(150.0, 250.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_node:
		var direction_vector = player_node.global_position - position
		var direction = direction_vector.normalized()
		rotation = direction.angle()
		linear_velocity = velocity * direction
		print(direction)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func take_damage():
	queue_free()
