extends CharacterBody3D

@export var min_speed = 10
@export var max_speed = 18

var difficulty = 0.5

signal squashed

func initialize(start_position,player_position):
	# MANAGE ROTATION
	# look to the player
	look_at_from_position(start_position,player_position,Vector3.UP)
	rotation.x = 0
	# rotate slightly for not look directly to the player
	rotate_y(randf_range(-PI / 4, PI / 4))
	
	# MANAGE SPEED
	var random_speed = randi_range(min_speed,max_speed) * difficulty
	velocity = Vector3.FORWARD * random_speed
	# rotate velocity vector to move the mob towars the direction is looking
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	$AnimationPlayer.speed_scale = random_speed / min_speed

func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()

func squash(combo):
	squashed.emit(combo,position)
	queue_free()
