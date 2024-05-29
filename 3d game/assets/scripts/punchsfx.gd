extends Spatial

var thing = 0
var rang = RandomNumberGenerator.new()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
	
	
func sound():
	rang.randomize()
	thing = rang.randi_range(6,11)
	$Timer.start()
	if thing == 11:
		$a.play()
	if thing  == 10:
		$b.play()
	if thing  == 9:
		$c.play()
	if thing  == 8:
		$d.play()
	if thing  == 7:
		$e.play()
	if thing  == 6:
		$f.play()
	




func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
