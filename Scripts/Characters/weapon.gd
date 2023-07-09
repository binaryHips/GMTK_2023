extends Node3D

const max_ammo := 20
const damage := 30

var current_ammo := 20


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func shoot_raycast(pos:Vector3, excluded:Node):
	
	var space_state = get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create($muzzle.global_position, pos)
	query.exclude = [excluded]
	query.collision_mask = 0b1 #only first collision layer
	
	return space_state.intersect_ray(query)
	
func shoot(pos:Vector3, caller:Node):
	
	if current_ammo == 0:
			reload()
			return
	
	if current_ammo > 0 && !$AnimationPlayer.is_playing():
		
		
		$muzzle/MuzzleFlash.rotate_z(randf())
		$muzzle/MuzzleFlash.scale.z = 1 + randf_range(0, 2)
		$AnimationPlayer.play("weapon_shoot")
		
		
		current_ammo -= 1
		var res = shoot_raycast(pos, caller)
		
		if res == {}:
			print("nyulll")
			return null #edge case with no collider.
		
		if res["collider"].is_in_group("Alive"): #Checks if the hit target is alive.
			caller.apply_damage(damage)
		else:
			print ("Hit a wall!")
		print(res["position"])
		print("Ammo: ", current_ammo)
		
	print("Ammo: ", current_ammo)
	
	



func reload():
	
	if !$AnimationPlayer.is_playing() && current_ammo < max_ammo:
		$AnimationPlayer.play("weapon_reload")
		current_ammo = max_ammo

func debugSphere(pos:Vector3):
	
	var sphere = CSGSphere3D.new()
	get_tree().root.add_child(sphere)
	
	sphere.scale *= 0.1
	sphere.position = pos
	


func save():

	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"pos_z" : position.z,
		
		"ammo" : current_ammo,
	}
	return save_dict
	
