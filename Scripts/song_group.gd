extends Control

signal play_me(nm: String, auth: String)
@onready var my_name: Label = $Name
@onready var author: Label = $Author

func send_metadata():
	play_me.emit(my_name.text, author.text)
