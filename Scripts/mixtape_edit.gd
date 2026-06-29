extends Control

var group_scene = preload("res://Scenes/song_group.tscn")

@onready var group_container: VBoxContainer = %SongsGroup
@onready var current_song: Control = %CurrentSong
@onready var duration: Label = $Duration
@onready var group_handle: Node = %GroupHandle
@onready var search_bar: LineEdit = $SearchBar

var _coll: CollectionSave

var recent_mixtape: Mixtape = null

func _ready() -> void:
	recent_mixtape = Mixtape.new()
	hide()

func read_mixtape(nm: String):
	var res = PlaylistManager.mix_library.mixtape_list[nm]
	recent_mixtape = res
	_set_current()

func open_mixtape(nm: String):
	var res = PlaylistManager.mix_library.mixtape_list[nm]
	sort_songs(res.song_indexes)
	recent_mixtape = res
	show_duration()
	show()

func show_duration():
	duration.text = "Duration: " + str(recent_mixtape.duration)

func close_casette():
	group_handle.clean_groups()
	recent_mixtape = Mixtape.new()
	hide()

func search_text_changed(txt: String):
	txt = txt.to_lower().replace(" ","")
	sort_songs(PlaylistManager.mix_library.mixtape_list[recent_mixtape.my_name].song_indexes, txt)

func sort_songs(indexes: Array, key: String = ""):
	for d in group_container.get_children():
		d.queue_free()
	
	get_tree().call_group("MixGroup", "duration_changed")
	
	search_result(indexes, key)

func search_result(indexes: Array, key: String = ""):
	var song_res: Array[Song] = AudioManager.song_library.songs_list.values()
	
	for i in indexes:
		var index_txt = song_res[i].name.to_lower().replace(" ","")
		if index_txt.left(clamp(len(key), 0, len(index_txt))) != key.left(clamp(len(key), 0, len(index_txt))):
			continue
		var new_song = group_scene.instantiate()
		new_song.get_node("Name").text = song_res[i].name
		new_song.get_node("Author").text = song_res[i].author
		new_song.get_node("Add").button_pressed = true
		new_song.my_index = i
		new_song.in_playlist = true
		new_song.connect("add_remove", add_or_remove)
		group_container.add_child(new_song)
	
	for j in range(AudioManager.song_library.songs_list.size()):
		if j in indexes:
			continue
		var index_txt = song_res[j].name.to_lower().replace(" ","")
		if index_txt.left(clamp(len(key), 0, len(index_txt))) != key.left(clamp(len(key), 0, len(index_txt))):
			continue
		var new_song = group_scene.instantiate()
		new_song.get_node("Name").text = "n-" + song_res[j].name
		new_song.get_node("Author").text = song_res[j].author
		new_song.get_node("Add").button_pressed = false
		new_song.in_playlist = true
		new_song.my_index = j
		new_song.connect("add_remove", add_or_remove)
		group_container.add_child(new_song)


func add_or_remove(idx: int):
	var indexes = PlaylistManager.mix_library.mixtape_list[recent_mixtape.my_name].song_indexes
	if idx in indexes:
		#remove
		PlaylistManager.mix_library.mixtape_list[recent_mixtape.my_name].song_indexes.erase(idx)
	else:
		#add
		PlaylistManager.mix_library.mixtape_list[recent_mixtape.my_name].song_indexes.append(idx)
	
	recent_mixtape.song_indexes = PlaylistManager.mix_library.mixtape_list[recent_mixtape.my_name].song_indexes
	
	#Duration calc
	var final_duration: int = 0
	for i in recent_mixtape.song_indexes:
		final_duration += AudioManager.song_library.songs_list.values()[i].duration
	PlaylistManager.mix_library.mixtape_list[recent_mixtape.my_name].duration = final_duration
	
	show_duration()
	
	#Save control
	if CollectionSave.save_exists():
		_coll = CollectionSave.load_savegame() as CollectionSave
		_coll.mixtapes[recent_mixtape.my_name] = [recent_mixtape.my_name, recent_mixtape.design, recent_mixtape.duration, recent_mixtape.song_indexes]
		_coll.write_savegame()
	
	search_bar.text = ""
	sort_songs(PlaylistManager.mix_library.mixtape_list[recent_mixtape.my_name].song_indexes)


func _set_current():
	PlaylistManager.selected_mix = recent_mixtape.my_name
	group_handle.clean_groups()
	var new_song_res: Song = AudioManager.song_library.songs_list.values()[recent_mixtape.song_indexes[0]]
	AudioManager.selected_song = new_song_res.name
	AudioManager.selected_author = new_song_res.author
	AudioManager.playing_song_index = 0
	AudioManager.play_song(new_song_res)
	current_song.set_song(new_song_res)
	PlaylistManager.generate_playlist(recent_mixtape.song_indexes)
