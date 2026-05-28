extends Resource
class_name LibrarySave

const SAVE_GAME_PATH = "user://library.tres"

@export var songs_key_data: Dictionary[String,String]

#region load files
func load_wav(input_path: String):
	var bytes = FileAccess.get_file_as_bytes(input_path)
	
	var stream = AudioStreamWAV.load_from_buffer(bytes)
	
	return stream

func load_ogg(input_path: String):
	var bytes = FileAccess.get_file_as_bytes(input_path)
	
	var stream = AudioStreamOggVorbis.load_from_buffer(bytes)
	return stream

func load_mp3(input_path: String):
	var bytes = FileAccess.get_file_as_bytes(input_path)
	
	var stream = AudioStreamMP3.new()
	stream.data = bytes
	return stream

#endregion

func load_song_file(path: String) -> AudioStream:
	var extension: String = path.get_extension().to_lower()
	
	match extension:
		"wav":
			return load_wav(path)
		"ogg":
			return load_ogg(path)
		"mp3":
			return load_mp3(path)
	
	return null

func load_song_from_lib(path: String, auth: String):
	var file_res: Song = Song.new()
	
	if !FileAccess.file_exists(path):
		file_res.stream = AudioStream.new()
		file_res.name = path.get_file().get_basename()
		file_res.duration = 0
		file_res.author = "File Not Found"
		return file_res
	
	file_res.stream = load_song_file(path)
	file_res.name = path.get_file().get_basename()
	@warning_ignore("narrowing_conversion")
	file_res.duration = file_res.stream.get_length()
	file_res.author = auth
	AudioManager.add_song(file_res)

func write_savegame() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH)

static func save_exists() -> bool:
	return ResourceLoader.exists(SAVE_GAME_PATH)

static func load_savegame():
	return ResourceLoader.load(SAVE_GAME_PATH, "", 1)
