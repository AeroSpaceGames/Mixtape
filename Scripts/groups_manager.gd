extends Node

var group_scene = preload("res://Scenes/song_group.tscn")
@onready var group_container: VBoxContainer = %GroupContainer
@onready var current_song: Control = %CurrentSong

func _ready() -> void:
	clean_groups()

func clean_groups(key: String = ""):
	for d in group_container.get_children():
		d.queue_free()
	
	create_groups(key)

func search(txt: String):
	txt = txt.to_lower().replace(" ","")
	clean_groups(txt)

func create_groups(key: String = ""):
	if PlaylistManager.mix_library.mixtape_list.keys().has("My Library"):
		
		var song_res: Array = PlaylistManager.mix_library.mixtape_list[PlaylistManager.selected_mix].song_indexes
		for i in len(song_res):
			var actual_name: String = AudioManager.song_library.songs_list.values()[song_res[i]].name.to_lower().replace(" ","")
			if actual_name.left(clamp(len(key), 0, len(actual_name))) != key.left(clamp(len(key), 0, len(actual_name))):
				continue
			
			var new_group = group_scene.instantiate()
			new_group.get_node("Name").text = AudioManager.song_library.songs_list.values()[song_res[i]].name
			new_group.get_node("Author").text = AudioManager.song_library.songs_list.values()[song_res[i]].author
			new_group.my_index = i
			new_group.connect("play_me", TrackManager.send_song)
			new_group.connect("play_me", _set_current)
			group_container.add_child(new_group)

func _set_current(nm: String, auth: String, _md: int):
	current_song.set_song(AudioManager.song_library.get_song(nm, auth))
