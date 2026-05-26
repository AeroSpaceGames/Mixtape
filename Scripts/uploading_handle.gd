extends Node

@onready var file_dialog: FileDialog = %FileDialog
@onready var edit_song_data: Control = %EditSongData
@onready var group_handle: Node = %GroupHandle

signal my_file(nm: String, auth: String)

var _lib: LibrarySave

func open_file_manager():
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.filters = PackedStringArray(["*.wav, *.ogg, *.mp3 ; Music"])
	file_dialog.show()

func open_folder_manager():
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	file_dialog.filters = PackedStringArray([""])
	file_dialog.show()

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

func file_selected(path: String, autoplay: bool = true):
	var file_res: Song = Song.new()
	
	file_res.stream = load_song_file(path)
	file_res.name = path.get_file().get_basename()
	@warning_ignore("narrowing_conversion")
	file_res.duration = file_res.stream.get_length()
	edit_song_data.show_song(file_res)
	await edit_song_data.author_changed
	file_res.author = edit_song_data.new_author_name
	file_res.path = path
	AudioManager.add_song(file_res)
	if autoplay:
		AudioManager.selected_song = file_res.name
		AudioManager.selected_author = file_res.author
		var new_song_res: Song = AudioManager.song_library.get_song(file_res.name, file_res.author)
		AudioManager.play_song(new_song_res)
		PlaylistManager.generate_random_playlist()
		my_file.emit(file_res.name, file_res.author)
	 
	if LibrarySave.save_exists():
		_lib = LibrarySave.load_savegame() as LibrarySave
		for i in AudioManager.song_library.songs_list.values():
			_lib.songs_key_data[i.path] = i.author
		_lib.write_savegame()
	
	group_handle.create_groups()

func scan_folder(folder_path: String):
	var dir = DirAccess.open(folder_path)
	
	if dir == null:
		print("no se pudo abrir la carpeta")
		return
	
	dir.list_dir_begin()
	
	while true:
		
		var file_name = dir.get_next()
		
		if file_name == "":
			break
		
		if dir.current_is_dir():
			continue
		
		var full_path = folder_path + "/" + file_name
		
		var extension = file_name.get_extension().to_lower()
		
		
		if extension in ["mp3", "ogg", "wav"]:
			file_selected(full_path, false)
			await edit_song_data.author_changed
		
		await get_tree().create_timer(0.1).timeout
	dir.list_dir_end()

func dir_selected(dir: String):
	scan_folder(dir)
