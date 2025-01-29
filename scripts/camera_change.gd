extends Camera2D

# note there is a weird bug where I cannot get rid of 2 in the name of camera2D's direct children
@onready var timer = $Timer2

func _on_right_boundary_2_body_entered(body):
	if body.has_method("player") and timer.time_left == 0:
		position.x += 380
		timer.start()


func _on_left_boundary_2_body_entered(body):
	if body.has_method("player") and timer.time_left == 0:
		position.x -= 380
		timer.start()
