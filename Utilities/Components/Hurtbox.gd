@tool
class_name Hurtbox extends Area2D

@export var health_component: Health 
@export var hurtbox_shape: Shape2D

func _ready() -> void:
	$HurtboxShape.shape = hurtbox_shape

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		$HurtboxShape.shape = hurtbox_shape

#Attack
func _on_area_entered(area: Area2D) -> void:
	if area is not Attack:
		return
	if not self.get_parent().ally_flag or not area.attacker.ally_flag:
		return
	if not GameGlobals.is_ally(area.attacker.ally_flag, self.get_parent().ally_flag):
		health_component.damage(area.damage)

#Projectile
func _on_body_entered(body: CharacterBody2D) -> void:
	if body is not Projectile:
		return
	if not self.get_parent().ally_flag:
		return
	if not GameGlobals.is_ally(body.attacker_ally_flag, self.get_parent().ally_flag):
		health_component.damage(body.damage)
