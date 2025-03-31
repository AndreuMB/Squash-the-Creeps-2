extends CanvasLayer

@export var focus_button: Button

var gamepad = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Menu/Ranking.hide()
	$Menu/Hints.hide()
	if focus_button: focus_button.release_focus() 

func _on_start_game_pressed() -> void:
	print('enter')
	get_tree().change_scene_to_file("res://main.tscn")


func _on_ranking_pressed() -> void:
	$Menu/Ranking.show()


func _on_exit_game_pressed() -> void:
	get_tree().quit()
	
func _input(event: InputEvent):
	if $Menu/Ranking.visible:
		if event is InputEventMouseButton:
			$Menu/Ranking.hide()
	
	if event is InputEventKey or event is InputEventMouse:
		$Menu/Hints.hide()
		if gamepad:
			if focus_button: 
				focus_button.grab_focus()
				focus_button.release_focus()
			gamepad = false
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		$Menu/Hints.show()
		if !gamepad:
			if focus_button: focus_button.grab_focus()
			gamepad = true

func _unhandled_input(event: InputEvent) -> void:
	if $Menu/Ranking.visible:
		if !event.is_action("ui_accept"):
			$Menu/Ranking.hide()
		
