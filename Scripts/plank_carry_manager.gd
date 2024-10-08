extends Node2D

@onready var plank: Sprite2D = $"../Plank"
@onready var bottle: Sprite2D = $"../Bottle"

@onready var angel: Player = $".."

var groundLayer: TileMapLayer
var planksLayer: TileMapLayer

var demonGrid: AStarGrid2D
var angelGrid: AStarGrid2D

@onready var isHoldingPlank: bool = false
@onready var isHoldingBottle: bool = false

signal plankMoved

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	plank.visible = false
	bottle.visible = false
	pass # Replace with function body.
		
func getGroundTilemap(tilemaps: Array[TileMapLayer]):
	if tilemaps.size() > 1: #get all tilemaplayers in order, 0 should be ground
		groundLayer = tilemaps[0]
		planksLayer = tilemaps[1]
	return
	
func getAStarGrids(grids: Array[AStarGrid2D]):
	demonGrid = grids[0] #get astar grids for both chars
	angelGrid = grids[1]
	return

func resetHolding():
	plank.visible = false
	bottle.visible = false
	isHoldingBottle = false
	isHoldingPlank = false

	
func _input(event):	
	if event is InputEventKey and event.keycode == KEY_E and event.pressed and angel.isActive: #interact #TODO: and angel is active and demon not on tile
		var angelPos = groundLayer.local_to_map(angel.global_position)
		if not isHoldingPlank and not isHoldingBottle:
			if planksLayer.get_cell_alternative_tile(angelPos) == 0: #plank on that tile
				planksLayer.erase_cell(angelPos)
				plank.visible = true
				isHoldingPlank = true
				$PickupSound.play()
				emit_signal("plankMoved")
				
			elif planksLayer.get_cell_alternative_tile(angelPos) == 3: #holy water on that tile
				planksLayer.erase_cell(angelPos)
				bottle.visible = true
				isHoldingBottle = true
				$PickupSound.play()
		
		else:
			if isHoldingPlank:	
				if planksLayer.get_cell_alternative_tile(angelPos) == -1: #nothing on that tile
					planksLayer.set_cell(angelPos, 0, Vector2i(0, 0), 0)
					plank.visible = false
					isHoldingPlank = false
					$PlaceSound.play()
					emit_signal("plankMoved")
					
			elif isHoldingBottle:
				if planksLayer.get_cell_alternative_tile(angelPos) == -1: #nothing on that tile
					planksLayer.set_cell(angelPos, 0, Vector2i(0, 0), 3)
					bottle.visible = false
					isHoldingBottle = false
					$PlaceSound.play()
					
				elif planksLayer.get_cell_alternative_tile(angelPos) == 4: #thorns on that tile
					print('on thorns with bottle')
					planksLayer.set_cell(angelPos, 0, Vector2i(0, 0), 5) #change to flowers
					bottle.visible = false
					isHoldingBottle = false


		
