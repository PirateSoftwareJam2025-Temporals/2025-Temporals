extends Node
@onready var player = $Player
@onready var game_objects = $GameObjects

var grappleNodes = []
func _ready():
	for child in game_objects.get_children():
		if child is grappleNode:
			grappleNodes.append(child)
			print(child.get_class())
			child.connect("grapple", playerGrapple)
	print(grappleNodes)
	
func playerGrapple(position):
	if player.has_method("grapple"):
		player.grapple(position)
