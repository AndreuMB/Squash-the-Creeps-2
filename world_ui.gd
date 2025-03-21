extends Marker3D

@export var score_label_scene: PackedScene
	
const SCORE_ENTRIES = [
	{"label": "OK", "color": Color.GREEN, "multicolor": false},
	{"label": "NICE", "color": Color.AQUA, "multicolor": false},
	{"label": "GOOD", "color": Color.RED, "multicolor": false},
	{"label": "AWESOME", "color": Color.DEEP_PINK, "multicolor": true},
	{"label": "PERFECT", "color": Color.PURPLE, "multicolor": true}
]

func _on_mob_squashed(combo_multiplier: int, mob_position: Vector3):
	var score_index = min(combo_multiplier - 1, SCORE_ENTRIES.size() - 1)
	
	var label_scene = score_label_scene.instantiate()
	var label = label_scene.get_node("Label")
	var animation_player = label_scene.get_node("AnimationPlayer2")
	label_scene.position = $Camera3D.unproject_position(mob_position)
	label.text = SCORE_ENTRIES[score_index].label
	label.modulate = SCORE_ENTRIES[score_index].color
	# rotate slightly for not look directly to the player
	label.rotation = randf_range(-PI / 4, PI / 4)
	if SCORE_ENTRIES[score_index].multicolor:
		animation_player.play("rainbow")
	add_child(label_scene)
