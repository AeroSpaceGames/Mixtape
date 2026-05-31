extends Node

func send_song(nm: String, auth: String):
	AudioManager.selected_song = nm
	AudioManager.selected_author = auth
	var new_song_res: Song = AudioManager.song_library.get_song(nm, auth)
	AudioManager.play_song(new_song_res)
	PlaylistManager.generate_random_playlist()

func send_casette(nm: String, auth: String):
	AudioManager.selected_song = nm
	AudioManager.selected_author = auth
	var new_song_res: Song = AudioManager.song_library.get_song(nm, auth)
	AudioManager.play_song(new_song_res)
	await get_tree().create_timer(0.1).timeout
	PlaylistManager.generate_playlist(PlaylistManager.collection_library.casette_list[PlaylistManager.selected_casette].song_indexes)


func change_song(nm: String, auth: String):
	AudioManager.selected_song = nm
	AudioManager.selected_author = auth
	var new_song_res: Song = AudioManager.song_library.get_song(nm, auth)
	AudioManager.play_song(new_song_res)
	#PlaylistManager.generate_random_playlist()
