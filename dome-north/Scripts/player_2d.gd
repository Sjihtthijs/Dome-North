extends CharacterBody2D
class_name Player_2D

var speed = 500
@onready var sprite = $Sprite2D

func _ready():
	pass

func _physics_process(delta):
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
	move_and_slide()
