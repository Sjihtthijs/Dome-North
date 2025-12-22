extends Node3D

### Vars ###

# Variables for waves
var enemies
var Time_per_Wave = 10 #s

# Initialize locations
var locats
@onready var Grid = get_node("EasyNavRegion")# /EasyLandscape/GridMap

# var Meshes = Grid.get_meshes

# import what night it is.
var night

# Ready up scene for hostile units
var HUnitScn = preload("res://Scenes/BadNorthScene/Components/ho_units.tscn")
var Hinstance = HUnitScn.instantiate()

### Core Loop ###

func _ready():
	print("The Grid:", Grid)
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
