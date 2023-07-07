extends Control

func _ready():
	GameMaster.pause_menue = self
	Input.use_accumulated_input = false

func _on_resume_pressed():
	GameMaster.toggle_pause(false)


func _on_reload_pressed():
	print("reload save!")


func _on_options_pressed():
	print("options!")


func _on_quit_pressed():
	get_tree().quit()


func _input(event):
	if event.is_action_released("menue"):
		
		
		GameMaster.toggle_pause(false)
		
		
