extends Node2D

@export var game_speed = 1.0
@export var enemy_units : Array[int] = [0, 1, 2, 3, 4]

var current_index : = 0
var current_instance: Node
var all_ho_units_defeated : bool = false
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
		
	for i in enemy_units.size():
		var spawn_interval = game_speed / enemy_units.size()
		var spawn_time = randf() * spawn_interval + (i * spawn_interval)
		var percent = spawn_time / game_speed
		
		
		
		var enemy_image := TextureRect.new()
		enemy_image.texture = load("res://icon.svg")
		enemy_image.anchor_right = percent
		enemy_image.anchor_left = percent
		enemy_image.anchor_top = 0
		enemy_image.anchor_bottom = 1
		enemy_image.expand_mode = 2
		enemy_image.custom_minimum_size.y = 30
		night.add_child(enemy_image)
		
		var enemy_spawn_timer := Timer.new()
		enemy_spawn_timer.one_shot = true
		enemy_spawn_timer.autostart = true
		enemy_spawn_timer.name = "SpawnEnemyTimer" + str(i)
		add_child(enemy_spawn_timer)
		enemy_spawn_timer.timeout.connect(func(): spawn_enemy(enemy_spawn_timer))

func spawn_enemy(enemy_spawn_timer):
	print("enemy spawned")
	enemy_spawn_timer.queue_free()

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



func switch_to_next():
	var next_index = (current_index + 1) % scenes.size()
	load_scene(next_index)



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
	
