class_name Weapon extends Area2D

signal hit_enemy(enemy: Node)

func _ready():
	self.connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node):
	if body is Enemy:
		emit_signal("hit_enemy", body)
