extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("new_animation")
	print("YERS")


func load_save():
	SaveManager.load_checkpoint()
