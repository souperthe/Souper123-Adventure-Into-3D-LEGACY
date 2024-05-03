extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$livestext.text = (str("%02d" % [global.lives]))
	$starstext.text = (str("%02d" % [global.score]))
	pass
