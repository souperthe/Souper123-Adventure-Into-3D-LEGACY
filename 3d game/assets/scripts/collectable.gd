extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (bool) var physics


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	
func thing1():
	var whiteflash = preload("res://assets/objects/sparkle.tscn")
	var ghost: Spatial = whiteflash.instance()
	get_tree().get_current_scene().add_child(ghost)
	if not physics:
		ghost.translation = self.translation
		ghost.translation.y = self.translation.y + 1
	if physics:
		ghost.translation = owner.translation
		ghost.translation.y = owner.translation.y + 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_collectable_body_entered(body):
	if body ==global.player:
		queue_free()
		global.score += 1
		thing1()
	pass # Replace with function body.
