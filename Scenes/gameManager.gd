extends Node
@onready var player = $Player

func _ready():
	for child in get_children():
		if child is grappleNode:
			child.connect("grapple", playerGrapple)
	
	
func playerGrapple(position):
	if player.has_method("grapple"):
		player.grapple(position)
