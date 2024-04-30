extends DirectionalLight


export (NodePath) var target
onready var realtarget = get_node(target)
var thing = 60
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#look_at(realtarget.global_transform.origin, Vector3.UP)
	translation = realtarget.translation
	rotation = realtarget.camera.rotation
	pass
