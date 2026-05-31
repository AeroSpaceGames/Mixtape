extends Control

signal play_me(nm: String, auth: String)
signal casette_me(nm: String, auth: String)
@onready var my_name: Label = $Name
@onready var author: Label = $Author
var in_playlist: bool = false

func send_metadata():
	if !in_playlist:
		play_me.emit(my_name.text, author.text)
	else:
		casette_me.emit(my_name.text, author.text)
