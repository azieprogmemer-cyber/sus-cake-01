extends Node2D
 
@export var player_scene: PackedScene
@onready var cake_node = $cake
@onready var round_timer: Timer = $Timer    
 
@onready var center_point = Vector2(540, 960) 
 
var corner_positions = [
	Vector2(150, 150),          # Top Left (P1)
	Vector2(930, 150),          # Top Right (P2)
	Vector2(150, 1770),         # Bottom Left (P3)
	Vector2(930, 1770)          # Bottom Right (P4)
]
 
func _ready():
	spawn_players()
	start_round_timer(5.0)
 
func spawn_players():
	# Safety check: If the scene is missing, don't try to spawn it
	if player_scene == null:
		print("CRITICAL ERROR: Player Scene not assigned in Inspector!")
		return

	for i in range(4):
		if Global.player_selections[i] != -1:
			var p = player_scene.instantiate()
			p.player_id = i
			p.add_to_group("players") 
			p.character_type = Global.player_selections[i]
			p.position = corner_positions[i]
			add_child(p)
 
func start_round_timer(time: float):
	# By adding the Type Hint above, this line no longer causes a warning
	if round_timer:
		round_timer.wait_time = time
		round_timer.one_shot = true
		if not round_timer.timeout.is_connected(_on_timer_timeout):
			round_timer.timeout.connect(_on_timer_timeout)
		round_timer.start()
 
func _on_timer_timeout():
	var is_bomb = randf() > 0.5
	if is_bomb:
		if cake_node and cake_node.has_method("play_explosion"):
			cake_node.play_explosion()
		check_blast_radius()
	else:
		if cake_node and cake_node.has_method("play_cake_reveal"):
			cake_node.play_cake_reveal()
		print("It's a cake! Everyone wins!")
 
func check_blast_radius():
	var blast_distance = 450.0 
	var players = get_tree().get_nodes_in_group("players")
	
	for p in players:
		# Safety check to ensure the node has global_position
		if p is Node2D:
			var dist = p.global_position.distance_to(center_point)
			if dist < blast_distance:
				print("Player ", p.get("player_id"), " was too close!")
				if p.has_method("die"):
					p.die() 
				else:
					p.queue_free()
