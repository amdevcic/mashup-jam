extends Control

func StartGame():
	get_tree().change_scene_to_file("Scenes/game.tscn")

func QuitGame():
	get_tree().quit()