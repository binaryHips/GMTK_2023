extends Node

#attributes

var player:CharacterBody3D

var pause_menue:Control
var game_paused := false

func game_over():
	pass

func game_won():
	pass
	


func toggle_pause(state:bool):
	if !state:
		
		pause_menue.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().paused = false
		game_paused = false
	else:
		
		pause_menue.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		game_paused = true


