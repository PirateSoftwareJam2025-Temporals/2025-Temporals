extends Node
@onready var player = $Player
@onready var game_objects = $GameObjects
@onready var camera_2d = $Camera2D

var grappleNodes = []
func _ready():
	for child in game_objects.get_children():
		if child is grappleNode:
			grappleNodes.append(child)
			print(child.get_class())
			child.connect("grapple", playerGrapple)
	print(grappleNodes)
	player.connect("dashSignal", dash)
	player.connect("shootSignal", shoot)
func playerGrapple(position):
	if player.has_method("grapple"):
		player.grapple(position)

func dash():
	if camera_2d.has_method("dash"):
		camera_2d.dash()

func shoot():
	if camera_2d.has_method("shoot"):
		camera_2d.shoot()
