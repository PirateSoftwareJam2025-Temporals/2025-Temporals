extends Camera2D

# note there is a weird bug where I cannot get rid of 2 in the name of camera2D's direct children
@onready var timer = $Timer2
@onready var dash_cooldown = $DashCooldown
@onready var shoot_cooldown = $shootCooldown
@onready var slowmo_cooldown = $slowmoCooldown
var scaleChange = Vector2(0.3, 0.3)
var dashCooldownTime = 0.8
var shootCooldownTime = 0.5
var slowMoCooldownTime = 0.8
func _on_right_boundary_2_body_entered(body):
	if body.has_method("player") and timer.time_left == 0:
		position.x += 380
		timer.start()


func _on_left_boundary_2_body_entered(body):
	if body.has_method("player") and timer.time_left == 0:
		position.x -= 380
		timer.start()

func dash():
	#dash_cooldown.modulate = Color(0.5, 0.5, 0.5)
	dash_cooldown.scale = dash_cooldown.scale - scaleChange
	changeScale(dash_cooldown, dashCooldownTime)
	await get_tree().create_timer(dashCooldownTime).timeout
	#dash_cooldown.modulate = Color(1, 1, 1)

func shoot():
	#shoot_cooldown.modulate = Color(0.5, 0.5, 0.5)
	shoot_cooldown.scale = shoot_cooldown.scale - scaleChange
	changeScale(shoot_cooldown, shootCooldownTime)
	await get_tree().create_timer(shootCooldownTime).timeout
	#shoot_cooldown.modulate = Color(1, 1, 1)

# slowly change the scale to alert the player when they can next use said ability
func changeScale(object, length): 
	var increments = length/10
	var scaleIncrements = scaleChange/10
	for i in 10:
		object.scale += scaleIncrements
		await get_tree().create_timer(increments).timeout
