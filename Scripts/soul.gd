extends Node2D

@export var movement: TilemapMovement

func beginMoving(level):
	movement.moveOnMap(level)

func initPath(startPosition: Vector2i, path: Array[Vector2i]):
	var newPath: Array[Vector2i]
	var pos = startPosition
	for delta: Vector2i in path:
		var length = delta.length()
		for i in range(length):
			pos += delta/int(length)
			newPath.append(pos)

	movement.currentTile = startPosition
	movement.queueMovement(newPath)