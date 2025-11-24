extends Node2D

# Ratios

@onready var ratio_Gold = 7
@onready var ratio_Iron = 15
@onready var ratio_Normal = 78

# Scenes

var Gold = preload("res://Scenes/DomeKeeperScene/Breakable Tile Objects/resource_a.tscn")
var Iron = preload("res://Scenes/DomeKeeperScene/Breakable Tile Objects/resource_b.tscn")
var Normal = preload("res://Scenes/DomeKeeperScene/Breakable Tile Objects/breakable_mine_tiles.tscn")


func _ready():
	var grid = generate_grid(10,10)
	print(grid)
	spawn_blocks(grid)

func generate_grid(width: int, height: int):
	var grid = Array()
	for x in range(width):
		var row = []
		for y in range(height):
			var xy
			var rand = randf()
			if rand < ratio_Gold/100.0:
				xy = 0
			elif rand < ratio_Iron/100.0:
				xy = 1
			else:
				xy = 2
			row.append(xy)  # Randomly place walls (1) and floors (0)
		grid.append(row)
	return grid

func spawn_blocks(grid: Array):
	# Instantiate blocks
	var GInst = Gold.instantiate()
	var IInst = Iron.instantiate()
	var NInst = Normal.instantiate()
	
	# Loop over grid to create the children and place them
	var width = len(grid[0])
	var height = len(grid)
	for x in range(width):
		for y in range(height):
			var Btype = grid[x][y]
			if Btype == 0:
				add_child(GInst)
				GInst.position = Vector2(GInst.position.x + 16*x, GInst.position.y + 16*y)
			elif Btype == 1:
				add_child(IInst)
				IInst.position = Vector2(IInst.position.x + 16*x, IInst.position.y + 16*y)
			else:
				NInst.position = Vector2(NInst.position.x + 16*x, NInst.position.y + 16*y)
				add_child(NInst)
			
	pass
