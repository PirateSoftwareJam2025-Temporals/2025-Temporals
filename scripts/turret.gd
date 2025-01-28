extends Node2D
@onready var BulletSpawn = $BulletSpawn
@onready var barrel = $Barrel
@onready var marker_2d = $BulletSpawn/Marker2D
@onready var barrel_2 = $Barrel/Barrel2
@onready var fire_rate = $fireRate
@onready var point_light_2d = $PointLight2D
@onready var explosion_length = $explosionLength
@onready var reload_speed = $reloadSpeed

const bulletPath = preload("res://Scenes/bullet.tscn")
var bodyEntered = false
var newBody
var canFire = true
var burstAmount = 3
var burstCounter = 0
func _process(delta):
	if bodyEntered == true:
		rotateTowards(barrel, newBody.position)
		if canFire == true:
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
	burstCounter += 1
	
	print("fireRate.start()")
	fire_rate.start()
	var bullet = bulletPath.instantiate() # create a new instance of a bullet
	add_child(bullet) # add the bullet as a child of turret
	bullet.global_position = marker_2d.global_position
	# rotate the turret barrel & bullet spawn location to be faceing the player
	rotateTowards(BulletSpawn, newBody.position)
	rotateTowards(bullet, newBody.position)
	bullet.velocity = newBody.global_position - bullet.global_position # find directional vector towards player
	barrel_2.play("fire")
	point_light_2d.enabled = true



func rotateTowards(object, position): # position is a Vector2
	object.look_at(position) # default look_at() is 90 degrees off
	object.rotate(3*TAU/4) # adjust with TAU == 2pi radians

func _on_fire_rate_timeout():
	print(burstCounter)
	if burstCounter <= 3:
		canFire = true
	else:
		print("timer")
		reload_speed.start()
		#canFire = false
	print(canFire)
	print()
func _on_reload_speed_timeout():
	burstCounter = 0
	print("reset")
	canFire = true

func _on_explosion_length_timeout():
	point_light_2d.enabled = false
