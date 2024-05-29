class_name Baddie
extends KinematicBody

enum states {
	normal,
	stun,
	dead
}

var state = states.normal
var gravity = 0.7
var health
var move_dir = Vector3.ZERO
var velocity = Vector3.ZERO
var look_rot = Vector3.ZERO
var snapvector = Vector3.DOWN

onready var model = $model
onready var animator = $model/root/modelanimator

func poof():
	var whiteflash = preload("res://assets/objects/poof.tscn")
	var ghost: Spatial = whiteflash.instance()
	get_tree().get_current_scene().add_child(ghost)
	ghost.translation = self.translation
	ghost.sound()
	ghost.translation.y = self.translation.y + 1

func createcoin():
	var whiteflash = preload("res://assets/objects/PhysicsCollectable.tscn")
	var ghost: Spatial = whiteflash.instance()
	get_tree().get_current_scene().add_child(ghost)
	ghost.velocity.y = 5
	ghost.velocity.x = rand_range(5,-5)
	ghost.velocity.z = rand_range(5,-5)
	randomize()
	ghost.translation = self.translation
	ghost.translation.y = self.translation.y + 1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide_with_snap(velocity, snapvector, Vector3.UP, true)
	match(state):
		states.normal:
			snapvector = Vector3.DOWN
			animator.play("walk")
		states.dead:
			velocity.y -= gravity
			snapvector = Vector3.UP
			animator.play("kill")
			if is_on_floor():
				destroy()
#	pass

func hurt():
	if !state == states.dead:
		velocity.y = 15
		state = states.dead
	#queue_free()
	
func destroy():
	createcoin()
	poof()
	queue_free()
