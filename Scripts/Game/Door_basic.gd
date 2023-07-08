extends Node3D

@export var locked = true

@export var key_id = 0

func _ready():
	
	if locked:
		$door_body.freeze = true
		$door_body/key.show()
	
