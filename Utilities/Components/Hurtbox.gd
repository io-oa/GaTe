@tool
class_name Hurtbox extends Area2D

@export var health_component: Health 
@export var hurtbox_shape: Shape2D

func _ready() -> void:
	$HurtboxShape.shape = hurtbox_shape

func _process(_delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	if area is MeleeAttack and self.get_parent() != area.get_parent().get_parent().get_parent():
		health_component.damage(10)
