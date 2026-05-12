extends Node2D

@export var player_scene: PackedScene
@onready var cake_node = $CenterObject # The Cake/Bomb in the middle

var corner_positions = [
	Vector2(150, 150),          # Top Left (P1)
	Vector2(930, 150),          # Top Right (P2)
	Vector2(150, 1770),         # Bottom Left (P3)
	Vector2(930, 1770)          # Bottom Right (P4)
]

func _ready():
	spawn_players()
	start_round_timer()

func spawn_players():
	for i in range(4):
		if Global.player_selections[i] != -1:
			var p = player_scene.instantiate()
			p.player_id = i
			p.character_type = Global.player_selections[i]
			p.position = corner_positions[i]
			add_child(p)

func _on_timer_timeout():
	# The SUS Reveal logic
	var is_bomb = randf() > 0.5
	if is_bomb:
		cake_node.play_explosion()
		check_blast_radius()
	else:
		cake_node.play_cake_reveal()
		print("It's a cake! Everyone wins!")
