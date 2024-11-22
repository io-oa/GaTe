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
	var attacker = self.get_parent()
	if not GameGlobals.is_ally(area.attacker.ally_flag, attacker.ally_flag):
		if randf()	<= attacker.stat_modifiers["critical_chance"]:
			health_component.damage(area.damage * 2.0)
		else:
			health_component.damage(area.damage)

#Projectile
func _on_body_entered(body: CharacterBody2D) -> void:
	if body is not Projectile:
		return
	if not GameGlobals.is_ally(body.attacker_ally_flag, self.get_parent().ally_flag):
		if randf() <= body.modifiers["critical_chance"]:
			health_component.damage(body.damage * 2.0)
		else:
			health_component.damage(body.damage)
		if body.hits_remaining == 0:
			body.queue_free()
