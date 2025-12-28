extends Control

var speed_cost = 10
var mining_strength_cost = 10

var speed_upgrade = 20
var mining_strength_upgrade = 1

@onready var player = $Player_2D

func _on_button_2_pressed():
	if GameManager.gold >= speed_cost:
		GameManager.gain_gold(-speed_cost)
		speed_cost += 10
		player.upgrade_speed(20)

func _on_button_pressed():
	if GameManager.gold >= mining_strength_cost:
		GameManager.gain_gold(-mining_strength_cost)
		player.upgrade_mining_strength(1)
		mining_strength_cost += 10
