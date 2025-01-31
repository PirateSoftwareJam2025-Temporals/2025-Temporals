extends CharacterBody2D

# note this is a universal script for both bullets
var bulletVelocity = Vector2(0, 0)
var bulletSpeed = 100

func _physics_process(delta):
	velocity = velocity.normalized() * bulletSpeed
	move_and_slide()
	
	
func bullet():
	pass

func _on_area_2d_body_entered(body):
	print(body)
	if body.get_parent().has_method("disable"): # the body collided with will be the collidor
		body.get_parent().disable()
		print("disabled?")
		
	# delete bullet
	queue_free()
	pass # Replace with function body.


func _on_area_2d_area_entered(area):
	if area.get_parent().has_method("disableTurret") and area.get_node("hitbox"): # the body collided with will be the collidor
		area.get_parent().disableTurret()
		print("booom?")
	pass # Replace with function body.
