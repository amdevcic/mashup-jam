extends Node2D

@onready var parentNode = get_node("../../..") #should be "Game"

var ground: TileMapLayer

var demon
var angel
var posOnTiles


func _ready() -> void:
	ground = get_tree().get_nodes_in_group('connections')[1] #should work
	demon = parentNode.find_child("Demon")
	angel = parentNode.find_child("Angel")
	
	posOnTiles = ground.local_to_map(global_position)
	
	


func _input(event):	
	if event is InputEventKey and event.keycode == KEY_E and event.pressed: #if demon next to, play little anim and destroy
		var surrounding = ground.get_surrounding_cells(posOnTiles)
		if ground.local_to_map(demon.global_position) in surrounding:
			#TODO: play demon burst animation
			self.queue_free()
			Signals.emit_signal('towerDestroyed')
			print("rip bozo")
			
			
		
