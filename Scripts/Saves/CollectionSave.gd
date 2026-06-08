extends Resource
class_name CollectionSave

const SAVE_GAME_PATH = "user://collection.tres"

@export var mixtapes: Dictionary[String, Array]
# "a" : [my name, design, [song indexes]]

func load_mix_from_coll(nm: String, data: Array):
	var new_mixtape: Mixtape = Mixtape.new()
	new_mixtape.my_name = data[0]
	new_mixtape.design = data[1]
	new_mixtape.duration = data[2]
	new_mixtape.song_indexes = data[3]
	PlaylistManager.mix_library.mixtape_list[nm] = new_mixtape

func write_savegame() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH)

static func save_exists() -> bool:
	return ResourceLoader.exists(SAVE_GAME_PATH)

static func load_savegame():
	@warning_ignore("int_as_enum_without_cast", "int_as_enum_without_match")
	return ResourceLoader.load(SAVE_GAME_PATH, "", 1)
