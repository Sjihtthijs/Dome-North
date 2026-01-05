extends CharacterBody3D
class_name NavCharacter3D

@export var move_speed: float = 2.0     
@export var stop_distance: float = 0.5
@export var fall_speed: float = 10.0    
@export var idle_target: Vector3 = Vector3(0.5, 1.5, -0.5)
var has_idle_target := false
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@export var hp = 10
@export var dmg = 1
var _has_target: bool = false
var _target_position: Vector3 = Vector3.ZERO
var player_target: Node3D = null
var is_aggro := false
@export var attack_cooldown := 1.0
var _attack_timer := 0.0
var _is_attacking: bool = false
var path_update_timer := 0.0
var path_update_interval := 0.2
var aggro_target: Node3D = null
func _ready() -> void:
	if nav_agent == null:
		push_error("NavigationAgent3D not found, check $NavigationAgent3D")
		return

	nav_agent.target_desired_distance = stop_distance
	nav_agent.path_desired_distance = 0.1
	
	set_move_target(idle_target)
	has_idle_target = true
	
	print("Start pos", position)

func take_damage(amount: int, attacker: Node3D) -> void:
	hp -= amount
	#print(name, "took damage:", amount)

	if hp <= 0:
		queue_free()
		print("enemy is dead")
		return

	is_aggro = true
	aggro_target = attacker


func set_move_target(world_pos: Vector3) -> void:
	if nav_agent == null:
		return
	
	var nav_map := nav_agent.get_navigation_map()
	if nav_map == RID():
		return

	var target_on_nav := NavigationServer3D.map_get_closest_point(nav_map, world_pos)
	nav_agent.set_target_position(target_on_nav)
	_has_target = true

func move_to(world_pos: Vector3) -> void:
	if nav_agent == null:
		return

	var nav_map := nav_agent.get_navigation_map()
	if nav_map == RID():
		return

	var target_on_nav := NavigationServer3D.map_get_closest_point(nav_map, world_pos)

	_target_position = target_on_nav
	nav_agent.set_target_position(_target_position)

	if nav_agent.is_target_reachable():
		_has_target = true
	else:
		_has_target = false


func stop() -> void:
	_has_target = false
	velocity.x = 0.0
	velocity.z = 0.0

"""
func _physics_process(delta: float) -> void:
	# print("Curr pos", position, name)
	if hp <= 0:
		print("Enemy is dead")
		queue_free()
	#player_target = get_parent().get_parent().find_child("FrUnits", true, false)
	#var players = get_tree().get_nodes_in_group("FrUnits")
	#if players.size() > 0:
	#	player_target = players[0]
	#	_has_target = true
	if not is_aggro:
		if has_idle_target:
			if nav_agent.distance_to_target() > stop_distance:
				move_to(idle_target)
			else:
				stop()

		_snap_to_navmesh(false, delta)
		return
		
	player_target = aggro_target
	
	if nav_agent == null:
		return
		
		
	_snap_to_navmesh(false, delta)

	if _has_target:
		if nav_agent.is_navigation_finished() and nav_agent.distance_to_target() <= stop_distance:
			stop()
		else:
			var next_point: Vector3 = nav_agent.get_next_path_position()
			var dir: Vector3 = next_point - global_position
			dir.y = 0.0  

			if dir.length() > 0.01:
				dir = dir.normalized()

				var look_dir := Vector3(dir.x, 0.0, dir.z)
				if look_dir.length() > 0.0:
					look_at(global_position + look_dir, Vector3.UP)

				velocity.x = dir.x * move_speed
				velocity.z = dir.z * move_speed
			else:
				velocity.x = move_toward(velocity.x, 0.0, move_speed)
				velocity.z = move_toward(velocity.z, 0.0, move_speed)
	else:
		velocity.x = move_toward(velocity.x, 0.0, move_speed)
		velocity.z = move_toward(velocity.z, 0.0, move_speed)

	move_and_slide()
	if player_target != null:
		var dist := global_position.distance_to(player_target.global_position)

		if dist > stop_distance:
			move_to(player_target.global_position)
		else:
			stop()

		_attack_timer -= delta
		if dist <= 1.5 and _attack_timer <= 0.0:
			_attack_timer = attack_cooldown
			attack_player()
"""
func _physics_process(delta: float) -> void:
	if hp <= 0:
		queue_free()
		return

	_attack_timer -= delta
	_snap_to_navmesh(false, delta)

	if not is_aggro:
		if global_position.distance_to(idle_target) > stop_distance:
			move_to(idle_target)
		else:
			stop()
	else:
		player_target = aggro_target
		if player_target and is_instance_valid(player_target):
			var dist = global_position.distance_to(player_target.global_position)
			
			if dist > stop_distance:
				move_to(player_target.global_position)
			else:
				stop()

			if dist <= 1.5 and _attack_timer <= 0.0:
				_attack_timer = attack_cooldown
				attack_player()
		else:
			is_aggro = false
			stop()

	_handle_movement_logic()

func _handle_movement_logic():
	if _has_target:
		if nav_agent.is_navigation_finished() and nav_agent.distance_to_target() <= stop_distance:
			stop()
		else:
			var next_point = nav_agent.get_next_path_position()
			var dir = (next_point - global_position).normalized()
			dir.y = 0
			
			if dir.length() > 0.01:
				look_at(global_position + dir, Vector3.UP)
				velocity.x = dir.x * move_speed
				velocity.z = dir.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, move_speed)
		velocity.z = move_toward(velocity.z, 0.0, move_speed)

	move_and_slide()
		
func _snap_to_navmesh(first_time: bool, delta: float = 0.0) -> void:
	if nav_agent == null:
		return

	var nav_map := nav_agent.get_navigation_map()
	if nav_map == RID():
		return

	var current := global_position
	var closest := NavigationServer3D.map_get_closest_point(nav_map, current + Vector3(0.0, 3.0, 0.0))

	if first_time:
		global_position.y = closest.y
	else:
		var target_y := closest.y
		var t = clamp(fall_speed * delta, 0.0, 1.0)
		global_position.y = lerp(global_position.y, target_y, t)

func attack_player():
	$AnimationPlayer.play("Swordstab")
	
	player_target.hp -= dmg
	print("Enemy attack, player hp:",player_target.hp )
