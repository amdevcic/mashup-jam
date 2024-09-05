extends Node2D
class_name Game

@export var loseScreen: CanvasLayer
@export var winScreen: CanvasLayer

@onready var characters: Array[Player] = [$Demon, $Angel]
@onready var portraits: Array[TextureRect] = [$UI/PortraitDemon, $UI/PortraitAngel]
@onready var soul: Node2D = $"Soul"

@export var levels: Array[PackedScene]
var level: Level
var currentLevelIndex: int = 0

var activeCharacterIndex = 0

var gameOver: bool = false

func _ready():
	loadLevel(currentLevelIndex)
	soul.movement.movementFinished.connect(winLevel)

func GetActiveCharacter() -> Player:
	return characters[activeCharacterIndex]

func switchCharacter():
	portraits[activeCharacterIndex].visible = false
	activeCharacterIndex = (activeCharacterIndex+1)%characters.size()
	level.activeCharacter = GetActiveCharacter()
	$Audio/Switch.play()
	portraits[activeCharacterIndex].visible = true

func nextLevel():
	if (currentLevelIndex + 1) >= levels.size():
		return
	currentLevelIndex += 1
	level.queue_free()
	loadLevel(currentLevelIndex)
	get_tree().paused = false
	winScreen.visible = false

func loadLevel(index: int) -> void:
	level = levels[index].instantiate() as Level
	add_child(level)
	level.initLevel(characters[0], characters[1], soul)	
	soul.initPath(level.soulPosition, level.soulPath, level.ground)
	soul.beginMoving()
	gameOver = false
	
func _input(event):
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_SPACE:
		switchCharacter()
	

func _physics_process(_delta):
	if !gameOver and level.isPositionObstacle(soul.global_position):
		soul.startDeath()
		gameOver = true

func winLevel():
	if !get_tree().paused:
		print("yippee")
		get_tree().paused = true
		winScreen.visible = true
		$Audio/Win.play()

func loseLevel():
	if !get_tree().paused:
		print("oh no")
		get_tree().paused = true
		loseScreen.visible = true

func restartCurrentLevel():
	level.queue_free()
	loadLevel(currentLevelIndex)
	loseScreen.visible = false
	get_tree().paused = false
