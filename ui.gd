extends CanvasLayer

@onready var message_label = $MessageLabel
@onready var score_label = $ScoreLabel
@onready var message_timer = $MessageTimer
@onready var start_button = $RetryButton

signal start_game

func show_message(text) -> void:
	message_label.text = text
	message_label.show()
	message_timer.start()


func _on_message_timer_timeout() -> void:
	message_label.hide()

func update_score(score):
	score_label.text = str(score)

func show_game_over():
	show_message("Game Over")
	await message_timer.timeout
	message_label.text = "try again?"
	message_label.show()
	await get_tree().create_timer(1).timeout
	start_button.show()
	$EnterToStartLabel.show()

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("ui_accept") && start_button.visible:
		_on_retry_button_pressed()

func _on_retry_button_pressed() -> void:
	start_button.hide()
	$EnterToStartLabel.hide()
	start_game.emit()
