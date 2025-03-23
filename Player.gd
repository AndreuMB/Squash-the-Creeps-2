extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var double_jump_impulse = 15
@export var bounce_impulse = 16
@export var combo_multiplier = 1

var target_velocity = Vector3.ZERO
var double_jump_used: bool = false
var on_floor_contact: bool = false
var death: bool = false

signal hit
signal floor_contact

func _physics_process(delta: float) -> void:
	if death: return
	var direction =  Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
			direction.x += 1
	if Input.is_action_pressed("move_left"): 
			direction.x -= 1
	if Input.is_action_pressed("move_back"):
			direction.z += 1
	if Input.is_action_pressed("move_forward"):
			direction.z -= 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1
		
	
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
		on_floor_contact = false

	if not is_on_floor() and Input.is_action_just_pressed("jump") and !double_jump_used:
		target_velocity.y = double_jump_impulse
		double_jump_used = true
		
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	velocity = target_velocity
	move_and_slide()
	
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if collision.get_collider() == null:
			continue
		
		#if collider is a mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			# if it hits from above
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				combo_multiplier += 1
				mob.squash(combo_multiplier)
				target_velocity.y = bounce_impulse
				double_jump_used = false
				break
		else:
			if is_on_floor() and !on_floor_contact:
				on_floor_contact = true
				double_jump_used = false
				combo_multiplier = 0
				floor_contact.emit()
	
	# make the player animation arc when jumping
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse
	

func die():
	death = true
	$CollisionShape3D.hide()
	$MobDetector.hide()
	$Pivot.hide()
	hit.emit()
	$Squashed.play()
	


func _on_mob_detector_body_entered(_body: Node3D) -> void:
	if death: return
	die()


func _on_squashed_finished() -> void:
	queue_free()
