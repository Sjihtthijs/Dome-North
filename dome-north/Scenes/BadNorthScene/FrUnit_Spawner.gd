extends Node3D

### Vars ###

# Variables for waves
var units = UnitManager.units

# Initialize locations
#var SpiralOfLocations = [[ 0,  1,  1,  0, -1, -1, -1,  0,  1,  2,  2,  2,  2,  1,  0, -1, -2, -2, -2, -2, -2, -1,  0,  1,
#   2,  3,  3,  3,  3],
# [ 0,  0,  1,  1,  1,  0, -1, -1, -1, -1,  0,  1,  2,  2,  2,  2,  2,  1,  0, -1, -2, -2, -2, -2,
#  -2, -2, -1,  0,  1]]

var SpiralOfLocations = [[ 0,  0],
 [ 1,  0],
 [ 1,  1],
 [ 0,  1],
 [-1,  1],
 [-1,  0],
 [-1, -1],
 [ 0, -1],
 [ 1, -1],
 [ 2, -1],
 [ 2,  0],
 [ 2,  1],
 [ 2,  2],
 [ 1,  2],
 [ 0,  2],
 [-1,  2],
 [-2,  2],
 [-2,  1],
 [-2,  0],
 [-2, -1],
 [-2, -2],
 [-1, -2],
 [ 0, -2],
 [ 1, -2],
 [ 2, -2],
 [ 3, -2],
 [ 3, -1],
 [ 3,  0],
 [ 3,  1]]

var locats
var height = .25
# var Meshes = Grid.get_meshes

# import what night it is.
var night

# Ready up scene for hostile units
var FrUnitScn = preload("res://Scenes/BadNorthScene/Components/fr_units.tscn")


### Core Loop ###

func _ready():
	locats = detspawnlocs(units)
	spawnunits(locats, units)
	pass


func _process(_delta):
	pass

### Custom Functions ###

func detspawnlocs(units):
	'''Determine per night when and where enemies will spawn'''
	var Places = Array([Vector3()])
	print(units)
	for i in range(1,len(units)):#):
		var Loc = Vector3(SpiralOfLocations[i][0], height, SpiralOfLocations[i][1])
		Places.append(Loc)
	print(Places)
	return Places

func spawnunits(locs, Units):
	'''Do the act of spawning of enemies on the given times and locations'''
	var Child
	for i in range(len(Units)):
		#Instantiate and add units on the given locations. Then somehow combine the stats from the unit manager to the stats of the fr unit scene
		print(Units[i].health, Units[i].max_health, Units[i].damage)
		
		var Finstance = FrUnitScn.instantiate()
		add_child(Finstance)
		Finstance.name = "FrUnit" + "%d" %[i]
		Child = get_node(NodePath(Finstance.name))
		Child.hp = Units[i].health
		Child.dmg = Units[i].damage
		Child.position = locs[i]
		print("Position of", Finstance.name, Child.position)
		pass
	pass
