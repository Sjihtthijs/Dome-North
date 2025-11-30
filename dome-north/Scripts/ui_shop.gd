extends Control

signal ready_pressed
signal unit_created
signal unit_updated

@onready var village_shop : Control = $Shop/HBoxContainer/VillageShop
@onready var unit_shop : Control = $Shop/HBoxContainer/UnitShop
@onready var mine_shop : Control = $Shop/HBoxContainer/MineShop
@onready var confirmation: Control = $Confirmation

func _on_village_pressed() -> void:
	village_shop.show()
	unit_shop.hide()
	mine_shop.hide()

func _on_units_pressed() -> void:
	village_shop.hide()
	unit_shop.show()
	mine_shop.hide()

func _on_mine_pressed() -> void:
	village_shop.hide()
	unit_shop.hide()
	mine_shop.show()

func _on_ready_pressed() -> void:
	confirmation.show()
	
func _on_go_back_pressed() -> void:
	confirmation.hide()

func _on_i_am_ready_pressed() -> void:
	confirmation.hide()
	emit_signal("ready_pressed")

func _on_unit_shop_unit_created() -> void:
	emit_signal("unit_created")

func _on_unit_shop_unit_updated() -> void:
	emit_signal("unit_updated")
