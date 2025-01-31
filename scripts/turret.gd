extends Node2D
@onready var BulletSpawn = $BulletSpawn
@onready var barrel = $Barrel
@onready var marker_2d = $BulletSpawn/Marker2D
@onready var barrel_2 = $Barrel/Barrel2
@onready var fire_rate = $fireRate
@onready var point_light_2d = $BulletSpawn/PointLight2D
@onready var explosion_light = $explosionLight
@onready var shoot_audio = $shootAudio
@onready var reload_speed = $reloadSpeed

var alreadyBeenHere = false
const bulletPath = preload("res://Scenes/bullet.tscn")
var bodyEntered = false
var newBody
var canFire = true
var burstAmount = 3
var burstCounter = 0
var disabled = false


func _process(delta):
	if bodyEntered == true:
		rotateTowards(barrel, newBody.position)
		if canFire == true and !disabled:
			fire()

func _on_area_2d_body_entered(body):
	if body.has_method("player") and !disabled:
		newBody = body
		bodyEntered = true
func rotateTowards(object, position): # position is a Vector2
	object.look_at(position) # default look_at() is 90 degrees off
	object.rotate(3*TAU/4) # adjust with TAU == 2pi radians
func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		bodyEntered = false
# need to delete bullets; after hitting something
func fire():
	canFire = false
	shoot_audio.play()
	burstCounter += 1 # add this bullet to the burstCount
	fire_rate.start() # start the timer for the next bullet instance
	var bullet = bulletPath.instantiate() # create a new instance of a bullet
	add_child(bullet) # add the bullet as a child of turret
	# rotate the turret barrel & bullet spawn location to be faceing the player
	rotateTowards(BulletSpawn, newBody.position)
	rotateTowards(bullet, newBody.position)
	bullet.global_position = marker_2d.global_position # set new bullets starting position
	bullet.velocity = newBody.global_position - bullet.global_position # find directional vector towards player
	barrel_2.play("fire") # play fire animation
	point_light_2d.enabled = true # display a light where the bullet is spawned
	explosion_light.start()

func _on_reload_speed_timeout():
	burstCounter = 0
	canFire = true

func _on_explosion_light_timeout():
	point_light_2d.enabled = false

func _on_fire_rate_timeout():
	if burstCounter < 3:
		canFire = true
	else:
		reload_speed.start()
func disableTurret():
	disabled = true
	barrel.visible = false
	
	
