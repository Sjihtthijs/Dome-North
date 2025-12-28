extends CharacterBody3D
class_name NavCharacter3D

@export var move_speed: float = 1.0     
@export var stop_distance: float = 0.5
@export var fall_speed: float = 10.0    

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@export var hp = 10
@export var dmg = 1
var _has_target: bool = false
var _target_position: Vector3 = Vector3.ZERO
var player_target: Node3D = null

@export var attack_cooldown := 1.0
var _attack_timer := 0.0
var _is_attacking: bool = false

func _ready() -> void:
	if nav_agent == null:
		push_error("NavigationAgent3D not found, check $NavigationAgent3D")
		return

	nav_agent.target_desired_distance = stop_distance
	nav_agent.path_desired_distance = 0.1
	var pos = Vector3(0.5, 1.5, -0.5)
	move_to(pos)


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


func _physics_process(delta: float) -> void:
	if hp <= 0:
		print("Enemy is dead")
		queue_free()
	player_target = get_parent().get_parent().find_child("FrUnits", true, false)
	if player_target != null:
		if player_target.global_position.distance_to(global_position) <= 2:
			move_to(player_target.global_position)
	else:
		#print("finding FrUnits，but not found under ", get_parent().name)
		pass

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
	
	_attack_timer -= delta
	
	if player_target == null or not is_instance_valid(player_target):
		if _is_attacking:
			$AnimationPlayer.play("RESET")
			_is_attacking = false
		return
		
	var dist := global_position.distance_to(player_target.global_position)
	
	if dist <= 1.5 and _attack_timer <= 0.0:
		_attack_timer = attack_cooldown
		_is_attacking = true
		attack_player()
		"""
	else:
		if _is_attacking:
			$AnimationPlayer.play("RESET")
			_is_attacking = false
"""

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
	print("attack")
	player_target.hp -= dmg

"""
func _on_timer_timeout() -> void:
	if player_target.global_position.distance_to(global_position) <= 1.5:
		$AnimationPlayer.play("SwordSlash")
		print("attack!")
		player_target.hp -= dmg
	else:
		$AnimationPlayer.play("RESET")
	pass # Replace with function body.
"""
