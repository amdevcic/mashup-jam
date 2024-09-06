extends Node2D

@onready var thorns_sprite: Sprite2D = $ThornsSprite
@onready var parentNode = get_node("../../..") #should be "Game"
var soul
var ground: TileMapLayer
var posOnTiles

func _ready() -> void:
	ground = MapManager.groundMap #should work
	soul = parentNode.find_child("Soul")
	posOnTiles = ground.local_to_map(global_position)
	

func _physics_process(delta: float) -> void:
	if posOnTiles == ground.local_to_map(soul.global_position):
		Signals.emit_signal("soulTouchedFire") #game over if soul touches thorns
