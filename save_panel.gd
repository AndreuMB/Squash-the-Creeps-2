extends Control

var score = 0

func _ready() -> void:
	$SavePanel/MarginContainer/Container/ErrorLabel.hide()
	Supabase.database.error.connect(_on_error.bind())
	Supabase.database.inserted.connect(_on_inserted.bind())

func _on_name_input_text_submitted(name: String) -> void:
	#not working
	var name_no_whitespace = name.strip_escapes()
	name_no_whitespace = name.replace(" ", "")
	Supabase.database.query(SupabaseQuery.new().from("ranking").insert([{"name":name_no_whitespace, "score":score}]))

func _on_draw() -> void:
	$SavePanel/MarginContainer/Container/NameInput.grab_focus()

func set_score(playerScore: int):
	score = playerScore

func _on_error(result : Object):
	if result.error != null and "23505" in str(result.error):
		$SavePanel/MarginContainer/Container/ErrorLabel.show()

func _on_inserted(result : Array):
	hide()
