extends Control

@onready var my_name: Label = $Name
@onready var author: Label = $Author
@onready var pause: Button = $Pause
@onready var seconds: Timer = $Seconds
@onready var time_preview: HSlider = $TimePreview
@onready var play_mode: Button = $PlayMode
@onready var total_duration: Label = %TotalDuration
@onready var actual_secs: Label = %ActualSecs

func _ready() -> void:
	AudioManager.connect("song_ended", restart_playlist)

func restart_playlist():
	if !PlaylistManager.has_next_song():
		PlaylistManager.generate_playlist(PlaylistManager.mix_library.mixtape_list[PlaylistManager.selected_mix].song_indexes, 1)
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
	total_duration.text = str(int(time_preview.max_value))
	my_name.text = data.name
	author.text = data.author
	pause.text = "pause"

func second_passed():
	time_preview.value += 1
	actual_secs.text = str(int(time_preview.value))

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
		var new_song: Song = PlaylistManager.get_next_song(1)
		TrackManager.change_song(new_song.name, new_song.author)
		set_song(AudioManager.song_library.get_song(AudioManager.selected_song,AudioManager.selected_author))

func prev_song():
	if AudioManager.selected_song != "" and PlaylistManager.has_next_song(-1):
		var new_song: Song = PlaylistManager.get_next_song(-1)
		TrackManager.change_song(new_song.name, new_song.author)
		set_song(AudioManager.song_library.get_song(AudioManager.selected_song,AudioManager.selected_author))


func _on_time_preview_value_changed(value: float) -> void:
	actual_secs.text = str(int(value))
