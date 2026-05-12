extends Node

var player_selections: Array = [-1, -1, -1, -1]
var player_scores: Array = [0, 0, 0, 0]

var music_player: AudioStreamPlayer

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	

	var music_path = "res://assets/audio/Sus Cake Parade.mp3"
	
	if FileAccess.file_exists(music_path):
		music_player.stream = load(music_path)
		music_player.bus = "Master"
		music_player.play()
	else:
		
		push_warning("Music file not found at: " + music_path)

func reset_data():
	player_selections = [-1, -1, -1, -1]
	player_scores = [0, 0, 0, 0]

func toggle_mute():
	var master_bus = AudioServer.get_bus_index("Master")
	var is_muted = not AudioServer.is_bus_mute(master_bus)
	AudioServer.set_bus_mute(master_bus, is_muted)
	return is_muted
