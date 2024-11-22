extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Position.text = str([int(self.get_parent().position.x), int(self.get_parent().position.y)])
	$Position2.text = str(self.get_parent().level)
	global_rotation = 0
