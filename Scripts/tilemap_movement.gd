extends Node
class_name TilemapMovement

@export var speed: float

var moveQueue: Array[Vector2i]
var currentTile: Vector2i

var tilesize=Vector2i(32, 16)

func moveOnMap(tilemap: TileMapLayer):
    if moveQueue.size() == 0:
        return
	
    var pos = moveQueue.pop_front()
    var tween = create_tween().bind_node(get_parent())
    tween.tween_property(get_parent(), "position", Vector2(tilemap.map_to_local(pos)), 1.0)
    tween.tween_callback(moveOnMap.bind(tilemap))

func queueMovement(tiles: Array[Vector2i]):
    moveQueue = tiles
