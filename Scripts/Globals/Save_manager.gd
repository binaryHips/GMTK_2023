extends Node

const LEVELS = [
	preload("res://Scenes/Levels/Blocking/level_1_0.tscn"),
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func save_checkpoint(exclude):
	var save_game = FileAccess.open(str("user://savegame.dat"), FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persistant")
	
	var level = get_tree().get_root().get_node("/root/GAME_level")
	
	var json_string = JSON.stringify(
		{
		"filename" : level.get_scene_file_path(),
		"parent" : level.get_parent().get_path(),
		"pos_x" : level.position.x,
		"pos_y" : level.position.y,
		"pos_z" : level.position.z,
		"name" : level.name,
		}
	)
	
	save_game.store_line(json_string)
	
	for node in save_nodes:
		
		if node == exclude: ## don't save the checkpoint that was used for the save!
			continue
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(json_string)

func load_checkpoint():
	
	if get_tree().get_root().get_node("root/menue_cam") != null:
		get_tree().get_root().get_node("root/menue_cam").queue_free()
	
	
	var level = get_tree().get_root().get_node("/root/root/GAME_level")
	
	
	
	if not FileAccess.file_exists("user://savegame.dat"):
		print("can't access save file!")
		return # Error! We don't have a save to load.
	
	var save_game = FileAccess.open("user://savegame.dat", FileAccess.READ)
	
	if level:
		level.queue_free()
	
	
	var save_nodes = get_tree().get_nodes_in_group("Persistant")
	for i in save_nodes:
		i.queue_free()


	#setup level first to clear it.
	var json_string = save_game.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	var node_data = json.get_data()
	# Firstly, we need to create the object and add it to the tree and set its position.
	var new_object = load(node_data["filename"]).instantiate()
	get_node(node_data["parent"]).add_child(new_object)
	new_object.position = Vector3(node_data["pos_x"], node_data["pos_y"], node_data["pos_z"] )
	new_object.name = node_data["name"]
# Now we set the remaining variables.
	for i in node_data.keys():
		if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y" or i == "pos_z":
			continue
		new_object.set(i, node_data[i])
	
	save_nodes = get_tree().get_nodes_in_group("Persistant")

	for i in save_nodes:
		i.queue_free()

# Load the file line by line and process that dictionary to restore
# the object it represents.
	while save_game.get_position() < save_game.get_length():
		json_string = save_game.get_line()
		
	# Creates the helper class to interact with JSON
		json = JSON.new()

	# Check if there is any error while parsing the JSON string, skip in case of failure
		parse_result = json.parse(json_string)
		
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
	# Get the data from the JSON object
		node_data = json.get_data()
	# Firstly, we need to create the object and add it to the tree and set its position.
		new_object = load(node_data["filename"]).instantiate()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector3(node_data["pos_x"], node_data["pos_y"], node_data["pos_z"] )

	# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y" or i == "pos_z":
				continue
			new_object.set(i, node_data[i])
	
	GameMaster.toggle_pause(false)




func start_new_game():
	var level = LEVELS[0].instantiate()
	get_tree().get_root().add_child(level)
	level.name = "GAME_level"
	await get_tree().create_timer(0.1).timeout
	GameMaster.player.get_node("Camera").current = true
	get_tree().get_root().get_node("root/menue_cam").queue_free()
