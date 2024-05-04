extends Control

var paused = false
var selection = 1
var xoffset = -3
onready var selecthing = $mainstuff/resume

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$mainstuff/pointer.rect_position.y = selecthing.rect_position.y + 10
	$mainstuff/pointer.rect_position.x = selecthing.rect_position.x + xoffset
	match(selection):
		1:
			xoffset = -3
			selecthing = $mainstuff/resume
		2:
			xoffset = -15
			selecthing = $mainstuff/restart
		3:
			xoffset = -13
			selecthing = $mainstuff/settings
		4:
			xoffset = 33
			selecthing = $mainstuff/exit
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
	if paused:
		pause()
	pass
	
	

	
func pause():
	if selection < 1:
		selection = 4
	if selection > 4:
		selection = 1
	if Input.is_action_just_pressed("ui_accept"):
		match(selection):
			1:
				paused = false
				visible = false
				get_tree().paused = false
				$AudioStreamPlayer2.play()
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			2:
				get_tree().reload_current_scene()
				global.reset()
				paused = false
				visible = false
				get_tree().paused = false
				$AudioStreamPlayer2.play()
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			3:
				pass
			4:
				get_tree().change_scene("res://assets/scenes/title.tscn")
				paused = false
				visible = false
				get_tree().paused = false
				$AudioStreamPlayer2.play()
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				global.reset()
	if Input.is_action_just_pressed("player_up") or Input.is_action_just_pressed("ui_up"):
		selection -= 1
		$AudioStreamPlayer2.play()
	if Input.is_action_just_pressed("player_down") or Input.is_action_just_pressed("ui_down"):
		selection += 1
		$AudioStreamPlayer2.play()
