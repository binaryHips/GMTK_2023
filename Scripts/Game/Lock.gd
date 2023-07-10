extends RigidBody3D

@export var lock_ID := 0


@export var trigger_dialogue = false
@export var Dialogue_line_name = ""
@export var Speaker_name = ""
@export var Speaker_Color = Color.BLUE_VIOLET
@export var priority := 10



func interact():
	
	GameMaster.acquired_keys.append(lock_ID)
	
	if trigger_dialogue:
		DialogueManager.queue_dialogue(Dialogue_line_name, Speaker_name, Speaker_Color, priority)
	
	
	
	queue_free()


func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"pos_z" : position.z,
		
		"lock_ID" : lock_ID,
		"trigger_dialogue" : trigger_dialogue,
		"Dialogue_line_name" : Dialogue_line_name,
		"Speaker_name" : Speaker_name,
		"Speaker_Color" : Speaker_Color,
		"priority" : priority,
	}
	return save_dict
