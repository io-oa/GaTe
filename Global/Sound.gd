extends Node

var tracks: Dictionary = {
	"MENU_MUSIC": preload("res://Main/Music/Main_Menu_Music.mp3"),
	"BOSS_MUSIC": preload("res://Main/Music/boss.wav"),
	"BACKGROUND_MUSIC": preload("res://Main/Music/background.wav")
}

var music_player: AudioStreamPlayer

func _ready():
	music_player = AudioStreamPlayer.new()
	self.add_child(music_player)
	music_player.bus = "Music"
	for stream_name in tracks:
		if tracks[stream_name] is AudioStreamWAV:
			tracks[stream_name].loop_mode = AudioStreamWAV.LOOP_FORWARD
		elif tracks[stream_name] is AudioStreamMP3: 
			tracks[stream_name].loop = true
			
func play(stream_name: String):
	music_player.stream = tracks[stream_name]
	music_player.play()
