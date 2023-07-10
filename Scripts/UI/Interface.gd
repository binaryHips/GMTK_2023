extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	GameMaster.interface = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_lifebar(n):
	$Lifebar.value = n
