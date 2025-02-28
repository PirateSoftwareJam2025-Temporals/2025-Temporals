extends Node
@onready var player = $Player
@onready var game_objects = $GameObjects
@onready var camera_2d = $Camera2D

var cameraFollow = false
var cameraDirection
func _ready():
	for child in game_objects.get_children():
		if child is grappleNode:
			child.connect("grapple", playerGrapple)
		if child is changeCameraNode:
			child.connect("changeCameraMode", changeCameraMode)
		if child is stabilityPickup:
			child.connect("stabilityPickup", stabilityPickup)
	player.connect("dashSignal", dash)
	player.connect("shootSignal", shoot)
	player.connect("grappleSignal", grapple)
	camera_2d.connect("death", die)
	
func playerGrapple(position):
	if player.has_method("grapple"):
		player.grapple(position)

func dash():
	if camera_2d.has_method("dash"):
		camera_2d.dash()

func shoot():
	if camera_2d.has_method("shoot"):
		camera_2d.shoot()

func grapple():
	if camera_2d.has_method("grapple"):
		camera_2d.grapple()
	
func die():
	get_tree().reload_current_scene()

func changeCameraMode(direction):
	cameraFollow = !cameraFollow
	cameraDirection = direction
	print(cameraDirection)

func stabilityPickup(pickupAmount):
	camera_2d.stabilityPickup(pickupAmount)
func _process(delta):
	if cameraFollow:
		player.connect("playerPosition", cameraFollowPlayer)
	else:
		player.disconnect("playerPosition", cameraFollowPlayer)
	
	if player.alive == false:
		camera_2d

func cameraFollowPlayer(playerPosition):
	camera_2d.followPlayer(playerPosition, cameraDirection)
