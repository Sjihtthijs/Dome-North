extends CharacterBody3D
class_name Player3DClickMove

@export var move_speed: float = 3.0     
@export var stop_distance: float = 0.5  
@export var hp = 10
@export var dmg = 1
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var cam: Camera3D = $"../Camera3D"   
var _is_selected: bool = false
var _pending_move: bool = false
var _has_target: bool = false
var _target_position: Vector3 = Vector3.ZERO
var enemy_target: Node3D = null


@export var attack_cooldown := 1.0
var _attack_timer := 0.0
var _is_attacking: bool = false

var _debug_last_has_target: bool = false
func _ready() -> void:
	print("==== [Player3DClickMove] _ready ====")
	print("  player global_position =", global_position)
	print("  nav_agent =", nav_agent)
	print("  cam =", cam)

	if nav_agent == null:
		push_error("[Player3DClickMove] NavigationAgent3D not found, check $NavigationAgent3D")
		return
	if cam == null:
		push_error("[Player3DClickMove] Camera3D not found, check ../Camera3D")
		return
	#enemy_target = get_parent().get_parent().find_child("HoUnits", true, false)
	nav_agent.target_desired_distance = stop_distance
	nav_agent.path_desired_distance = 0.1
	print("  nav_agent.target_desired_distance =", nav_agent.target_desired_distance)
	print("  nav_agent.path_desired_distance   =", nav_agent.path_desired_distance)
	print("  nav_agent.navigation_map          =", nav_agent.get_navigation_map())

func select_unit(value: bool):
	_is_selected = value
	print(name, " selected: ", _is_selected)

func find_nearest_enemy(max_dist: float) -> Node3D:
	var enemies = get_tree().get_nodes_in_group("HoUnits")
	var nearest: Node3D = null
	var nearest_dist := max_dist

	for e in enemies:
		if not is_instance_valid(e):
			continue

		var d = global_position.distance_to(e.global_position)
		if d < nearest_dist:
			nearest_dist = d
			nearest = e

	return nearest


func move_to_position(pos: Vector3):
	if _is_selected:
		_set_navigation_target(pos)


func _set_navigation_target(world_pos: Vector3) -> void:
	if nav_agent == null:
		push_error("[Nav] nav_agent is null")
		return
	var nav_map := nav_agent.get_navigation_map()
	if nav_map == RID():
		push_error("[Nav] navigation_map is null，check if NavigationRegion3D exists")
		return

	var closest_nav_point := NavigationServer3D.map_get_closest_point(nav_map, world_pos)
	print("[Nav] click =", world_pos, " -> nearest point =", closest_nav_point)

	_target_position = closest_nav_point
	nav_agent.set_target_position(_target_position)

	var reachable := nav_agent.is_target_reachable()
	var dist := nav_agent.distance_to_target()
	print("  nav_agent.target_position       =", nav_agent.target_position)
	print("  nav_agent.is_target_reachable() =", reachable)
	print("  nav_agent.distance_to_target()  =", dist)

	if not reachable:
		print("[Nav] ⚠ unable to reach")
		_has_target = false
		return
	_pending_move = true
	
	_has_target = true

func _physics_process(delta: float) -> void:
	#print("has_target =", _has_target, " pending =", _pending_move, " on_floor =", is_on_floor())
	if _pending_move:
		_has_target = true
		_pending_move = false

	if hp <= 0:
		print("Friendly unit is dead")
		queue_free()
	if nav_agent == null:
		return

	if _has_target != _debug_last_has_target:
		#print("[Move] _has_target changed to ", _has_target, " nav_finished =", nav_agent.is_navigation_finished())
		_debug_last_has_target = _has_target

	if _has_target:
		if nav_agent.is_navigation_finished():
		#	print("[Move] stop moving pos =", global_position,
		#		  " distance_to_target =", nav_agent.distance_to_target())
			_stop_moving()
			return

		var next_point: Vector3 = nav_agent.get_next_path_position()
		var raw_dir: Vector3 = next_point - global_position
		var flat_dir := Vector3(raw_dir.x, 0.0, raw_dir.z)

		#print("[Move] next point =", next_point, " raw_dir =", raw_dir, " flat_dir =", flat_dir,
			  #" distance_to_target =", nav_agent.distance_to_target())

		if nav_agent.distance_to_target() <= stop_distance:
			#print("[Move] close to target (distance_to_target <=", stop_distance, ") -> stop moving")
			_stop_moving()
			return
		var dir := raw_dir.normalized()

		
		if dir.length() > 0.0:
			look_at(global_position + dir, Vector3.UP)

		velocity = dir * move_speed
		move_and_slide()
	else:
		if velocity.length() > 0.0:
			print("[Move] no target")
		velocity = Vector3.ZERO
		move_and_slide()
	_attack_timer -= delta

	var target = find_nearest_enemy(0.6) 

	if target == null:
		if _is_attacking:
			$AnimationPlayer.play("RESET")
			_is_attacking = false
		return

	if _attack_timer <= 0.0:
		_attack_timer = attack_cooldown
		_is_attacking = true
		attack_enemy(target)


func _stop_moving() -> void:
	_has_target = false
	velocity = Vector3.ZERO
	move_and_slide()
	print("[Move] _stop_moving, final spot =", global_position)

func attack_enemy(target):
	$AnimationPlayer.play("Swordstab")
	#enemy_target.hp -= dmg
	target.take_damage(dmg,self)
	print("Player attack, enemy hp:", target.hp)
