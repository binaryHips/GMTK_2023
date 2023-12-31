extends CharacterBody3D


const SPEED = 8.0
const JUMP_VELOCITY = 8
const MAX_INTERACT_DISTANCE := 3.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 2


@onready var WEAPON = $Camera/hand/weapon
func _ready():
	GameMaster.player = self
	print("player revenu")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Camera.current = true
	
	

func _physics_process(delta):
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()


	if is_on_floor(): #stop faster if on ground
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			
			$Camera/hand/weapon.position.y = cos(Time.get_ticks_msec()/100.0)/50 * min((velocity/3).length_squared(), 1)
			
			
			
		else:
			$Camera/hand/weapon.position.y = lerp($Camera/hand/weapon.position.y, 0.0, 10*delta)
			velocity.x = move_toward(velocity.x, 0, exp(-abs(velocity.x/40)))
			velocity.z = move_toward(velocity.z, 0, exp(-abs(velocity.z/40)))
	else:
		velocity.x = move_toward(velocity.x, 0, exp(-abs(velocity.x)))
		velocity.z = move_toward(velocity.z, 0, exp(-abs(velocity.z)))

	move_and_slide()
	
	for col_idx in get_slide_collision_count():
		var col := get_slide_collision(col_idx)
		if col.get_collider() is RigidBody3D:
			col.get_collider().apply_central_impulse(-col.get_normal() * 0.3)
			col.get_collider().apply_impulse(-col.get_normal() * 0.01, col.get_position())


########
#Movement

func _input(event):         
	if event is InputEventMouseMotion && Input.mouse_mode == 2: #mouse captured
		rotate_y(deg_to_rad(-event.relative.x*Settings.sens))
		
		$Camera.rotation.x = clamp(
			$Camera.rotation.x - deg_to_rad(event.relative.y*Settings.sens),
			deg_to_rad(-80),
			deg_to_rad(80)
		)
	
		
	if event.is_action_pressed("shoot") && Input.mouse_mode == 2: #mouse captured
		var pos = $Camera/RayCast.get_collision_point()
		
		if pos != null:
			WEAPON.shoot(
				(pos-$Camera.global_position) *1.002  + $Camera.global_position, #shoots juuuuuust a little further to avoid rounding errors
				self
				)
	
	if event.is_action_released("menue") && !GameMaster.game_paused:
		
		GameMaster.toggle_pause(true)
		
	if event.is_action_pressed("interact") && Input.mouse_mode == 2: #mouse captured
		var collider = $Camera/RayCast.get_collider()
		
		if collider:
			if collider.is_in_group("Interactables"):
				print($Camera.global_position.distance_to($Camera/RayCast.get_collision_point()))
				
				if $Camera.global_position.distance_to($Camera/RayCast.get_collision_point()) <= MAX_INTERACT_DISTANCE:
					collider.interact()
					
	if event.is_action_pressed("reload") && Input.mouse_mode == 2: #mouse captured
		WEAPON.reload()


########
#Gameplay
const max_hp = 100
var hp := 100

func apply_damage(n):
	
	hp -= n
	print("PV: ", hp)
	
	if hp <= 0:
		GameMaster.game_over()
	
	GameMaster.interface.update_lifebar(hp)

func heal(n):
	hp = min(hp+n, max_hp)
	GameMaster.interface.update_lifebar(hp)
	



func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"pos_z" : position.z,
		
		"hp" : hp,
	}
	return save_dict
