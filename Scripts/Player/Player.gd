extends CharacterBody3D


const SPEED = 8.0
const JUMP_VELOCITY = 4.5
const MAX_INTERACT_DISTANCE := 3.5

const sens = 0.3 #à mettre dans settings à terme

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


@onready var WEAPON = $Camera/hand/weapon
func _ready():
	GameMaster.player = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

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
		rotate_y(deg_to_rad(-event.relative.x*sens))
		
		$Camera.rotation.x = clamp(
			$Camera.rotation.x - deg_to_rad(event.relative.y*sens),
			deg_to_rad(-80),
			deg_to_rad(80)
		)
	
	if event.is_action_pressed("secondary") && Input.mouse_mode == 2: #mouse captured
		pass
		
	if event.is_action_pressed("primary") && Input.mouse_mode == 2: #mouse captured
		var pos = $Camera/RayCast.get_collision_point()
		if pos != null:
			WEAPON.shoot(pos, self)
	
	if event.is_action_released("menue") && !GameMaster.game_paused:
		
		GameMaster.toggle_pause(true)
		
	if event.is_action_pressed("interact") && Input.mouse_mode == 2: #mouse captured
		var collider = $Camera/RayCast.get_collider()
		if collider:
			if collider.is_in_group("Interactables"):
				print($Camera.global_position.distance_to($Camera/RayCast.get_collision_point()))
				if $Camera.global_position.distance_to($Camera/RayCast.get_collision_point()) <= MAX_INTERACT_DISTANCE:
					
					collider.interact()
					print("interagi!")


########
#Gameplay
const max_hp = 100
var hp := 100

func apply_damage(n):
	
	hp -= n
	print("PV: ", hp)
	
	if hp <= 0:
		GameMaster.game_over()

func heal(n):
	hp = min(hp+n, max_hp)
