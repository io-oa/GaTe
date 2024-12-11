class_name WavesResource extends Resource

var max_waves_spawned: int = 1
var spawn_interval: float = 5.0

var waves = {
	"water_elementals": {
		"enemy": preload("res://Enemy/Enemies/WaterElemental/WaterElemental.tscn"),
		"time_available": 0.0,
		"mob_count": 5,
		"available": false
	},
	"air_elementals": {
		"enemy": preload("res://Enemy/Enemies/AirElemental/AirElemental.tscn"),
		"time_available": 10.0,
		"mob_count": 5,
		"available": false
	},
	"fire_elementals": {
		"enemy": preload("res://Enemy/Enemies/FireElemental/FireElemental.tscn"),
		"time_available": 20.0,
		"mob_count": 5,
		"available": false
	},
	"earth_elementals": {
		"enemy": preload("res://Enemy/Enemies/EarthElemental/EarthElemental.tscn"),
		"time_available": 30.0,
		"mob_count": 5,
		"available": false
	}
}

var bosses = {
	"alien": {
		"enemy": preload("res://Enemy/Enemies/Bosses/Alien/Alien.tscn")
	}
}
