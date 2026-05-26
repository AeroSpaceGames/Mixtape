extends Control

@onready var my_name: Label = $Name
@onready var author: Label = $Author
@onready var pause: Button = $Pause
@onready var seconds: Timer = $Seconds
@onready var time_preview: HSlider = $TimePreview
@onready var play_mode: Button = $PlayMode

func _ready() -> void:
	AudioManager.connect("song_ended", restart_playlist)

func restart_playlist():
	if !PlaylistManager.has_next_song():
		PlaylistManager.generate_random_playlist()
	next_song()

func change_play_mode():
	PlaylistManager.play_mode += 1
	PlaylistManager.play_mode %= 2 #Luego se cambia a 3. (Por el modo inteligente)
	match PlaylistManager.play_mode:
		0:
			play_mode.text = "Linear"
		1:
			play_mode.text = "Random"

func set_song(data: Song):
	seconds.paused = false
	seconds.start(1)
	time_preview.value = 0
	time_preview.max_value = data.duration
	my_name.text = data.name
	author.text = data.author
	pause.text = "pause"

func second_passed():
	time_preview.value += 1

func move_to_second(changed: bool):
	if changed:
		var sec = time_preview.value
		AudioManager.seek_second(sec)

func pause_resume_song():
	if AudioManager.selected_song != "":
		AudioManager.pause_resume()
		pause.text = "pause" if AudioManager.playing else "play"
		if !AudioManager.playing: seconds.paused = true
		else: seconds.paused = false

func next_song():
	if AudioManager.selected_song != "" and PlaylistManager.has_next_song():
		var new_song: Song = PlaylistManager.get_next_song(1, PlaylistManager.play_mode)
		TrackManager.change_song(new_song.name, new_song.author)
		set_song(AudioManager.song_library.get_song(AudioManager.selected_song,AudioManager.selected_author))

func prev_song():
	if AudioManager.selected_song != "" and PlaylistManager.has_next_song(-1):
		var new_song: Song = PlaylistManager.get_next_song(-1, PlaylistManager.play_mode)
		TrackManager.change_song(new_song.name, new_song.author)
		set_song(AudioManager.song_library.get_song(AudioManager.selected_song,AudioManager.selected_author))
