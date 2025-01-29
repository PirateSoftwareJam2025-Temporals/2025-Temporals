extends CharacterBody2D

# note this is a universal script for both bullets
var bulletVelocity = Vector2(0, 0)
var bulletSpeed = 100

func _physics_process(delta):
	velocity = velocity.normalized() * bulletSpeed
	move_and_slide()

func bullet():
	pass
