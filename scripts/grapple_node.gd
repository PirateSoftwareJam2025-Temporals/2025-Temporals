extends Area2D
class_name grappleNode
@onready var indicator = $Indicator

var mouseEntered = false
signal grapple
# enable button functionality
func _on_mouse_entered():
	mouseEntered = true
	indicator.visible = true
func _on_mouse_exited():
	mouseEntered = false
	indicator.visible = false
func _physics_process(delta):
	if Input.is_action_just_pressed("grapple") and mouseEntered:
		emit_signal("grapple", global_position)
		# need to pass this nodes position when called
