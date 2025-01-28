extends Node2D
@onready var BulletSpawn = $BulletSpawn
@onready var barrel = $Barrel
@onready var marker_2d = $BulletSpawn/Marker2D
@onready var barrel_2 = $Barrel/Barrel2
@onready var timer_fire_rate = $fireRate

const bulletPath = preload("res://Scenes/bullet.tscn")
var bodyEntered = false
var newBody
var canFire = true
func _process(delta):
	if bodyEntered == true:
		rotateTowards(barrel, newBody.position)
		if canFire:
			fire()

func _on_area_2d_body_entered(body):
	newBody = body
	if body.has_method("player"):
		bodyEntered = true
	
func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		bodyEntered = false
# need to delete bullets; after hitting something
func fire():
	canFire = false
	timer_fire_rate.start()
	var bullet = bulletPath.instantiate() # create a new instance of a bullet
	add_child(bullet) # add the bullet as a child of turret
	bullet.global_position = marker_2d.global_position
	# rotate the turret barrel & bullet spawn location to be faceing the player
	rotateTowards(BulletSpawn, newBody.position)
	rotateTowards(bullet, newBody.position)
	bullet.velocity = newBody.global_position - bullet.global_position # find directional vector towards player
	barrel_2.play("fire")

func rotateTowards(object, position): # position is a Vector2
	object.look_at(position) # default look_at() is 90 degrees off
	object.rotate(3*TAU/4) # adjust with TAU == 2pi radians

func _on_fire_rate_timeout():
	canFire = true
