extends Button

@onready var upgrade_choices: Panel = $"../.."
@onready var HUD: CanvasLayer = $"../../.."
@onready var audio: AudioStreamPlayer = $"../AudioStreamPlayer"
static var choices: int = 0

func _ready() -> void:
	self.pressed.connect(_on_button_press)	

func _process(delta: float) -> void:
	pass

func _on_button_press():
	upgrade_choices.visible = false
	get_tree().paused = false
	audio.play()
