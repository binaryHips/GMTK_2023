extends Control

func _ready():
	GameMaster.pause_menue = self
	Input.use_accumulated_input = false

func _on_visibility_changed():
	if visible:
		
		if not FileAccess.file_exists("user://savegame.json"):
			$Reload.disabled = true
		else:
			$Reload.disabled = false



func _on_resume_pressed():
	GameMaster.toggle_pause(false)


func _on_reload_pressed():
	$AnimationPlayer.play("screen_fade")
	


func _on_options_pressed():
	print("options!")


func _on_quit_pressed():
	get_tree().quit()


func _input(event):
	if event.is_action_released("menue"):
		
		GameMaster.toggle_pause(false)

func load_checkpoint():
	SaveManager.load_checkpoint()
