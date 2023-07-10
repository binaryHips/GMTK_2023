extends Node


var sens:float = 0.5
var global_volume := 1.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func reset_inputs():
	InputMap.load_from_project_settings()

func change_action(action:String, new_event:InputEvent):
	InputMap.action_erase_events(action)
	
	InputMap.action_add_event(action, new_event)


