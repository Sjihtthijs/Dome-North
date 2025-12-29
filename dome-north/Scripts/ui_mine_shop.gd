extends Control

var speed_cost = 10
var mining_strength_cost = 10

var speed_upgrade = 20
var mining_strength_upgrade = 1

var player = Global.player

func _on_button_2_pressed():
	if GameManager.gold >= speed_cost:
		GameManager.gain_gold(-Global.speed_cost)
		Global.upgrade_speed(speed_upgrade)  # Upgrade speed
		Global.speed_cost += 10  # Increase cost

func _on_button_pressed():
	if GameManager.gold >= mining_strength_cost:
		GameManager.gain_gold(-Global.mining_strength_cost)
		Global.upgrade_mining_strength(mining_strength_upgrade)  # Upgrade mining strength
		Global.mining_strength_cost += 10  # Increase cost
