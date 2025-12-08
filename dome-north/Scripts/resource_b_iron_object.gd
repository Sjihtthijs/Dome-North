extends Node2D

func _ready():
	pass 

func _process(delta):
	pass

func _on_area_2d_area_entered(area):
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$Pennydrop.play()
	$Sprite2D.visible = false
	await get_tree().create_timer($Pennydrop.stream.get_length()).timeout
	GameManager.gain_iron(1)
	queue_free()
