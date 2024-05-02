extends Control

var paused = false
var selection = 1
onready var selecthing = $mainstuff/resume

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$mainstuff/pointer.rect_position = selecthing.rect_position
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
		paused = !paused
		if get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$AudioStreamPlayer.play()
			$AnimationPlayer.play("pause")
		if !get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			$AudioStreamPlayer.play()
			$AnimationPlayer.play("unpause")
	pass
