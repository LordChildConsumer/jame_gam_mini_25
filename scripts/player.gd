extends CharacterBody2D

@export var speed : float = 800
@export var friction : float = 0.04
@export var acceleration : float = 0.05
@export var rotation_speed : float = 2

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

signal game_over
signal gem_collected

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('ui_right'):
		input.x += 1
	if Input.is_action_pressed('ui_left'):
		input.x -= 1
	if Input.is_action_pressed('ui_down'):
		input.y += 1
	if Input.is_action_pressed('ui_up'):
		input.y -= 1
	return input


func _physics_process(_delta):
	#print("player pos:", global_position)
	var direction = get_input()
	
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	
	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):  # Moving sideways
			animated_sprite.play("side")
			animated_sprite.flip_h = velocity.x < 0  # Flip sprite for left movement
		elif velocity.y < 0:  # Moving up
			animated_sprite.play("up")
		else:  # Moving down
			animated_sprite.play("down")
	move_and_slide()


func start(pos):
	position = pos
	show()
	$DeathCollider/CollisionShape2D.disabled = false


func _on_death_collider_body_entered(body: Node2D) -> void:
	if body.is_in_group("mob"):
		hide()
		$DeathCollider/CollisionShape2D.set_deferred("disabled", true)
		game_over.emit()
	


func _on_laugh_timer_timeout() -> void:
	if self.visible:
		$laugh_sfx.play()
	$LaughTimer.wait_time = randf_range(6, 24)
	$LaughTimer.start()


func _on_death_collider_area_entered(area: Area2D) -> void:
	if area.is_in_group("gem"):
		if(area.is_orb):
			$GemCollectedSFX.play()
			gem_collected.emit()
			gem_collected.emit()
		gem_collected.emit()
		$GemCollectedSFX.play()
		area.queue_free()
