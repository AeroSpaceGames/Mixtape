extends Node
@onready var text_edit: Control = %TextEdit
@onready var mixes_groups: Node = %MixesGroups

var _coll: CollectionSave

# "My Mixtape" : [design1: int, design2: int , duration: float, [songs_index: index]]

func create_new_mix():
	var new_mixtape: Mixtape = Mixtape.new()
	new_mixtape.my_name = "NewMixtape" + str(PlaylistManager.new_mixes_name) if "NewMixtape" in PlaylistManager.mix_library.mixtape_list else "NewMixtape"
	new_mixtape.duration = 0.0
	new_mixtape.design = PlaylistManager.designs.pick_random()
	new_mixtape.song_indexes = []
	PlaylistManager.add_mixtape(new_mixtape.my_name, new_mixtape)
	
	
	#Save control
	if CollectionSave.save_exists():
		_coll = CollectionSave.load_savegame() as CollectionSave
		_coll.mixtapes[new_mixtape.my_name] = [new_mixtape.my_name, new_mixtape.design, new_mixtape.duration, new_mixtape.song_indexes]
		_coll.new_mix_name += 1
		PlaylistManager.new_mixes_name += 1
		_coll.write_savegame()
	
	mixes_groups.create_groups()
