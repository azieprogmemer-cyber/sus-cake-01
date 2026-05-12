extends Control

var master_bus = AudioServer.get_bus_index("Master")

@onready var transition_anim = $TransitionLayer/AnimationPlayer
@onready var fade_rect = $TransitionLayer/ColorRect

func _ready() -> void:
	fade_rect.modulate.a = 0
	fade_rect.visible = false
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE 
	
	# Check current mute status to update button look on start
	_update_mute_button_visuals()

func _on_playbtn_pressed() -> void:
	# Disable the button to prevent double-clicks
	var play_btn = $Playbtn # Ensure this matches your node name
	play_btn.disabled = true
	
	fade_rect.visible = true
	fade_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	
	transition_anim.play("fade_out")
	await transition_anim.animation_finished
	
	get_tree().change_scene_to_file("res://assets/scene/character_selection.tscn")
	
func _on_mutebtn_pressed() -> void:
	# Use the global function so the state is saved
	Global.toggle_mute()
	_update_mute_button_visuals()

func _update_mute_button_visuals():
	var muted = AudioServer.is_bus_mute(master_bus)
	var mute_btn = $Mutebtn # Ensure this matches your node name
	if mute_btn:
		mute_btn.modulate = Color(0.5, 0.5, 0.5) if muted else Color(1, 1, 1)
