extends Node2D

var hit_count: int = 0
const MAX_HITS := 4

var Current_time = 0.0
var time_to_mine = 3000.0
var start_mine = 0.0
var mining = false

func _ready():
	$AnimatedSprite2D.play("middle_center_middle")

func _process(_delta):
	Current_time = Time.get_ticks_msec()
	if Current_time-start_mine >= time_to_mine and mining:
		queue_free()
		print("Poof")

func _on_area_2d_body_entered(body):
	if body is Player_2D:
		start_mine = Time.get_ticks_msec()
		mining = true
		print("Yes!")
		mining = true
		if Current_time - start_mine >= time_to_mine:
			queue_free()

func _on_area_2d_body_exited(body):
	if body is Player_2D:
		start_mine = Current_time
		mining = false
		print("No!")
