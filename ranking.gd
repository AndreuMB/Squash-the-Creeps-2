extends Control

#@export var label_theme: Theme


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	select()

func select():
	Supabase.database.selected.connect(_on_selected.bind())
	Supabase.database.error.connect(_on_error.bind())
	var query = SupabaseQuery.new().from("ranking").select(["*"]).order('score',1).range(0,10)
	Supabase.database.query(query)

func _on_selected(result : Array):
	for entry in result:
		setColumnValue($Panel/MarginContainer/Content/Table/ScoreColumn,str(int(entry.score)))
		setColumnValue($Panel/MarginContainer/Content/Table/NameColumn,entry.name)

func _on_error(result : Object):
	print("error result = ", result)

func setColumnValue(columnNode, value):
	var label = Label.new()
	label.text = value
	columnNode.add_child(label)
