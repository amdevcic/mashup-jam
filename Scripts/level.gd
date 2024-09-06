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
@onready var astarGridAngel = AStarGrid2D.new()
@onready var ground: TileMapLayer = $"Ground"
@onready var obstacles: TileMapLayer = $Obstacles

var layers: Array[TileMapLayer]



func _draw():
	var currentPos: Vector2i = soulPosition
	for line in soulPath:
		draw_line(ground.map_to_local(currentPos), ground.map_to_local(currentPos+line), Color.GREEN, 2.0)
		currentPos += line

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	MapManager.groundMap = ground
	MapManager.obstaclesMap = obstacles
	
	#astar init
	var used_rect := ground.get_used_rect()
	for grid in [astarGrid, astarGridAngel]:
		grid.region = used_rect
		grid.cell_shape = 1 #CELL_SHAPE_ISOMETRIC_RIGHT 
		grid.cell_size = Vector2i(32, 32)
		grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
		grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
		
	astarGrid.update()
	astarGridAngel.update()	
	
	updateDemonAstar()
	updateAngelAstar()
	
	var plankCarryNode = get_tree().get_nodes_in_group('connections')[0] #should work
	plankCarryNode.plankMoved.connect(_on_plank_move) #connect signal to function
	print(get_tree().get_nodes_in_group('connections'))
	
	Signals.towerDestroyed.connect(_on_tower_destroyed)
	Signals.blessToCurse.connect(_on_bless_flipped)
	Signals.curseToBless.connect(_on_curse_flipped)
	

func initLevel(demon: Player, angel: Player, soul: Node2D):
	activeCharacter = demon
	angel.global_position = ground.map_to_local(angelPosition)
	demon.global_position = ground.map_to_local(demonPosition)
	soul.global_position = ground.map_to_local(soulPosition)
	
	var plankManager = angel.get_node('CarryManager') #send tile data to plank manager
	plankManager.getGroundTilemap(layers)
	var gr: Array[AStarGrid2D] = [astarGrid, astarGridAngel] #send astar data to plank manager
	plankManager.getAStarGrids(gr)
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed: #movement
		var local_mouse_position = ground.to_local(get_global_mouse_position()) #get pos of mouse click
		var clicked_coordinate = ground.local_to_map(local_mouse_position)
		var demon_position = ground.local_to_map(activeCharacter.global_position)
		
		print("Demon pos on grid: ", demon_position, " Demon pos in world: ", activeCharacter.global_position, " Tile clicked: ", clicked_coordinate) #debug
		
		var movementPath = generatePath(demon_position, clicked_coordinate, activeCharacter)
			
		print('path: ', movementPath) #debug
		if !activeCharacter.isWalking and movementPath.size() > 1:
			activeCharacter.move(movementPath)
			
		
func snapActiveCharacterToGrid():
	activeCharacter.global_position = ground.map_to_local(ground.local_to_map(activeCharacter.global_position))
		
func generatePath(startPos: Vector2i, endPos: Vector2i, activeCharacter: Player): #generate path with astar
	if activeCharacter.name == "Angel":
		return astarGridAngel.get_id_path(
			startPos,
			endPos,
			true
		)
	else:
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
		
func duplicateAstar(grid: AStarGrid2D):
	var temp = grid
	return temp
	
func updateDemonAstar():
	var tileData: TileData
	var atlasCoords: Vector2i #for scene tiles
	var altTileData: int
	
	for c in get_children(): #list of tilemaplayers
		if c is TileMapLayer:
			layers.append(c)
						
	for x in range(astarGrid.region.position[0], astarGrid.region.end[0]): #iterate through each tile of ground
		for y in range(astarGrid.region.position[1], astarGrid.region.end[1]):
			for layer in layers:
				tileData = layer.get_cell_tile_data(Vector2i(x, y))
				atlasCoords = layer.get_cell_atlas_coords(Vector2i(x, y))
				altTileData = obstacles.get_cell_alternative_tile(Vector2i(x, y))
				
				if layer.name == 'Ground':						
					if tileData != null and (layer as TileMapLayer).get_navigation_map():
						if tileData.get_navigation_polygon(0) == null:
							astarGrid.set_point_solid(Vector2i(x, y))
			
				elif layer.name == "Obstacles":
					match altTileData:
						0: #check for plank
							astarGrid.set_point_solid(Vector2i(x, y), false)
						2: #check for tower
							astarGrid.set_point_solid(Vector2i(x, y))
						6: #check for blessed
							astarGrid.set_point_solid(Vector2i(x, y), false	)
							
					
	astarGrid.update()
	

func updateAngelAstar():
	var tileData: TileData
	var altTileData: int #ID in scenes tileset
	
	for x in range(astarGridAngel.region.position[0], astarGridAngel.region.end[0]):
		for y in range(astarGridAngel.region.position[1], astarGridAngel.region.end[1]):
			altTileData = obstacles.get_cell_alternative_tile(Vector2i(x, y))
			
			if altTileData == 2:
				print('angel sees tower at: ', Vector2i(x, y))
				for i in range(x-2, x+3):
					for j in range(y-2, y+3):
						if not(i == x-2 and j == y-2) and not(i == x+2 and j == y+2) and not(i == x-2 and j == y+2) and not(i == x+2 and j == y-2): #5x5 except corners
							astarGridAngel.set_point_solid(Vector2i(i, j))

	astarGridAngel.update()
	
func _on_plank_move():
	updateDemonAstar()
	
func _on_tower_destroyed(towerPos):
	var x = towerPos.x
	var y = towerPos.y
	astarGrid.set_point_solid(Vector2i(x, y), false)
	astarGrid.update()
	
	for i in range(x-2, x+3):
		for j in range(y-2, y+3):
			if not(i == x-2 and j == y-2) and not(i == x+2 and j == y+2) and not(i == x-2 and j == y+2) and not(i == x+2 and j == y-2): #5x5 except corners
				astarGridAngel.set_point_solid(Vector2i(i, j), false)
	updateAngelAstar()
	
func _on_bless_flipped(tilePos):
	var x = tilePos.x
	var y = tilePos.y
	
	astarGrid.set_point_solid(Vector2i(x, y), false)
	astarGrid.update()
	
func _on_curse_flipped(tilePos):
	var x = tilePos.x
	var y = tilePos.y
	
	astarGrid.set_point_solid(Vector2i(x, y))
	astarGrid.update()
	
