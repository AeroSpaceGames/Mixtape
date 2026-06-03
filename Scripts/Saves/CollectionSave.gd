extends Resource
class_name CollectionSave

const SAVE_GAME_PATH = "user://collection.tres"

@export var casettes: Dictionary[String, Array]
# "a" : [my name, design, [song indexes]]

func load_mix_from_coll(nm: String, data: Array):
	var new_casette: Casette = Casette.new()
	new_casette.my_name = data[0]
	new_casette.design = data[1]
	new_casette.duration = data[2]
	new_casette.song_indexes = data[3]
	PlaylistManager.collection_library.casette_list[nm] = new_casette

func write_savegame() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH)

static func save_exists() -> bool:
	return ResourceLoader.exists(SAVE_GAME_PATH)

static func load_savegame():
	return ResourceLoader.load(SAVE_GAME_PATH, "", 1)
