class_name ProjectileImpact extends AnimatedSprite2D

func _ready() -> void:
	play("impact")
	
func _process(_delta) -> void:
	if not is_playing():
		queue_free()
