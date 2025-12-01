extends Node2D

var hit_count: int = 0
const MAX_HITS := 4

var Current_time = 0.0
var time_to_mine = 3000.0
var start_mine = 0.0
var mining = false

@onready var IronObject = preload("res://Scenes/DomeKeeperScene/resource_b_iron_object.tscn")

func _process(_delta):
	Current_time = Time.get_ticks_msec()
	if Current_time-start_mine >= time_to_mine and mining:
		drop_resource()
		queue_free()
		print("Poof")

func _on_area_2d_body_entered(body):
	if body is Player_2D:
		start_mine = Time.get_ticks_msec()
		mining = true
		print("Iron Ore is being mined")

func _on_area_2d_body_exited(body):
	if body is Player_2D:
		print("Iron Ore is not being mined")
		start_mine = Current_time
		mining = false

func drop_resource():
	var iron = IronObject.instantiate()
	iron.global_position = global_position
	get_tree().get_root().add_child(iron)
