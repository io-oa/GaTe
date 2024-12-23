class_name Projectile extends CharacterBody2D

@export var damage: float = 10.0
@export var max_range: float = 1000.0
@export var max_hits: int = GameGlobals.INT64_MAX
@export var spread: float = 0
@export var impact_scene: PackedScene
@export var rotate_sprite: bool = true

@onready var hitbox: Area2D = $Area2D
@onready var travel_animation: AnimatedSprite2D = $TravelAnimation
@onready var hits_remaining: int = max_hits
@onready var velocity_component: Velocity = $Velocity
@onready var audio: AudioStreamPlayer =  $AudioStreamPlayer
	
var start_position: Vector2
var end_position: Vector2
var attacker_ally_flag: int
var travelled: float = 0

var modifiers: Dictionary
	
func spawn(pos: Vector2, projectile_rotation: float, ally_flag: int, modifiers: Dictionary) -> void:
	self.modifiers = modifiers
	self.apply_attacker_modifiers()
	self.attacker_ally_flag = ally_flag
	self.start_position = pos
	self.global_rotation = projectile_rotation + randf_range(-spread, spread)
	if not rotate_sprite:
		self.travel_animation.global_rotation = 0
	self.global_position = self.start_position
	velocity_component.maximizeVelocity(Vector2.RIGHT.rotated(self.global_rotation))
	travel_animation.play("travelling")
	if audio:
		audio.play()
	
func _physics_process(delta: float) -> void:
	var last_position: Vector2 = self.position
	velocity_component.move_collide(self, delta)
	travelled = min(max_range, travelled + last_position.distance_to(self.position))
			
	if travelled == max_range:
		queue_free()
		
func _on_area_2d_area_entered(area: Area2D) -> void:
	if self.attacker_ally_flag == area.get_parent().ally_flag:
		return
	if area is Hurtbox and max_hits != GameGlobals.INT64_MAX:
		hits_remaining = max(0, hits_remaining - 1)
	if impact_scene:
		var impact_effect = impact_scene.instantiate()
		GameGlobals.EFFECTS.add_child(impact_effect)
		impact_effect.position = self.position
		
func apply_attacker_modifiers():
	self.damage = damage * modifiers["damage"]
	self.scale *= modifiers["projectile_size"]
	
func modify_damage(scale: float, amount: float = damage):
	self.damage = damage * scale
