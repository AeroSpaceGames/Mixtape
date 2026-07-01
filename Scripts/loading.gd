extends Control

var _lib: LibrarySave
var _coll: CollectionSave

func _ready() -> void:
	create_or_load_saves()

func create_or_load_saves():
	#All songs
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
	
	#All mixtapes/casettes
	if CollectionSave.save_exists():
		_coll = CollectionSave.load_savegame() as CollectionSave
		#var auto_mix: Mixtape = Mixtape.new()
		#auto_mix.design = 0
		#auto_mix.duration = 0
		#auto_mix.my_name = "Auto"
		#auto_mix.song_indexes = []
		PlaylistManager.mix_library.mixtape_list = {}
		for i in _coll.mixtapes.keys():
			_coll.load_mix_from_coll(i, _coll.mixtapes[i])
		PlaylistManager.new_mixes_name = _coll.new_mix_name
	else:
		_coll = CollectionSave.new()
		#var auto_mix: Mixtape = Mixtape.new()
		#auto_mix.design = 0
		#auto_mix.duration = 0
		#auto_mix.my_name = "Auto"
		#auto_mix.song_indexes = []
		PlaylistManager.mix_library.mixtape_list = {}
		_coll.mixtapes = {}
		_coll.new_mix_name = 0
		_coll.write_savegame()


func _on_load_time_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
