extends Control

# References from IMG_20260513_074526.jpg
@onready var back_button = $backbutton
@onready var exit_button = $"press exit"


@onready var exit_panel = $exitPanel
@onready var answer_input = $exitPanel/LineEdit
@onready var confirm_exit_button = $exitPanel/confirmexitbutton

func _ready() -> void:
	# 1. Hide the exit panel initially
	exit_panel.visible = false
	
	# 2. Connect the "Troll" back button
	if back_button is BaseButton:
		back_button.pressed.connect(_on_back_pressed)
	
	# 3. Connect the initial Exit button to SHOW the panel
	if exit_button is BaseButton:
		exit_button.pressed.connect(_on_show_exit_panel)
		
	# 4. Connect the Confirm button inside the panel
	confirm_exit_button.pressed.connect(_on_check_answer)

func _on_back_pressed() -> void:
	# Keep the troll movement logic
	var screen_size = get_viewport_rect().size
	var button_size = back_button.size
	var random_x = randf_range(0, screen_size.x - button_size.x)
	var random_y = randf_range(0, screen_size.y - button_size.y)
	
	back_button.position = Vector2(random_x, random_y)

func _on_show_exit_panel() -> void:
	# Instead of quitting, show the math quiz
	exit_panel.visible = true
	# Optional: Disable the troll button while the panel is open
	back_button.disabled = true

func _on_check_answer() -> void:
	# The correct answer is 2 (One cake + One cake)
	var player_input = answer_input.text
	
	if player_input == "2":
		# Correct! Now let them leave
		await get_tree().create_timer(0.1).timeout
		get_tree().quit()
	else:
		# Wrong! Hide the panel and make them try again
		exit_panel.visible = false
		back_button.disabled = false
		answer_input.text = "" # Clear the wrong answer
		
		# Optional prank: Move the exit button to a random spot too!
		_randomize_exit_button()

func _randomize_exit_button() -> void:
	var screen_size = get_viewport_rect().size
	exit_button.position = Vector2(
		randf_range(0, screen_size.x - exit_button.size.x),
		randf_range(0, screen_size.y - exit_button.size.y)
	)
