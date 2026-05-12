extends Control


@export var scene_path: String = "res://assets/scene/gameplay.tscn"


@onready var click_button = $PanelContainer/GridContainer/click_buttton
@onready var start_button = $Startbtn

@onready var buttons = [
	$PanelContainer/GridContainer/Circlebtn,
	$PanelContainer/GridContainer/Squarebtn,
	$PanelContainer/GridContainer/Trianglebtn,
	$PanelContainer/GridContainer/Heartbtn
]


var current_player_count = 0 

func _ready():
	Global.player_selections = [-1, -1, -1, -1]
	
	
	for i in range(buttons.size()):
		buttons[i].pivot_offset = buttons[i].size / 2
		var label = buttons[i].get_node_or_null("PlayerLabel")
		if label: label.text = ""
		
		buttons[i].pressed.connect(_on_character_pressed.bind(i))
	

	start_button.visible = false
	start_button.pressed.connect(_on_start_button_pressed)
	
	_update_visuals()

func _on_character_pressed(index: int):
	if Global.player_selections.has(index):
		return
		
	if current_player_count < 4:
		Global.player_selections[current_player_count] = index
		
		var label = buttons[index].get_node_or_null("PlayerLabel")
		if label:
			label.text = "P" + str(current_player_count + 1)
		
		current_player_count += 1
		
		_play_hover_sound()
		_update_visuals()
		
		if current_player_count >= 1:
			start_button.visible = true

func _update_visuals():
	for i in range(buttons.size()):
		var player_who_chose_this = Global.player_selections.find(i)
		var is_locked = player_who_chose_this != -1
		
		if is_locked:
			
			buttons[i].modulate = Color(0.878, 0.831, 0.965, 1.0)
			buttons[i].scale = Vector2(0.9, 0.9)
			buttons[i].disabled = true
		else:
			buttons[i].modulate = Color.WHITE
			buttons[i].scale = Vector2(1.0, 1.0)
			buttons[i].disabled = false

func _on_start_button_pressed():

	_play_hover_sound()

	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file(scene_path)

func _play_hover_sound():
	if click_button:
		click_button.play()
