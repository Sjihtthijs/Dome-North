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
		var mining_strength = body.mining_strength if "mining_strength" in body else 1
		var required_hits = int(ceil(MAX_HITS/max(mining_strength,1)))
		var knockback_direction = (body.global_position - global_position).normalized()
		body.apply_knockback(knockback_direction, 40.0, 0.25)
		$Shoot3.play()
		await get_tree().create_timer($Shoot3.stream.get_length()).timeout
		hit_count += 1
		print("Boing hit count:", hit_count, "required:", MAX_HITS)
		if hit_count >= required_hits:
			queue_free()
			drop_resource()  # Destroy block when enough hits are reached
		else:
			# Play animation depending on how much damage has been taken
			if hit_count == 1:
				$"AnimatedSprite2D - Breaklines".play("hit_1")
			elif hit_count == 2:
				$"AnimatedSprite2D - Breaklines".play("hit_2")
			elif hit_count == 3:
				$"AnimatedSprite2D - Breaklines".play("hit_3")

func _on_area_2d_body_exited(body):
	if body is Player_2D:
		mining = false

func drop_resource():
	var gold = GoldObject.instantiate()
	gold.global_position = global_position
	get_tree().get_root().add_child(gold)
