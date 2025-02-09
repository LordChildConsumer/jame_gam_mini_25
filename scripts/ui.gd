extends CanvasLayer

@onready var message_label = $MessageLabel
@onready var score_label = $ScoreLabel
@onready var message_timer = $MessageTimer
@onready var start_button = $RetryButton
@onready var high_score_interface = $HighScore
@onready var line_edit = $HighScore/LineEdit
@onready var highscore_label = $HighScore/HighScoreLabel
@onready var enter_highscore = $HighScore/EnterHighScoreLabel

var highscores = [
	{"name": "pol", "score": 60},
	{"name": "kay", "score": 49},
	{"name": "tor", "score": 20},
	{"name": "sam", "score": 14},
	{"name": "har", "score": 12}
]

signal start_game
var last_run_score = 0
var player_index = -1  # To track the player's position in the leaderboard

func show_message(text) -> void:
	message_label.text = text
	message_label.show()
	message_timer.start()


func _on_message_timer_timeout() -> void:
	message_label.hide()

func update_score(score):
	score_label.text = str(score)
	last_run_score = score

func show_game_over():
	show_message("Game Over")
	await message_timer.timeout
	show_highscore_input()


func show_retry():
	high_score_interface.show()
	$EnterToStartLabel.show()


func show_highscore_input():
	check_and_update_leaderboard()
	high_score_interface.show()
	


func check_and_update_leaderboard():
	# Add new score with an empty name if it qualifies
	highscores.append({"name": "", "score": last_run_score})

	# Sort in descending order
	highscores.sort_custom(func(a, b): return a["score"] > b["score"])

	# Trim to top 5
	if highscores.size() > 5:
		highscores.pop_back()

	# Find the new score's index
	player_index = highscores.find({"name": "", "score": last_run_score})

	# Update UI
	update_leaderboard()

	# If the player's score made it to the top 5, show the name input field
	if player_index != -1:
		line_edit.show()
		line_edit.grab_focus()
		enter_highscore.show()
	else:
		_on_line_edit_text_submitted("")


func update_leaderboard():
	var display_text = ""

	for entry in highscores:
		var name_display = entry["name"] if entry["name"] != "" else "..."  # Placeholder for missing name
		display_text += name_display + " : " + str(entry["score"]) + "\n"

	highscore_label.text = display_text


func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("ui_accept") && $EnterToStartLabel.visible:
		_on_retry_button_pressed()


func _on_retry_button_pressed() -> void:
	start_button.hide()
	$EnterToStartLabel.hide()
	high_score_interface.hide()
	start_game.emit()


func _on_line_edit_text_changed(new_text: String) -> void:
	if player_index != -1:
		highscores[player_index]["name"] = new_text
		update_leaderboard()


func _on_line_edit_text_submitted(_new_text: String) -> void:
	line_edit.hide()  # Hide input field
	enter_highscore.hide()
	show_retry()  # Call retry function
