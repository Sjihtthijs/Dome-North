extends CharacterBody3D
# --- HP Related Variables ---
# Define max health, using @export allows adjustment in the editor
@export var max_hp: float = 100.0
# Current health, initialized to max health
var current_hp: float 

# --- Movement and Attack Variables ---
@export var speed := 1.0

@export_group("Attack Settings")
@export var attack_damage: float = 10.0      # Damage dealt per attack
@export var attack_range: float = 1.5        # Distance within which the unit can attack
@export var attack_cooldown: float = 2.0     # Cooldown time between two attacks (seconds)

var time_since_last_attack: float = 0.0 # Used to track cooldown timer
var player: CharacterBody3D # Explicitly type as CharacterBody3D


func _ready():
	# Just for debugging rn, can be changed to player node afterwards
	player = get_tree().get_current_scene().get_node("FrUnits")
	current_hp = max_hp
	time_since_last_attack = attack_cooldown
	
func _process(delta: float):
	time_since_last_attack += delta

func _physics_process(delta):
	if player == null:
		return
	# Calculate the horizontal distance to the player (XZ plane)
	var distance_to_player = global_position.distance_to(player.global_position)
	
	
	# Check if within attack range
	if distance_to_player <= attack_range:
		velocity = Vector3.ZERO
		move_and_slide()
		_try_attack()
	else:
		
	# Getting the direction pointing at player
		var direction = (player.global_transform.origin - global_transform.origin).normalized()

		look_at(player.global_transform.origin, Vector3.UP)
	# movement
		velocity = direction * speed
		move_and_slide()
		
func _try_attack():
	if time_since_last_attack >= attack_cooldown:
		time_since_last_attack = 0.0
		_execute_attack()

func _execute_attack():
	# Ensure the player node exists and has the take_damage method
	if player != null and player.has_method("take_damage"):
		print("HoUnit attacks FrUnits, dealing ", attack_damage, " damage!")
		
		# Call the damage function in the FrUnits script
		player.take_damage(attack_damage, self)
		
		# TODO: Add attack animation, sound effects, or particle effects here	



func take_damage(damage_amount: float):
	if damage_amount <= 0:
		return
	current_hp -= damage_amount
	if current_hp <= 0:
		die()
		
func die():
	print("HoUnit dies!")
	queue_free()
