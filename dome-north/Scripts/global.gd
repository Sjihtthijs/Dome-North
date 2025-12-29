extends Node

var player : Player_2D

func upgrade_speed(value):
	if is_instance_valid(player):
		player.speed += value
	else:
		print("Player object is invalid!")
	print("speed: " , player.speed)

func upgrade_mining_strength(value):
	if is_instance_valid(player):
		player.mining_strength += value
	else:
		print("Player object is invalid!")
	print("Mining Strength: " , player.mining_strength)
