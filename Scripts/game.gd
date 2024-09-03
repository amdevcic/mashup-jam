extends Node2D

@onready var characters: Array[Player] = [$"Demon", $"Angel"]

@export var levels: Array[PackedScene]
var level: Level
var currentLevelIndex: int = 0

@onready var characterLabel: Label = $"UI/Label"
var activeCharacterIndex = 0

func _ready():
	loadLevel(currentLevelIndex)
	characterLabel.text = GetActiveCharacter().name

func GetActiveCharacter() -> Player:
	return characters[activeCharacterIndex]

func switchCharacter():
	activeCharacterIndex = (activeCharacterIndex+1)%characters.size()
	characterLabel.text = GetActiveCharacter().name
	level.activeCharacter = GetActiveCharacter()

func nextLevel():
	if (currentLevelIndex + 1) >= levels.size():
		return
	currentLevelIndex += 1
	level.queue_free()
	loadLevel(currentLevelIndex)

func loadLevel(index: int) -> void:
	level = levels[index].instantiate() as Level
	add_child(level)
	level.initLevel(characters[0], characters[1])
