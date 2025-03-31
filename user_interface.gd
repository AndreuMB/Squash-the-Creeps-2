extends Control

@export var score_label_scene: PackedScene

var score = 0
var higher_combo = 0
var time = 0
var stop = false
var saved = false

func _ready() -> void:
	$Retry/VBoxContainer/RetryLabel.hide()
	$Retry/VBoxContainer/ExitLabel.hide()
	$Retry/SavePanel.hide()
	$Retry.hide()

func _process(delta: float) -> void:
	if stop: return
	time += delta
	time_to_string()

func _on_mob_squashed(combo_multiplier: int, mob_position: Vector3):
	score += 1 * combo_multiplier
	if combo_multiplier > higher_combo:
		higher_combo = combo_multiplier
	$ScoreInfo/ScoreLabel.text = "Score: %s" % score
	set_combo(combo_multiplier)
	
	
func set_combo(combo:int):
	$ScoreInfo/ComboLabel.text = "Combo: %s" % combo

func _game_over():
	stop = true
	$RestartTimer.start()
	$ScoreInfo.hide()
	$Retry.show()
	$Retry/VBoxContainer/FinalScoreLabel.text = "Final Score: %s" % score
	$Retry/VBoxContainer/HigherComboLabel.text = "Higher Combo: %s" % higher_combo

func time_to_string():
	var min = time / 60
	var sec = fmod(time,60)
	var time_string = str("%02d" % min, ":", "%02d" % sec)
	$TimerLabel.text = time_string


func _unhandled_input(event: InputEvent) -> void:
	if $Retry.visible and $RestartTimer.is_stopped() and !$Retry/SavePanel.visible:
		if event is InputEventKey and event.pressed:
			if event.keycode == KEY_X:
				get_tree().change_scene_to_file("res://main_menu.tscn")
			elif event.keycode == KEY_S and saved == false:
				$Retry/SavePanel.set_score(score)
				$Retry/SavePanel.show()
				saved = true
				$Retry/VBoxContainer/SaveLabel.hide()
				
		if event.is_action_pressed("ui_accept") or event.is_action_pressed("jump"):
			get_tree().reload_current_scene()


func _on_restart_timer_timeout() -> void:
	$Retry/VBoxContainer/RetryLabel.show()
	$Retry/VBoxContainer/RetryLabel/AnimationPlayer.play("ease_in_out")
	
	$Retry/VBoxContainer/ExitLabel.show()
	$Retry/VBoxContainer/ExitLabel/AnimationPlayer.play("ease_in_out")
	
	$Retry/VBoxContainer/SaveLabel.show()
	$Retry/VBoxContainer/SaveLabel/AnimationPlayer.play("ease_in_out")
