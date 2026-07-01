extends Node

@export var actual_playlist: Array
@export var playlist_index: int = 0

@export var play_mode: int = 0

@export var mix_library: MixCollection = MixCollection.new()
var designs: Array = [0,1,2,3,4,5] #6 label designs

@export var new_mixes_name: int = 0

var selected_mix: String = "My Library"

func add_mixtape(nm: String, res: Mixtape):
	mix_library.mixtape_list[nm] = res


func generate_playlist(songs: Array, mode: int = 0):
	#actual_playlist.append([AudioManager.selected_song, AudioManager.selected_author])
	if len(songs) <= 1:
		actual_playlist = []
		var next_song: Song = AudioManager.song_library.songs_list.values()[songs[0]]
		actual_playlist.append([next_song.name, next_song.author])
		playlist_index = 0
		return
	
	actual_playlist = []
	match mode:
		0: #Lineal Mode
			for i in range(AudioManager.playing_song_index, len(songs) + AudioManager.playing_song_index + 1):
				var next_song: Song = AudioManager.song_library.songs_list.values()[songs[i % (len(songs))]]
				actual_playlist.append([next_song.name, next_song.author])
		1: #Random Mode
			var new_songs_order = []
			new_songs_order.append_array(songs)
			new_songs_order.shuffle()
			"""
			for j in 2:
				new_songs_order.shuffle()
				new_songs_order.append_array(new_songs_order)
			"""
			for i in len(new_songs_order):
				var next_song: Song = AudioManager.song_library.songs_list.values()[new_songs_order[i % len(new_songs_order)]]
				actual_playlist.append([next_song.name, next_song.author])
	
	playlist_index = 0


#region OBSOLETE/DESUSE
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
#endregion

func has_next_song(dir: int = 1) -> bool:
	if playlist_index + 1 * dir > len(actual_playlist) - 1 or playlist_index + 1 * dir < 0:
		return false
	return true

func get_next_song(dir: int = 1,) -> Song:
	playlist_index += 1 * dir
	return AudioManager.song_library.get_song(actual_playlist[playlist_index][0],actual_playlist[playlist_index][1])
