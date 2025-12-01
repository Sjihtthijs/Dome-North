extends Control

@onready var unit_buttons: HBoxContainer = $VBoxContainer/UnitBar/ScrollContainer/UnitButtons

var unit = 0

const UI_THEME = preload("res://UI/Resources/UITheme.tres")
var UnitManager = preload("res://UI/unit_manager.gd").new()
func _on_shop_unit_created() -> void:
	create_unit_buttons(UnitManager.units)

func create_unit_buttons(units: Array[Unit]):
	for child in unit_buttons.get_children():
		child.free()
		
	for i in units.size():
		var unit = units[i]
		var button := Button.new()
		
		button.name = "ButtonUnit" + str(i)
		button.text = "Unit %d 
		HP: %d/%d
		DMG: %d" % [i + 1, unit.health, unit.max_health, unit.damage]
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
		
func update_unit_button_text():
	for unit in unit_buttons.get_child_count():
		unit_buttons.get_child(unit).text = "Unit %d\nHP: %d/%d\nDMG: %d" % [unit + 1, UnitManager.units[unit].health, UnitManager.units[unit].max_health, UnitManager.units[unit].damage]

func _on_unit_button_pressed(index: int):
	unit = index
	toggle_only(index)

func toggle_only(index: int):
	for i in unit_buttons.get_child_count():
		var button = unit_buttons.get_child(i)
		button.button_pressed = (i == index)

func _on_shop_unit_updated() -> void:
	update_unit_button_text()
