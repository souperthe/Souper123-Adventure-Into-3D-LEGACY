extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	music_controller.songplay("res://assets/sound/mu_titlebeat.ogg", false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button2_pressed():
	#get_tree().change_scene("res://assets/scenes/bob.tscn")
	$CanvasLayer/Control/FileDialog.popup()
	pass # Replace with function body.


func _on_Button_pressed():
	get_tree().change_scene("res://assets/scenes/test.tscn")
	pass # Replace with function body.


func _on_FileDialog_file_selected(path):
	get_tree().change_scene(path)
	music_controller.stopmusic()
	pass # Replace with function body.
