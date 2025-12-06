extends Node2D

var hit_count: int = 0
const MAX_HITS := 4

var mining = false

var knockback: Vector2 = Vector2.ZERO

func _ready():
	$AnimatedSprite2D.play("middle_center_middle")
	pass

func _on_area_2d_body_entered(body):
	#Breaks blocks when the player collided with it four times
	if body is Player_2D:
		hit_count += 1
		print("Boing")
		if hit_count >= MAX_HITS:
			queue_free()

func _on_area_2d_body_exited(body):
	if body is Player_2D:
		mining = false
