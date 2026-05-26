extends Resource
class_name SongLibrary

@export var songs_list : Dictionary[String,Song]

func get_song(nm: String, auth: String) -> Song:
	for i in songs_list.values():
		if i.author == auth and i.name == nm:
			return i
	return null
