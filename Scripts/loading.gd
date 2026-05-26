extends Control

var _lib: LibrarySave

func _ready() -> void:
	create_or_load_saves()

func create_or_load_saves():
	if LibrarySave.save_exists():
		_lib = LibrarySave.load_savegame() as LibrarySave
		AudioManager.song_library.songs_list = {}
		for i in _lib.songs_key_data.keys():
			_lib.load_song_from_lib(i, _lib.songs_key_data[i])
	else:
		_lib = LibrarySave.new()
		_lib.songs_key_data = {}
		AudioManager.song_library.songs_list = {}
		_lib.write_savegame()


func _on_load_time_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/Testing.tscn")
