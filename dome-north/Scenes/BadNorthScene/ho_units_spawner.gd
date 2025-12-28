extends Node3D

### Vars ###

# Variables for waves
var enemies 
var spawn_count : int = 0

var SquareOfLocations = [[-8, -8],
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

# Ready up scene for hostile units
var HoUnitScn = preload("res://Scenes/BadNorthScene/Components/ho_units.tscn")

# Signals
signal all_hostile_units_defeated

### Core Loop ###

func _ready():
	locats = detspawnlocs()
	pass

func _process(_delta):
	if get_children() == null:
		emit_signal("all_hostile_units_defeated")

### Custom Functions ###

func detspawnlocs():
	'''Determine per night when and where enemies will spawn'''
	var Places = Array([Vector3()])
	for i in range(1,len(SquareOfLocations)):#):
		var Loc = Vector3(SquareOfLocations[i][0], height, SquareOfLocations[i][1])
		Places.append(Loc)
	print(Places)
	return Places
"""
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
		Child.position = locs[i]
		print("Position of", Hinstance.name, Child.position)
		pass
	pass
"""
func spawn_single_unit(unit_data):
	if locats.is_empty(): 
		locats = detspawnlocs()
	
	var pos_index = spawn_count % locats.size()
	var spawn_pos = locats[pos_index]
	spawn_count += 1
	
	var Hinstance = HoUnitScn.instantiate()
	
	Hinstance.global_position = spawn_pos
	
	add_child(Hinstance)
	
	if "hp" in Hinstance: Hinstance.hp = unit_data.health
	if "dmg" in Hinstance: Hinstance.dmg = unit_data.damage
	
	#Hinstance.global_position = spawn_pos
	print("Enemy spawned at: ", spawn_pos, " Total count: ", spawn_count)
