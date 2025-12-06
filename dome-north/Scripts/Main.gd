extends Node2D

@export var game_speed = 5.0

var current_index : = 0
var current_instance: Node
var all_ho_units_defeated : bool = false
@onready var scene_switch_timer : Timer = $SceneSwitchTimer

const START_SCREEN = preload("res://Scenes/UI/StartScreen.tscn")

var scenes: Array[PackedScene] = [
	preload("res://Scenes/DomeKeeperScene/mine.tscn"),
	preload("res://Scenes/BadNorthScene/BNMain.tscn")
	]

var daynight_animation : Array = [
	"day_to_night",
	"night_to_day"
	]

func _on_game_started() -> void:
	scene_switch_timer.wait_time = game_speed
	scene_switch_timer.start()
	load_scene(0)
	
func _ready() -> void:
	$CanvasLayer/UI.animation_player.speed_scale = 1.0 / game_speed

func load_scene(index: int):
	if current_instance:
		current_instance.queue_free()

	current_index = index
	current_instance = scenes[current_index].instantiate()
	add_child(current_instance)
	$CanvasLayer/UI.animation_player.seek(1.0, true)
	$CanvasLayer/UI.animation_player.play(daynight_animation[current_index])

func switch_to_next():
	var next_index = (current_index + 1) % scenes.size()
	load_scene(next_index)
	
	if next_index == 0:
		$CanvasLayer/UI.dome_keeper_scene()
	else:
		$CanvasLayer/UI.bad_north_scene()

	scene_switch_timer.start()

func _on_scene_switch_timer_timeout() -> void:
	if current_index == 0:
		current_instance.queue_free()
		$CanvasLayer/UI.shop_scene()
	elif all_ho_units_defeated == false:
		return
	else:
		switch_to_next()

func _shop_ready() -> void:
	switch_to_next()

func _on_all_hostile_units_defeated() -> void:
	all_ho_units_defeated = true
	$CanvasLayer/UI.animation_player.seek(1.0, true)
	_on_scene_switch_timer_timeout()
	
