extends Node2D

var hit_count: int = 0
const MAX_HITS := 4
var mining = false

@onready var IronObject = preload("res://Scenes/DomeKeeperScene/resource_b_iron_object.tscn")

func _ready():
	$AnimatedSprite2D.play("middle_center_middle")

func _on_area_2d_body_entered(body):
	#Breaks blocks when the player collided with it four times
	if body is Player_2D:
		var knockback_direction = (body.global_position - global_position).normalized()
		body.apply_knockback(knockback_direction, 40.0, 0.25)
		hit_count += 1
		print("Boing")
		if hit_count == 1:
			$"AnimatedSprite2D - Breaklines".play("hit_1")
		if hit_count == 2:
			$"AnimatedSprite2D - Breaklines".play("hit_2")
		if hit_count == 3:
			$"AnimatedSprite2D - Breaklines".play("hit_3")
		if hit_count >= MAX_HITS:
			drop_resource()
			queue_free()

func _on_area_2d_body_exited(body):
	if body is Player_2D:
		mining = false

func drop_resource():
	var iron = IronObject.instantiate()
	iron.global_position = global_position
	get_tree().get_root().add_child(iron)
