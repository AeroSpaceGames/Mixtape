extends Control

@export var song_library: SongLibrary
@onready var player: AudioStreamPlayer = $Player

@export var selected_song: String = ""
@export var selected_author: String = ""
@export var playing: bool = false
@export var playing_song_index: int = 0

var saved_sec: float = 0.0

signal song_ended

func add_song(res: Song):
	if song_library.songs_list.keys().has(res.name):
		if song_library.songs_list[res.name].author == res.author:
			return
	song_library.songs_list[res.name] = res

func seek_second(sec: float):
	if playing:
		player.seek(sec)
	else:
		saved_sec = sec

func pause_resume():
	if playing:
		player.stream_paused = true
		playing = false
	else:
		player.stream_paused = false
		playing = true
		if saved_sec != 0.0:
			player.seek(saved_sec)
			saved_sec = 0.0

func play_song(data: Song):
	player.stream = data.stream
	player.play()
	playing = player.playing


func _on_player_finished() -> void:
	song_ended.emit()
