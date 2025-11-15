extends Node3D
@export var enemy_scene: PackedScene
@export var spawn_radius := 40.0  
@export var min_distance := 30.0   

var player

func _ready():
	player = get_tree().get_current_scene().get_node("FrUnits")
	spawn_enemy()

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	
	# random angle
	var angle = randf() * TAU
	
	# random radius
	var radius = randf_range(min_distance, spawn_radius)
	
	var spawn_pos = player.global_transform.origin + Vector3(
		cos(angle) * radius,
		0,
		sin(angle) * radius
	)
	
	enemy.global_transform.origin = spawn_pos
	get_tree().get_current_scene().add_child(enemy)
