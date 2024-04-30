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
var gravity = 2
onready var camera = $camera
var jumpheight = 35
var doland = false
var punchtime = 60
var jumps = float(1)
var attackcooldown = 10


enum states{
	normal,
	jump,
	punch,
	wallbounce,
	gp_prep,
	attackjump
}
var state = states.wallbounce
var dropshadow_distance = 0
var walljumped = float(1.0)

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
	
func punch():
	if attackcooldown < 0 and key_m12:
		$soupermodel/root/limb.play("idle")
		punchtime = 100
		attackcooldown = 10
		velocity.z = camera_dir.z * 30
		velocity.x = camera_dir.x * 30
		$soupermodel.rotation.y = atan2(-camera_dir.x, -camera_dir.z)
		#velocity = (floor_checker.global_position - self_center.global_position).normalized() * jetpack_scala
		state = states.punch
		#$soupermodel/AnimationPlayer.play("attack")
		if !is_on_floor():
			velocity.y += jumpheight / 2
				#$soupermodel.rotation.y = $camera.rotation.y
	


func _physics_process(delta):
	attackcooldown -= 15 * delta
	global.player = self
	#$dropshadow.translation = translation
	get_inputs()
	grounded = is_on_floor()
	var thing = 1.5 - (dropshadow_distance / 5)
	var cameratwist = $camera.rotation.normalized()
	$camera.rotation_degrees.y = lerp($camera.rotation_degrees.y, look_rot.y, 15 * delta)
	$camera.rotation_degrees.x = lerp($camera.rotation_degrees.x, look_rot.x, 15 * delta)
	if is_on_floor():
		velocity.y = 0
	move_dir = Vector3(key_sright - key_sleft, 0, key_sdown - key_sup).normalized().rotated(Vector3.UP, $camera.rotation.y)
	camera_dir = -($camera.transform.basis.z).normalized()
	var dir = $camera.transform.basis
	var movex = float(move_dir.x)
	var movez = float(move_dir.z)
	var snapvector = Vector3.DOWN
			# call the zoom function
		# zoom out
	if Input.is_action_just_released("player_scrollup"):
		$camera/SpringArm.spring_length -= 1
	if Input.is_action_just_released("player_scrolldown"):
		$camera/SpringArm.spring_length += 1
		
	#$shadow.translation.y = $RayCast.target_translation.y
	match(state):
		states.normal:
			walljumped = 1
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
			if grounded and key_jump2:
				snapvector = Vector3.UP
				velocity.y = jumpheight
				state = states.jump
				$jump.play()
				doland = true
				$soupermodel/AnimationPlayer.stop()
				$soupermodel/AnimationPlayer.play("actual jump")
				$soupermodel/root/limb.playback_speed = 3
				$soupermodel/root/limb.play("actual jump")
			if !is_on_floor():
				state = states.jump
				#velocity.y = 0
			punch()
		states.jump:
			if key_run2:
				$soupermodel/root/limb.playback_speed = 0.5
				$soupermodel/root/limb.play("groundpoundprep")
				#$soupermodel/AnimationPlayer.stop()
				#$soupermodel/AnimationPlayer.play("actual jump")
				$soupermodel/yea.play()
				state = states.gp_prep
				velocity.y = jumpheight * 2
			if $soupermodel/root/limb.current_animation != ("actual jump") and $soupermodel/root/limb.current_animation != ("groundpoundprep")  and $soupermodel/root/limb.current_animation != ("gp_jump"):
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
			punch()
		states.wallbounce:
			if key_run2:
				$soupermodel/root/limb.playback_speed = 0.5
				$soupermodel/root/limb.play("groundpoundprep")
				#$soupermodel/AnimationPlayer.stop()
				#$soupermodel/AnimationPlayer.play("actual jump")
				$soupermodel/yea.play()
				state = states.gp_prep
				velocity.y = jumpheight * 2
			$soupermodel/root/limb.playback_speed = 15
			if $soupermodel/root/limb.current_animation != ("actual jump") and $soupermodel/root/limb.current_animation != ("groundpoundprep"):
				$soupermodel/root/limb.play("spin")
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
			punch()
		states.punch:
			if key_jump2:
				state = states.attackjump
				velocity.y = jumpheight
			if grounded:
				snapvector = Vector3.DOWN
			if !grounded:
				snapvector = Vector3.UP
			if !grounded and is_on_wall():
				#$soupermodel.rotation.y = -$soupermodel.rotation.y
				$bounce.play()
				$land.play()
				$soupermodel/AnimationPlayer.stop()
				$soupermodel/AnimationPlayer.play("actual jump")
				walljumped += -0.1
				state = states.wallbounce
				$soupermodel/root/limb.playback_speed = 3
				$soupermodel/root/limb.play("spin")
				velocity.y = walljumped * (jumpheight * 1.5)
				velocity.x = -velocity.x
				velocity.z = -velocity.z
			if grounded and is_on_wall():
				velocity.x = -velocity.x / 2.5
				velocity.z = -velocity.z / 2.5
			$soupermodel/root/limb.play("idle")
			velocity.y -= gravity
			snapvector = Vector3.UP
			punchtime -= 300 * delta
			if !punchtime > 0:
				state = states.normal
				velocity.y = 0
		states.gp_prep:
			velocity.x = lerp(velocity.x, movex * movespeed, 5 * delta)
			velocity.z = lerp(velocity.z, movez * movespeed, 5 * delta)
			snapvector = Vector3.UP
			$soupermodel/root/limb.playback_speed = 4
			velocity.y -= gravity * 3
			if is_on_floor():
				#$bounce.play()
				$land.play()
				$soupermodel/AnimationPlayer.stop()
				$soupermodel/AnimationPlayer.play("actual jump")
				state = states.jump
				$soupermodel/root/limb.playback_speed = 3
				$soupermodel/root/limb.play("gp_jump")
				velocity.y = jumpheight * 1
		states.attackjump:
			if key_run2:
				$soupermodel/root/limb.playback_speed = 0.5
				$soupermodel/root/limb.play("groundpoundprep")
				#$soupermodel/AnimationPlayer.stop()
				#$soupermodel/AnimationPlayer.play("actual jump")
				$soupermodel/yea.play()
				state = states.gp_prep
				velocity.y = jumpheight * 2
			$soupermodel/root/limb.playback_speed = 20
			if $soupermodel/root/limb.current_animation != ("actual jump") and $soupermodel/root/limb.current_animation != ("groundpoundprep"):
				$soupermodel/root/limb.play("spin")
			snapvector = Vector3.UP
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
	move_and_slide_with_snap(velocity, snapvector, Vector3.UP, true)
				
			
			
			
			
			




## inputs
var key_left = 0
var key_right = 0
var key_up = 0
var key_down = 0
var key_jump = 0
var key_jump2 = 0
var key_run = 0
var key_run2 = 0
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
	key_run2 = Input.is_action_just_pressed("player_run")
	key_m1 = Input.is_action_pressed("player_action1")
	key_m12 = Input.is_action_just_pressed("player_action1")
	key_m2 = Input.is_action_pressed("player_action2")
	key_m22 = Input.is_action_just_pressed("player_action2")
	key_sleft = Input.get_action_strength("player_left")
	key_sright = Input.get_action_strength("player_right")
	key_sup = Input.get_action_strength("player_up")
	key_sdown = Input.get_action_strength("player_down")
