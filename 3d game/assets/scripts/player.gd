class_name Player
extends KinematicBody

var look_rot = Vector3.ZERO
var move_dir = Vector3.ZERO
var velocity = Vector3.ZERO
var mouse = Vector2()

var maxangle = 90
var minangle = -80
var grounded = false
var movespeed = 20
var gravity = 1
var jumpheight = 25
var doland = false

enum states{
	normal,
	jump
}
var state = states.normal
var dropshadow_distance = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		look_rot.y -= (event.relative.x * 0.2)
		look_rot.x -= (event.relative.y * 0.2)
		look_rot.x = clamp(look_rot.x, minangle, maxangle)
		mouse = event.position


func _physics_process(delta):
	#$dropshadow.translation = translation
	get_inputs()
	grounded = is_on_floor()
	var thing = 1.5 - (dropshadow_distance / 5)
	$camera.rotation_degrees.y = look_rot.y
	$camera.rotation_degrees.x = look_rot.x
	if is_on_floor():
		velocity.y = 0
	move_dir = Vector3(key_sright - key_sleft, 0, key_sdown - key_sup).normalized().rotated(Vector3.UP, $camera.rotation.y)
	var movex = float(move_dir.x * movespeed)
	var movez = float(move_dir.z * movespeed)
	var snapvector = Vector3.DOWN
	#$shadow.translation.y = $RayCast.target_translation.y
	match(state):
		states.normal:
			snapvector = Vector3.DOWN
			velocity.x = lerp(velocity.x, movex, 8 * delta)
			velocity.z = lerp(velocity.z, movez, 8 * delta)
			if move_dir.x == 0 and move_dir.y == 0:
				$soupermodel/root/limb.playback_speed = 2
				$soupermodel/root/limb.play("idlenew")
			else:
				$soupermodel/root/limb.playback_speed = 4
				$soupermodel/root/limb.play("idlenew 2")
			if !movex == 0:
				$soupermodel.rotation.y = atan2(-velocity.x, -velocity.z)
			if key_jump2:
				snapvector = Vector3.UP
				velocity.y = jumpheight
				state = states.jump
				$jump.play()
				doland = true
				$soupermodel/AnimationPlayer.play("actual jump")
				$soupermodel/root/limb.playback_speed = 2.5
				$soupermodel/root/limb.play("actual jump")
				#$soupermodel.rotation.y = $camera.rotation.y
			if !is_on_floor():
				state = states.jump
				#velocity.y = 0
		states.jump:
			if $soupermodel/root/limb.current_animation != ("actual jump"):
				$soupermodel/root/limb.play("fall")
			snapvector = Vector3.UP
			velocity.x = lerp(velocity.x, movex, 1 * delta)
			velocity.z = lerp(velocity.z, movez, 1 * delta)
			if not is_on_floor():
				velocity.y -= gravity
			if grounded:
				$soupermodel/AnimationPlayer.play("jump")
				$land.play()
				velocity.y = 0
				grounded = true
				state = states.normal
				velocity.y -= 10
	move_and_slide_with_snap(velocity, snapvector, Vector3.UP, true)
				
			
			
			
			
			




## inputs
var key_left = 0
var key_right = 0
var key_up = 0
var key_down = 0
var key_jump = 0
var key_jump2 = 0
var key_run = 0
var key_m1 = 0
var key_m12 = 0
var key_m2 = 0
var key_m22 = 0
var key_sleft = 0
var key_sright = 0
var key_sup = 0
var key_sdown = 0

func get_inputs():
	key_left = Input.is_action_pressed("player_left")
	key_right = Input.is_action_pressed("player_right")
	key_up = Input.is_action_pressed("player_up")
	key_down = Input.is_action_pressed("player_down")
	key_jump = Input.is_action_pressed("player_jump")
	key_jump2 = Input.is_action_just_pressed("player_jump")
	key_run = Input.is_action_pressed("player_run")
	key_m1 = Input.is_action_pressed("player_action1")
	key_m12 = Input.is_action_just_pressed("player_action1")
	key_m2 = Input.is_action_pressed("player_action2")
	key_m22 = Input.is_action_just_pressed("player_action2")
	key_sleft = Input.get_action_strength("player_left")
	key_sright = Input.get_action_strength("player_right")
	key_sup = Input.get_action_strength("player_up")
	key_sdown = Input.get_action_strength("player_down")
