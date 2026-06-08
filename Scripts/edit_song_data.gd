extends Control
@onready var song_name: Label = $Name
@onready var line_edit: LineEdit = $LineEdit
@onready var title: Label = $Title

@export var saved_name: String = ""

signal text_changed(txt: String)

func _ready() -> void:
	hide()

func show_mix():
	title.text = "Casette's Name"
	line_edit.placeholder_text = "My Casette"
	line_edit.text = ""
	saved_name = ""
	song_name.text = ""
	show()

func show_song(res: Song):
	title.text = "Enter the Author"
	line_edit.placeholder_text = "Whos the author?"
	line_edit.text = ""
	saved_name = ""
	song_name.text = res.name
	show()

func set_author():
	if line_edit.text != "":
		saved_name = line_edit.text
		text_changed.emit(line_edit.text)
		hide()
