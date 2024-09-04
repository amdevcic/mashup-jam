extends Node2D

@onready var parentNode = get_node("../../..") #should be "Game"

var ground: TileMapLayer
var demon
var soul
var posOnTiles

signal soulTouchedFire

func _ready() -> void:
	ground = get_tree().get_nodes_in_group('connections')[1] #should work
	demon = parentNode.find_child("Demon")
	soul = parentNode.find_child("Soul")
	
	posOnTiles = ground.local_to_map(global_position)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if posOnTiles == ground.local_to_map(demon.global_position):
		self.queue_free()
	if posOnTiles == ground.local_to_map(soul.global_position):
		emit_signal("soulTouchedFire") #TODO: connect signal to game ove
