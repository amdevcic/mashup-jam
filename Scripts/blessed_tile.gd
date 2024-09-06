extends Node2D

@onready var parentNode = get_node("../../..") #should be "Game"

var ground: TileMapLayer
var obstacles: TileMapLayer

@onready var blessed_sprite: Sprite2D = $BlessedSprite
@onready var cursed_sprite: Sprite2D = $CursedSprite

var angel
var demon
var soul

var posOnGrid

func _ready() -> void:
	ground = MapManager.groundMap
	obstacles = MapManager.obstaclesMap
	
	cursed_sprite.visible = false
	blessed_sprite.visible = true
	
	angel = parentNode.find_child("Angel")
	demon = parentNode.find_child("Demon")
	soul = parentNode.find_child("Soul")
	
	posOnGrid = ground.local_to_map(global_position)

func _input(event):	
	if event is InputEventKey and event.keycode == KEY_E and event.pressed and angel.isActive:
		var angelPos = ground.local_to_map(angel.global_position)
		if posOnGrid == angelPos:
			if blessed_sprite.visible: #currently blessed, change to cursed
				blessed_sprite.visible = false
				cursed_sprite.visible = true
				Signals.emit_signal('blessToCurse', posOnGrid)
				print('blessed, this should only appear once')
				
			elif cursed_sprite.visible: #currently cursed, change to blessed
				cursed_sprite.visible = false
				blessed_sprite.visible = true
				Signals.emit_signal('curseToBless', posOnGrid)
				print('cursed, this should only appear once')
				
func _physics_process(delta: float) -> void:
	if cursed_sprite.visible: #currently cursed
		if posOnGrid == ground.local_to_map(soul.global_position):
			Signals.emit_signal("soulTouchedFire")
		
	
