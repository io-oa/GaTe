extends CanvasLayer 

@export var player: Player

@onready var hp_bar: TextureProgressBar = $HealthBarContainer/MarginContainer/PlayerHealthBar
@onready var exp_bar: TextureProgressBar = $ExpBarContainer/MarginContainer/PlayerExpBar
@onready var level_display: RichTextLabel = $LevelDisplayContainer/MarginContainer/LevelDisplay
@onready var timer:  RichTextLabel = $TimePlayedContainer/RichTextLabel
@onready var upgrade_choices_menu: Panel = $UpgradeChoices
@onready var upgrade_options_container: HBoxContainer = $UpgradeChoices/HBoxContainer
@onready var upgrade_buttons: Array[Node] = upgrade_options_container.get_children()
@onready var resource: HUDResource = preload("res://Resources/HUD/HUDResource.tres")

#Stat Display
@onready var stat_display: PanelContainer = $StatDisplay
@onready var basic_attack_dmg_lbl: RichTextLabel = $StatDisplay/MarginContainer/VBoxContainer/BasicAttackDmg
@onready var damage_lbl: RichTextLabel = $StatDisplay/MarginContainer/VBoxContainer/Damage
@onready var projectile_size_lbl: RichTextLabel = $StatDisplay/MarginContainer/VBoxContainer/ProjectileSize
@onready var crit_chance_lbl: RichTextLabel = $StatDisplay/MarginContainer/VBoxContainer/CritChance

func _process(delta: float) -> void:
	update_timer()
	if Input.is_action_just_pressed("stat_display_toggle"):
		stat_display.visible = !stat_display.visible
	
func _ready() -> void:
	exp_bar.value = player.current_level_points / player.points_to_next_level * 100
	hp_bar.value = player.health_component.get_health_percentage()
	level_display.text = resource.LEVEL_DISPLAY_TEXT % player.level
	_update_stat_display()
	player.level_up.connect(_on_player_level_up)
	player.exp_change.connect(_on_player_exp_change)
	player.stat_change.connect(_update_stat_display)
	player.health_component.health_changed.connect(_on_health_changed)
	
func _on_health_changed(previous_health: float, current_health: float, max_health: float) -> void:
	hp_bar.value = player.health_component.get_health_percentage()

func _on_player_level_up(level: int):
	level_display.text = resource.LEVEL_DISPLAY_TEXT % player.level
	get_tree().paused = true
	upgrade_choices_menu.visible = true
	var picked_upgrades: Array[String] = GameGlobals.pick_random_keys(resource.upgrades, 3)
	for i in upgrade_buttons.size():
		upgrade_buttons[i].set_properties(picked_upgrades[i])
		
func _on_player_exp_change():
	exp_bar.value = player.current_level_points / player.points_to_next_level * 100

func _update_stat_display():
	self.basic_attack_dmg_lbl.text = resource.STAT_DISPLAY_TEXT % ("BASIC DMG: " + str(player.basic_attack.damage))
	self.damage_lbl.text = resource.STAT_DISPLAY_TEXT % ("DAMAGE: " + str(player.stat_modifiers["damage"] * 100) + "%")
	self.projectile_size_lbl.text = resource.STAT_DISPLAY_TEXT % ("PROJECTILE SIZE: " + str(player.stat_modifiers["projectile_size"] * 100) + "%")
	self.crit_chance_lbl.text = resource.STAT_DISPLAY_TEXT % ("CRIT: " + str(player.stat_modifiers["critical_chance"] * 100) + "%")
	
func update_timer():
	if not GameGlobals.in_boss_fight:
		var minutes: int = int((GameGlobals.current_time) / 60)
		var	seconds: int = int((GameGlobals.current_time) - minutes * 60)
		timer.text = resource.TIMER_DISPLAY_TEXT % [minutes, seconds]
	else:
		var minutes: int = int((GameGlobals.ROUND_TIMER.time_left) / 60)
		var	seconds: int = int((GameGlobals.ROUND_TIMER.time_left) - minutes * 60)
		timer.text = resource.TIMER_DISPLAY_TEXT % [minutes, seconds]
