extends Control

var music_bus = AudioServer.get_bus_index("Music")
var volume = -10
@onready var asp =  $AudioStreamPlayer

func _ready() -> void:
	asp.play()
	
func _on_audio_stream_player_finished() -> void:
	AudioServer.set_bus_volume_db(0,volume)
	asp.play()

func _on_playbtn_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scene/gameplay.tscn")
	
func _on_mutebtn_pressed() -> void:
	AudioServer.set_bus_mute(music_bus, not AudioServer.is_bus_mute(music_bus))
