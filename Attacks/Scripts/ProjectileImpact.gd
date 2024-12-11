class_name ProjectileImpact extends AnimatedSprite2D

var reverse = false

func _ready() -> void:
	if not reverse:
		play("impact")
	else:
		play_backwards("impact")
	
func _process(_delta) -> void:
	if not is_playing():
		queue_free()
