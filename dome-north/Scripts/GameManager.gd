extends Node

signal gained_gold(int)
signal gained_iron(int)

var gold : int
var iron : int

func gain_gold(gold_gained:int):
	gold += gold_gained
	emit_signal("gained_gold", gold_gained)

func gain_iron(iron_gained:int):
	iron += iron_gained
	emit_signal("gained_iron", iron_gained)
