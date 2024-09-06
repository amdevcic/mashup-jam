extends Node
class_name TilemapMovement

@export var speed: float
@export var defaultSpeed: float

var moveQueue: Array[Vector2]
var currentTile: Vector2i

var moving: bool = false

signal movementFinished

func _physics_process(_delta):
	if !moving:
		return
	elif moveQueue.size() <= 0:
		moving = false
		emit_signal("movementFinished")
	elif get_parent().global_position != moveQueue[0]:
		get_parent().global_position = get_parent().global_position.move_toward(moveQueue[0], speed)
	elif moveQueue.size() > 0: #next tile in list
		moveQueue.pop_front()

func queueMovement(tiles: Array[Vector2]):
	moveQueue = tiles

func start():
	moving = true

func stop():
	moving = false
	moveQueue.clear
