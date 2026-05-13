extends Control

@export var scene_path: String = "res://assets/scene/player_scene.tscn"

# Use get_node_or_null to prevent crashing if the name is wrong
@onready var start_button = get_node_or_null("Startbtn")

# We define these inside _ready to make sure the scene tree is actually loaded
var buttons: Array = []

func _ready():
	# 1. Reset data through the REAL Autoload (Global.gd)
	if Global.has_method("reset_data"):
		Global.reset_data()
	
	# 2. Assign buttons manually to ensure they exist
	buttons = [
		get_node_or_null("PanelContainer/GridContainer/Circlebtn"),
		get_node_or_null("PanelContainer/GridContainer/Squarebtn"),
		get_node_or_null("PanelContainer/GridContainer/Trianglebtn"),
		get_node_or_null("PanelContainer/GridContainer/Heartbtn")
	]
	
	# 3. Setup Buttons
	for i in range(buttons.size()):
		var btn = buttons[i]
		if btn: # Only run logic if the button was actually found
			btn.pivot_offset = btn.size / 2
			var label = btn.get_node_or_null("PlayerLabel")
			if label: label.text = ""
			
			if not btn.pressed.is_connected(_on_character_pressed):
				btn.pressed.connect(_on_character_pressed.bind(i))
	
	# 4. Setup Start Button
	if start_button:
		start_button.visible = false
		if not start_button.pressed.is_connected(_on_start_button_pressed):
			start_button.pressed.connect(_on_start_button_pressed)
	
	_update_visuals()

func _on_character_pressed(index: int):
	Global.player_selections[0] = index
	
	for btn in buttons:
		if btn:
			var lbl = btn.get_node_or_null("PlayerLabel")
			if lbl: lbl.text = ""
		
	if buttons[index]:
		var selected_label = buttons[index].get_node_or_null("PlayerLabel")
		if selected_label:
			selected_label.text = "YOU"
	
	_update_visuals()
	if start_button:
		start_button.visible = true

func _update_visuals():
	for i in range(buttons.size()):
		if buttons[i]:
			var is_selected = Global.player_selections[0] == i
			if is_selected:
				buttons[i].modulate = Color(0.878, 0.831, 0.965, 1.0)
				buttons[i].scale = Vector2(1.1, 1.1)
			else:
				buttons[i].modulate = Color.WHITE
				buttons[i].scale = Vector2(1.0, 1.0)

func _on_start_button_pressed():
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file(scene_path)
