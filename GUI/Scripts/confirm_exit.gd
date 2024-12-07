class_name ConfirmExit
extends Control

signal confirmed(is_conf: bool)

@onready var button_exit: Button = %ButtonExit
@onready var button_cancel: Button = %ButtonCancel

func _ready() -> void:
	button_cancel.pressed.connect(_on_button_cancel_pressed)
	button_exit.pressed.connect(_on_button_exit_pressed)

func _on_button_exit_pressed() -> void:
	confirmed.emit(true)

func _on_button_cancel_pressed() -> void:
	confirmed.emit(false)
	
func prompt() -> bool:
	var is_confirmed = await confirmed
	return is_confirmed
	
#Instrukcja:
#0. Dla scen, w których jest:
#	exit_button.button_down.connect(on_exit_pressed)
#1. Dodaj tę scenę jako instancję sceny roboczej
#2. Ustaw tę scenę jako domyślnie niewidoczną
#3. Dodaj w skrypcie sceny roboczej deklarację:
#	@onready var confirm_exit: ConfirmExit = $ConfirmExit
#4. Dodaj w skrypcie sceny roboczej funkcję:
#	func on_exit_pressed() -> void:
#		confirm_exit.visible = true
#		var is_confirmed = await confirm_exit.prompt()
#		if is_confirmed:
#!!			wyjscie() # odpowiedni kod, np. przejście do innej sceny
#		else:
#			confirm_exit.visible = false
