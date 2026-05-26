extends Button

var song_name: String = ""
var author_name: String = ""

func _on_button_down() -> void:
	AudioManager.selected_song = song_name
	if AudioManager.song_library.songs_list.has(AudioManager.selected_song):
		if AudioManager.song_library.songs_list[AudioManager.selected_song].author == author_name:
			AudioManager.play_song(AudioManager.song_library.songs_list[AudioManager.selected_song])


func _on_author_edit_text_changed(new_text: String) -> void:
	author_name = new_text

func _on_song_edit_text_changed(new_text: String) -> void:
	song_name = new_text
