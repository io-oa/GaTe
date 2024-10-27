class_name Mob extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true
	max_contacts_reported = 10
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func take_damage():
	queue_free()
	
func _on_body_entered(body: Node) -> void:
	print("Entered body:", body.name, " - Type:", body.get_class())
	if (body.get_class() == "Area2D"):
		queue_free()
