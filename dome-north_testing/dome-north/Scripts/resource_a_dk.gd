extends Node2D

var hit_count: int = 0
const MAX_HITS := 4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if body is Player_2D:
		hit_count += 1
		print("Hit count:", hit_count)
		if hit_count >= MAX_HITS:
			queue_free()
