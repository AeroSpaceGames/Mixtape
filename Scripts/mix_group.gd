extends Control

var my_name: String = ""

signal mixtape_data(nm: String)
signal play_mix(nm: String)
@onready var select: Button = %Select
@onready var duration: Label = $Duration

func _ready() -> void:
	if my_name == "My Library":
		select.hide()
	
	if PlaylistManager.mix_library.mixtape_list[my_name].duration != 0:
		duration.text = from_seconds_to_clockhour(int(PlaylistManager.mix_library.mixtape_list[my_name].duration))

func set_data(nm: String):
	my_name = nm

func open_me():
	mixtape_data.emit(my_name)

func play_mixtape():
	play_mix.emit(my_name)


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
