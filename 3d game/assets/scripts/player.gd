class_name Player
extends KinematicBody

var look_rot = Vector3.ZERO
var camera_dir = 0
var move_dir = Vector3.ZERO
var velocity = Vector3.ZERO
var mouse = Vector2()

var maxangle = 90
var minangle = -80
var grounded = false
var movespeed = 20
onready var model = $soupermodel
var gravity = 1
onready var camera = $camera
var jumpheight = 25
var doland = false

enum states{
	normal,
	jump,
	punch,
	wallbounce,
	gp_prep
}
var state = states.wallbounce
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
		
		
func funnysfx():
	var whiteflash = preload("res://assets/objects/funnynoise.tscn")
	var ghost: Spatial = whiteflash.instance()
	get_tree().get_current_scene().add_child(ghost)
	ghost.translation = self.translation
	ghost.sound()


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
	camera_dir = -$camera.rotation.rotated(Vector3.UP, $camera.rotation.y).normalized()
	var dir = $camera.transform.basis
	var movex = float(move_dir.x)
	var movez = float(move_dir.z)
	var snapvector = Vector3.DOWN
	#$shadow.translation.y = $RayCast.target_translation.y
	match(state):
		states.normal:
			snapvector = Vector3.DOWN
			velocity.x = lerp(velocity.x, movex * movespeed, 8 * delta)
			velocity.z = lerp(velocity.z, movez * movespeed, 8 * delta)
			if move_dir.x == 0 and move_dir.y == 0:
				$soupermodel/root/limb.playback_speed = 2
				$soupermodel/root/limb.play("idlenew")
			else:
				$soupermodel/root/limb.playback_speed = 4
				$soupermodel/root/limb.play("idlenew 2")
			if !movex == 0:
				$soupermodel.rotation.y = atan2(-velocity.x, -velocity.z)
				#$$soupermodel/root.rotation.x = -velocity.x
			if key_jump2:
				snapvector = Vector3.UP
				velocity.y = jumpheight
				state = states.jump
				$jump.play()
				doland = true
				$soupermodel/AnimationPlayer.stop()
				$soupermodel/AnimationPlayer.play("actual jump")
				$soupermodel/root/limb.playback_speed = 3
				$soupermodel/root/limb.play("actual jump")
			if key_m12:
				state = states.punch
				$soupermodel/root/limb.play("idle")
				velocity.z = camera_dir.z * 25
				velocity.x = camera_dir.x * 25
				#velocity = (floor_checker.global_position - self_center.global_position).normalized() * jetpack_scala
				velocity.y = jumpheight
				#$soupermodel.rotation.y = $camera.rotation.y
			if !is_on_floor():
				state = states.jump
				#velocity.y = 0
		states.jump:
			if is_on_wall():
				if key_jump2:
					$bounce.play()
					$land.play()
					$soupermodel/AnimationPlayer.play("actual jump")
					state = states.wallbounce
					$soupermodel/root/limb.playback_speed = 3
					$soupermodel/root/limb.play("spin")
					velocity.y = jumpheight * 1.5
					velocity.x = -velocity.x
					velocity.z = -velocity.z
			if key_run:
				$soupermodel/root/limb.playback_speed = 1
				$soupermodel/root/limb.play("groundpoundprep")
				state = states.gp_prep
				velocity.y = jumpheight * 2
			if $soupermodel/root/limb.current_animation != ("actual jump") and $soupermodel/root/limb.current_animation != ("groundpoundprep"):
				$soupermodel/root/limb.play("fall")
			snapvector = Vector3.UP
			velocity.x = lerp(velocity.x, movex * movespeed, 5 * delta)
			velocity.z = lerp(velocity.z, movez * movespeed, 5 * delta)
			if not is_on_floor():
				velocity.y -= gravity
			if grounded:
				$soupermodel/AnimationPlayer.stop()
				$soupermodel/AnimationPlayer.play("jump")
				$land.play()
				velocity.y = 0
				grounded = true
				state = states.normal
				velocity.y -= 10
		states.wallbounce:
			if key_run:
				$soupermodel/root/limb.playback_speed = 1
				$soupermodel/root/limb.play("groundpoundprep")
				state = states.gp_prep
				velocity.y = jumpheight * 2
			$soupermodel/root/limb.playback_speed = 15
			if $soupermodel/root/limb.current_animation != ("actual jump") and $soupermodel/root/limb.current_animation != ("groundpoundprep"):
				$soupermodel/root/limb.play("spin")
			snapvector = Vector3.UP
			velocity.x = lerp(velocity.x, movex * movespeed, 2 * delta)
			velocity.z = lerp(velocity.z, movez * movespeed, 2 * delta)
			if not is_on_floor():
				velocity.y -= gravity
			if grounded:
				$soupermodel/AnimationPlayer.stop()
				$soupermodel/AnimationPlayer.play("jump")
				$land.play()
				velocity.y = 0
				grounded = true
				state = states.normal
				velocity.y -= 10
		states.punch:
			velocity.y -= gravity
			snapvector = Vector3.UP
			if grounded:
				#funnysfx()
				velocity.y = jumpheight
				#$soupermodel/root/limb.play("my big money")
				#$soupermodel/AnimationPlayer.stop()
				#$soupermodel/AnimationPlayer.play("actual jump")
				#$soupermodel/root/limb.playback_speed = rand_range(180,-180)
				$soupermodel.rotation.z = rand_range(180,-180)
				$soupermodel.rotation.x = rand_range(180,-180)
				$soupermodel.rotation.y = rand_range(180,-180)
		states.gp_prep:
			velocity.x = lerp(velocity.x, 0, 5 * delta)
			velocity.z = lerp(velocity.z, 0, 5 * delta)
			snapvector = Vector3.UP
			$soupermodel/root/limb.playback_speed = 7
			velocity.y -= gravity * 4
			if is_on_floor():
				$bounce.play()
				$land.play()
				$soupermodel/AnimationPlayer.play("actual jump")
				state = states.wallbounce
				$soupermodel/root/limb.playback_speed = 3
				$soupermodel/root/limb.play("spin")
				velocity.y = jumpheight * 1.5
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
