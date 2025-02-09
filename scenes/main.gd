extends Node2D

@onready var green_mob_scene : PackedScene = preload("res://scenes/green_mob.tscn")

@onready var score_timer : Timer = $ScoreTimer
@onready var green_mob_timer : Timer = $GreenMobTimer
@onready var start_timer : Timer = $StartTimer
@onready var hud = $UI

@onready var player = $Player
@onready var start_position = $StartPosition

@onready var mob_spawn_location = $MobPath/MobSpawnLocation

var score = 0

func _ready() -> void:
	randomize()


func game_over() -> void:
	green_mob_timer.stop()
	score_timer.stop()
	hud.show_game_over()

func new_game() -> void:
	score = 0
	player.start(start_position.position)
	start_timer.start()
	hud.update_score(score)
	hud.show_message("Get Ready")
	await get_tree().create_timer(1).timeout
	hud.show_message("GO!")


func _on_start_timer_timeout() -> void:
	green_mob_timer.start()
	score_timer.start()


func _on_score_timer_timeout() -> void:
	score += 1
	hud.update_score(score)
	if score == 10:
		green_mob_timer.wait_time = 2
	if score == 20:
		green_mob_timer.wait_time = 1.5
	if score == 30:
		green_mob_timer.wait_time = 0.5


func _on_green_mob_timer_timeout() -> void:
	# Choose a random location on Path2D.
	mob_spawn_location.progress_ratio = randf_range(0, 1)
	# Create a Mob instance and add it to the scene.
	var mob = green_mob_scene.instantiate()
	add_child(mob)
	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position
	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	# Set the velocity (speed & direction).
	mob.linear_velocity = Vector2(randf_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	mob.last_direction = direction
	hud.start_game.connect(mob.on_start_game)


func _on_ui_start_game() -> void:
	new_game()


func _on_player_game_over() -> void:
	game_over()
