extends StaticBody2D

@onready var grave_material = $GraveSprite.material # Make sure your sprite has the ShaderMaterial
@onready var grave_sprite = $GraveSprite
@onready var dirt_particles = $DirtParticles2D
@onready var shovel_sound = $shovel_sound

func _ready():
	if grave_material is ShaderMaterial:
		grave_material.set_shader_parameter("progress", 0.0)  # Start hidden
	if dirt_particles:
		dirt_particles.emitting = false  # Start with no particles
	

func appear_from_ground():
	if grave_material is ShaderMaterial:
		shovel_sound.play()
		var tween = create_tween()
		tween.tween_method(update_shader_progress, 0.0, 1.0, 10)  # 1.5s duration

		# Trigger the dirt particle effect at the start of the animation
		dirt_particles.emitting = true
		var dirt_tween = create_tween()
		dirt_tween.tween_property(dirt_particles, "emitting", false, 6)  # Stop emitting after 1.5s
		var dirt_position_tween = create_tween()
		dirt_position_tween.tween_property(dirt_particles, "position", Vector2(dirt_particles.position.x, 40), 6)
	else:
		print("Error: ShaderMaterial not found on sprite!")

func update_shader_progress(value: float):
	if grave_material and grave_material is ShaderMaterial:
		grave_material.set_shader_parameter("progress", value)
	else:
		print("ERROR: ShaderMaterial not found on grave!")
