extends Area2D
class_name grappleNode
@onready var indicator = $Indicator
var entered = false
var mouseEntered = false
signal grapple
# enable button functionality
func _physics_process(delta):
	if Input.is_action_just_pressed("grapple") and entered && PlayerInfo.grappleHook:
		emit_signal("grapple", global_position)
		# need to pass this nodes position when called


func _on_body_entered(body):
	if body.has_method("player"):
		modulate = Color(0.353, 1, 0.408)
		entered = true
		if Input.is_action_just_pressed("grapple"):
			emit_signal("grapple", global_position)
			print("grapple")
	pass # Replace with function body.


func _on_body_exited(body):
	if body.has_method("player"):
		modulate = Color(1, 1, 1)
		entered = false
	pass # Replace with function body.
