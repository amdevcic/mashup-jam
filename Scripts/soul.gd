extends Node2D

@export var movement: TilemapMovement

func beginMoving():
	movement.start()

func initPath(startPosition: Vector2i, path: Array[Vector2i], tilemap: TileMapLayer):
	var newPath: Array[Vector2]
	var pos = startPosition
	for delta: Vector2i in path:
		pos += delta
		newPath.append(tilemap.map_to_local(pos))

	movement.currentTile = startPosition
	movement.queueMovement(newPath)

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SHIFT:
			movement.speed = 1
		elif event.is_released() and event.keycode == KEY_SHIFT:
			movement.speed = 0.2
