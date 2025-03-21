extends Control

var score = 0

func _on_name_input_text_submitted(name: String) -> void:
	Supabase.database.query(SupabaseQuery.new().from("ranking").insert([{"name":name, "score":score}]))
	hide()

func _on_draw() -> void:
	$SavePanel/MarginContainer/Container/NameInput.grab_focus()

func set_score(playerScore: int):
	score = playerScore
