extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	
func thing1():
	var whiteflash = preload("res://assets/objects/sparkle.tscn")
	var ghost: Spatial = whiteflash.instance()
	get_tree().get_current_scene().add_child(ghost)
	ghost.translation = self.translation
	ghost.translation.y = self.translation.y + 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_collectable_body_entered(body):
	if body is Player:
		queue_free()
		global.score += 1
		thing1()
	pass # Replace with function body.
