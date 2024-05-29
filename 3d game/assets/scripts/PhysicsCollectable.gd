extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var gravity = 0.5
var velocity = Vector3.ZERO
var snapvector = Vector3.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y -= gravity
	if is_on_floor():
		velocity.x = lerp(velocity.x, 0, 3 * delta)
		velocity.z = lerp(velocity.z, 0, 3 * delta)
	if !$collectable:
		queue_free()
	move_and_slide_with_snap(velocity, snapvector, Vector3.UP, true)
#	pass
