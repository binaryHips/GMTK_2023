extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	#print($text.visible_ratio)
	pass

func play_dialogue(talker_name:String, name_color:Color, text:String, length:int):
	
	#in case another dialogue took focus
	$Persistance.stop() 
	$AnimationPlayer.stop()
	$text.visible_ratio = 0
	
	
	$text.text = (
		"[center][color=#" +
		name_color.to_html(false) +
		"]"+
		
		talker_name +
		
		"[/color] \n" +
		
		text +
		
		"[/center]"
		)
	
	$AnimationPlayer.speed_scale =1.0/ (length * len(text)/150)
	$AnimationPlayer.play("Dialogue_window_animation")
	





func _on_animation_player_animation_finished(anim_name):
	if $text.visible_ratio == 1: #don't play if we're on the backwards woosh
		$Persistance.start()

func _on_persistance_timeout():
	$AnimationPlayer.speed_scale = 2.0
	$AnimationPlayer.play_backwards()
	await get_tree().create_timer(0.6).timeout #small timer to let the anim play
	DialogueManager.play_next_dialogue()
	


