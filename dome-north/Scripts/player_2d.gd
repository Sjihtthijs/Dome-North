extends CharacterBody2D
class_name Player_2D

var speed = 100
@onready var sprite = $Sprite2D
var mining_strength = 0

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

func _physics_process(_delta):
		#checks what direction the player is looking (left/right)
	if Input.is_action_pressed("move_left"):
		sprite.scale.x = abs(sprite.scale.x) * -1
	if Input.is_action_pressed("move_right"):
		sprite.scale.x = abs(sprite.scale.x) * 1
		
	#handles movement left or right
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	#handles movement up or down
	var vert_direction = Input.get_axis("move_up", "move_down")
	if vert_direction:
		velocity.y = vert_direction * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
	
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= _delta
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO
	move_and_slide()

func _ready():
	upgrade_mining_strength(1)
	upgrade_speed(100)

func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration
	pass
# Make Function to send signal of breaking block
# that acts when there is a collision
# and when the player inputs to move in that direction

func upgrade_speed(value):
	speed += value
	print("speed: " , speed)

func upgrade_mining_strength(value):
	mining_strength += value
	print("Mining Strength: " , mining_strength)
