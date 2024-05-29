class_name Player
extends KinematicBody

var look_rot = Vector3.ZERO
var camera_dir = 0
var model_dir = 0
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
var lastfloor = Vector3()
var distancefromlastfloor = 0
var shakeamount = 1
onready var rootanimator = $soupermodel/AnimationPlayer
onready var modelanimator = $soupermodel/root/limb

enum states{
	normal,
	jump,
	punch,
	wallbounce,
	gp_prep,
	attackjump,
	entercourse,
	actor,
	debug
}
var state = states.entercourse
var dropshadow_distance = 0
var walljumped = float(1.0)
onready var cam = $camera/SpringArm/Camera

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
		#look_rot.x = clamp(look_rot.x, minangle, maxangle)
		look_rot.x = -15
		mouse = event.position
		
		
func funnysfx():
	var whiteflash = preload("res://assets/objects/funnynoise.tscn")
	var ghost: Spatial = whiteflash.instance()
	get_tree().get_current_scene().add_child(ghost)
	ghost.translation = self.translation
	ghost.sound()
	
func thing1():
	var whiteflash = preload("res://assets/objects/poundeffect.tscn")
	var ghost: Spatial = whiteflash.instance()
	get_tree().get_current_scene().add_child(ghost)
	ghost.translation = self.translation
	
func thing2():
	var whiteflash = preload("res://assets/objects/groundpartpart.tscn")
	var ghost: Spatial = whiteflash.instance()
	get_tree().get_current_scene().add_child(ghost)
	ghost.translation = self.translation
	
func punch():
	if attackcooldown < 0 and key_m12:
		$attack.play()
		attackcooldown = 8
		#$soupermodel.rotation.y = atan2(-camera_dir.x, -camera_dir.z)
		#velocity = (floor_checker.global_position - self_center.global_position).normalized() * jetpack_scala
		state = states.punch
		#rootanimator.play("attack")
		if !is_on_floor():
			punchtime = 0
			$soupermodel.rotation.y = atan2(-camera_dir.x, -camera_dir.z)
			velocity.z = camera_dir.z * 45
			velocity.x = camera_dir.x * 45
			velocity.y += jumpheight / 2
			modelanimator.playback_speed = 1
			modelanimator.play("dive")
		if is_on_floor():
			$soupermodel.rotation.y = atan2(-model_dir.x, -model_dir.z)
			punchtime = 100
			velocity.z = model_dir.z * 20
			velocity.x = model_dir.x * 20
			modelanimator.playback_speed = 8
			modelanimator.play("punch")
				#$soupermodel.rotation.y = $camera.rotation.y
				
				
func impact():
	var whiteflash = preload("res://assets/objects/impact.tscn")
	var ghost: Spatial = whiteflash.instance()
	get_tree().get_current_scene().add_child(ghost)
	ghost.translation = self.translation
	ghost.translation.y = self.translation.y + 1
	


func _physics_process(delta):
	$soupermodel/AttackCheck/Attack1.disabled = !state == states.punch and !state == states.debug
	$soupermodel/AttackCheck/Attack2.disabled = !state == states.gp_prep
	$HUD/hud/debughud.pos = str(self.translation)
	$HUD/hud/debughud.state = state
	#print($camera/SpringArm/Camera/shaketime.time_left)
	if !$camera/SpringArm/Camera/shaketime.time_left == 0:
		$camera/SpringArm/Camera.h_offset = rand_range(shakeamount, -shakeamount)
		$camera/SpringArm/Camera.v_offset = rand_range(shakeamount, -shakeamount)
		randomize()
	if $camera/SpringArm/Camera/shaketime.time_left == 0:
		$camera/SpringArm/Camera.h_offset = 0
		$camera/SpringArm/Camera.v_offset = 0
	attackcooldown -= 15 * delta
	global.player = self
	#$dropshadow.translation = translation
	get_inputs()
	grounded = is_on_floor()
	var thing = 1.5 - (dropshadow_distance / 5)
	var cameratwist = $camera.rotation.normalized()
	if state != states.actor:
		$camera/SpringArm/Camera.fov = 40
		#$camera.rotation_degrees.y = lerp($camera.rotation_degrees.y, look_rot.y, 15 * delta)
		#$camera.rotation_degrees.x = lerp($camera.rotation_degrees.x, look_rot.x, 15 * delta)
		var distance = -15 + (distancefromlastfloor / 2)
		var distance2 =  (distancefromlastfloor / 15)
		$camera.rotation_degrees.x =  lerp($camera.rotation_degrees.x, distance, 5 * delta)
		$camera.translation.y = 2 - distance2
		if Input.is_action_just_released("player_scrollup"):
			$camera/SpringArm.spring_length -= 1
		if Input.is_action_just_released("player_scrolldown"):
			$camera/SpringArm.spring_length += 1
		if key_cameral:
			$camera.rotation_degrees.y += 5
		if key_camerar:
			$camera.rotation_degrees.y -= 5
	if is_on_floor():
		velocity.y = 0
		lastfloor = global_translation
	distancefromlastfloor = lastfloor.distance_to(translation)
	move_dir = Vector3(key_sright - key_sleft, 0, key_sdown - key_sup).normalized().rotated(Vector3.UP, $camera.rotation.y)
	camera_dir = -($camera.transform.basis.z).normalized()
	model_dir = -(model.transform.basis.z).normalized()
	var dir = $camera.transform.basis
	var movex = float(move_dir.x)
	var movez = float(move_dir.z)
	var snapvector = Vector3.DOWN
			# call the zoom function
		# zoom out
	if is_on_ceiling():
		velocity.y -= 10
		
	#$shadow.translation.y = $RayCast.target_translation.y
	match(state):
		states.normal:
			walljumped = 1
			snapvector = Vector3.DOWN
			velocity.x = lerp(velocity.x, movex * movespeed, 8 * delta)
			velocity.z = lerp(velocity.z, movez * movespeed, 8 * delta)
			if move_dir.x == 0 and move_dir.y == 0:
				modelanimator.playback_speed = 2
				modelanimator.play("idlenew")
			else:
				modelanimator.playback_speed = 4
				modelanimator.play("idlenew 2")
			if !movex == 0:
				$soupermodel.rotation.y = atan2(-velocity.x, -velocity.z)
				#$$soupermodel/root.rotation.x = -velocity.x
			if grounded and key_jump2:
				snapvector = Vector3.UP
				if (move_dir.x == 0 and move_dir.z == 0):
					velocity.y = jumpheight
				if !(move_dir.x == 0 and move_dir.z == 0):
					velocity.y = jumpheight * 1.2
				state = states.jump
				$jump.play()
				doland = true
				rootanimator.stop()
				rootanimator.play("actual jump")
				modelanimator.playback_speed = 3
				modelanimator.play("actual jump")
			if !is_on_floor():
				state = states.jump
				#velocity.y = 0
			punch()
		states.jump:
			if velocity.y > 10:
				if !key_jump:
					velocity.y = 10
			if key_run2:
				modelanimator.playback_speed = 0.5
				modelanimator.play("groundpoundprep")
				#rootanimator.stop()
				#rootanimator.play("actual jump")
				$soupermodel/yea.play()
				$soupermodel/swoosh.play()
				state = states.gp_prep
				velocity.y = jumpheight * 2
			if modelanimator.current_animation != ("gp_spin") and modelanimator.current_animation != ("actual jump") and modelanimator.current_animation != ("groundpoundprep")  and modelanimator.current_animation != ("gp_jump") and modelanimator.current_animation != ("spin"):
				modelanimator.play("fall")
			snapvector = Vector3.UP
			velocity.x = lerp(velocity.x, movex * movespeed, 5 * delta)
			velocity.z = lerp(velocity.z, movez * movespeed, 5 * delta)
			if not is_on_floor():
				velocity.y -= gravity
			if grounded:
				rootanimator.stop()
				rootanimator.play("jump")
				$land.play()
				velocity.y = 0
				grounded = true
				state = states.normal
				velocity.y -= 10
			punch()
		states.wallbounce:
			if key_run2:
				modelanimator.playback_speed = 0.5
				modelanimator.play("groundpoundprep")
				#rootanimator.stop()
				#rootanimator.play("actual jump")
				$soupermodel/yea.play()
				$soupermodel/swoosh.play()
				state = states.gp_prep
				velocity.y = jumpheight * 2
			modelanimator.playback_speed = 15
			if modelanimator.current_animation != ("actual jump") and modelanimator.current_animation != ("groundpoundprep"):
				modelanimator.play("spin")
			snapvector = Vector3.UP
			velocity.x = lerp(velocity.x, movex * movespeed, 8 * delta)
			velocity.z = lerp(velocity.z, movez * movespeed, 8 * delta)
			if not is_on_floor():
				velocity.y -= gravity
			if grounded:
				rootanimator.stop()
				rootanimator.play("jump")
				$land.play()
				velocity.y = 0
				grounded = true
				state = states.normal
				velocity.y -= 10
			punch()
		states.punch:
			if modelanimator.current_animation == ("dive"):
				velocity.x = lerp(velocity.x, movex * 45, 2 * delta)
				velocity.z = lerp(velocity.z, movez * 45, 2 * delta)
			if grounded and key_jump2:
				state = states.attackjump
				velocity.y = jumpheight
				velocity.z = camera_dir.z * 35
				velocity.x = camera_dir.x * 35
			if grounded:
				snapvector = Vector3.DOWN
			if !grounded:
				snapvector = Vector3.UP
			if !grounded and is_on_wall():
				$attack.stop()
				#$soupermodel.rotation.y = -$soupermodel.rotation.y
				$land.play()
				rootanimator.stop()
				rootanimator.play("actual jump")
				walljumped += -0.08
				state = states.wallbounce
				modelanimator.playback_speed = 3
				modelanimator.play("spin")
				$wall.play()
				#$jump.play()
				velocity.y = walljumped * (jumpheight * 1.7)
				velocity.x = -velocity.x * 1.5
				velocity.z = -velocity.z * 2
			if grounded and is_on_wall():
				$attack.stop()
				velocity.x = -velocity.x
				velocity.z = -velocity.z
				$wall.play()
			#modelanimator.play("idle")
			velocity.y -= gravity
			snapvector = Vector3.UP
			punchtime -= 300 * delta
			if grounded and !punchtime > 0:
				state = states.normal
				#velocity.y = 0
				#velocity.z = 0
				#velocity.x = 0
		states.gp_prep:
			velocity.x = lerp(velocity.x, movex * 35, 2 * delta)
			velocity.z = lerp(velocity.z, movez * 35, 2 * delta)
			snapvector = Vector3.UP
			modelanimator.playback_speed = 4
			velocity.y -= gravity * 3
			if is_on_floor():
				if key_jump:
					#$bounce.play()
					$land.play()
					rootanimator.stop()
					rootanimator.play("bigjump")
					$bounce.play()
					state = states.jump
					modelanimator.playback_speed = -15
					modelanimator.play("gp_spin")
					velocity.y = jumpheight * 1.5
					$crash.play()
					camerashake(2, 0.1)
					thing1()
					thing2()
				if !key_jump:
					#$bounce.play()
					$land.play()
					rootanimator.stop()
					rootanimator.play("jump")
					state = states.normal
					$crash.play()
					camerashake(2, 0.1)
					thing1()
					thing2()
		states.attackjump:
			if key_run2:
				modelanimator.playback_speed = 0.5
				modelanimator.play("groundpoundprep")
				#rootanimator.stop()
				#rootanimator.play("actual jump")
				$soupermodel/yea.play()
				state = states.gp_prep
				velocity.y = jumpheight * 2
			modelanimator.playback_speed = 20
			if modelanimator.current_animation != ("actual jump") and modelanimator.current_animation != ("groundpoundprep"):
				modelanimator.play("spin")
			snapvector = Vector3.UP
			if is_on_wall():
				velocity.x = -velocity.x
				velocity.z = -velocity.z
				#velocity.y = 15
				impact()
				$wall.play()
			if not is_on_floor():
				velocity.y -= gravity
			if grounded:
				rootanimator.stop()
				rootanimator.play("jump")
				$land.play()
				velocity.y = 0
				grounded = true
				state = states.normal
				velocity.y -= 10
				
		states.entercourse:
			modelanimator.playback_speed = 15
			modelanimator.play("spin")
			if not is_on_floor():
				velocity.y -= gravity / 1.5
			if grounded:
				rootanimator.stop()
				rootanimator.play("jump")
				$land.play()
				velocity.y = 0
				grounded = true
				state = states.normal
				velocity.y -= 10
			#punch()
		states.debug:
			modelanimator.play("idle")
			var amount = 35
			velocity.x = movex * amount
			velocity.z = movez * amount
			snapvector = Vector3.UP
			if key_jump:
				velocity.y = amount
			if key_run:
				velocity.y = -amount
			if !key_jump and !key_run:
				velocity.y = 0
			punch()
	move_and_slide_with_snap(velocity, snapvector, Vector3.UP, true)
				
			
			
			
			
			


func camerashake(amount, time):
	$camera/SpringArm/Camera/shaketime.wait_time = time
	$camera/SpringArm/Camera/shaketime.start()
	shakeamount = amount

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
var key_cameral = 0
var key_justcameral = 0
var key_camerar = 0
var key_justcamerar = 0

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
	key_cameral = Input.is_action_pressed("player_cameraleft")
	key_justcameral = Input.is_action_just_pressed("player_cameraleft")
	key_camerar = Input.is_action_pressed("player_cameraright")
	key_justcamerar = Input.is_action_just_pressed("player_cameraright")


func _on_AttackCheck_body_entered(body):
	if body is Baddie:
		#body.queue_free()
		var flungvelocity = velocity.normalized()
		var amount = 25
		body.velocity.x = flungvelocity.x * amount
		body.velocity.z = flungvelocity.z * amount
		body.model.look_at(self.translation, Vector3.UP)
		body.hurt()
	pass # Replace with function body.
