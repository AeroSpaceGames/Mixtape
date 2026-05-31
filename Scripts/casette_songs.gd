extends Control

var group_scene = preload("res://Scenes/song_group.tscn")

@onready var group_container: VBoxContainer = %SongsGroup
@onready var current_song: Control = %CurrentSong

var recent_casette: Casette = null

func _ready() -> void:
	close_casette()

func open_casette(res: Casette):
	sort_songs(res.song_indexes)
	recent_casette = res
	show()

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

func _set_current(nm: String, auth: String):
	PlaylistManager.selected_casette = recent_casette.my_name
	current_song.set_song(AudioManager.song_library.get_song(nm, auth))
