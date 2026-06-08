extends Control

var my_name: String = ""

signal mixtape_data(nm: String)
signal play_mix(nm: String)
@onready var select: Button = %Select

func _ready() -> void:
	if my_name == "Auto":
		select.hide()

func set_data(nm: String):
	my_name = nm

func open_me():
	mixtape_data.emit(my_name)

func play_mixtape():
	play_mix.emit(my_name)
