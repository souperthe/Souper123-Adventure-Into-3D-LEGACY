extends Spatial

var thing = 0
var rang = RandomNumberGenerator.new()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
	
	
func sound():
	rang.randomize()
	thing = rang.randi_range(1,11)
	$Timer.start()
	if thing == 11:
		$k.play()
	if thing  == 10:
		$j.play()
	if thing  == 9:
		$i.play()
	if thing  == 8:
		$h.play()
	if thing  == 7:
		$g.play()
	if thing  == 6:
		$f.play()
	if thing  == 5:
		$e.play()
	if thing  == 4:
		$d.play()
	if thing  == 3:
		$c.play()
	if thing  == 2:
		$b.play()
	if thing  == 1:
		$a.play()
	




func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
