extends Node

@export var scenes: Array[PackedScene] = [
	preload("res://Scenes/BadNorthScene/BNMain.tscn"),
	preload("res://Scenes/DomeKeeperScene/mine.tscn"),
	preload("res://UI/Shop.tscn")
]
@export var switch_interval := 3.0

var current_index := 0
var current_instance: Node
var waiting_for_ready := false  

func _ready():
	load_scene(0)
	var timer := Timer.new()
	timer.wait_time = switch_interval
	timer.autostart = true
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)

func load_scene(index: int):
	if current_instance:
		current_instance.queue_free()

	current_index = index
	current_instance = scenes[current_index].instantiate()
	add_child(current_instance)

	if current_instance.has_signal("Ready"):
		waiting_for_ready = true
		current_instance.ready_pressed.connect(_on_ready_from_C)
	else:
		waiting_for_ready = false


func _on_timer_timeout():
	if waiting_for_ready:
		return
	switch_to_next()

func switch_to_next():
	var next_index = (current_index + 1) % scenes.size()
	load_scene(next_index)
	waiting_for_ready = scenes[current_index].resource_path.ends_with("Shop.tscn")


func _on_ready_from_C():
	waiting_for_ready = false
	switch_to_next()
