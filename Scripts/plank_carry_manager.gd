extends Node2D

@onready var parentNode = get_node("../..") #should be "Game"
@onready var plank: Sprite2D = $"../Plank"
@onready var angel: Player = $".."

var layers
@onready var isHolding: bool = false

var groundLayer
var planksLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	plank.visible = false
	pass # Replace with function body.
	
func getGroundTilemap(tilemaps: Array[TileMapLayer]):
	layers = tilemaps #get all tilemaplayers in order, 0 should be ground
	if layers.size() > 2:
		groundLayer = layers[0]
		planksLayer = layers[2]
	print(layers)
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event):	
	if event is InputEventKey and event.keycode == KEY_E and event.pressed: #interact
		var angelPos = groundLayer.local_to_map(angel.global_position)
		if !isHolding:
			if planksLayer.get_cell_alternative_tile(angelPos) != -1: #plank on that tile
				print("on board")
				planksLayer.set_cell(angelPos, 1, Vector2i(9, 7))
				plank.visible = true
				isHolding = true
				pass
		
		else:
			if layers[2].get_cell_alternative_tile(angelPos) == -1: #no plank on that tile
				print("setting down")
				planksLayer.set_cell(angelPos, 0, Vector2i(0, 0))
				plank.visible = false
				isHolding = false
