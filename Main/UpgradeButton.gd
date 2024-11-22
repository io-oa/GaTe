extends Button

@onready var upgrade_choices: Panel = $"../.."
@onready var HUD: CanvasLayer = $"../../.."
@onready var audio: AudioStreamPlayer = $"../../AudioStreamPlayer"
@onready var upgrade_name: Label = $VBoxContainer/Name
@onready var upgrade_description: Label = $VBoxContainer/Desc
static var choices: int = 0

var stat: String = ""

func _ready() -> void:
	self.pressed.connect(_on_button_press)	

func _process(delta: float) -> void:
	pass

func _on_button_press():
	HUD.player.stat_modifiers[stat] += HUD.resource.stat_upgrades[stat]["amount"]
	upgrade_choices.visible = false
	get_tree().paused = false
	audio.play()

func set_properties(upgrade_name: String):
	stat = upgrade_name
	self.upgrade_name.text = HUD.resource.stat_upgrades[upgrade_name]["name"] + " +" + str(HUD.resource.stat_upgrades[upgrade_name]["amount"] * 100)+"%"
	self.upgrade_description.text = HUD.resource.stat_upgrades[upgrade_name]["description"]
	self.icon = HUD.resource.stat_upgrades[upgrade_name]["icon"]
	
