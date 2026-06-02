extends Node
@onready var text_edit: Control = %TextEdit
@onready var collection_groups: Node = %CollectionGroups

# "My Casette" : [design: int, duration: float, [songs_index: index]]

func create_new_casette():
	var new_casette: Casette = Casette.new()
	text_edit.show_casette()
	await text_edit.text_changed
	new_casette.my_name = text_edit.saved_name
	new_casette.duration = 0.0
	new_casette.design = PlaylistManager.designs.pick_random()
	new_casette.song_indexes = []
	PlaylistManager.add_casette(new_casette.my_name, new_casette)
	
	collection_groups.create_groups()
