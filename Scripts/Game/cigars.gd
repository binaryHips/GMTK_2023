extends RigidBody3D

@export var heal := 50


@export var trigger_dialogue = false
@export var dialogue_line_name = ""
@export var speaker_name = ""
@export var speaker_Color = Color.BLUE_VIOLET
@export var priority := 10



func interact():
	
	GameMaster.player.heal(heal)
	
	if trigger_dialogue:
		DialogueManager.queue_dialogue(dialogue_line_name, speaker_name, speaker_Color, priority)
	
	
	
	queue_free()

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"pos_z" : position.z,
		
		"heal" : heal,
		"trigger_dialogue" : trigger_dialogue,
		"dialogue_line_name" : dialogue_line_name,
		"speaker_name" : speaker_name,
		"speaker_Color" : speaker_Color,
		"priority" : priority,
	}
	return save_dict
