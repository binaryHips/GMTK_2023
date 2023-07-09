extends Node

#attributes

var player:CharacterBody3D

var interface:Control
var pause_menue:Control

var game_paused := false
var game_lost := false


func game_over(cause:int = 0):
	print("gameover!!!")
	game_lost = true
	get_tree().paused = true
	print("perdu")

func game_won():
	pass
	

func _process(delta):
	pass


func toggle_pause(state:bool):
	if game_lost: return
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




## player

var acquired_keys = []



