extends Control

var self_data: Casette = Casette.new()

signal casette_data(data: Casette)

func set_data(res: Casette):
	self_data.design = res.design
	self_data.duration = res.duration
	self_data.my_name = res.my_name
	self_data.song_indexes = res.song_indexes

func open_me():
	casette_data.emit(self_data)
