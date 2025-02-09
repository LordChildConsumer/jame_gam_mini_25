extends Control


@onready var game_scene : PackedScene = preload("res://scenes/main.tscn")

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("ui_accept"):
		_on_start_button_pressed()
