extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

var alive = true
const SPEED = 200
const JUMP_VELOCITY = -300.0
const dashSpeed = 400
const dashDist = 100
var dashing = false
var dashStart = 0
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
	if alive == true:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		var direction := Input.get_axis("move_left", "move_right")
		move(direction)
		flip(direction)
		if Input.is_action_just_pressed("dash") && direction:
			dash(direction)
			
	elif alive == false:
		velocity.x = 0
		animated_sprite.modulate = Color(1,0.33,0.33,1)
		
	move_and_slide()

func player():
	pass #function check whether a body is the player
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
		
func dash(direction):
	dashing = true
	velocity.x = direction * dashSpeed
	velocity.y = 0
	dashStart = position.x
