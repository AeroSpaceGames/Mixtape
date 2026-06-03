extends Control

var group_scene = preload("res://Scenes/song_group.tscn")

@onready var group_container: VBoxContainer = %SongsGroup
@onready var current_song: Control = %CurrentSong
@onready var song_selection: OptionButton = %SongSelection
@onready var add_remove: Button = $AddRemove
@onready var duration: Label = $Duration

var _coll: CollectionSave

var recent_casette: Casette = null

func _ready() -> void:
	close_casette()

func open_casette(nm: String):
	var res = PlaylistManager.collection_library.casette_list[nm]
	sort_songs(res.song_indexes)
	recent_casette = res
	show_duration()
	load_new_songs()
	show()

func show_duration():
	duration.text = "Duration: " + str(recent_casette.duration)

func close_casette():
	recent_casette = Casette.new()
	hide()

func sort_songs(indexes: Array):
	for d in group_container.get_children():
		d.queue_free()
	
	await get_tree().create_timer(0.2).timeout
	
	var song_res: Array[Song] = AudioManager.song_library.songs_list.values()
	
	for i in indexes:
		var new_song = group_scene.instantiate()
		new_song.get_node("Name").text = song_res[i].name
		new_song.get_node("Author").text = song_res[i].author
		new_song.in_playlist = true
		new_song.connect("casette_me", TrackManager.send_casette)
		new_song.connect("casette_me", _set_current)
		group_container.add_child(new_song)

func load_new_songs():
	song_selection.clear()
	
	for i in AudioManager.song_library.songs_list.values():
		song_selection.add_item(i.name)

func song_selected(_idx: int):
	if !song_selection.selected in recent_casette.song_indexes:
		add_remove.text = "Add"
	else:
		add_remove.text = "Remove"

func add_or_remove():
	var idx: int = song_selection.get_item_index(song_selection.get_selected_id())
	if idx in recent_casette.song_indexes:
		#remove
		PlaylistManager.collection_library.casette_list[recent_casette.my_name].song_indexes.erase(idx)
	else:
		#add
		PlaylistManager.collection_library.casette_list[recent_casette.my_name].song_indexes.append(idx)
	
	recent_casette.song_indexes = PlaylistManager.collection_library.casette_list[recent_casette.my_name].song_indexes
	
	#Duration calc
	var final_duration: int = 0
	for i in recent_casette.song_indexes:
		print(AudioManager.song_library.songs_list.values()[i].duration)
		final_duration += AudioManager.song_library.songs_list.values()[i].duration
	PlaylistManager.collection_library.casette_list[recent_casette.my_name].duration = final_duration
	
	show_duration()
	
	#Save control
	if CollectionSave.save_exists():
		_coll = CollectionSave.load_savegame() as CollectionSave
		_coll.casettes[recent_casette.my_name] = [recent_casette.my_name, recent_casette.design, recent_casette.duration, recent_casette.song_indexes]
		_coll.write_savegame()
	
	
	sort_songs(PlaylistManager.collection_library.casette_list[recent_casette.my_name].song_indexes)
	song_selected(-1)


func _set_current(nm: String, auth: String):
	PlaylistManager.selected_casette = recent_casette.my_name
	current_song.set_song(AudioManager.song_library.get_song(nm, auth))
