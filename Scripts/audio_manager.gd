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

func pause():
	if playing:
		player.stream_paused = true
		playing = false

func resume():
	if !playing:
		player.stream_paused = false
		playing = true
		if saved_sec != 0.0:
			player.seek(saved_sec)
			saved_sec = 0.0

func stop_restart():
	player.seek(0.0)
	saved_sec = 0.0

func play_song(data: Song):
	get_tree().call_group("SongGroup", "color_selected")
	player.stream = data.stream
	player.play()
	playing = player.playing


func _on_player_finished() -> void:
	song_ended.emit()


func set_effect(idx: int):
	match idx:
		0: #Starting slow
			player.pitch_scale = 0.6
			player.volume_db = -8
			var tween = create_tween()
			if tween.is_running():
				tween.kill()
			tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT).set_parallel()
			tween.parallel().tween_property(player, "pitch_scale", 1.0, 0.4)
			tween.parallel().tween_property(player, "volume_db", 0, 0.25)
		1: #Ending slow
			player.pitch_scale = 1.0
			player.volume_db = 0
			var tween = create_tween()
			tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT).set_parallel()
			tween.parallel().tween_property(player, "pitch_scale", 0.6, 0.25)
			tween.parallel().tween_property(player, "volume_db", -8, 0.5)
