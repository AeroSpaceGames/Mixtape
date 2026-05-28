extends Node

var group_scene = preload("res://Scenes/casette_group.tscn")
@onready var group_container: HFlowContainer = %CollectionsContainer
@onready var current_song: Control = %CurrentSong

func _ready() -> void:
	create_groups()

func create_groups():
	for d in group_container.get_children():
		d.queue_free()
	
	await get_tree().create_timer(0.2).timeout
	
	var casette_res: Array[Casette] = PlaylistManager.collection_library.casette_list.values()
	for i in len(casette_res):
		var new_group = group_scene.instantiate()
		new_group.get_node("Name").text = casette_res[i].my_name
		new_group.get_node("Duration").text = str(casette_res[i].duration)
		#new_group.connect("play_me", TrackManager.send_song)
		group_container.add_child(new_group)

func _set_current(nm: String, auth: String):
	current_song.set_song(AudioManager.song_library.get_song(nm, auth))
