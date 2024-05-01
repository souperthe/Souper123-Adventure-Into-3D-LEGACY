extends Control

var state = 1
var pos
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	$RichTextLabel.text = str("score: ", global.score)
	$RichTextLabel2.text = str("player state: ", state)
	$RichTextLabel3.text = str("delta: ", delta)
	$RichTextLabel4.text = str("player position: ", pos)
	pass
