extends Node2D

@onready var green_mob_scene : PackedScene = preload("res://scenes/green_mob.tscn")
@onready var yellow_mob_scene : PackedScene = preload("res://scenes/yellow_mob.tscn")
@onready var purple_mob_scene : PackedScene = preload("res://scenes/purple_mob.tscn")
@onready var gem_scene : PackedScene = preload("res://scenes/score_sprite.tscn")
@onready var grave_scene : PackedScene = preload("res://scenes/graves.tscn")
@onready var grave_scene_2 : PackedScene = preload("res://scenes/grave_2.tscn")
@onready var grave_scene_3 : PackedScene = preload("res://scenes/grave_3.tscn")

@onready var score_timer : Timer = $ScoreTimer
@onready var green_mob_timer : Timer = $GreenMobTimer
@onready var start_timer : Timer = $StartTimer
@onready var yellow_mob_timer : Timer = $YellowMobTimer
@onready var purple_mob_timer : Timer = $PurpleMobtimer
@onready var gem_spawn_timer : Timer = $GemSpawnTimer
@onready var hud = $UI

@onready var grave = $Graves


@onready var player = $Player
@onready var start_position = $StartPosition

@onready var mob_spawn_location = $MobPath/MobSpawnLocation
var screen_size

var score = 0

func _ready() -> void:
	randomize()
	screen_size = get_viewport_rect().size


func game_over() -> void:
	green_mob_timer.stop()
	yellow_mob_timer.stop()
	purple_mob_timer.stop()
	gem_spawn_timer.stop()
	score_timer.stop()
	hud.show_game_over()
	get_tree().call_group("gem", "queue_free")
	get_tree().call_group("grave", "queue_free")

func new_game() -> void:
	score = 0
	player.start(start_position.position)
	start_timer.start()
	hud.update_score(score)
	hud.show_message("Get Ready")
	await get_tree().create_timer(1).timeout
	hud.show_message("GO!")
	if get_tree().get_nodes_in_group("grave").size() == 0:
		spawn_grave()

func _on_start_timer_timeout() -> void:
	green_mob_timer.wait_time = 3
	yellow_mob_timer.wait_time = 2
	purple_mob_timer.wait_time = 3
	gem_spawn_timer.wait_time = 5
	green_mob_timer.start()
	score_timer.start()
	gem_spawn_timer.start()


func _on_score_timer_timeout() -> void:
	score += 1
	hud.update_score(score)
	if score == 10:
		yellow_mob_timer.start()
		gem_spawn_timer.wait_time = 4
		spawn_grave()
	if score == 20:
		purple_mob_timer.start()
		gem_spawn_timer.wait_time = 3.5
		spawn_grave()
	if score == 30:
		green_mob_timer.wait_time = 2.5
		yellow_mob_timer.wait_time = 2.0
		purple_mob_timer.wait_time = 2.8
		gem_spawn_timer.wait_time = 3
		spawn_grave()
	if score == 40:
		green_mob_timer.wait_time = 1.5
		yellow_mob_timer.wait_time = 2.3
		purple_mob_timer.wait_time = 2.5
		gem_spawn_timer.wait_time = 2
		spawn_grave()
	if score == 60:
		green_mob_timer.wait_time = 1.5
		yellow_mob_timer.wait_time = 1.2
		purple_mob_timer.wait_time = 1.6
		spawn_grave()
		


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


func _on_yellow_mob_timer_timeout() -> void:
	# Choose a random location on Path2D.
	mob_spawn_location.progress_ratio = randf_range(0, 1)
	# Create a Mob instance and add it to the scene.
	var mob = yellow_mob_scene.instantiate()
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
	

func _on_purple_mobtimer_timeout() -> void:
	# Choose a random location on Path2D.
	mob_spawn_location.progress_ratio = randf_range(0, 1)
	# Create a Mob instance and add it to the scene.
	var mob = purple_mob_scene.instantiate()
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


func _on_gem_spawn_timer_timeout() -> void:
	var x = randf_range(-screen_size.x / 2 + 100, screen_size.x / 2 - 100)
	var y = randf_range(-screen_size.y / 2 + 100, screen_size.y / 2 - 100)
	var gem = gem_scene.instantiate()
	add_child(gem)
	gem.get_node("Gem").hide()
	gem.get_node("Orb").hide()
	
	var gem_choice = randi_range(0,3)
	if gem_choice == 3:
		gem.get_node("Orb").show()
		gem.is_orb = true
	else:
		gem.get_node("Gem").show()
		
	
	gem.global_position = Vector2(x,y)
	

func spawn_grave() -> void:
	var x = randf_range(-screen_size.x / 2 + 100, screen_size.x / 2 - 100)
	var y = randf_range(-screen_size.y / 2 + 100, screen_size.y / 2 - 100)
	var grave_choice = randi_range(0, 2)
	var grave
	if grave_choice == 0:
		grave = grave_scene.instantiate()
	elif grave_choice == 1:
		grave = grave_scene_2.instantiate()
	elif grave_choice == 2:
		grave = grave_scene_3.instantiate()
	add_child(grave)
	
	# Duplicate the shader material so it's unique to this grave
	var new_material = grave.get_node("GraveSprite").material.duplicate()
	grave.get_node("GraveSprite").material = new_material
	grave.grave_material = new_material
	
	grave.global_position = Vector2(x,y)
	grave.appear_from_ground()


func _on_ui_start_game() -> void:
	new_game()


func _on_player_game_over() -> void:
	game_over()


func _on_player_gem_collected() -> void:
	_on_score_timer_timeout()
