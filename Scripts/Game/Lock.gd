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
