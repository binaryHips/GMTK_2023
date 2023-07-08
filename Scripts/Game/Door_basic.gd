extends Node3D

@export var locked = true

@export var key_id = 0

func _ready():
	
	if locked:
		$door_body.freeze = true
		$door_body/key.show()
	


func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"pos_z" : position.z,
		
		"locked" : locked
	}
	return save_dict
