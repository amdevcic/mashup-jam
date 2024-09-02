extends Node2D
class_name Level

var activeCharacter: Player

@export var angelPosition: Vector2i
@export var demonPosition: Vector2i

@onready var astarGrid = AStarGrid2D.new()
@onready var ground: TileMapLayer = $"Ground"

func _ready() -> void:
	#astar init
	var used_rect := ground.get_used_rect()
	astarGrid.region = used_rect
	astarGrid.cell_shape = 1 #CELL_SHAPE_ISOMETRIC_RIGHT 
	astarGrid.cell_size = Vector2i(32, 32)
	astarGrid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	
	astarGrid.update()
	#TODO: iterate through tilemaplayers, set obstacles as astarGrid.set_point_solid(vector, false)
	var tileData
	var layers = get_children()
	
	for x in range(astarGrid.region.position[0], astarGrid.region.end[0]): #iterate through each tile of ground
		for y in range(astarGrid.region.position[1], astarGrid.region.end[1]):
			for layer in layers:
				if layer is TileMapLayer:
					tileData = layer.get_cell_tile_data(Vector2i(x, y))
					
					if tileData != null:
						if tileData.get_navigation_polygon(0) == null:
							astarGrid.set_point_solid(Vector2i(x, y))

	astarGrid.update()	

func initLevel(demon: Player, angel: Player):
	activeCharacter = demon
	angel.global_position = ground.map_to_local(angelPosition)
	demon.global_position = ground.map_to_local(demonPosition)
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var local_mouse_position = ground.to_local(get_global_mouse_position()) #get pos of mouse click
		var clicked_coordinate = ground.local_to_map(local_mouse_position)
		var demon_position = ground.local_to_map(activeCharacter.global_position)
		
		print("Demon pos on grid: ", demon_position, " Demon pos in world: ", activeCharacter.global_position, " Tile clicked: ", clicked_coordinate) #debug
		
		var movementPath = generatePath(demon_position, clicked_coordinate)
			
		print('path: ', movementPath) #debug
		if !activeCharacter.isWalking and movementPath.size() > 1:
			activeCharacter.move(movementPath)
		
func snapActiveCharacterToGrid():
	activeCharacter.global_position = ground.map_to_local(ground.local_to_map(activeCharacter.global_position))
		
func generatePath(startPos: Vector2i, endPos: Vector2i): #generate path with astar
	return astarGrid.get_id_path(
		startPos,
		endPos,
		true
	)
