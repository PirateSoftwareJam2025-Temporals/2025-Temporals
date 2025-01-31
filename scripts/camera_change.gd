extends Camera2D

# note there is a weird bug where I cannot get rid of 2 in the name of camera2D's direct children
@onready var timer = $Timer2
@onready var dash_cooldown = $DashCooldown
@onready var shoot_cooldown = $shootCooldown
@onready var slowmo_cooldown = $slowmoCooldown
@onready var stability_bar = $StabilityBar
var scaleChange = Vector2(0.3, 0.3)
var dashCooldownTime = 0.8
var shootCooldownTime = 0.5
var slowMoCooldownTime = 0.8
var playerAlive = true
signal death
func _ready():
	stability_bar.connect("death", die)
func die():
	emit_signal("death")
func _process(delta):
	if !playerAlive:
		stability_bar.playerAlive = false
func _on_right_boundary_2_body_entered(body):
	if body.has_method("player") and timer.time_left == 0:
		
		position.x += 370
		timer.start()

func _on_left_boundary_2_body_entered(body):
	if body.has_method("player") and timer.time_left == 0:
		position.x -= 370
		timer.start()
func _on_bottom_boundary_body_entered(body):
	if body.has_method("player") and timer.time_left == 0:
		position.y += 208
		timer.start()

func dash():
	if stability_bar.has_method("dash"):
		stability_bar.dash()
	dash_cooldown.scale = dash_cooldown.scale - scaleChange
	changeScale(dash_cooldown, dashCooldownTime)
	await get_tree().create_timer(dashCooldownTime).timeout

func shoot():
	if stability_bar.has_method("shoot"):
		stability_bar.shoot()
	shoot_cooldown.scale = shoot_cooldown.scale - scaleChange
	changeScale(shoot_cooldown, shootCooldownTime)
	await get_tree().create_timer(shootCooldownTime).timeout

# slowly change the scale to alert the player when they can next use said ability
func changeScale(object, length): 
	var increments = length/10
	var scaleIncrements = scaleChange/10
	for i in 10:
		object.scale += scaleIncrements
		await get_tree().create_timer(increments).timeout

func followPlayer(playerPosition, direction):
	if direction:
		position.x = playerPosition.x
	elif !direction:
		position.y = playerPosition.y

func stabilityPickup(pickupAmount):
	stability_bar.stabilityPickup(pickupAmount)
