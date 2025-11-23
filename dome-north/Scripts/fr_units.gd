extends CharacterBody3D

# --- Navigation & Layer Constants ---
const MAP_TILE_LAYER_BIT = 1 << 1
const UNIT_LAYER_BIT = 1 << 0

# --- HP & Death System ---
@export_group("Health")
@export var max_hp: float = 100.0
var current_hp: float

# --- Movement System ---
@export_group("Movement")
const SPEED = 5.0
const ROTATION_SPEED = 10.0
var target_position: Vector3 = global_position # Player's click target position

var is_selected: bool = false # Tracks if this unit is currently selected by the player
const STOP_DISTANCE_NAV = 0.5 
const STOP_DISTANCE_AGGRO = 2.0

# --- Aggro Target ---
# Automatic counter-attack target. Set when the unit takes damage.
var aggro_target: CharacterBody3D = null

const STOP_DISTANCE = 0.1
var camera: Camera3D
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
# --- Attack System ---
@export_group("Attack")
@export var attack_damage: float = 20.0
@export var attack_range: float = 2.0
@export var attack_cooldown: float = 1.0
var time_since_last_attack: float = 0.0

func _ready():
	current_hp = max_hp
	time_since_last_attack = attack_cooldown
	
	camera = get_viewport().get_camera_3d()
	if camera == null:
		push_error("camera3D not found")
		set_physics_process(false)
		
	if nav_agent == null:
		push_error("NavigationAgent3D not found on fr_units node.")
		set_physics_process(false)

func _process(delta: float):
	# Update attack cooldown timer
	time_since_last_attack += delta

func _physics_process(delta: float):
	# 1. Check if there is a valid aggro target
	if aggro_target != null and is_instance_valid(aggro_target):
		# If valid target exists, prioritize handling the aggro target
		_handle_aggro_movement_and_attack(aggro_target)
		
	else:
		# Clear invalid target and revert to player click movement
		aggro_target = null
		#_handle_click_movement(delta)
		_handle_navigation_movement()

# --- Handles movement and attack when an aggro target is present ---
func _handle_aggro_movement_and_attack(target: CharacterBody3D):
	# Calculate distance to the aggro target
	var distance_to_target = global_position.distance_to(target.global_position)
	
	# Unit stops moving when engaging an aggro target (no chasing)
	velocity = Vector3.ZERO
	move_and_slide()
	
	# Turn to face the target while engaging/waiting for cooldown
	look_at(target.global_position, Vector3.UP, true)

	# Check if the target is within attack range
	if distance_to_target <= attack_range:
		# In range: attempt to attack
		_try_attack(target)
	else:
		# Out of range: stop and hold position (velocity is already zero)
		pass 

# ---   Navigation Click Movement  ---
func _handle_navigation_movement():
	if nav_agent.is_navigation_finished():
		velocity = Vector3.ZERO
		move_and_slide()
		return
	var next_path_position: Vector3 = nav_agent.get_next_path_position()
	var direction_3d = (next_path_position - global_position).normalized()
	direction_3d.y = 0.0 
	var distance_to_next = global_position.distance_to(next_path_position)
	if distance_to_next > STOP_DISTANCE_NAV:
		var target_look_at = global_position + direction_3d
		look_at(target_look_at, Vector3.UP, true)
		velocity = direction_3d * SPEED
	else:
		velocity = Vector3.ZERO
	move_and_slide()

'''
# --- Consolidated Movement Function ---
# Used for both chasing (if we re-add it) and player click movement
func _move_towards(target_pos: Vector3):
	var direction_3d = (target_pos - global_position).normalized()
	direction_3d.y = 0.0
	
	var target_look_at = global_position + direction_3d
	look_at(target_look_at, Vector3.UP, true)
	velocity = direction_3d * SPEED
	move_and_slide()

# --- Original Click Movement Logic ---
func _handle_click_movement(delta: float):
	var current_xz = Vector2(global_position.x, global_position.z)
	var target_xz = Vector2(target_position.x, target_position.z)
	var distance_to_target = current_xz.distance_to(target_xz)

	if distance_to_target > STOP_DISTANCE:
		_move_towards(target_position)
	else:
		velocity = Vector3.ZERO
		move_and_slide()
'''
# --- Mouse Input (Click to Move) ---
# (Raycasting code omitted for brevity, logic remains the same)
func _input(event: InputEvent):
	# Mouse Left Click Logic (Raycasting)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Check camera... Raycasting code...
		
		# IMPORTANT: When player clicks, clear aggro target to prioritize movement
		aggro_target = null
		var mouse_pos = event.position
		var ray_origin = camera.project_ray_origin(mouse_pos)
		var ray_dir = camera.project_ray_normal(mouse_pos)
		var ray_end = ray_origin + ray_dir * 1000 
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
		var result = space_state.intersect_ray(query)
		# ... (Raycasting code to get new_target) ...
		if result.has("collider"):
			var clicked_node = result.collider
			
			if clicked_node == self:
				is_selected = true
				aggro_target = null
				print("Unit ", name, " **SELECTED**")
				return

			elif is_selected:
				var new_target = result.position
				set_target_position(new_target) 
				
				is_selected = false
				print("Unit ", name, " ordered to move to hit position on node: ", clicked_node.name)
				return
		elif not result.has("collider") and is_selected:
			is_selected = false
			print("Unit ", name, " deselected by clicking empty space.")
			return

func set_target_position(new_pos: Vector3):
	aggro_target = null
	target_position = new_pos
	nav_agent.target_position = target_position


# --- Attack Logic ---

# Modified attack function, takes a target node
func _try_attack(target_node: CharacterBody3D):
	if time_since_last_attack >= attack_cooldown:
		time_since_last_attack = 0.0
		_execute_attack(target_node)

func _execute_attack(enemy_node: CharacterBody3D):
	if enemy_node.has_method("take_damage"):
		print("FrUnits Attacks (Aggro), dealing ", attack_damage, " damage to ", enemy_node.name)
		enemy_node.take_damage(attack_damage) # Pass self as the attacker
		
		# TODO: Play attack animation, sound effects, particles

# --- Take Damage Logic - Includes Aggro ---

# Must receive the attacker as an argument to counter-attack
func take_damage(damage_amount: float, attacker: CharacterBody3D):
	if damage_amount <= 0:
		return

	current_hp -= damage_amount
	print("FrUnits takes damage. Current HP: ", current_hp)
	
	# *** Core Counter-Attack Logic ***
	# Set the attacker as the new aggro target if they are valid
	if attacker != null and is_instance_valid(attacker) and attacker.has_method("take_damage"):
		aggro_target = attacker
		print("FrUnits sets new aggro target: ", attacker.name)

	if current_hp <= 0:
		die()

func die():
	print("FrUnits is dead!")
	# ... (Death logic) ...
	queue_free()
