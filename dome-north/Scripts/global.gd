extends Node

var player : Player_2D

# Default values
var player_speed = 100
var player_mining_strength = 0

# These values will be modified by the shop or game logic
var speed_cost = 10
var mining_strength_cost = 10

# Function to upgrade speed
func upgrade_speed(value):
	player_speed += value  # Increase player speed
	print("Speed upgraded to: ", player_speed)

# Function to upgrade mining strength
func upgrade_mining_strength(value):
	player_mining_strength += value  # Increase player mining strength
	print("Mining Strength upgraded to: ", player_mining_strength)
