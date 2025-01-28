extends Area2D

@onready var timer = $"Respawn Timer"


func _on_body_entered(body):
	if body.has_method("player") && !body.dashing:
		body.alive = false	# disables player controls
		timer.start() # respawn timer
		Engine.time_scale = 1
	elif body.has_method("enemy"): # if an enemy
		body.queue_free()

func _on_respawn_timer_timeout():
	get_tree().reload_current_scene()
	
	
