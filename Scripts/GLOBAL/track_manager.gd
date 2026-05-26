extends Node

func send_song(nm: String, auth: String):
	AudioManager.selected_song = nm
	AudioManager.selected_author = auth
	var new_song_res: Song = AudioManager.song_library.get_song(nm, auth)
	AudioManager.play_song(new_song_res)
	PlaylistManager.generate_random_playlist()

func change_song(nm: String, auth: String):
	AudioManager.selected_song = nm
	AudioManager.selected_author = auth
	var new_song_res: Song = AudioManager.song_library.get_song(nm, auth)
	AudioManager.play_song(new_song_res)
	#PlaylistManager.generate_random_playlist()
