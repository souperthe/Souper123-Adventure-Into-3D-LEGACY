extends Node2D

var score = 0
var debug = true
var player
var lives = 2
var music_index= AudioServer.get_bus_index("Music")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	OS.center_window()
	get_viewport().transparent_bg = true
	#Engine.target_fps = 30
	pass # Replace with function body.


func reset():
	AudioServer.set_bus_volume_db(music_index, 0)
	music_controller.stopmusic()
	score = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
