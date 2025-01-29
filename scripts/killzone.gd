extends Area2D

#@onready var timer = $"Respawn Timer"
var respawnLength = 1

	# very strange bug where if bullets are being deleted player doesn't die
	# & if bullets aren't deleted player can die
	# perhaps related to bullet inheriting killzone
func _on_body_entered(body):
	# if a bullet delete said bullet
	if get_parent().has_method("bullet") and get_parent().visible == true: # visible check to ensure that if the node has hit the player not to delete the bullet before game reload
				get_parent().visible = false
				if body.has_method("player") == false: # if not the player delete immediatly
					get_parent().queue_free()
	# if player kill
	if body.has_method("player") && !body.dashing:
		if body.alive == true: # check the player is not already trying to respawn
			body.alive = false	# disables player controls
			Engine.time_scale = 1
			await get_tree().create_timer(respawnLength).timeout
			get_tree().reload_current_scene()

#func _on_timer_timeout():
	#et_parent().queue_free() # if not already deleted
	
