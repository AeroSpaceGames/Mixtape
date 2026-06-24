extends Control

signal play_me(nm: String, auth: String, md: int)
signal add_remove(idx: int)

var my_index: int = -1

@onready var my_name: Label = $Name
@onready var author: Label = $Author
var in_playlist: bool = false
@onready var play: TextureButton = $Play
@onready var add: CheckBox = $Add
@onready var duration: Label = $Duration

func _ready() -> void:
	if in_playlist:
		play.hide()
		duration.hide()
	else:
		add.hide()
	
	duration.text = from_seconds_to_clockhour(AudioManager.song_library.get_song(my_name.text, author.text).duration)

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

func add_toggle(_toggle: bool):
	add_remove.emit(my_index)

func send_metadata():
	AudioManager.playing_song_index = my_index
	play_me.emit(my_name.text, author.text, PlaylistManager.play_mode)
