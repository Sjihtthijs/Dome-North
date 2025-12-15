extends Node3D

### Vars ###

@onready var units = UnitManager.units


### Core Loop ###

func _ready():
	var locats = detspawnlocs()
	spawnunits(locats, units)

func _process(_delta):
	pass


### Custom Functions ###

func detspawnlocs():
	pass

func spawnunits(locs, Units):
	pass
