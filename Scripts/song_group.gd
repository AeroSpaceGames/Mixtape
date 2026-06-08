extends Control

signal play_me(nm: String, auth: String)
@onready var my_name: Label = $Name
@onready var author: Label = $Author
var in_playlist: bool = false
@onready var play: Button = $Play

func _ready() -> void:
	if in_playlist:
		play.hide()

func send_metadata():
	play_me.emit(my_name.text, author.text)
