extends Control

@onready var ui: Control = $"../UI"
@onready var start_screen: Control = $"."
signal game_started

func _on_start_game_pressed() -> void:
	ui.show()
	start_screen.hide()
	emit_signal("game_started")
	$"JuhaniJunkala[chiptuneAdventures]2_Stage2".stop()

func _ready():
	$"JuhaniJunkala[chiptuneAdventures]2_Stage2".play()
