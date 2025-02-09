extends RigidBody2D

@export var min_speed : float = 400
@export var max_speed : float = 600

@export var rotation_speed : float = 2.5

var last_direction

@onready var animated_sprite = $AnimatedSprite2D
@onready var aggro_sound = $AggroSound

var target : Node

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	target = null
	queue_free()
	
	

func on_start_game() -> void :
	queue_free()

func _physics_process(delta: float) -> void:
	if target:
		# Get direction vector to the player (normalized)
		var direction_to_target = (target.position - position).normalized()
		
		# Smoothly adjust the velocity towards the target direction
		linear_velocity = linear_velocity.lerp(direction_to_target * randf_range(min_speed, max_speed), rotation_speed * delta)
	
	else:
		linear_velocity = Vector2(randf_range(min_speed, max_speed), 0)
		linear_velocity = linear_velocity.rotated(last_direction)
	
	
	if abs(linear_velocity.x) > abs(linear_velocity.y):  # Moving sideways
		animated_sprite.play("side")
		animated_sprite.flip_h = linear_velocity.x < 0  # Flip sprite for left movement
	elif linear_velocity.y < 0:  # Moving up
		animated_sprite.play("up")
	else:  # Moving down
		animated_sprite.play("down")


func _on_detection_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		aggro_sound.play()
		target = body


func _on_detection_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		target = null
