extends Node

class_name Unit

var health : int
var max_health : int
var damage : int
var damage_up : int
var health_up : int


func _init(health, max_health, damage, health_up, damage_up) -> void:
	self.health = health
	self.max_health = max_health
	self.damage = damage
	self.health_up = health_up
	self.damage_up = damage_up

func upgrade_unit(health_up, health, damage_up, damage):
	if health_up > 0:
		self.health_up = health_up
		self.max_health += health
		self.health += health
	if damage_up > 0:
		self.damage_up = damage_up
		self.damage += damage

func heal_unit(heal):
	if self.max_health - self.health > heal:
		self.health += heal
	else:
		self.health = self.max_health
