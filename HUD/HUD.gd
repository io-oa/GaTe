extends CanvasLayer 

@export var player: Player
var enemies_kill: float = 0.0

@onready var resource: HUDResource = preload("res://Resources/HUD/HUDResource.tres")

#Trackers
@onready var hp_bar: TextureProgressBar = $HealthBarContainer/MarginContainer/PlayerHealthBar
@onready var exp_bar: TextureProgressBar = $ExpBarContainer/MarginContainer/PlayerExpBar
@onready var level_display: RichTextLabel = $VBoxContainer/LevelDisplayContainer/MarginContainer/LevelDisplay
@onready var kill_counter: RichTextLabel = $VBoxContainer/KillCounterContainer/RichTextLabel
@onready var timer:  RichTextLabel = $TimePlayedContainer/RichTextLabel
@onready var boss_health_bar_container: PanelContainer = $BossHealthBarContainer
@onready var boss_hp_bar: TextureProgressBar = $BossHealthBarContainer/MarginContainer/BossHealthBar

#Upgrades
@onready var upgrade_choices_menu: Panel = $UpgradeChoices
@onready var upgrade_options_container: HBoxContainer = $UpgradeChoices/HBoxContainer
@onready var upgrade_buttons: Array[Node] = upgrade_options_container.get_children()

#Stat Display
@onready var stat_display: PanelContainer = $StatDisplay
@onready var basic_attack_dmg_lbl: RichTextLabel = $StatDisplay/MarginContainer/VBoxContainer/BasicAttackDmg
@onready var damage_lbl: RichTextLabel = $StatDisplay/MarginContainer/VBoxContainer/Damage
@onready var projectile_size_lbl: RichTextLabel = $StatDisplay/MarginContainer/VBoxContainer/ProjectileSize
@onready var crit_chance_lbl: RichTextLabel = $StatDisplay/MarginContainer/VBoxContainer/CritChance

#End Game Prompt
@onready var end_game_prompt: Panel = $EndGameScreen
@onready var level_lbl = $EndGameScreen/MarginContainer/EndGameMenu/VBoxContainer/Level
@onready var enemies_killed_lbl = $EndGameScreen/MarginContainer/EndGameMenu/VBoxContainer/EnemiesKilled
@onready var boss_fight_time_lbl = $EndGameScreen/MarginContainer/EndGameMenu/VBoxContainer/BossFightTime
@onready var menu_back_btn: Button = $EndGameScreen/MarginContainer/MenuBackButton

func _process(delta: float) -> void:
	update_timer()
	if Input.is_action_just_pressed("stat_display_toggle"):
		stat_display.visible = !stat_display.visible
	
func _ready() -> void:
	exp_bar.value = player.current_level_points / player.points_to_next_level * 100
	hp_bar.value = player.health_component.get_health_percentage()
	level_display.text = resource.LEVEL_DISPLAY_TEXT % player.level
	kill_counter.text = resource.KILL_COUNTER_TEXT % GameGlobals.enemies_killed
	_update_stat_display()
	player.level_up.connect(_on_player_level_up)
	player.exp_change.connect(_on_player_exp_change)
	player.stat_change.connect(_update_stat_display)
	player.health_component.health_changed.connect(_on_health_changed)
	GameGlobals.enemy_death.connect(_on_enemy_killed)
	GameGlobals.boss_death.connect(_on_boss_death)
	menu_back_btn.pressed.connect(_on_menu_back_btn)
	
func _on_health_changed(previous_health: float, current_health: float, max_health: float) -> void:
	hp_bar.value = player.health_component.get_health_percentage()

func _on_player_level_up(level: int):
	level_display.text = resource.LEVEL_DISPLAY_TEXT % player.level
	get_tree().paused = true
	upgrade_choices_menu.visible = true
	var excluded_upgrades: Array[String] = []
	for i in range(player.auto_projectiles.projectile_scenes.size()):
		var projectile_name: String = player.auto_projectiles.projectile_scenes[i].projectile_name.to_lower() 
		if projectile_name in resource.upgrades.keys():
			excluded_upgrades.append(projectile_name)
	var picked_upgrades: Array[String] = GameGlobals.pick_random_keys(resource.upgrades, 3, excluded_upgrades)
	for i in upgrade_buttons.size():
		upgrade_buttons[i].set_properties(picked_upgrades[i])
		
func _on_player_exp_change():
	exp_bar.value = player.current_level_points / player.points_to_next_level * 100

func _update_stat_display():
	self.basic_attack_dmg_lbl.text = resource.STAT_DISPLAY_TEXT % ("BASIC DMG: " + str(player.basic_attack.damage))
	self.damage_lbl.text = resource.STAT_DISPLAY_TEXT % ("DAMAGE: " + str(player.stat_modifiers["damage"] * 100) + "%")
	self.projectile_size_lbl.text = resource.STAT_DISPLAY_TEXT % ("PROJECTILE SIZE: " + str(player.stat_modifiers["projectile_size"] * 100) + "%")
	self.crit_chance_lbl.text = resource.STAT_DISPLAY_TEXT % ("CRIT: " + str(player.stat_modifiers["critical_chance"] * 100) + "%")
	
func _on_enemy_killed(scaling: Node):
	kill_counter.text = resource.KILL_COUNTER_TEXT % GameGlobals.enemies_killed
	
func _on_boss_death(boss: Entity):
	var minutes: int = int((GameGlobals.MAX_BOSS_FIGHT_TIME - GameGlobals.ROUND_TIMER.time_left) / 60)
	var	seconds: int = snappedi(((GameGlobals.MAX_BOSS_FIGHT_TIME - GameGlobals.ROUND_TIMER.time_left) - minutes * 60), 1)
	GameGlobals.ROUND_TIMER.stop()
	get_tree().paused = true
	end_game_prompt.visible = true
	self.level_lbl.text = resource.STAT_DISPLAY_TEXT % ("Level: " + str(player.level))
	self.enemies_killed_lbl.text = resource.STAT_DISPLAY_TEXT % ("Enemies Killed: " + str(GameGlobals.enemies_killed))
	self.boss_fight_time_lbl.text = resource.END_GAME_TIMER_TEXT % [minutes, seconds]

	
func update_timer():
	if not GameGlobals.in_boss_fight:
		var minutes: int = int((GameGlobals.current_time) / 60)
		var	seconds: int = snappedi(((GameGlobals.current_time) - minutes * 60), 1)
		timer.text = resource.TIMER_DISPLAY_TEXT % [minutes, seconds]
	else:
		var minutes: int = int((GameGlobals.ROUND_TIMER.time_left) / 60)
		var	seconds: int = int((GameGlobals.ROUND_TIMER.time_left) - minutes * 60)
		timer.text = resource.TIMER_DISPLAY_TEXT % [minutes, seconds]

func _on_menu_back_btn():
	SilentWolf.Scores.save_score(GameGlobals.player_name, GameGlobals.enemies_killed)
	Scenes.switch_to(Scenes.MAIN_MENU)
	GameGlobals.reset_vars()

	
func toggle_boss_health_bar():
	boss_health_bar_container.visible = !boss_health_bar_container.visible
