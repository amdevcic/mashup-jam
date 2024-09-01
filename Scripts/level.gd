extends Node2D
class_name Level

@export var activeCharacter: Node2D
@onready var astarGrid = AStarGrid2D.new()
@onready var ground: TileMapLayer = $"Ground"

func _ready() -> void:
	#snap player to tile
	activeCharacter.global_position = ground.map_to_local(ground.local_to_map(activeCharacter.global_position))
	#astar init
	astarGrid.size = Vector2i(50, 50)
	astarGrid.cell_size = Vector2i(32, 32)
	astarGrid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astarGrid.update()
	
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var local_mouse_position = ground.to_local(get_global_mouse_position()) #get pos of mouse click
		var clicked_coordinate = ground.local_to_map(local_mouse_position)
		var demon_position = ground.local_to_map(activeCharacter.global_position)
		
		# print("Demon pos on grid: ", demon_position, " Demon pos in world: ", activeCharacter.global_position, " Tile clicked: ", clicked_coordinate) #debug
		
		var movementPath = generatePath(demon_position, clicked_coordinate) 
		if !activeCharacter.isWalking and movementPath.size() > 1:
			activeCharacter.move(movementPath)
		
		
func generatePath(startPos: Vector2i, endPos: Vector2i): #generate path with astar
	return astarGrid.get_id_path(
		startPos,
		endPos
	)
