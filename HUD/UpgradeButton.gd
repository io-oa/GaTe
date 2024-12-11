extends Button

@onready var upgrade_choices: Panel = $"../.."
@onready var HUD: CanvasLayer = $"../../.."
@onready var audio: AudioStreamPlayer = $"../../AudioStreamPlayer"
@onready var upgrade_name_label: Label = $VBoxContainer/Name
@onready var upgrade_description_label: Label = $VBoxContainer/Desc
@onready var icon_texture: TextureRect = $IconContainer/MarginContainer/Icon
static var choices: int = 0

var upgrade_type: String = ""
var upgrade_name: String = ""

func _ready() -> void:
	self.pressed.connect(_on_button_press)	

func _process(delta: float) -> void:
	pass

func _on_button_press():
	if self.upgrade_type == "stat":
		HUD.player.stat_modifiers[upgrade_name] += HUD.resource.upgrades[upgrade_name]["amount"]
		HUD.player.stat_change.emit()
	elif self.upgrade_type == "projectile":
		var projectile_aquired: bool = false
		for i in range(HUD.player.auto_projectiles.projectile_scenes.size()):
			if HUD.player.auto_projectiles.projectile_scenes[i].projectile_name.to_lower() == upgrade_name:
				projectile_aquired = true
				break
		if not projectile_aquired:
			HUD.player.auto_projectiles.projectile_scenes.append(ProjectileSceneWrapper.new(
					HUD.resource.upgrades[upgrade_name]["scene_path"],
					HUD.resource.upgrades[upgrade_name]["cooldown"],
					HUD.resource.upgrades[upgrade_name]["duplicate_x"],
					HUD.resource.upgrades[upgrade_name]["follow_attack_direction"],
					HUD.resource.upgrades[upgrade_name]["spread_around"]
				)
			)
		else:
			print("upgraded")
	upgrade_choices.visible = false
	get_tree().paused = false
	GameGlobals.set_cursor()
	audio.play()

func set_properties(upgrade_name: String):
	self.upgrade_type = HUD.resource.upgrades[upgrade_name]["type"]
	self.upgrade_name = upgrade_name
	var upgrade_amount: String = ""
	if HUD.resource.upgrades[upgrade_name].has("amount"):
		upgrade_amount = " +" + str(HUD.resource.upgrades[upgrade_name]["amount"] * 100)+"%"
	self.upgrade_name_label.text = HUD.resource.upgrades[upgrade_name]["name"] + upgrade_amount
	self.upgrade_description_label.text = HUD.resource.upgrades[upgrade_name]["description"]
	self.icon_texture.texture = HUD.resource.upgrades[upgrade_name]["icon"]
	
