extends Node

@export var actual_playlist: Array
@export var playlist_index: int = 0

@export var available_playlist: Array

@export var play_mode: int = 0

func generate_random_playlist(n: int = 5):
	if len(AudioManager.song_library.songs_list.keys()) <= 1:
		return
	
	available_playlist = []
	actual_playlist = []
	actual_playlist.append([AudioManager.selected_song, AudioManager.selected_author])
	
	var prev_song: Song = AudioManager.song_library.get_song(AudioManager.selected_song, AudioManager.selected_author)
	
	for i in n:
		var next_song: Song = AudioManager.song_library.songs_list.values().pick_random()
		while next_song == prev_song:
			next_song = AudioManager.song_library.songs_list.values().pick_random()
		prev_song = next_song
		actual_playlist.append([next_song.name, next_song.author])
	
	for i in len(actual_playlist):
		available_playlist.append(i)
	playlist_index = 0

func has_next_song(dir: int = 1) -> bool:
	if playlist_index + 1 * dir > len(available_playlist) - 1 or playlist_index + 1 * dir < 0:
		return false
	return true

func get_next_song(dir: int = 1, mode: int = 0) -> Song:
	match mode:
		0: #Linear
			playlist_index += 1 * dir
		1: #Random
			playlist_index = available_playlist.pick_random()
			available_playlist.erase(playlist_index)
	return AudioManager.song_library.get_song(actual_playlist[playlist_index][0],actual_playlist[playlist_index][1])
