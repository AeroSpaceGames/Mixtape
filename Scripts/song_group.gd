extends Control

signal play_me(nm: String, auth: String)
signal add_remove(idx: int)

var my_index: int = -1

@onready var my_name: Label = $Name
@onready var author: Label = $Author
var in_playlist: bool = false
@onready var play: Button = $Play
@onready var add: CheckBox = $Add

func _ready() -> void:
	if in_playlist:
		play.hide()
	else:
		add.hide()

func add_toggle(_toggle: bool):
	add_remove.emit(my_index)

func send_metadata():
	play_me.emit(my_name.text, author.text)
