extends Node2D

@onready var parentNode = get_node("../../..") #should be "Game"

var ground: TileMapLayer
var obstacles: TileMapLayer

var angel
var demon
var soul

var posOnGrid

func _ready() -> void:
	ground = MapManager.groundMap
	obstacles = MapManager.obstaclesMap
	
	angel = parentNode.find_child("Angel")
	demon = parentNode.find_child("Demon")
	soul = parentNode.find_child("Soul")
	
	posOnGrid = ground.local_to_map(global_position)

func _input(event):	
	if event is InputEventKey and event.keycode == KEY_E and event.pressed and angel.isActive:
		var angelPos = ground.local_to_map(angel.global_position)
		if obstacles.get_cell_alternative_tile(angelPos) == 7: #on cursed tile
			obstacles.erase_cell(angelPos)
			obstacles.set_cell(angelPos, 0, Vector2i(0, 0), 6) #change to blessed tile
			Signals.emit_signal('curseToBless', posOnGrid)
			print('cursed, this should only appear once')
		
#func _physics_process(delta: float) -> void:
	#if posOnGrid == ground.local_to_map(soul.global_position):
		#Signals.emit_signal("soulTouchedFire", posOnGrid)
	
