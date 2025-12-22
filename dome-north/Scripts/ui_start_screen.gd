extends Control

signal game_started

func _on_start_game_pressed() -> void:
	emit_signal("game_started")
	$"JuhaniJunkala[chiptuneAdventures]2_Stage2".stop()

func _ready():
	$"JuhaniJunkala[chiptuneAdventures]2_Stage2".play()
