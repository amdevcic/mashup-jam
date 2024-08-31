extends Node2D

@onready var ground: Ground = $"../Ground"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var directions: Dictionary = { #distance of each movement
	"UL": Vector2i(-16, -8), 
	"UR": Vector2i(16, -8), 
	"DL": Vector2i(-16, 8), 
	"DR": Vector2i(16, 8),
	}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("idle_DL")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func getPos():
	var position: Vector2i = ground.local_to_map(global_position)
	return position
	
func move(path: Array):
	var newPos
	for i in range (path.size() - 1):
		newPos = position + Vector2(directions[ 
									(moveDir(path[i], path[i+1])) 
									])
									
		match moveDir(path[i], path[i+1]): #play anim
			"UL":
				sprite.play("walk_UL")
			"UR":
				sprite.play("walk_UR")
			"DL":
				sprite.play("walk_DL")
			"DR":
				sprite.play("walk_DR")
		
		while position != newPos:
			global_position = global_position.move_toward(newPos, 2)
			await get_tree().create_timer(0.01).timeout
			
	match sprite.get_animation():
		"walk_UL":
			sprite.play("idle_UL")
		"walk_UR":
			sprite.play("idle_UR")
		"walk_DL":
			sprite.play("idle_DL")
		"walk_DR":
			sprite.play("idle_DR")
	
func moveDir(point1: Vector2i, point2: Vector2i) -> String:
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

		
