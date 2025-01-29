extends CharacterBody2D

@onready var coyote_time = $coyoteTime
@onready var jump_buffer_timer = $jumpBuffer
@onready var marker_2d = $AnimatedSprite2D/Marker2D
@onready var animated_sprite = $AnimatedSprite2D
const PLAYER_BULLET = preload("res://Scenes/player_bullet.tscn")
var alive = true
const DEFAULT_SPEED = 150
const JUMP_VELOCITY = -300.0
const dashSpeed = 250
const dashDist = 50
var dashing = false
var dashStart = 0
var speed = DEFAULT_SPEED
var buffered = 0
var jumping = false
func player():
	pass #function check whether a body is the player
 
func _physics_process(delta: float) -> void:
	if dashing:
		timeSlow() # playing should still be able to time slow while dashing
		if abs(dashStart - position.x) >= dashDist || get_real_velocity().x == 0:
			dashing = false
			return
		move_and_slide()
		return
	# Add gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if alive == false:
		velocity.x = 0
		animated_sprite.modulate = Color(1,0.33,0.33,1)
		return # if not alive skip movement
	# jump buffer: if jump is pressed just before they hit the floor
	if Input.is_action_just_pressed("jump") and !is_on_floor():
		jump_buffer_timer.start()
	if jump_buffer_timer.time_left != 0 and is_on_floor():
		jump()
		jump_buffer_timer.stop()
	# coyote time
	if is_on_floor(): # start timer when on floor & because it is in process will
		coyote_time.start()
		jumping = false
	
	# jump if coyote available and not currently jumping
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_time.time_left != 0) and !jumping:
		jump()
	var direction := Input.get_axis("move_left", "move_right")
	move(direction)
	flip(direction)
	if direction != 0 and is_on_floor(): # if not idle
		animated_sprite.play("running")
	else:
		animated_sprite.play("default")
	if Input.is_action_just_pressed("dash") && direction:
		dash(direction)
	timeSlow()
	move_and_slide()
	if Input.is_action_just_pressed("shoot"):
		shoot()

func jump():
	velocity.y = JUMP_VELOCITY
	jumping = true

func move(direction):
	if direction:
		velocity.x = direction * DEFAULT_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, DEFAULT_SPEED)
func flip(direction):
	if direction < 0:
		animated_sprite.scale.x = -1
	elif direction > 0:
		animated_sprite.scale.x = 1

# Allows the player to slow down time to assist with dodging 
# bullets while also allowing the player to make it through
# time slow required sections
func timeSlow():
	if Input.is_action_just_pressed("time_slow"): #&& time_slow_length.timeout()
		Engine.time_scale = 0.2
	elif Input.is_action_just_released("time_slow"):
		Engine.time_scale = 1

func dash(direction):
	if dashing == false:# only play the dash animation the first time its pressed
		animated_sprite.play("dash")
	dashing = true
	velocity.x = direction * dashSpeed
	velocity.y = 0
	dashStart = position.x

func shoot():
	var playerDirection = animated_sprite.scale.x
	var bullet = PLAYER_BULLET.instantiate()
	add_child(bullet)
	bullet.top_level = true # do not alter the bullets position when the player moves
	bullet.global_position = marker_2d.global_position
	bullet.velocity.x = playerDirection
	bullet.velocity.y = 0
	bullet.bulletSpeed = 200
	print("bullet")
	
