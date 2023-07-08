extends CharacterBody3D

var target
var chase_speed = 10.0
var move_state = 0
var direction = Vector3()
var anim = ANIM_IDLE
var chasing = false
var dead = false

@onready var animation = $Sk_mesh/AnimationTree
@onready var navigationagent = $NavigationAgent3D


const ANIM_IDLE = 0
const ANIM_CHASE = 2
const ANIM_DEAD = 3
const IDLE_BLEND_AMOUNT = 0.01

# STATES
var state
enum {IDLE, PATROL, CHASE, DEAD}

var hp = 100

@export var bluey := false

func _ready():
	
	#good color
	
	if bluey:
		pass #change color here!
	
	
	#INITIAL STATE
	change_state(IDLE)
	
	# PATROL TIMER START
	$Timer.start()
	
	# RANDOMIZE PATROL POINTS
	randomize()
	
func _physics_process(delta):
	
	# RUNS ENEMY ANIMATION
	animate()
	
	# HANDLES CHASING
	if target and not dead:
		if chasing:
			chasing_player(delta)
			var next_path_position = navigationagent.get_next_path_position()
			var new_velocity = (next_path_position - global_position).normalized() * chase_speed
			navigationagent.set_velocity(new_velocity)
			rotation.x = 0
			rotation.y = lerp_angle(rotation.y, atan2(new_velocity.x,new_velocity.z), delta * 5.0)



# FUNCTION FOR CHASING
func chasing_player(delta):
	navigationagent.set_target_position(GameMaster.player.global_position)

# PATROLLING AREA RANGE
func get_random_pos_in_sphere (radius : float) -> Vector3:
	var x1 = randf_range (-1, 1)
	var x2 = randf_range (-1, 1)

	while x1*x1 + x2*x2 >= 1:
		x1 = randf_range (-1, 1)
		x2 = randf_range (-1, 1)

	var random_pos_on_unit_sphere = Vector3 (
	2 * x1 * sqrt (1 - x1*x1 - x2*x2),
	2 * x2 * sqrt (1 - x1*x1 - x2*x2),
	1 - 2 * (x1*x1 + x2*x2))

	return random_pos_on_unit_sphere * randf_range (0, radius)
	
# HANDLES STATE
func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			anim = ANIM_IDLE
		CHASE:
			anim = ANIM_CHASE
		DEAD:
			anim = ANIM_DEAD

func animate():
	
	# CHASING STATE
	if chasing:
		change_state(CHASE)
		move_state -= IDLE_BLEND_AMOUNT
	
	# IDLE STATE
	if !chasing:
		change_state(IDLE)
		move_state -= IDLE_BLEND_AMOUNT
		
	# DEAD STATE
	if dead:
		change_state(DEAD)
	
	# CLAMP BLEND FOR IDLE - WALK
	move_state = clamp(move_state, 0, 1)
	
	# ANIMATIONTREE BLEND
	#animation["parameters/Blend2/blend_amount"]=move_state
	#animation["parameters/Blend3/blend_amount"]=move_state
	
	# ANIMATIONTREE TRANSITION
	#if animation.get("parameters/state/current_index") != anim:
	#	animation["parameters/state/transition_request"]="state " + str(anim)

# MAKE THE ENEMY MOVE
func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()



# DETECTION AREA - PLAYER IS NEARBY
func _on_vision_cone_body_entered(body):
	if body == GameMaster.player:
		target = body
		chasing = true
		$Timer.stop()


func _on_vision_cone_body_exited(body):
	if body == GameMaster.player:
		target = null
		chasing = false
		$Timer.start()


#####
#Gameplay functions

func apply_damage(n):
	
	hp -= n
	print("PV: ", hp)
	
	if hp <= 0:
		if bluey:
			GameMaster.game_over(1)
