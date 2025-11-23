extends Node3D
class_name MapLoader

const MAP_CHUNK_PREFAB_PATH = "res://Scenes/BadNorthScene/Components/TileTypes/tile_display.tscn" 
var MapChunkPrefab = preload(MAP_CHUNK_PREFAB_PATH)

@onready var map_container: Node3D = $"../NavigationRegion3D/Virtual Nodes" 
@onready var map_timer: Timer = $MapTimer          
@onready var nav_region: NavigationRegion3D = $"../NavigationRegion3D" 

@export_group("Map Generation Settings")
@export var chunk_size: Vector2i = Vector2i(1.05, 1.05)
@export var map_rows: int = 6                 
@export var map_cols: int = 7             
@export var tile_size: float = 1.05            
@export var generation_interval: float = 1.05    

# --- 内部状态 ---
var current_row: int = 0
var current_col: int = 0
var total_chunks: int = 0

func _ready():
	if MapChunkPrefab == null:
		push_error("MapChunkPrefab failed to load. Check the path!")
		set_process(false)
		return
		
	if !is_instance_valid(map_timer):
		push_error("MapTimer (Timer node) not found!")
		set_process(false)
		return
		
	if !is_instance_valid(map_container):
		push_error("Map container (NavigationRegion3D/VirtualNodes) not found! Check the path: ../NavigationRegion3D/VirtualNodes")
		set_process(false)
		return

	total_chunks = map_rows * map_cols
	print("Starting map generation... Total chunks: ", total_chunks)
	
	map_timer.wait_time = generation_interval
	map_timer.timeout.connect(_on_map_timer_timeout) 
	
	_start_generation()

func _start_generation():
	current_row = 0
	current_col = 0
	map_timer.start()

func _on_map_timer_timeout():
	
	if current_row >= map_rows:
		_finish_generation()
		return
		
	var x_offset = float(current_col) * tile_size * chunk_size.x
	var z_offset = float(current_row) * tile_size * chunk_size.y
	
	var spawn_pos = Vector3(x_offset, 0.0, z_offset)
	
	var new_chunk = MapChunkPrefab.instantiate()
	new_chunk.global_position = spawn_pos
	
	map_container.add_child(new_chunk) 
	
	current_col += 1
	
	if current_col >= map_cols:
		current_col = 0
		current_row += 1

func _finish_generation():
	map_timer.stop()
	print("Map generation complete. Total chunks generated: ", total_chunks)
	
