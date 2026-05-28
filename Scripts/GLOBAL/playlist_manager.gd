extends Node

@export var actual_playlist: Array
@export var playlist_index: int = 0

@export var play_mode: int = 0

@export var collection_library: CasetteCollection = CasetteCollection.new()
var designs: Array = [0,1,2]

func add_casette(nm: String, res: Casette):
	collection_library.casette_list[nm] = res

func generate_random_playlist(n: int = 5):
	if len(AudioManager.song_library.songs_list.keys()) <= 1:
		return
	
	#available_playlist = []
	actual_playlist = []
	actual_playlist.append([AudioManager.selected_song, AudioManager.selected_author])
	
	var prev_song: Song = AudioManager.song_library.get_song(AudioManager.selected_song, AudioManager.selected_author)
	
	for i in n:
		var next_song: Song = AudioManager.song_library.songs_list.values().pick_random()
		while next_song == prev_song:
			next_song = AudioManager.song_library.songs_list.values().pick_random()
		prev_song = next_song
		actual_playlist.append([next_song.name, next_song.author])

	playlist_index = 0

func has_next_song(dir: int = 1) -> bool:
	if playlist_index + 1 * dir > len(actual_playlist) - 1 or playlist_index + 1 * dir < 0:
		return false
	return true

func get_next_song(dir: int = 1,) -> Song:
	playlist_index += 1 * dir
	return AudioManager.song_library.get_song(actual_playlist[playlist_index][0],actual_playlist[playlist_index][1])
