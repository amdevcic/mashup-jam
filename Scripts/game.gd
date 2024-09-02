extends Node2D

@onready var characters: Array[Player] = [$"Demon", $"Angel"]
@onready var level: Level = $"Level"

@onready var characterLabel: Label = $"UI/Label"
var activeCharacterIndex = 0

func _ready():
	characterLabel.text = GetActiveCharacter().name
	level.activeCharacter = GetActiveCharacter()
	level.snapActiveCharacterToGrid()

func GetActiveCharacter() -> Player:
	return characters[activeCharacterIndex]

func switchCharacter():
	activeCharacterIndex = (activeCharacterIndex+1)%characters.size()
	characterLabel.text = GetActiveCharacter().name
	level.activeCharacter = GetActiveCharacter()
	level.snapActiveCharacterToGrid()

func nextLevel():
	var newLevel: PackedScene = load("res://Scenes/level2.tscn")
	level.queue_free()
	level = newLevel.instantiate() as Level
	print(level.name)
	level.activeCharacter = GetActiveCharacter()
