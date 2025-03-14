extends Control

var score = 0
var higher_combo = 0
var time = 0
var stop = false

func _ready() -> void:
	$Retry.hide()

func _process(delta: float) -> void:
	if stop: return
	time += delta
	time_to_string()

func _on_mob_squashed(combo_multiplier: int):
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
