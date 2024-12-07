extends Node

signal enemy_death(game_scaling: Node)
signal boss_death(boss: Entity)

#Random stuff!
var PLAYER: Player
var SCREEN_SIZE: Vector2
var PROJECTILES: Node
var EFFECTS: Node
var ROUND_TIMER: Timer
var score: int
var player_name: String
var current_time: float
var in_boss_fight: bool = false
var enemies_killed: int = 0
 
#Multithreading
var projectile_queue: Array[Callable]
var projectile_queue_semaphore: Semaphore
var projectile_queue_mutex: Mutex
var projectile_threads: Array[Thread]

#Constants
const INT64_MAX: int = (1 << 63) - 1
const GAME_TIME: float = 3.0
const MAX_BOSS_FIGHT_TIME: float = 180.0

const MAP_VERTICES: PackedVector2Array = [
		Vector2(-5000, -5000),	#	TOP LEFT
		Vector2(-5000, 5000),	#	BOTTOM LEFT
		Vector2(5000, 5000),	#	BOTTOM RIGHT
		Vector2(5000, -5000)	#	TOP RIGHT
]

enum ALLY_FLAGS{
	player = 1 << 0,
	enemy = 1 << 1
}

#Helpers
func is_ally(flag1: int, flag2: int):
	return (flag1 & flag2) != 0

func normalize_angle_360(angle: float) -> float:
	return fmod(angle + 360, 360)
	
func update_animation_4dir(sprite: AnimatedSprite2D, animation: String, angle: float):
	if angle > 315.0 or angle < 45.0:
		sprite.play(animation + "_right")
	elif angle >= 45.0 and angle <= 135.0:
		sprite.play(animation + "_down")
	elif angle > 135.0 and angle < 225.0:
		sprite.play(animation + "_left")
	elif angle >= 225.0 and angle <= 315.0:
		sprite.play(animation + "_up")

func pick_random_keys(dict: Dictionary, n_keys: int) -> Array[String]:
	var key_array: Array = dict.keys()
	var picked_keys: Array[String] = []
	for i in range(n_keys):
		if key_array.size() > 0:
			var picked_key = key_array[randi() % key_array.size()]
			key_array.erase(picked_key)
			picked_keys.append(picked_key)
	return picked_keys
	
func init_projectile_threads(count: int):
	for i in range(count):
		self.projectile_threads.append(Thread.new())
	for i in range(projectile_threads.size()):
		projectile_threads[i].start(Callable(self, "_projectile_processing_thread").bind(str(i)))
				
func _process(delta: float) -> void:
	current_time = GAME_TIME - ROUND_TIMER.time_left
	
		
func _ready() -> void:
	current_time = 0.0
	projectile_queue_semaphore = Semaphore.new()
	projectile_queue_mutex = Mutex.new()
	init_projectile_threads(4)
	
#Projectile multithreading xd
func _projectile_processing_thread(thread_name: String):
	while true:
		projectile_queue_semaphore.wait()
		projectile_queue_mutex.lock()
		if not projectile_queue.is_empty():
			var proj_callable = projectile_queue.pop_front()
			if proj_callable.is_valid():
				proj_callable.call()
		projectile_queue_mutex.unlock()

func _exit_tree() -> void:
	for thread in projectile_threads:
		thread.wait_to_finish()

func add_to_projectile_queue(callable: Callable) -> void:
	projectile_queue_mutex.lock()
	projectile_queue.append(callable)
	projectile_queue_mutex.unlock()
	projectile_queue_semaphore.post()

func find_valid_position(offset: float) -> Vector2:
	var point: Vector2 = Vector2.ZERO
	point.x = randi_range(
		self.PLAYER.position.x - (self.SCREEN_SIZE.x / 2) - offset,
		self.PLAYER.position.x + (self.SCREEN_SIZE.x / 2) + offset
	)
	point.y = randi_range(
		self.PLAYER.position.y - (self.SCREEN_SIZE.y / 2) - offset,
		self.PLAYER.position.y + (self.SCREEN_SIZE.y / 2) + offset
	)
	if offset > 0.0:
		if point.x > self.PLAYER.position.x:
			point.x = clamp(
				point.x, 
				self.PLAYER.position.x + (self.SCREEN_SIZE.x / 2), 
				self.PLAYER.position.x + (self.SCREEN_SIZE.x / 2) + offset
			)
		else:
			point.x = clamp(
				point.x, 
				self.PLAYER.position.x - (self.SCREEN_SIZE.x / 2) - offset, 
				self.PLAYER.position.x - (self.SCREEN_SIZE.x / 2)
			)
		if point.y > self.PLAYER.position.y:
			point.x = clamp(
				point.y, 
				self.PLAYER.position.y + (self.SCREEN_SIZE.y / 2), 
				self.PLAYER.position.y + (self.SCREEN_SIZE.y / 2) + offset
			)
		else:
			point.y = clamp(
				point.y, 
				self.PLAYER.position.y - (self.SCREEN_SIZE.y / 2) - offset, 
				self.PLAYER.position.y - (self.SCREEN_SIZE.y / 2)
			)
	point.x = clamp(point.x, self.MAP_VERTICES[1].x, self.MAP_VERTICES[3].x)
	point.y = clamp(point.y, self.MAP_VERTICES[3].y, self.MAP_VERTICES[1].y)
	return point
