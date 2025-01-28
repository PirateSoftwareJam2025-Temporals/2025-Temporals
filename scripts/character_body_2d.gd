extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var time_slow_length = $timeSlowLength

var alive = true
const SPEED = 200
const JUMP_VELOCITY = -300.0
const dashSpeed = 400
const dashDist = 100
var dashing = false
var dashStart = 0
var timeSlowAvailable = true

func player():
	pass #function check whether a body is the player
 
func _physics_process(delta: float) -> void:
	if dashing:
		if abs(dashStart - position.x) >= dashDist || get_real_velocity().x == 0:
			dashing = false
			return
		move_and_slide()
		return
	# Add gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# perhaps not the best practice slamming it all into one if statement
	# potentially could use a block statement to check if player is alive at start & if not pass
	if alive == true:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		var direction := Input.get_axis("move_left", "move_right")
		move(direction)
		flip(direction)
		if Input.is_action_just_pressed("dash") && direction:
			dash(direction)
		if Input.is_action_just_pressed("time_slow") && timeSlowAvailable: #&& time_slow_length.timeout()
			time_slow()
	elif alive == false:
		velocity.x = 0
		animated_sprite.modulate = Color(1,0.33,0.33,1)
		
	move_and_slide()

func move(direction):
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
func flip(direction):
	if direction < 0:
		animated_sprite.flip_h = true
	elif direction > 0:
		animated_sprite.flip_h = false

# Allows the player to slow down time to assist with dodging 
# bullets while also allowing the player to make it through
# time slow required sections
func time_slow(): # perhaps could have respawn timer so as not to waste the players time if they die in slowMo
	Engine.time_scale = 0.2
	# not quite as fast as normal so as not to be broken
	speed *= 2
	# bug where you can jump really high
	timeSlowAvailable = false
	time_slow_length.start()

func _on_time_slow_length_timeout():
	Engine.time_scale = 1
	speed = DEFAULT_SPEED
	timeSlowAvailable = true
func dash(direction):
	dashing = true
	velocity.x = direction * dashSpeed
	velocity.y = 0
	dashStart = position.x
