extends Control

var on_play: Array[CompressedTexture2D] = [preload("res://Asssets/PNG/New Assets MixTape/Player_Buttons/Play_Button_Released (Animation).png"), preload("res://Asssets/PNG/New Assets MixTape/Player_Buttons/Play_Button_Pressed (Animation).png")]
var on_pause: Array[CompressedTexture2D] = [preload("res://Asssets/PNG/New Assets MixTape/Player_Buttons/Pause_Button_Released (Animation).png"), preload("res://Asssets/PNG/New Assets MixTape/Player_Buttons/Pause_Button_Pressed (Animation).png")]

@onready var my_name: Label = $Name
@onready var author: Label = $Author
@onready var seconds: Timer = $Seconds
@onready var time_preview: HSlider = $TimePreview
@onready var play_mode: Button = $PlayMode
@onready var total_duration: Label = %TotalDuration
@onready var actual_secs: Label = %ActualSecs

@export var repeat_mode: bool = false

@onready var pause: TextureButton = %Pause
@onready var play: TextureButton = %Play


func _ready() -> void:
	AudioManager.connect("song_ended", restart_playlist)

func restart_playlist():
	if repeat_mode:
		PlaylistManager.playlist_index -= 1
	else:
		if !PlaylistManager.has_next_song():
			PlaylistManager.generate_playlist(PlaylistManager.mix_library.mixtape_list[PlaylistManager.selected_mix].song_indexes, PlaylistManager.play_mode)
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
	
	play.texture_normal = on_play[1]
	pause.texture_normal = on_pause[0]

func second_passed():
	time_preview.value += 1
	actual_secs.text = from_seconds_to_clockhour(int(time_preview.value))

func from_seconds_to_clockhour(secs: int) -> String:
	var final_hour = ""
	@warning_ignore("integer_division")
	var hours = int(secs/3600)
	@warning_ignore("integer_division")
	var minutes = int(secs/60 - hours * 60)
	var second = secs - minutes * 60
	
	if hours > 0:
		final_hour = str(hours) + ":"
	final_hour += str(minutes) + ":" if minutes >= 10 else "0" + str(minutes) + ":"
	final_hour += str(second) if second >= 10 else "0" + str(second)
	
	return final_hour

func move_to_second(changed: bool):
	if changed:
		var sec = time_preview.value
		AudioManager.seek_second(sec)

func pause_song():
	if AudioManager.selected_song != "":
		AudioManager.pause()
		seconds.paused = true
	play.texture_normal = on_play[int(AudioManager.playing)]
	pause.texture_normal = on_pause[int(!AudioManager.playing)]

func resume_song():
	if AudioManager.selected_song != "":
		seconds.paused = false
		AudioManager.resume()
	play.texture_normal = on_play[int(AudioManager.playing)]
	pause.texture_normal = on_pause[int(!AudioManager.playing)]

func stop_restart_song():
	if AudioManager.selected_song != "":
		time_preview.value = 0.0
		actual_secs.text = from_seconds_to_clockhour(int(time_preview.value))
		AudioManager.stop_restart()
	play.texture_normal = on_play[int(AudioManager.playing)]
	pause.texture_normal = on_pause[int(!AudioManager.playing)]

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
	actual_secs.text = from_seconds_to_clockhour(int(value))

func set_repeat_mode(toggled: bool):
	repeat_mode = toggled
