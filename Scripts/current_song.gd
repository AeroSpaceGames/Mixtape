extends Control

var on_play: Array[CompressedTexture2D] = [preload("res://Asssets/PNG/New Assets MixTape/Player_Buttons/Play_Button_Released (Animation).png"), preload("res://Asssets/PNG/New Assets MixTape/Player_Buttons/Play_Button_Pressed (Animation).png")]
var on_pause: Array[CompressedTexture2D] = [preload("res://Asssets/PNG/New Assets MixTape/Player_Buttons/Pause_Button_Released (Animation).png"), preload("res://Asssets/PNG/New Assets MixTape/Player_Buttons/Pause_Button_Pressed (Animation).png")]
var led_texts: Array[CompressedTexture2D] = [preload("res://Asssets/PNG/New Assets MixTape/Player_Buttons/Led_Off_(Playing_Animation).png"), preload("res://Asssets/PNG/New Assets MixTape/Player_Buttons/Led_On_(Playing_Animation).png")]

var play_mode_textures: Array[CompressedTexture2D] = [preload("res://Asssets/PNG/New Assets MixTape/Player_Buttons/In Order_Mode_Button.png"), preload("res://Asssets/PNG/New Assets MixTape/Player_Buttons/Shuffle_Mode_Button.png")]

@onready var my_name: Label = $Name
@onready var author: Label = $Author
@onready var seconds: Timer = $Seconds
@onready var time_preview: HSlider = $TimePreview
@onready var total_duration: Label = %TotalDuration
@onready var actual_secs: Label = %ActualSecs
@onready var led: TextureRect = %Led

@export var repeat_mode: bool = false

@onready var pause: TextureButton = %Pause
@onready var play: TextureButton = %Play
@onready var play_mode: TextureButton = %PlayMode

@onready var casette_anims: AnimationPlayer = %CasetteAnims


func _ready() -> void:
	AudioManager.connect("song_ended", restart_playlist)

func restart_playlist():
	if PlaylistManager.mix_library.mixtape_list[PlaylistManager.selected_mix].song_indexes.size() <= 1:
		PlaylistManager.playlist_index -= 1
	if repeat_mode:
		PlaylistManager.playlist_index -= 1
	else:
		if !PlaylistManager.has_next_song():
			PlaylistManager.generate_playlist(PlaylistManager.mix_library.mixtape_list[PlaylistManager.selected_mix].song_indexes, PlaylistManager.play_mode)
	next_song()

func change_play_mode():
	PlaylistManager.play_mode += 1
	PlaylistManager.play_mode %= 2 #Luego se cambia a 3. (Por el modo inteligente)
	play_mode.texture_normal = play_mode_textures[PlaylistManager.play_mode]
	play_mode.texture_pressed = play_mode_textures[PlaylistManager.play_mode]
	play_mode.texture_focused = play_mode_textures[PlaylistManager.play_mode]
	play_mode.texture_hover = play_mode_textures[PlaylistManager.play_mode]

func set_song(data: Song):
	seconds.paused = false
	seconds.start(1)
	time_preview.value = 0
	time_preview.max_value = data.duration
	total_duration.text = str(int(time_preview.max_value))
	my_name.text = data.name
	author.text = data.author
	actual_secs.text = from_seconds_to_clockhour(int(time_preview.value))
	led.texture = led_texts[int(AudioManager.playing)]
	casette_anims.play("Starting")
	
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
		casette_anims.play("Stopping")

func really_paused_song():
	seconds.paused = true
	AudioManager.pause()
	led.texture = led_texts[int(AudioManager.playing)]
	play.texture_normal = on_play[int(AudioManager.playing)]
	pause.texture_normal = on_pause[int(!AudioManager.playing)]

func resume_song():
	if AudioManager.selected_song != "":
		seconds.paused = false
		AudioManager.resume()
		led.texture = led_texts[int(AudioManager.playing)]
		play.texture_normal = on_play[int(AudioManager.playing)]
		pause.texture_normal = on_pause[int(!AudioManager.playing)]
		casette_anims.play("Starting")

func stop_restart_song():
	if AudioManager.selected_song != "":
		time_preview.value = 0.0
		actual_secs.text = from_seconds_to_clockhour(int(time_preview.value))
		AudioManager.stop_restart()
		play.texture_normal = on_play[int(AudioManager.playing)]
		pause.texture_normal = on_pause[int(!AudioManager.playing)]
		casette_anims.play("Restart")
		queue_casette_anim()

func queue_casette_anim():
	if AudioManager.playing:
		casette_anims.queue("Roll")
	else:
		casette_anims.queue("Stop")

func next_song():
	if AudioManager.selected_song != "" and PlaylistManager.has_next_song():
		var new_song: Song = PlaylistManager.get_next_song(1)
		TrackManager.change_song(new_song.name, new_song.author)
		set_song(AudioManager.song_library.get_song(AudioManager.selected_song,AudioManager.selected_author))
		casette_anims.play("Next")
		queue_casette_anim()

func prev_song():
	if AudioManager.selected_song != "" and PlaylistManager.has_next_song(-1):
		var new_song: Song = PlaylistManager.get_next_song(-1)
		TrackManager.change_song(new_song.name, new_song.author)
		set_song(AudioManager.song_library.get_song(AudioManager.selected_song,AudioManager.selected_author))
		casette_anims.play_backwards("Next")
		queue_casette_anim()


func _on_time_preview_value_changed(value: float) -> void:
	actual_secs.text = from_seconds_to_clockhour(int(value))

func set_repeat_mode(toggled: bool):
	repeat_mode = toggled
