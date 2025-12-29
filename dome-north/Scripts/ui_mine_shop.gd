extends Control

var speed_cost = 10
var mining_strength_cost = 10

var speed_upgrade = 20
var mining_strength_upgrade = 1

var player = Global.player

func _on_button_2_pressed():
	if GameManager.gold >= speed_cost:
		GameManager.gain_gold(-speed_cost)
		if is_instance_valid(Global.player):
			Global.upgrade_speed(20)
		else:
			print("Player object is invalid!")
		speed_cost += 10

func _on_button_pressed():
	if GameManager.gold >= mining_strength_cost:
		GameManager.gain_gold(-mining_strength_cost)
		if is_instance_valid(Global.player):
			Global.upgrade_mining_strength(1)
		else:
			print("Player object is invalid!")
		mining_strength_cost += 10
