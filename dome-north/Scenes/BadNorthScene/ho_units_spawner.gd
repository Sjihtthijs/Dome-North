extends Node3D

### Vars ###

# Variables for waves
var enemies = 

# Initialize locations
#var SpiralOfLocations = [[ 0,  1,  1,  0, -1, -1, -1,  0,  1,  2,  2,  2,  2,  1,  0, -1, -2, -2, -2, -2, -2, -1,  0,  1,
#   2,  3,  3,  3,  3],
# [ 0,  0,  1,  1,  1,  0, -1, -1, -1, -1,  0,  1,  2,  2,  2,  2,  2,  1,  0, -1, -2, -2, -2, -2,
#  -2, -2, -1,  0,  1]]

var SpiralOfLocations = [[-8, -8],
 [-6, -8],
 [-4, -8],
 [-2, -8],
 [ 0, -8],
 [ 2, -8],
 [ 4, -8],
 [ 6, -8],
 [ 8, -8],
 [ 8, -6],
 [ 8, -4],
 [ 8, -2],
 [ 8,  0],
 [ 8,  2],
 [ 8,  4],
 [ 8,  6],
 [ 8,  8],
 [ 6,  8],
 [ 4,  8],
 [ 2,  8],
 [ 0,  8],
 [-2,  8],
 [-4,  8],
 [-6,  8],
 [-8,  8],
 [-8,  6],
 [-8,  4],
 [-8,  2],
 [-8,  0],
 [-8, -2],
 [-8, -4],
 [-8, -6],]

var locats
var height = .25
# var Meshes = Grid.get_meshes

# import what night it is.
var night

# Ready up scene for hostile units
var HoUnitScn = preload("res://Scenes/BadNorthScene/Components/ho_units.tscn")


### Core Loop ###

func _ready():
	locats = detspawnlocs()
	pass


func _process(_delta):
	spawnunits(locats, enemies)

### Custom Functions ###

func detspawnlocs():
	'''Determine per night when and where enemies will spawn'''
	var Places = Array([Vector3()])
	for i in range(1,len(SpiralOfLocations)):#):
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
		
		var Hinstance = HoUnitScn.instantiate()
		add_child(Hinstance)
		Hinstance.name = "FrUnit" + "%d" %[i]
		Child = get_node(NodePath(Hinstance.name))
		Child.hp = Units[i].health
		Child.dmg = Units[i].damage
		Child.position = locs[i]
		print("Position of", Hinstance.name, Child.position)
		pass
	pass
