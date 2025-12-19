extends Control

@onready var unit_buttons: VBoxContainer = $PanelContainer/Panel/PanelContainer/ScrollContainer/VBoxContainer/UnitButtons
@onready var add_unit_button: Button = $PanelContainer/Panel/PanelContainer/ScrollContainer/VBoxContainer/AddUnit

var unit = 0
var unit_cost = 10

signal unit_created
signal unit_updated

@onready var damage_buttons: Array[Button] = [
	$PanelContainer/Panel/ScrollContainer/MarginContainer/HBoxContainer/MarginContainer/Damage/Damage0,
	$PanelContainer/Panel/ScrollContainer/MarginContainer/HBoxContainer/MarginContainer/Damage/Damage1,
	$PanelContainer/Panel/ScrollContainer/MarginContainer/HBoxContainer/MarginContainer/Damage/Damage2,
	$PanelContainer/Panel/ScrollContainer/MarginContainer/HBoxContainer/MarginContainer/Damage/Damage3
]

@onready var health_buttons: Array[Button] = [
	$PanelContainer/Panel/ScrollContainer/MarginContainer/HBoxContainer/MarginContainer2/Health/Health0,
	$PanelContainer/Panel/ScrollContainer/MarginContainer/HBoxContainer/MarginContainer2/Health/Health1,
	$PanelContainer/Panel/ScrollContainer/MarginContainer/HBoxContainer/MarginContainer2/Health/Health2
]

@onready var hp_buttons: Array[Button] = [
	$PanelContainer/Panel/ScrollContainer/MarginContainer/HBoxContainer/MarginContainer3/HP/HP0
]


const UI_THEME = preload("res://Assets/Resources/UITheme.tres")
const ILLUSTRATION = preload("res://Assets/Sprites/Illustration.png")

func _ready() -> void:
	create_unit_buttons(UnitManager.units)
	show_bought_upgrades(unit)



func create_unit_buttons(units: Array[Unit]):
	for child in unit_buttons.get_children():
		child.free()
		
	for i in units.size():
		var unit = units[i]
		var button := Button.new()
		
		button.name = "ButtonUnit" + str(i)
		button.text = "Unit %d\nHP: %d/%d\nDMG: %d" % [i + 1, unit.health, unit.max_health, unit.damage]
		button.icon_alignment = 1
		button.expand_icon = true
		button.toggle_mode = true
		button.action_mode = 0
		button.clip_contents = true
		button.custom_minimum_size.x = 100
		button.custom_minimum_size.y = 100
		button.size_flags_horizontal = 1
		button.theme = UI_THEME
		
		unit_buttons.add_child(button)
		
		button.pressed.connect(func(): _on_unit_button_pressed(i))
		toggle_only(i)
		show_bought_upgrades(i)


func _on_add_unit_button_pressed() -> void:
	if GameManager.gold >= unit_cost:
		GameManager.gain_gold(-unit_cost)
		unit_cost = int(ceil(unit_cost * 1.2))
		add_unit_button.text = "Add Unit\n%d Gold" % unit_cost

		var health = randi() % 6 + 10
		UnitManager.add_unit(health - randi() % 6, health, randi() % 2 + 1, 0, 0)
		create_unit_buttons(UnitManager.units)
		unit = UnitManager.units.size() - 1
		emit_signal("unit_created")
	pass


func _on_unit_button_pressed(index: int):
	unit = index
	toggle_only(index)
	show_bought_upgrades(index)

func toggle_only(index: int):
	for i in unit_buttons.get_child_count():
		var button = unit_buttons.get_child(i)
		button.button_pressed = (i == index)

func show_bought_upgrades(index : int):
	var health_up = UnitManager.units[index].health_up
	for i in health_buttons.size():
		health_buttons[i].disabled = (i != health_up)
	var damage_up = UnitManager.units[index].damage_up
	for i in damage_buttons.size():
		damage_buttons[i].disabled = (i != damage_up)

func update_unit_button_text():
	unit_buttons.get_child(unit).text = "Unit %d\nHP: %d/%d\nDMG: %d" % [unit + 1, UnitManager.units[unit].health, UnitManager.units[unit].max_health, UnitManager.units[unit].damage]

func _on_upgrade_pressed(health_up, health, damage_up, damage, cost) -> void:
	if GameManager.iron >= cost:
		GameManager.gain_iron(-cost)
		UnitManager.units[unit].upgrade_unit(health_up, health, damage_up, damage)
		show_bought_upgrades(unit)
		update_unit_button_text()
		emit_signal("unit_updated")
	pass

func _on_hp_0_pressed(cost) -> void:
	if (GameManager.gold >= cost) && (UnitManager.units[unit].health < UnitManager.units[unit].max_health):
		UnitManager.units[unit].heal_unit(5)
		GameManager.gain_gold(-cost)
		update_unit_button_text()
		emit_signal("unit_updated")
	pass
