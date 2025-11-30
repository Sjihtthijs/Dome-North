extends Node

signal gained_gold(int)

var gold : int

func gain_gold(gold_gained:int):
	gold += gold_gained
	emit_signal("gained_gold", gold_gained)
