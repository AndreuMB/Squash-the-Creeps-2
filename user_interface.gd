extends Control
var score = 0
var higher_combo = 0

func _ready() -> void:
	$Retry.hide()

func _on_mob_squashed(combo_multiplier: int):
	score += 1 * combo_multiplier
	if combo_multiplier > higher_combo:
		higher_combo = combo_multiplier
	$ScoreInfo/ScoreLabel.text = "Score: %s" % score
	set_combo(combo_multiplier)
	
func set_combo(combo:int):
	$ScoreInfo/ComboLabel.text = "Combo: %s" % combo

func _game_over():
	$ScoreInfo.hide()
	$Retry.show()
	$Retry/VBoxContainer/FinalScoreLabel.text = "Final Score: %s" % score
	$Retry/VBoxContainer/HigherComboLabel.text = "Higher Combo: %s" % higher_combo
