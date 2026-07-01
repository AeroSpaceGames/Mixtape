extends Control

var group_scene = preload("res://Scenes/song_group.tscn")

@onready var group_container: VBoxContainer = %SongsGroup
@onready var current_song: Control = %CurrentSong
@onready var group_handle: Node = %GroupHandle
@onready var search_bar: LineEdit = $SearchBar
@onready var flow_manager: Node = %FlowManager
@onready var mixes_groups: Node = %MixesGroups
@onready var new_name: LineEdit = %NewName
@onready var label: TextureRect = %Label
@onready var player_label: TextureRect = %PlayerLabel
@onready var label_texture: TextureRect = %LabelTexture

var new_design: int = 0

var _coll: CollectionSave

var recent_mixtape: Mixtape = null

func _ready() -> void:
	recent_mixtape = Mixtape.new()
	hide()

func read_mixtape(nm: String):
	var res = PlaylistManager.mix_library.mixtape_list[nm]
	recent_mixtape = res
	new_design = recent_mixtape.design
	player_label.texture = CasettesTextures.labels[res.design]
	flow_manager.go_to_library()
	_set_current()

func open_mixtape(nm: String):
	var res = PlaylistManager.mix_library.mixtape_list[nm]
	
	new_design = res.design
	label.texture = CasettesTextures.labels[res.design]
	label_texture.texture = CasettesTextures.labels[new_design]
	new_name.text = res.my_name
	sort_songs(res.song_indexes)
	recent_mixtape = res
	show()


func close_casette():
	group_handle.clean_groups()
	recent_mixtape = Mixtape.new()
	new_design = 0
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
		new_song.get_node("Name").text = song_res[j].name
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
	
	
	#Save control
	if CollectionSave.save_exists():
		_coll = CollectionSave.load_savegame() as CollectionSave
		_coll.mixtapes[recent_mixtape.my_name] = [recent_mixtape.my_name, recent_mixtape.design, recent_mixtape.duration, recent_mixtape.song_indexes]
		_coll.write_savegame()
	
	#search_bar.text = ""
	sort_songs(PlaylistManager.mix_library.mixtape_list[recent_mixtape.my_name].song_indexes, search_bar.text)


func save_mix_name(txt: String):
	if CollectionSave.save_exists():
		_coll = CollectionSave.load_savegame() as CollectionSave
		if txt in _coll.mixtapes:
			return false
		if len(recent_mixtape.my_name.trim_prefix("NewMixtape")) == len(recent_mixtape.my_name) - len("NewMixtape"):
			_coll.new_mix_name -= 1
		if len(txt.trim_prefix("NewMixtape")) == len(txt) - len("NewMixtape"):
			_coll.new_mix_name += 1
		_coll.mixtapes[txt] = _coll.mixtapes[recent_mixtape.my_name]
		_coll.mixtapes[txt][0] = txt
		_coll.mixtapes.erase(recent_mixtape.my_name)
		_coll.write_savegame()
		PlaylistManager.mix_library.mixtape_list = {}
		for i in _coll.mixtapes.keys():
			_coll.load_mix_from_coll(i, _coll.mixtapes[i])
		PlaylistManager.new_mixes_name = _coll.new_mix_name
		if PlaylistManager.selected_mix == recent_mixtape.my_name:
			PlaylistManager.selected_mix = txt

func save_mix_label(txt: String, design: int):
	if CollectionSave.save_exists():
		_coll = CollectionSave.load_savegame() as CollectionSave
		_coll.mixtapes[txt][1] = design
		PlaylistManager.mix_library.mixtape_list[txt].design = design
		_coll.write_savegame()


func save_data():
	var txt: String = new_name.text
	save_mix_name(txt)
	save_mix_label(txt, new_design)
	await get_tree().create_timer(0.2).timeout
	draw_new_data(txt)

func draw_new_data(txt: String):
	mixes_groups.create_groups()
	open_mixtape(txt)


func change_label(k: int = 1):
	new_design += 1 * k
	if new_design < 0:
		new_design = len(PlaylistManager.designs) - 1
	new_design %= len(PlaylistManager.designs)
	label_texture.texture = CasettesTextures.labels[new_design]

func prev_label():
	change_label(-1)

func next_label():
	change_label()



func _set_current():
	PlaylistManager.selected_mix = recent_mixtape.my_name
	group_handle.clean_groups()
	var new_song_res: Song = AudioManager.song_library.songs_list.values()[recent_mixtape.song_indexes[0]]
	AudioManager.selected_song = new_song_res.name
	AudioManager.selected_author = new_song_res.author
	AudioManager.playing_song_index = 0
	AudioManager.play_song(new_song_res)
	current_song.set_song(new_song_res)
	PlaylistManager.generate_playlist(recent_mixtape.song_indexes, PlaylistManager.play_mode)
