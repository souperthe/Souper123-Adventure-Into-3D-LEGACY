extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var temp = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	temp = $song.get_playback_position()
	pass

func songplay(id, time):
	if $song.stream != load(id):
		$song.stream = load(id)
		$song.play()
		if time:
			$song.seek(temp)
			
func stopmusic():
	$song.stop()
	$song.stream = null
