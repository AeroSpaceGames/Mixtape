extends Node
@onready var tabs: AnimationPlayer = %Tabs

func go_to_library():
	tabs.play("Library")

func go_to_collection():
	tabs.play("Collection")
