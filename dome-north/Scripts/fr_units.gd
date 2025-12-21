extends CharacterBody3D
class_name Player3DClickMove

@export var move_speed: float = 5.0     
@export var stop_distance: float = 0.2    

@onready var nav_agent: NavigationAgent3D = $EasyNavRegion #NavigationAgent3D 
@onready var cam: Camera3D = $"../Camera3D"   

var _pending_move: bool = false
var _has_target: bool = false
var _target_position: Vector3 = Vector3.ZERO

var _debug_last_has_target: bool = false
var hp = 10
func _ready() -> void:
	print("==== [Player3DClickMove] _ready ====")
	print("  player global_position =", global_position)
	print("  nav_agent =", nav_agent)
	print("  cam =", cam)

	if nav_agent == null:
		push_error("[Player3DClickMove] NavigationAgent3D 没找到，请检查节点路径 $NavigationAgent3D")
		return
	if cam == null:
		push_error("[Player3DClickMove] Camera3D 没找到，请检查路径 ../Camera3D")
		return

	nav_agent.target_desired_distance = stop_distance
	nav_agent.path_desired_distance = 0.1
	print("  nav_agent.target_desired_distance =", nav_agent.target_desired_distance)
	print("  nav_agent.path_desired_distance   =", nav_agent.path_desired_distance)
	print("  nav_agent.navigation_map          =", nav_agent.get_navigation_map())

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		print("[Input] click, spot =", event.position)
		_handle_click(event.position)

func _handle_click(mouse_pos: Vector2) -> void:
	if cam == null:
		push_error("[_handle_click] cam is null")
		return

	var from: Vector3 = cam.project_ray_origin(mouse_pos)
	var dir: Vector3 = cam.project_ray_normal(mouse_pos)
	print("[Ray] from =", from, " dir =", dir)

	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(from, from + dir * 1000.0)
	var result := space_state.intersect_ray(query)

	if result:
		var hit_pos: Vector3 = result.position
		var collider = result.collider
		print("[Ray] hitting:", collider, "  collider =", hit_pos)
		_set_navigation_target(hit_pos)
	else:
		print("[Ray] not hitting anything")

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
	print("has_target =", _has_target, " pending =", _pending_move, " on_floor =", is_on_floor())
	if _pending_move:
		_has_target = true
		_pending_move = false

	if hp <= 0:
		queue_free()
	if nav_agent == null:
		return

	if _has_target != _debug_last_has_target:
		print("[Move] _has_target changed to ", _has_target, " nav_finished =", nav_agent.is_navigation_finished())
		_debug_last_has_target = _has_target

	if _has_target:
		if nav_agent.is_navigation_finished():
			print("[Move] stop moving pos =", global_position,
				  " distance_to_target =", nav_agent.distance_to_target())
			_stop_moving()
			return

		var next_point: Vector3 = nav_agent.get_next_path_position()
		var raw_dir: Vector3 = next_point - global_position
		var flat_dir := Vector3(raw_dir.x, 0.0, raw_dir.z)

		print("[Move] next point =", next_point, " raw_dir =", raw_dir, " flat_dir =", flat_dir,
			  " distance_to_target =", nav_agent.distance_to_target())

		if nav_agent.distance_to_target() <= stop_distance:
			print("[Move] close to target (distance_to_target <=", stop_distance, ") -> stop moving")
			_stop_moving()
			return
		"""
		if flat_dir.length() > 0.01:
			var dir := flat_dir.normalized()
			look_at(global_position + dir, Vector3.UP)
			velocity = dir * move_speed
			move_and_slide()
			
		#if flat_dir.length() < 0.01:
			#print("[Move] flat_dir not yet target")
			#return

		#var dir := flat_dir.normalized()
		"""
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

func _stop_moving() -> void:
	_has_target = false
	velocity = Vector3.ZERO
	move_and_slide()
	print("[Move] _stop_moving, final spot =", global_position)


func _on_timer_timeout() -> void:
	if $"../HoUnits".global_position.distance_to(global_position) <= 0.5:
		$AnimationPlayer.play("Swordstab")
		$"../HoUnits".hp -= 1
	else:
		$AnimationPlayer.play("RESET")
	pass # Replace with function body.
