extends Node2D
class_name Game

@export var loseScreen: CanvasLayer
@export var winScreen: CanvasLayer

@onready var characters: Array[Player] = [$"Demon", $"Angel"]
@onready var soul: Node2D = $"Soul"

@export var levels: Array[PackedScene]
var level: Level
var currentLevelIndex: int = 0

@onready var characterLabel: Label = $"UI/Label"
var activeCharacterIndex = 0

var gameOver: bool = false

func _ready():
	loadLevel(currentLevelIndex)
	characterLabel.text = GetActiveCharacter().name
	soul.movement.movementFinished.connect(winLevel)
	Signals.soulTouchedFire.connect(loseLevel)

func GetActiveCharacter() -> Player:
	return characters[activeCharacterIndex]

func switchCharacter():
	GetActiveCharacter().isActive = false
	
	activeCharacterIndex = (activeCharacterIndex+1)%characters.size()
	characterLabel.text = GetActiveCharacter().name
	level.activeCharacter = GetActiveCharacter()
	$Audio/Switch.play()
	
	GetActiveCharacter().isActive = true

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
