extends Node2D

var hit_count: int = 0
const MAX_HITS := 4

var Current_time = 0.0
var time_to_mine = 3000.0
var start_mine = -1.0
var mining = false

@onready var GoldObject = preload("res://Scenes/DomeKeeperScene/resource_a_gold_object.tscn")

func _ready():
	$AnimatedSprite2D.play("middle_center_middle")

func _process(delta):
	Current_time = Time.get_ticks_msec()
	if Current_time-start_mine >= time_to_mine and mining:
		drop_resource()
		queue_free()

func _on_area_2d_body_entered(body):
	if body is Player_2D:
		start_mine = Time.get_ticks_msec()
		mining = true
		print("PLayer is mining")

func _on_area_2d_body_exited(body):
	if body is Player_2D:
		print("Player stopped mining")
		start_mine = -1.0
		mining = false

func drop_resource():
	var gold = GoldObject.instantiate()
	gold.global_position = global_position
	get_tree().get_root().add_child(gold)
