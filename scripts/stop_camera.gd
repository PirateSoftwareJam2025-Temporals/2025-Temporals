extends Area2D
class_name changeCameraNode
signal changeCameraMode

@export var cameraDirection = true # true for horizontal, false for vertical

func _on_area_entered(area):
	if area.get_parent().has_method("player"):
		emit_signal("changeCameraMode", cameraDirection)
	
