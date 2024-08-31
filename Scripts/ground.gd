class_name Ground
extends TileMapLayer

@onready var demon: Node2D = $"../Demon"
#demon init TEMP
#@onready var demonPos = Vector2i(2, 34)

@onready var astarGrid = AStarGrid2D.new()

# Called when the node enters the scene tree for the first time.


func _process(delta: float) -> void: #TODO: highlight tile where mouse is
	pass

func _ready() -> void:
	#astar init
	astarGrid.size = Vector2i(50, 50)
	astarGrid.cell_size = Vector2i(32, 32)
	astarGrid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astarGrid.update()
	
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var local_mouse_position = to_local(get_global_mouse_position()) #get pos of mouse click
		var clicked_coordinate = local_to_map(local_mouse_position)
		var demon_position = demon.getPos()
		
		print("Demon pos: ", demon_position, " Tile clicked: ", clicked_coordinate) #debug
		
		var movementPath = generatePath(demon_position, clicked_coordinate) 
		demon.move(movementPath)
		
		
func generatePath(startPos: Vector2i, endPos: Vector2i): #generate path with astar
	var path = astarGrid.get_id_path(
		startPos,
		endPos
	)
	
	print("Path: ", path) #debug
	return path

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
