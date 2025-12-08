extends Node2D

var hit_count: int = 0
const MAX_HITS := 4
var mining = false

@onready var GoldObject = preload("res://Scenes/DomeKeeperScene/resource_a_gold_object.tscn")

func _ready():
	$AnimatedSprite2D.play("middle_center_middle")

func _on_area_2d_body_entered(body):
	#Breaks blocks when the player collided with it four times
	if body is Player_2D:
		hit_count += 1
		print("Boing")
		if hit_count >= MAX_HITS:
			drop_resource()
			queue_free()

func _on_area_2d_body_exited(body):
	if body is Player_2D:
		mining = false

func drop_resource():
	var gold = GoldObject.instantiate()
	gold.global_position = global_position
	get_tree().get_root().add_child(gold)
