class_name MainMenu
extends Control

@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button
@onready var leaderboard_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Leaderboard_Button
@onready var settings_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Settings_Button 
@onready var credits_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Credits_Button 
@onready var exit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button 
@onready var margin_container: MarginContainer = $MarginContainer
@onready var settings_menu: SettingsMenu = $Settings_Menu
@onready var leaderboard: Node2D = $Leaderboard
@onready var credits: Credits = $Credits
@onready var line_edit: LineEdit = $MarginContainer/NicknameContainer/VBoxContainer/LineEdit
@onready var texture_rect: TextureRect = $TextureRect/TextureRect2
@onready var label: VBoxContainer = $VBoxContainer
@onready var save_confirmation_dialog: AcceptDialog = $MarginContainer/SaveConfirmationDialog
@export var start_level = preload("res://Main/Main.tscn")
const PLAYER_NAME_FILE = "user://player_name.save"
var player_name = ""


func _ready() -> void:
	Sound.play("MENU_MUSIC")
	handle_connecting_signals()
	load_player_name()

func handle_connecting_signals() -> void:
	line_edit.text_submitted.connect(_on_name_text_submitted)
	start_button.button_down.connect(on_start_pressed)
	leaderboard_button.button_down.connect(on_leaderboard_pressed)
	settings_button.button_down.connect(on_settings_pressed)
	credits_button.button_down.connect(on_credits_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	settings_menu.exit_settings_menu.connect(on_exit_settings)
	leaderboard.exit_leaderboard_menu.connect(on_exit_leaderboard)
	credits.exit_credits_menu.connect(on_exit_credits)

func on_start_pressed() -> void:
	Scenes.switch_to(Scenes.GAME)
	
func _on_name_text_submitted(text: String) -> void:
	player_name = text
	GameGlobals.player_name = player_name
	save_player_name()
	print("New player name:", player_name)
	
	save_confirmation_dialog.popup_centered()

func on_leaderboard_pressed() -> void:
	label.visible = false
	texture_rect.visible = false
	margin_container.visible = false
	leaderboard.visible = true

func on_exit_leaderboard() -> void:
	label.visible = true
	texture_rect.visible = true
	margin_container.visible = true
	leaderboard.visible = false

func on_settings_pressed() -> void:
	label.visible = false
	texture_rect.visible = false
	margin_container.visible = false
	settings_menu.visible = true

func on_exit_settings() -> void:
	label.visible = true
	texture_rect.visible = true
	margin_container.visible = true
	settings_menu.visible = false
	
func on_credits_pressed() -> void:
	label.visible = false
	texture_rect.visible = false
	margin_container.visible = false
	credits.visible = true

func on_exit_credits() -> void:
	label.visible = true
	texture_rect.visible = true
	margin_container.visible = true
	credits.visible = false

func load_player_name() -> void:
	if FileAccess.file_exists(PLAYER_NAME_FILE):
		var file = FileAccess.open(PLAYER_NAME_FILE, FileAccess.READ)
		player_name = file.get_line().strip_edges()
		GameGlobals.player_name = player_name
		line_edit.text = player_name
		file.close()
	else:
		player_name = "Player1"
		GameGlobals.player_name = player_name
		line_edit.text = player_name

func save_player_name() -> void:
	var file = FileAccess.open(PLAYER_NAME_FILE, FileAccess.WRITE)
	file.store_line(player_name)
	file.close()


func on_exit_pressed() -> void:
	OS.kill(OS.get_process_id())
