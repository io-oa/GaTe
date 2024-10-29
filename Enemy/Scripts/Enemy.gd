class_name Enemy extends CharacterBody2D

const MOTION_SPEED: float = 400 # Pixels/second.

@onready var player_node: Node2D = get_node("/root/Main/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	var enemy_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(enemy_types[randi() % enemy_types.size()])



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_node:
		pass
		#var direction_vector = player_node.global_position - position
		#var direction = direction_vector.normalized()
		#rotation = direction.angle()
		#linear_velocity = velocity * direction


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func take_damage():
	queue_free()
