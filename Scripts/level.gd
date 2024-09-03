@tool

extends Node2D
class_name Level

var activeCharacter: Player

@export var angelPosition: Vector2i
@export var demonPosition: Vector2i
@export var soulPosition: Vector2i
@export var soulPath: Array[Vector2i]:
	set(value):
		soulPath=value
		queue_redraw()

@onready var astarGrid = AStarGrid2D.new()
@onready var ground: TileMapLayer = $"Ground"

func _draw():
	var currentPos: Vector2i = soulPosition
	for line in soulPath:
		draw_line(ground.map_to_local(currentPos), ground.map_to_local(currentPos+line), Color.GREEN, 2.0)
		currentPos += line

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	#astar init
	var used_rect := ground.get_used_rect()
	astarGrid.region = used_rect
	astarGrid.cell_shape = 1 #CELL_SHAPE_ISOMETRIC_RIGHT 
	astarGrid.cell_size = Vector2i(32, 32)
	astarGrid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	
	astarGrid.update()
	#TODO: iterate through tilemaplayers, set obstacles as astarGrid.set_point_solid(vector, false)
	var tileData: TileData
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

func initLevel(demon: Player, angel: Player, soul: Node2D):
	activeCharacter = demon
	angel.global_position = ground.map_to_local(angelPosition)
	demon.global_position = ground.map_to_local(demonPosition)
	soul.global_position = ground.map_to_local(soulPosition)
	
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

func getGlobalPositionFromTile(tile: Vector2i):
	return ground.map_to_local(tile)

func isPositionObstacle(pos: Vector2):
	var mappos = ground.local_to_map(pos)
	return astarGrid.is_point_solid(mappos)