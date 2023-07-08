extends RigidBody3D

const FUSE_TIME = 4.0

const FORCE = 6

func _ready():
	await get_tree().create_timer(FUSE_TIME).timeout
	
	explode()
	$AnimationPlayer.play("grenade_explode")

func explode():
	for body in $Area3D.get_overlapping_bodies():
		
		var vec = position.direction_to(body.position)
		var force = exp(-position.distance_to(body.position)/40) * FORCE
		
		if body is RigidBody3D:
			body.apply_impulse(vec*force)
			
		if body is CharacterBody3D:
			body.velocity += (vec + Vector3.UP) * force * 2
