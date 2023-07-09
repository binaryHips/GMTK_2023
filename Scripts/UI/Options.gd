extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$sens.value = Settings.sens
	$volume.value = Settings.global_volume
	
	$sens/sens_text.text = "[center]mouse sensivity \n" + str($sens.value) + "[/center]"

	$volume/volume_text.text = "[center]volume \n" + str($volume.value) + "[/center]"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_go_back_pressed():
	#get_parent().visible = true
	queue_free()


func _on_sens_value_changed(value):
	Settings.sens = value
	$sens/sens_text.text = "[center]mouse sensivity \n" + str(value) + "[/center]"



func _on_volume_value_changed(value):
	Settings.global_volume = value
	$volume/volume_text.text = "[center]volume \n" + str(value) + "[/center]"
