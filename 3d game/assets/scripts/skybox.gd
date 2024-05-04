extends CanvasLayer

export (NodePath) var target
onready var realtarget = get_node(target)
export (String) var skytexture = "res://assets/images/bluesky.png"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/ParallaxBackground/ParallaxLayer/TextureRect.texture = load(skytexture)
	pass # Replace with function body.


func _process(delta):
	$Control/ParallaxBackground/ParallaxLayer.motion_mirroring = OS.window_size
	$Control/ParallaxBackground/ParallaxLayer/TextureRect.rect_size = OS.window_size
	#$Control/TextureRect.material.set_shader_param(scale, 100)
	$Control/ParallaxBackground.scroll_offset.x = realtarget.camera.rotation.y / 1.5
	$Control/ParallaxBackground.scroll_offset.y = -realtarget.camera.rotation.z / 5
	pass
