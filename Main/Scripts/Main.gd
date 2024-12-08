extends Node

const MOB_POS_OFFSET: float = 100.0
const MOB_SPAWN_CUT_OFF: int = 75
const NAVIGATION_POLY_INDICES: PackedInt32Array = [0, 1, 2, 3]
const WAVE_UPDATE_INTERVAL: float = 20.0

@onready var navigation_region: NavigationRegion2D = $NavigationRegion2D
@onready var waves_resource: WavesResource = preload("res://Resources/Main/Waves.tres")
@onready var wave_spawn_timer: float = waves_resource.spawn_interval
@onready var wave_update_timer: float = 0.0

var spawning_disabled = false

func _process(delta: float) -> void:
	handle_waves()
	
func _ready():
	get_tree().paused = false
	GameGlobals.PLAYER = $Player
	GameGlobals.HUD = $HUD
	GameGlobals.ROUND_TIMER = $RoundTimer
	GameGlobals.SCREEN_SIZE = GameGlobals.PLAYER.get_viewport_rect().size
	GameGlobals.PROJECTILES = get_node(^"/root/Main/Projectiles")
	GameGlobals.EFFECTS = get_node(^"/root/Main/Effects")
	GameGlobals.ROUND_TIMER.wait_time = GameGlobals.GAME_TIME
	GameGlobals.ROUND_TIMER.timeout.connect(_on_round_time_timeout)
	set_navigation_poly()
	new_game()
	
func game_over():
	$ScoreTimer.stop()

func new_game():
	GameGlobals.ROUND_TIMER.start()
	Sound.play("BACKGROUND_MUSIC")
	
func _on_round_time_timeout():
	spawn_boss("alien")

func set_navigation_poly() -> bool:
	var navigation_polygon: NavigationPolygon = NavigationPolygon.new()
	navigation_polygon.vertices = GameGlobals.MAP_VERTICES
	navigation_polygon.add_polygon(self.NAVIGATION_POLY_INDICES)
	self.navigation_region.navigation_polygon = navigation_polygon
	return true
	
func spawn_wave():
	for wave in waves_resource.waves.keys():
		if waves_resource.waves[wave]["available"]:
			for i in range(waves_resource.waves[wave]["mob_count"]):
				var enemy = waves_resource.waves[wave]["enemy"].instantiate()
				enemy.position = GameGlobals.find_valid_position(MOB_POS_OFFSET)
				add_child(enemy)
				enemy.add_to_group("Enemies")			

func handle_waves():
	wave_spawn_timer = max(0, wave_spawn_timer - get_process_delta_time())
	wave_update_timer = max(0, wave_update_timer - get_process_delta_time())
	if get_tree().get_node_count_in_group("Enemies") <= MOB_SPAWN_CUT_OFF and is_zero_approx(wave_spawn_timer) and not spawning_disabled: 
		spawn_wave()
		wave_spawn_timer = waves_resource.spawn_interval
	if is_zero_approx(wave_update_timer):
		for wave in waves_resource.waves:
			if waves_resource.waves[wave]["time_available"] <= GameGlobals.current_time:
				waves_resource.waves[wave]["available"] = true
		wave_update_timer = WAVE_UPDATE_INTERVAL

func spawn_boss(name: String):
	GameGlobals.ROUND_TIMER.wait_time = GameGlobals.MAX_BOSS_FIGHT_TIME
	GameGlobals.ROUND_TIMER.start()
	GameGlobals.HUD.toggle_boss_health_bar()
	Sound.play("BOSS_MUSIC")
	GameGlobals.in_boss_fight = true
	spawning_disabled = true
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.queue_free()
	var boss = waves_resource.bosses[name]["enemy"].instantiate()
	add_child(boss)
	boss.position = GameGlobals.find_valid_position(MOB_POS_OFFSET)
	boss.add_to_group("Bosses")		
