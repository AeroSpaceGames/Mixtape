extends Node

var group_scene = preload("res://Scenes/song_group.tscn")
@onready var group_container: VBoxContainer = %GroupContainer
@onready var current_song: Control = %CurrentSong

func _ready() -> void:
	create_groups()

func create_groups():
	for d in group_container.get_children():
		d.queue_free()
	
	await get_tree().create_timer(0.2).timeout
	
	var song_res: Array[Song] = AudioManager.song_library.songs_list.values()
	for i in len(song_res):
		var new_group = group_scene.instantiate()
		new_group.get_node("Name").text = song_res[i].name
		new_group.get_node("Author").text = song_res[i].author
		new_group.connect("play_me", TrackManager.send_song)
		new_group.connect("play_me", _set_current)
		group_container.add_child(new_group)

func _set_current(nm: String, auth: String):
	current_song.set_song(AudioManager.song_library.get_song(nm, auth))
