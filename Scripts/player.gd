extends Node2D

@onready var ground: Ground = $"../Ground"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var isWalking: bool = false
var nextMovementTile
var destinationTile
var movementPath
@onready var moveIndex = 1
var direction

var directions: Dictionary = { #distance of each movement
	"UL": Vector2i(-16, -8), 
	"UR": Vector2i(16, -8), 
	"DL": Vector2i(-16, 8), 
	"DR": Vector2i(16, 8),
	}

func _ready() -> void:
	sprite.play("idle_D")

func _physics_process(delta: float):
	if !isWalking:
		return
	if global_position != nextMovementTile:
		global_position = global_position.move_toward(nextMovementTile, 1)
	
	elif moveIndex < movementPath.size() - 1: #next tile in list
		direction = moveDir(movementPath[moveIndex], movementPath[moveIndex+1])
		nextMovementTile = global_position + Vector2(directions[direction])
		
		match direction: #play anim
			"UL":
				changeAnim("walkUL")
			"UR":
				changeAnim("walkUR")
			"DL":
				changeAnim("walkDL")
			"DR":
				changeAnim("walkDR")
				
		moveIndex += 1
	
	if global_position == ground.map_to_local(destinationTile):
		isWalking = false
		movementPath = []
		moveIndex = 1
		
		match direction: #return to idle
			"UL":
				changeAnim("idleUL")
			"UR":
				changeAnim("idleUR")
			"DL":
				changeAnim("idleDL")
			"DR":
				changeAnim("idleDR")

			
			

	
func move(path: Array):
	movementPath = path
	destinationTile = path[-1]
	direction = moveDir(path[0], path[1])
	nextMovementTile = global_position + Vector2(directions[direction])

	match direction: #play anim
		"UL":
			changeAnim("walkUL")
		"UR":
			changeAnim("walkUR")
		"DL":
			changeAnim("walkDL")
		"DR":
			changeAnim("walkDR")
	
	isWalking = true #begin walk

	
func moveDir(point1: Vector2i, point2: Vector2i) -> String: #return which direction the next movement is
	var diffX = point2.x - point1.x
	var diffY = point2.y - point1.y
	
	var movementDir: Vector2i
	var dir: String
	
	if diffX > 0 and diffY == 0:
		dir = "UR"
	if diffX < 0 and diffY == 0:
		dir = "DL"
	if diffX == 0 and diffY > 0:
		dir = "DR"
	if diffX == 0 and diffY < 0:
		dir = "UL"

	return dir
	
	
func changeAnim(animName):
	match animName:
		"walkUL", "walkUR":
			sprite.play("walk_U")
		"walkDL", "walkDR":
			sprite.play("walk_D")
		"idleUL", "idleUR":
			sprite.play("idle_U")
		"idleDL", "idleDR":
			sprite.play("idle_D")
	match animName:
		"walkUL", "walkDL", "idleUL", "idleDL":
			sprite.flip_h = true
		"walkUR", "walkDR", "idleUR", "idleDR":
			sprite.flip_h = false
	return
	

		
