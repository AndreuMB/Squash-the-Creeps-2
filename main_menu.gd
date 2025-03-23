extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Menu/Ranking.hide()


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_ranking_pressed() -> void:
	$Menu/Ranking.show()


func _on_exit_game_pressed() -> void:
	get_tree().quit()
	
func _input(event: InputEvent):
	if event is InputEventMouseButton and $Menu/Ranking.visible:
		$Menu/Ranking.hide()

func _unhandled_input(_event: InputEvent) -> void:
	if $Menu/Ranking.visible:
		$Menu/Ranking.hide()
