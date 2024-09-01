extends Node2D

@onready var characters: Array[Player] = [$"Demon", $"Angel"]
@onready var level: Level = $"Level"

@onready var characterLabel: Label = $"UI/Label"
var activeCharacterIndex = 0

func _ready():
	characterLabel.text = GetActiveCharacter().name
	level.activeCharacter = GetActiveCharacter()

func GetActiveCharacter() -> Player:
	return characters[activeCharacterIndex]

func switchCharacter():
	activeCharacterIndex = (activeCharacterIndex+1)%characters.size()
	characterLabel.text = GetActiveCharacter().name
	level.activeCharacter = GetActiveCharacter()