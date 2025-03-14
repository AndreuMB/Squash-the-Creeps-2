extends Node

@export var mob_scene: PackedScene

func _on_mob_timer_timeout() -> void:
	# instantiate mob
	var mob = mob_scene.instantiate()
	
	# get random location from the spawnPath
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	# initialize function mob script
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position,player_position)
	
	# add mob to the main scene
	add_child(mob)
	
	# squased signal to score label
	mob.squashed.connect($UserInterface._on_mob_squashed.bind())

func _on_player_hit() -> void:
	$MobTimer.stop()
	$UserInterface._game_over()
	


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
			get_tree().reload_current_scene()


func _on_player_floor_contact() -> void:
	$UserInterface.set_combo($Player.combo_multiplier)
