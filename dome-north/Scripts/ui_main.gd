extends Control

var village_health : float = 100.0
signal shop_ready
signal animation_ready
signal all_hostile_units_defeated

@onready var main_menu : Control = $UI/MainMenu
@onready var menu_button : Button = $UI/VBoxContainer/TopBar/HBoxContainer/MenuButton
@onready var bad_north: Control = $UI/VBoxContainer/BadNorth
@onready var shop: Control = $UI/VBoxContainer/Shop
@onready var dome_keeper: Panel = $UI/VBoxContainer/DomeKeeper
@onready var item_list: ItemList = $UI/VBoxContainer/TopBar/HBoxContainer/CenterContainer/ItemList

@onready var village_max_health_bar: Panel = $UI/VBoxContainer/TopBar/HBoxContainer/MarginContainer/VBoxContainer/Panel/HBoxContainer/MaxHealthBar
@onready var village_health_bar: Panel = $UI/VBoxContainer/TopBar/HBoxContainer/MarginContainer/VBoxContainer/Panel/HBoxContainer/HealthBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_label: Label = $UI/VBoxContainer/TopBar/HBoxContainer/MarginContainer/VBoxContainer/Panel/HealthLabel

func _ready() -> void:
	set_village_health_bar(village_health)
	GameManager.gained_gold.connect(update_items)
	GameManager.gained_iron.connect(update_items)
	update_items()

func update_items(_amount = null):
	item_list.set_item_text(0, str(GameManager.gold))
	item_list.set_item_text(1, str(GameManager.iron))

func set_village_health_bar(village_health):
	village_max_health_bar.size_flags_stretch_ratio = 100.0 - village_health
	village_health_bar.size_flags_stretch_ratio = village_health

func _on_menu_button_pressed() -> void:
	main_menu.show()
	get_tree().paused = true

func _on_main_menu_continue_pressed() -> void:
	main_menu.hide()

func _on_main_menu_new_game_pressed() -> void:
	UnitManager.units.clear()
	UnitManager.add_unit(15, 15, 1, 0, 0)
	GameManager.gold = 10
	GameManager.iron = 10
	get_tree().reload_current_scene()

func _on_main_menu_quit_pressed() -> void:
	get_tree().quit()

func shop_scene() -> void:
	shop.show()
	bad_north.hide()
	dome_keeper.hide()
	
func bad_north_scene() -> void:
	shop.hide()
	bad_north.show()
	dome_keeper.hide()

func dome_keeper_scene() -> void:
	shop.hide()
	bad_north.hide()
	dome_keeper.show()

func _on_shop_ready_pressed() -> void:
	emit_signal("shop_ready")

func _on_village_damage(damage):
	village_health = village_health - damage
	health_label.text = "%d/100" % int(village_health)
	set_village_health_bar(village_health)


func _all_hostile_units_defeated() -> void:
	emit_signal("all_hostile_units_defeated")
