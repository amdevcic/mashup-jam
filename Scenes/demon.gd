extends Node2D

@onready var ground: Ground = $"../Ground"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func getPos():
	var position: Vector2i = ground.local_to_map(global_position)
	return position
	
func move(path: Array):
	for i in range (path.size() - 1):
		position += Vector2(moveDir(path[i], path[i+1]))
		await get_tree().create_timer(0.1).timeout
	
func moveDir(point1: Vector2i, point2: Vector2i) -> Vector2i:
	var diffX = point2.x - point1.x
	var diffY = point2.y - point1.y
	
	var movementDir: Vector2i
	
	if diffX > 0 and diffY == 0:
		movementDir.x = 16
		movementDir.y = -8
	if diffX < 0 and diffY == 0:
		movementDir.x = -16
		movementDir.y = 8
	if diffX == 0 and diffY > 0:
		movementDir.x = 16
		movementDir.y = 8
	if diffX == 0 and diffY < 0:
		movementDir.x = -16
		movementDir.y = -8

	
	return movementDir

		
