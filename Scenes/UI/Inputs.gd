extends VBoxContainer



var is_in_action_listening_mode := false

var button_being_changed:Button

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for a in InputMap.get_actions():
		if InputMap.action_get_events(a).size() == 1:
			if not a.begins_with('ui'):
				create_new_mapping_button(a)



func create_new_mapping_button(action):
	var button = Button.new()
	add_child(button)
	
	button.text = (
		"'" +
		action +
		"'\n"+
		InputMap.action_get_events(action)[0].as_text()
		)
		
	button.name = action
	
	button.pressed.connect(_on_input_button_pressed)
	button.mouse_exited.connect(_on_mouse_exited)

func update_mapping_buttons():
	
	for b in get_children():
		b.text = (
			"'" +
			b.name +
			"'\n"+
			InputMap.action_get_events(b.name)[0].as_text()
			)
		b.button_pressed = false

func _on_input_button_pressed():
	#find pressed button
	var pressed:Button
	
	for b in get_children():
		if b.button_pressed:
			pressed = b
			break
	
	is_in_action_listening_mode = true
	button_being_changed = pressed
	pressed.text = (
			"'" +
			button_being_changed.name +
			"'\n"+
			"******"
			)
	
func _on_mouse_exited():
	if is_in_action_listening_mode:
		is_in_action_listening_mode = false
		update_mapping_buttons()

func _input(event):
	if is_in_action_listening_mode:
		if event is InputEventKey and event.keycode == KEY_ESCAPE:
			is_in_action_listening_mode = false
			update_mapping_buttons()
			return
			
		if event is InputEventKey or event is InputEventMouseButton:
			Settings.change_action(button_being_changed.name, event)
			is_in_action_listening_mode = false
			update_mapping_buttons()


func _on_reset_mapping_pressed():
	Settings.reset_inputs()
	update_mapping_buttons()
