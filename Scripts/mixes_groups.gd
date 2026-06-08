extends Node

var group_scene = preload("res://Scenes/mix_group.tscn")
@onready var MixesContainer: VBoxContainer = %MixesContainer
@onready var current_song: Control = %CurrentSong
@onready var MixtapeEdit: Control = %MixtapeEdit

func _ready() -> void:
	create_groups()

func create_groups():
	for d in MixesContainer.get_children():
		d.queue_free()
	
	await get_tree().create_timer(0.2).timeout
	
	var mixtape_res: Array[Mixtape] = PlaylistManager.mix_library.mixtape_list.values()
	for i in len(mixtape_res):
		var new_group = group_scene.instantiate()
		new_group.set_data(mixtape_res[i].my_name)
		new_group.get_node("Name").text = mixtape_res[i].my_name
		new_group.connect("mixtape_data", MixtapeEdit.open_mixtape)
		new_group.connect("play_mix", MixtapeEdit.read_mixtape)
		MixesContainer.add_child(new_group)

func _set_current(nm: String, auth: String):
	current_song.set_song(AudioManager.song_library.get_song(nm, auth))
