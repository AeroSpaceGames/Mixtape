extends Control

var my_name: String = ""

signal casette_data(data: Casette)


func set_data(nm: String):
	my_name = nm

func open_me():
	casette_data.emit(my_name)
