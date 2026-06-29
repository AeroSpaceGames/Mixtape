extends Node
@onready var tabs: AnimationPlayer = %Tabs

var player_on: Array[CompressedTexture2D] = [preload("res://Asssets/PNG/New Assets MixTape/Player_Button_Released_(Animation).png"),preload("res://Asssets/PNG/New Assets MixTape/Player_Button_Pressed_(Animation).png")]
var mixtape_on: Array[CompressedTexture2D] = [preload("res://Asssets/PNG/New Assets MixTape/Mixtape_Button_Released_(Animation).png"),preload("res://Asssets/PNG/New Assets MixTape/Mixtape_Button_Pressed_(Animation).png")]

@onready var coll: TextureButton = %Coll
@onready var lib: TextureButton = %Lib

func _ready() -> void:
	go_to_library()

func go_to_library():
	lib.texture_normal = player_on[1]
	coll.texture_normal = mixtape_on[0]
	tabs.play("Library")

func go_to_collection():
	lib.texture_normal = player_on[0]
	coll.texture_normal = mixtape_on[1]
	tabs.play("Collection")
