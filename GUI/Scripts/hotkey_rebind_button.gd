class_name HotkeyRebindButton
extends Control

@onready var label: Label = $HBoxContainer/Label
@onready var button: Button = $HBoxContainer/Button

@export var action_name : String = "move_left"
var previous_button = null

func _ready() -> void:
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()

func set_action_name() -> void:
	label.text = "Unassigned"
	
	match action_name:
		"move_left":
			label.text = "Move left"
		"move_right":
			label.text = "Move right"
		"move_up":
			label.text = "Move up"
		"move_down":
			label.text = "Move down"
		"player_dash":
			label.text = "Dash"

func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	if action_events.size() > 0:
		var action_event = action_events[0]
		var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
		button.text = "%s" % action_keycode
	else:
		button.text = "Unassigned"

func _on_button_toggled(button_pressed) -> void:
	if button_pressed:
		button.text = "Press any key..."
		set_process_unhandled_key_input(button_pressed)

		if previous_button != null and previous_button != self:
			previous_button.button.toggle_mode = false
			previous_button.set_process_unhandled_key_input(false)

		previous_button = self
	else:
		button.toggle_mode = true
		set_process_unhandled_key_input(false)
		set_text_for_key()

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var already_bound = is_key_already_bound(event)
		if not already_bound:
			rebind_action_key(event)
		button.button_pressed = false

func is_key_already_bound(event: InputEventKey) -> bool:
	for action in InputMap.get_actions():
		var action_events = InputMap.action_get_events(action)
		for action_event in action_events:
			if action_event is InputEventKey and action_event.physical_keycode == event.physical_keycode:
				return true
	return false

func rebind_action_key(event) -> void:
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)

	set_process_unhandled_key_input(false)
	set_text_for_key()
	set_action_name()
