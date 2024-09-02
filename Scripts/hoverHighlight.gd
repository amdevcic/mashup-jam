extends Sprite2D

@onready var ground: TileMapLayer = $"../Ground"

var mousePosOnGrid
var usedRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	usedRect = ground.get_used_rect()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	mousePosOnGrid = ground.local_to_map(ground.to_local(get_global_mouse_position()))
	if usedRect.has_point(mousePosOnGrid):
		visible = true
		position = ground.map_to_local(mousePosOnGrid) - Vector2(0, 10)
	else:
		visible = false
		
