extends Control

var master_bus = AudioServer.get_bus_index("Master")
var music
var volume = -80

@onready var asp = $BackgroundMusic
@onready var transition_anim = $TransitionLayer/AnimationPlayer
@onready var fade_rect = $TransitionLayer/ColorRect

func _ready() -> void:
	fade_rect.modulate.a = 0
	fade_rect.visible = false
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE 
	asp.play()

func _on_background_music_finished() -> void:
	AudioServer.set_bus_volume_db(master_bus, volume)
	asp.play()
		
func _on_playbtn_pressed() -> void:
	var play_btn = get_node_or_null("PlayButton") 
	if play_btn:
		play_btn.disabled = true
		play_btn.scale = Vector2(0.9, 0.9) 

	fade_rect.visible = true
	fade_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	
	transition_anim.play("fade_out")
	await transition_anim.animation_finished
	
	get_tree().change_scene_to_file("res://assets/scene/character_selection.tscn")
	
func _on_mutebtn_pressed() -> void:
	var muted = not AudioServer.is_bus_mute(master_bus)
	AudioServer.set_bus_mute(master_bus, muted)
	
	# MOBILE FIX: Visual feedback since there is no 'hover' on phones
	var mute_btn = get_node_or_null("MuteButton")
	if mute_btn:
		mute_btn.modulate = Color(0.5, 0.5, 0.5) if muted else Color(1, 1, 1)
