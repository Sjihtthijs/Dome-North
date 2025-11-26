extends Node2D

var hit_count: int = 0
const MAX_HITS := 4

var Current_time = 0.0
var time_to_mine = 4000.0
var start_mine = 0.0

func _ready():
	pass 

func _process(delta):
	Current_time = Time.get_ticks_msec()
	if Current_time-start_mine >= time_to_mine:
		queue_free()

func _on_area_2d_body_entered(body):
	if body is Player_2D:
		start_mine = Time.get_ticks_msec()
		print("Yes!")
		if Current_time - start_mine >= time_to_mine:
			queue_free()

func _on_area_2d_body_exited(body):
	if body is Player_2D:
		start_mine = Current_time
		print("No!")
