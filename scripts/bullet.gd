extends CharacterBody2D

var bulletVelocity = Vector2(0, 0)
var bulletSpeed = 5000
@onready var collision_shape_2d = $Killzone/CollisionShape2D

func _physics_process(delta):
		velocity = velocity.normalized() * delta * bulletSpeed
		move_and_slide()

func bullet():
	pass
#func _on_killzone_body_entered(body):
	#queue_free()
