class_name HotkeyRebindButton
extends Control

@onready var label: Label = $HBoxContainer/Label
@onready var button: Button = $HBoxContainer/Button

@export var action_name: String = "move_left"
static var active_button: HotkeyRebindButton = null

func _ready() -> void:
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()

	load_keybinds()

func load_keybinds() -> void:
	rebind_action_key(SettingsDataContainer.get_keybind(action_name))

func set_action_name() -> void:
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

		button.text = OS.get_keycode_string(action_event.physical_keycode)
	else:
		button.text = "Unassigned"

func _on_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		if active_button and active_button != self:
			active_button._deactivate_button()
		active_button = self
		button.text = "Press any key..."
		set_process_unhandled_key_input(true)
	else:
		if active_button == self:
			active_button = null
		set_process_unhandled_key_input(false)
		set_text_for_key()

func _deactivate_button() -> void:
	if self.button:
		self.button.button_pressed = false
	set_process_unhandled_key_input(false)
	set_text_for_key()

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and not is_key_already_bound(event):
		rebind_action_key(event)
		button.button_pressed = false

func is_key_already_bound(event: InputEventKey) -> bool:
	for action in InputMap.get_actions():
		for action_event in InputMap.action_get_events(action):
			if action_event is InputEventKey and action_event.physical_keycode == event.physical_keycode:
				return true
	return false

func rebind_action_key(event: InputEventKey) -> void:
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)
	SettingsDataContainer.set_keybind(action_name, event)
	set_process_unhandled_key_input(false)
	set_text_for_key()

