extends Control

const OPTIONS = preload("res://Scenes/UI/Options.tscn")

func _ready():
	get_tree().paused = false
	if not FileAccess.file_exists("user://savegame.dat"):
		$Reload.disabled = true
	else:
		$Reload.disabled = false
	

func _process(delta):
	pass


func _on_resume_pressed():
	$AnimationPlayer.play("screen_fade_new_game")
	


func _on_reload_pressed():
	$AnimationPlayer.play("screen_fade")
	#checkpoint loaded from animationplayer


func _on_options_pressed():
	add_child(OPTIONS.instantiate())


func _on_quit_pressed():
	get_tree().quit()

func load_checkpoint():
	SaveManager.load_checkpoint()

func new_game():
	SaveManager.start_new_game()
