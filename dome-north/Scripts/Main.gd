extends Node2D

@export var game_speed = 15.0
@export var enemy_units : Array[int] = [0, 1, 2, 3, 4]
var wave_count : int = 0
var current_index : = 0
var current_instance: Node
var all_ho_units_defeated : bool = false
var spawn_times
var timeout = false
@onready var scene_switch_timer : Timer = $SceneSwitchTimer
@onready var night: Panel = $CanvasLayer/UI/UI/VBoxContainer/TopBar/HBoxContainer/MarginContainer/VBoxContainer/Panel2/Night
@onready var scene_switch_animation: AnimationPlayer = $SceneSwitchAnimation


@onready var ui: Control = $CanvasLayer/UI
@onready var start_screen: Control = $CanvasLayer/StartScreen


var scenes: Array[PackedScene] = [
	preload("res://Scenes/DomeKeeperScene/mine.tscn"),
	preload("res://Scenes/BadNorthScene/BNMain.tscn")
	]

var daynight_animation : Array = [
	"day_to_night",
	"night_to_day"
	]



func set_enemy_spawns():
	for child in night.get_children():
		child.free()
	
	spawn_times = []
	
	for i in enemy_units.size():
		var spawn_time = game_speed / enemy_units.size() / 3
		if i > 0:
			var spawn_interval = game_speed / enemy_units.size()
			spawn_time = 0.9 * (randf() * spawn_interval + (i * spawn_interval)) + 0.05
			spawn_times.append(spawn_time)
		draw_enemy_spawn_indicator(spawn_time)
		create_enemy_spawn_timer(spawn_time, i)

func draw_enemy_spawn_indicator(spawn_time):
	var enemy_image := TextureRect.new()
	enemy_image.texture = load("res://icon.svg")
	enemy_image.anchor_right = spawn_time / game_speed
	enemy_image.anchor_left = spawn_time / game_speed
	enemy_image.anchor_top = 0
	enemy_image.anchor_bottom = 1
	enemy_image.expand_mode = 2
	enemy_image.grow_horizontal = 2
	enemy_image.custom_minimum_size.y = 30
	night.add_child(enemy_image)

func create_enemy_spawn_timer(spawn_time, enemy):
	var enemy_spawn_timer := Timer.new()
	enemy_spawn_timer.one_shot = true
	enemy_spawn_timer.name = "SpawnEnemyTimer" + str(enemy)
	enemy_spawn_timer.wait_time = spawn_time
	add_child(enemy_spawn_timer)
	enemy_spawn_timer.timeout.connect(func(): spawn_enemy(enemy_spawn_timer))

func start_enemy_spawn_timer():
	for child in get_children():
		if child.name.begins_with("SpawnEnemyTimer"):
			child.start()

func spawn_enemy(enemy_spawn_timer):
	print("enemy spawned")
	enemy_spawn_timer.queue_free()
	
	if current_index == 1 and is_instance_valid(current_instance):
		var spawner = current_instance.get_node_or_null("HoUnitsSpawner")
		if spawner:
			var single_enemy_data = {
				"health": 10 ,
				"damage": 1 
			}
			spawner.spawn_single_unit(single_enemy_data)

func _on_game_started() -> void:
	scene_switch_timer.wait_time = game_speed

	scene_switch_animation.play("scene_fade_out")
	await scene_switch_animation.animation_finished
	
	ui.show()
	start_screen.hide()
	$CanvasLayer/UI.animation_player.play(daynight_animation[0])
	$CanvasLayer/UI.animation_player.stop()
	set_enemy_spawns()
	current_instance = scenes[0].instantiate()
	await add_child(current_instance)

	
	scene_switch_animation.play("scene_fade_in")
	await scene_switch_animation.animation_finished
	$CanvasLayer/UI.animation_player.play(daynight_animation[0])
	scene_switch_timer.start()



func _ready() -> void:
	$CanvasLayer/UI.animation_player.speed_scale = 1.0 / game_speed

func _process(_delta) -> void:
	if timeout:
		_on_scene_switch_timer_timeout()

func load_scene(index: int):
	scene_switch_animation.play("scene_fade_out")
	await scene_switch_animation.animation_finished
	
	if index == 0:
		set_enemy_spawns()
		$CanvasLayer/UI.dome_keeper_scene()
	if index == 1 :
		$CanvasLayer/UI.bad_north_scene()
		
	if current_instance:
		current_instance.queue_free()

	current_index = index
	current_instance = scenes[current_index].instantiate()
	add_child(current_instance)
	$CanvasLayer/UI.animation_player.play(daynight_animation[current_index])
	$CanvasLayer/UI.animation_player.stop()

	scene_switch_animation.play("scene_fade_in")
	await scene_switch_animation.animation_finished
	$CanvasLayer/UI.animation_player.play(daynight_animation[current_index])
	scene_switch_timer.start()
	
	if index == 1:
		start_enemy_spawn_timer()


func switch_to_next():
	var next_index = (current_index + 1) % scenes.size()
	# Every time add 2 enemies to the set
	if next_index == 1: 
		wave_count += 1
		for i in range(2):
			enemy_units.append(enemy_units.size())
	load_scene(next_index)



func _on_scene_switch_timer_timeout() -> void:
	timeout = true
	# print("Time Out")
	if current_index == 0:
		current_instance.queue_free()
		$CanvasLayer/UI.shop_scene()
		timeout = false
	elif all_ho_units_defeated == false:
		return
	else:
		switch_to_next()
		timeout = false



func _shop_ready() -> void:
	switch_to_next()



func _on_all_hostile_units_defeated() -> void:
	all_ho_units_defeated = true
	$CanvasLayer/UI.animation_player.seek(1.0, true)
	
