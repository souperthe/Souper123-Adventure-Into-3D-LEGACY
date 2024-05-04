extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#export (int) var pages = 1
export var pagestext = []
var pageon = 0
var player
var interacted = false
var thing


# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var thing = player.model.rotation.y + 20
	if !interacted:
		$CanvasLayer/Control/Control/RichTextLabel.visible_characters = 0
	if interacted:
		$CanvasLayer/Control/Control/pointer.visible = $CanvasLayer/Control/Control/RichTextLabel.percent_visible > 0.9
		$CanvasLayer/Control/Control/RichTextLabel.bbcode_text = str(pagestext[pageon])
		if $CanvasLayer/Control/Control/RichTextLabel.percent_visible == 1 and Input.is_action_just_pressed("player_action1"):
			pageon += 1
			if !pageon == pagestext.size():
				$CanvasLayer/Control/Control/RichTextLabel.visible_characters = 0
				$CanvasLayer/AnimationPlayer2.play("text")
				$AnimationPlayer.play("interact")
				$AudioStreamPlayer2.play()
			if pageon == pagestext.size():
				$CanvasLayer/AnimationPlayer.play("disapear")
				player.state = player.states.normal
				interacted = false
				$AnimationPlayer.play("interact")
				$AudioStreamPlayer2.play()
				$AudioStreamPlayer3.play()
		var thing = rotation.normalized() * 2
		#player.translation.x = lerp(player.translation.x, self.global_translation.x, 5 * delta)
		#player.translation.z = lerp(player.translation.z, self.global_translation.z, 5 * delta)
		player.translation.y = lerp(player.translation.y, self.global_translation.y, 5 * delta)
		player.camera.rotation.x = lerp(player.camera.rotation.x, player.model.rotation.x, 5 * delta)
		player.camera.rotation.z = lerp(player.camera.rotation.z, player.model.rotation.z, 5 * delta)
		#player.camera.rotation.y = lerp(player.camera.rotation.y, thing, 5 * delta)
		player.cam.fov = lerp(player.cam.fov, 25, 5 * delta)
		player.model.look_at(self.global_transform.origin, Vector3.UP)
		#player.model.rotation = lerp(player.model.rotation, Vector3(0,0,0), 5 * delta)
	pass


func _on_Area_body_entered(body):
	if body is Player:
		if body.state == body.states.punch:
			player = body
			pageon = 0
			body.state = body.states.actor
			body.velocity = Vector3(0,0,0)
			body.modelanimator.play("idlenew")
			body.modelanimator.playback_speed = 2
			#thing = body.model.rotation.y + 20
			interacted = true
			$AudioStreamPlayer.play()
			$CanvasLayer/AnimationPlayer.play("appear")
			$AnimationPlayer.play("interact")
			$CanvasLayer/Control/Control/RichTextLabel.visible_characters = 0
			$CanvasLayer/Control/Control/RichTextLabel.bbcode_text = str(pagestext[pageon])
			#body.model.look_at(self.global_transform.origin, Vector3.UP)
	pass # Replace with function body.
	
func starttextthing():
	$CanvasLayer/AnimationPlayer2.play("text")
