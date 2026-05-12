extends Control


@export var scene_path: String = "res://assets/scene/player_scene.tscn"


@onready var click_button = $PanelContainer/GridContainer/click_buttton
@onready var start_button = $Startbtn

@onready var buttons = [
	$PanelContainer/GridContainer/Circlebtn,
	$PanelContainer/GridContainer/Squarebtn,
	$PanelContainer/GridContainer/Trianglebtn,
	$PanelContainer/GridContainer/Heartbtn
]

func _ready():
	# Reset Global data via our helper function
	Global.reset_data()
	
	# Setup Buttons
	for i in range(buttons.size()):
		# Pivot offset is required for the "Scale" animation to grow from the center
		buttons[i].pivot_offset = buttons[i].size / 2
		
		# Clear any placeholder text in the "YOU" label
		var label = buttons[i].get_node_or_null("PlayerLabel")
		if label: label.text = ""
		
		# Connect the press signal
		buttons[i].pressed.connect(_on_character_pressed.bind(i))
	
	# Prepare the Start button
	start_button.visible = false
	if not start_button.pressed.is_connected(_on_start_button_pressed):
		start_button.pressed.connect(_on_start_button_pressed)
	
	_update_visuals()

func _on_character_pressed(index: int):
	# Single Player: Only index 0 (Player 1) is used
	Global.player_selections[0] = index
	
	# Update labels: Remove "YOU" from everywhere, then add to the new choice
	for btn in buttons:
		var lbl = btn.get_node_or_null("PlayerLabel")
		if lbl: lbl.text = ""
		
	var label = buttons[index].get_node_or_null("PlayerLabel")
	if label:
		label.text = "YOU"
	
	_play_hover_sound()
	_update_visuals()
	
	# Show the start button now that a choice is made
	start_button.visible = true

func _update_visuals():
	for i in range(buttons.size()):
		# Highlight the button if it matches the current selection
		var is_selected = Global.player_selections[0] == i
		
		if is_selected:
			# Give it the "SUS Cake" purple tint and make it pop
			buttons[i].modulate = Color(0.878, 0.831, 0.965, 1.0)
			buttons[i].scale = Vector2(1.1, 1.1)
		else:
			# Revert others to normal
			buttons[i].modulate = Color.WHITE
			buttons[i].scale = Vector2(1.0, 1.0)

func _on_start_button_pressed():
	_play_hover_sound()
	# Brief pause so the player feels the button click
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://assets/scene/player_scene.tscn")

func _play_hover_sound():
	if click_button:
		click_button.play()
