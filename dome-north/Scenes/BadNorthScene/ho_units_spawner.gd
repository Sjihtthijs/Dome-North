extends Node3D

### Vars ###

# Base stats for enemies
var enemies

# Initialize locations
var locats

# import what night it is.
var night

# Ready up scene for hostile units
var HUnitScn 


### Core Loop ###

func _ready():
	locats = detspawnlocs(night)


func _process(_delta):
	spawnunits(locats, enemies)


### Custom Functions ###

func detspawnlocs(Night):
	'''Determine per night when and where enemies will spawn'''
	var TimeAndPlace = Vector4()
	pass

func spawnunits(locs, Units):
	'''Do the act of spawning of enemies on the given times and locations'''
	pass
