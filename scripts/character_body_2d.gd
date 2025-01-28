extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var time_slow_length = $timeSlowLength

var alive = true
const DEFAULT_SPEED = 200
var speed = DEFAULT_SPEED
var jumpVelocity = -250.0
const dashDistance = 40
var timeSlowAvailable = true

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
		if Input.is_action_just_pressed("time_slow") && timeSlowAvailable: #&& time_slow_length.timeout()
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
func time_slow(): # perhaps could have respawn timer so as not to waste the players time if they die in slowMo
	Engine.time_scale = 0.2
	timeSlowAvailable = false
	time_slow_length.start()

# weird bug where sometimes that speed doesn't go back to default
func _on_time_slow_length_timeout():
	Engine.time_scale = 1
	timeSlowAvailable = true
