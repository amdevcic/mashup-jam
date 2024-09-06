extends Node2D

@onready var parentNode = get_node("../../..") #should be "Game"

var ground: TileMapLayer
var obstacles: TileMapLayer
var demon
var soul
var posOnTiles

func _ready() -> void:
	ground = MapManager.groundMap
	obstacles = MapManager.obstaclesMap
	demon = parentNode.find_child("Demon")
	soul = parentNode.find_child("Soul")
	
	posOnTiles = ground.local_to_map(global_position)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if posOnTiles == ground.local_to_map(demon.global_position):
		obstacles.erase_cell(posOnTiles)
	if posOnTiles == ground.local_to_map(soul.global_position):
		parentNode.killSoul()
