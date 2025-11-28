extends Control

const NEW_GAME = preload("res://StartScreen.tscn")
const UI = preload("res://UI.tscn")
var village_health : float = 100.0

@onready var main_menu : Control = $UI/MainMenu
@onready var menu_button : Button = $UI/VBoxContainer/TopBar/HBoxContainer/MenuButton
@onready var bad_north: Control = $UI/VBoxContainer/BadNorth
@onready var shop: Control = $UI/VBoxContainer/Shop
@onready var dome_keeper: Panel = $UI/VBoxContainer/DomeKeeper

@onready var village_max_health_bar: Panel = $UI/VBoxContainer/TopBar/HBoxContainer/MarginContainer/VBoxContainer/Panel/HBoxContainer/MaxHealthBar
@onready var village_health_bar: Panel = $UI/VBoxContainer/TopBar/HBoxContainer/MarginContainer/VBoxContainer/Panel/HBoxContainer/HealthBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_label: Label = $UI/VBoxContainer/TopBar/HBoxContainer/MarginContainer/VBoxContainer/Panel/HealthLabel

func _ready() -> void:
	animation_player.play("day_to_night")
	if village_health == 100:
		village_max_health_bar.size_flags_stretch_ratio = 0.0
	else:
		village_max_health_bar.size_flags_stretch_ratio = 1.0
		village_health_bar.size_flags_stretch_ratio = village_health

func _on_menu_button_pressed() -> void:
	main_menu.show()

func _on_main_menu_continue_pressed() -> void:
	main_menu.hide()

func _on_main_menu_new_game_pressed() -> void:
	UnitManager.units.clear()
	UnitManager.add_unit(15, 15, 1, 0, 0)
	get_tree().change_scene_to_packed(UI)

func _on_main_menu_quit_pressed() -> void:
	get_tree().quit()

#replace with daynight cycle trigger
func shop_scene() -> void:
	if shop.is_visible_in_tree():
		pass
	shop.show()
	bad_north.hide()
	dome_keeper.hide()

func _on_shop_ready_pressed() -> void:
	shop.hide()
	bad_north.show()
	dome_keeper.hide()
	animation_player.play("night_to_day")

func dome_keeper_scene() -> void:
	shop.hide()
	bad_north.hide()
	dome_keeper.show()

func _on_button_pressed(damage):
	village_health = village_health - damage
	village_max_health_bar.size_flags_stretch_ratio = 100.0 - village_health
	village_health_bar.size_flags_stretch_ratio = village_health
	health_label.text = "%d/100" % int(village_health)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "day_to_night":
		shop_scene()
	if anim_name == "night_to_day":
		dome_keeper_scene()
		animation_player.play("day_to_night")
