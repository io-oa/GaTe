class_name Leaderboard
extends Control

@onready var line_edit: LineEdit = $SubmitContainer/LineEdit
var leaderboardScene = preload("res://GUI/leaderboard.tscn")

signal exit_leaderboard_menu

var score = GameGlobals.score
var player_name = GameGlobals.player_name

	
func _on_line_edit_text_submitted(text: String) -> void:
	player_name= line_edit.text
	GameGlobals.player_name= player_name
	print(player_name)

func _on_score_b_pressed() -> void:
	GameGlobals.score += 50
	score = GameGlobals.score
	print(score)

func _on_submit_b_pressed() -> void:
	await Leaderboards.post_guest_score("godot_gate-main-1OxY", score, player_name)
	_return_to_leaderboard()

func _return_to_leaderboard() -> void:
	$SubmitContainer.hide()
	$LeaderboardUI.show()
	
func _on_to_submit_score_pressed() -> void:
	$SubmitContainer.show()
	$LeaderboardUI.hide()


func _on_exit_pressed() -> void:
	exit_leaderboard_menu.emit()
	set_process(false)
