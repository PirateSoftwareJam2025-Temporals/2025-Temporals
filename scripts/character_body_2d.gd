extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var time_slow_length = $timeSlowLength

var alive = true
var speed = 200
var jumpVelocity = -300.0
const dashDistance = 40

func player():
	pass #function check whether a body is the player
func _physics_process(delta: float) -> void:
	# Add gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# perhaps not the best practice slamming it all into one if statement
	# potentially could use a block statement to check if player is alive at start & if not pass
	if alive == true:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jumpVelocity
		var direction := Input.get_axis("move_left", "move_right")
		move(direction)
		flip(direction)
		if Input.is_action_just_pressed("dash"):
			dash(direction)
		if Input.is_action_just_pressed("time_slow"): #&& time_slow_length.timeout()
			time_slow()
	elif alive == false:
		velocity.x = 0
		animated_sprite.modulate = Color(1,0.33,0.33,1)
		
	
	move_and_slide()

func move(direction):
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
func flip(direction):
	if direction < 0:
		animated_sprite.flip_h = true
	elif direction > 0:
		animated_sprite.flip_h = false
func dash(direction):
	position.x += dashDistance * direction
# Allows the player to slow down time to assist with dodging 
# bullets while also allowing the player to make it through
# time slow required sections
func time_slow():
	Engine.time_scale = 0.2
	# not quite as fast as normal
	speed *= 4
	# currently has moon gravity
	jumpVelocity *= 2
	time_slow_length.start() # might need to start on initialise
	

func _on_time_slow_length_timeout():
	Engine.time_scale = 1
	speed /= 4
	jumpVelocity /= 2
