extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	$Control/RichTextLabel.text = str("score: ", global.score)
	$Control/RichTextLabel2.text = str("player state: ", global.player.state)
	$Control/RichTextLabel3.text = str("delta: ", delta)
	pass
