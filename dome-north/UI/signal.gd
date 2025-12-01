extends Control
signal ready_pressed

func _ready():
	$Ready.pressed.connect(_on_ready_button_pressed)

func _on_ready_button_pressed():
	emit_signal("ready_pressed")
