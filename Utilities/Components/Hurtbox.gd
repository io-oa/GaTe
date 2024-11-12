@tool
class_name Hurtbox extends Area2D

@export var health_component: Health 
@export var hurtbox_shape: Shape2D

func _ready() -> void:
	$HurtboxShape.shape = hurtbox_shape

func _process(_delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	if (area is Attack) and (self.get_parent() != area.attacker):
		health_component.damage(area.damage)

func _on_body_entered(body: CharacterBody2D) -> void:
	if	(body is Projectile) and (self.get_parent() != body.attacker):
		health_component.damage(body.damage)
