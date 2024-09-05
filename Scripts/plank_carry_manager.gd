extends Node2D

@onready var plank: Sprite2D = $"../Plank"
@onready var angel: Player = $".."

var groundLayer: TileMapLayer
var planksLayer: TileMapLayer

var demonGrid: AStarGrid2D
var angelGrid: AStarGrid2D

@onready var isHolding: bool = false

signal plankMoved

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	plank.visible = false
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event):	
	if event is InputEventKey and event.keycode == KEY_E and event.pressed and angel.isActive: #interact #TODO: and angel is active and demon not on tile
		var angelPos = groundLayer.local_to_map(angel.global_position)
		if !isHolding:
			if planksLayer.get_cell_atlas_coords(angelPos) == Vector2i(0, 0): #plank on that tile
				planksLayer.erase_cell(angelPos)
				plank.visible = true
				isHolding = true
				$PickupSound.play()
		
		else:
			if planksLayer.get_cell_atlas_coords(angelPos) != Vector2i(0, 0): #no plank on that tile
				planksLayer.set_cell(angelPos, 0, Vector2i(0, 0))
				plank.visible = false
				isHolding = false
				$PlaceSound.play()

		emit_signal("plankMoved")
		
