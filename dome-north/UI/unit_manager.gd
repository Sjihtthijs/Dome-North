extends Node

var units: Array[Unit] = []

func _ready() -> void:
	var health = randi() % 6 + 10
	add_unit(health, health, randi() % 2 + 1, 0, 0)

func add_unit(health: int, max_health : int, damage: int, health_up : int, damage_up : int):
	var new_unit = Unit.new(health, max_health, damage, health_up, damage_up)
	units.append(new_unit)
