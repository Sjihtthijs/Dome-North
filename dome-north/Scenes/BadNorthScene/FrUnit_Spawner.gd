extends Node3D

### Vars ###

# Variables for waves
var units = UnitManager.units
var Time_per_Wave = 10 #s

# Initialize locations
var locats
@onready var Grid = get_node("EasyNavRegion")# /EasyLandscape/GridMap

# var Meshes = Grid.get_meshes

# import what night it is.
var night

# Ready up scene for hostile units
var HUnitScn = preload("res://Scenes/BadNorthScene/Components/fr_units.tscn")
var Hinstance = HUnitScn.instantiate()

### Core Loop ###

func _ready():
	print("The Grid:", Grid)
	locats = detspawnlocs(night)
	spawnunits(locats, units)


func _process(_delta):
	pass

### Custom Functions ###

func detspawnlocs(Night):
	'''Determine per night when and where enemies will spawn'''
	var Place = Vector3()
	for i in range(10):
		print(i)
		Place = Vector3(i%1,i%2,0)
		print(Place)
	pass

func spawnunits(locs, Units):
	'''Do the act of spawning of enemies on the given times and locations'''
	pass
