extends Control

signal continue_pressed
signal new_game_pressed
signal quit_pressed

func _on_continue_pressed() -> void:
	get_tree().paused = false
	emit_signal("continue_pressed")

func _on_new_game_pressed() -> void:
	get_tree().paused = false
	emit_signal("new_game_pressed")

func _on_quit_pressed() -> void:
	emit_signal("quit_pressed")
