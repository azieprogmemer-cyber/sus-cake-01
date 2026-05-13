extends Node

# Persistent Data
var player_selections: Array = [-1, -1, -1, -1]
var player_scores: Array = [0, 0, 0, 0]

var music_player: AudioStreamPlayer
var click_player: AudioStreamPlayer

func _ready():
	# 1. Setup Music Player
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = "Master"
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS # Keeps playing during pauses
	
	var music_path = "res://assets/audio/Sus Cake Parade.mp3"
	if FileAccess.file_exists(music_path):
		music_player.stream = load(music_path)
		music_player.play()
	
	# 2. Setup Click SFX Player
	click_player = AudioStreamPlayer.new()
	add_child(click_player)
	
	var click_path = "res://assets/audio/click.wav"
	if FileAccess.file_exists(click_path):
		click_player.stream = load(click_path)

	# 3. Automation: Play click sound for EVERY button in the game automatically
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node: Node):
	if node is BaseButton: # This covers Button, TextureButton, etc.
		node.pressed.connect(play_click_sound)

func play_click_sound():
	if click_player and click_player.stream:
		if click_player.playing:
			click_player.stop()
		click_player.play()

func reset_data():
	player_selections = [-1, -1, -1, -1]
	player_scores = [0, 0, 0, 0]

func toggle_mute():
	var master_bus = AudioServer.get_bus_index("Master")
	var is_muted = not AudioServer.is_bus_mute(master_bus)
	AudioServer.set_bus_mute(master_bus, is_muted)
	return is_muted
