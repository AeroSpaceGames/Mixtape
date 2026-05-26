extends Control
@onready var song_name: Label = $Name
@onready var author_edit: LineEdit = $AuthorEdit

@export var new_author_name: String = ""

signal author_changed(auth: String)

func _ready() -> void:
	hide()

func show_song(res: Song):
	author_edit.text = ""
	new_author_name = ""
	song_name.text = res.name
	show()

func set_author():
	if author_edit.text != "":
		new_author_name = author_edit.text
		author_changed.emit(author_edit.text)
		hide()
