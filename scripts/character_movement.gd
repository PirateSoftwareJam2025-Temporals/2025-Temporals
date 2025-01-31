extends CharacterBody2D

@onready var grapple_cooldown_timer = $grappleCooldown
@onready var stop_momentum_timer = $stopMomentum
@onready var coyote_time = $coyoteTime
@onready var jump_buffer_timer = $jumpBuffer
@onready var marker_2d = $AnimatedSprite2D/Marker2D
@onready var animated_sprite = $AnimatedSprite2D
signal dashSignal
signal shootSignal
const PLAYER_BULLET = preload("res://Scenes/player_bullet.tscn")
var alive = true
# Movement
const maxSpeed = 120
var onGround
var desiredVelocity
var maxSpeedChange
var acceleration
var maxAcceleration = 700
var maxAirAcceleration = 400
var deceleration 
var maxDeceleration = 800
var maxAirDeceleration = 600
var turnSpeed
var maxTurnSpeed = 1000
var maxAirTurnSpeed = 700
# Jump
const jumpHeight = 50 ** 2 # jump height times timeToJumpApex * 10
var desiredJump = false
var newGravity
var defaultGravity = 980
var gravityScale
var gravMultiplier = 1
var downwardMovementMultiplier = -1.5
var jumpSpeed
var timeToJumpApex = 0.3
var jumping = false
# Dash
const dashSpeed = 250
const dashDist = 50
var dashing = false
var dashStart = 0
var buffered = 0

const grappleSpeed = 250
var grappling = false
var stoppingMomentum = false


# when doing the ui use the cooldown timers for each of the abilities using the time_left function

func player():
	pass #function check whether a body is the player

func _process(delta):
	pass


func _physics_process(delta: float) -> void:
	onGround = is_on_floor()
	
	if dashing:
		timeSlow() # playing should still be able to time slow while dashing
		if abs(dashStart - position.x) >= dashDist || get_real_velocity().x == 0:
			dashing = false
			return
		move_and_slide()
		return
	# Add gravity.
	newGravity = Vector2(0, (-2 * jumpHeight) / (timeToJumpApex * timeToJumpApex))
	gravityScale = ((newGravity.y*10) / defaultGravity) * gravMultiplier
	if not is_on_floor():
		velocity.y += gravityScale * delta
	if (velocity.y == 0):
		gravMultiplier = 1
	if (velocity.y < -0.01):
		gravMultiplier = downwardMovementMultiplier
	
	if alive == false:
		velocity.x = 0
		animated_sprite.modulate = Color(1,0.33,0.33,1)
		return # if not alive skip movement
	# jump buffer: if jump is pressed just before they hit the floor
	if Input.is_action_just_pressed("jump") and !is_on_floor():
		jump_buffer_timer.start()
	if jump_buffer_timer.time_left != 0 and is_on_floor():
		desiredJump = true
		jump_buffer_timer.stop()
	# coyote time
	if is_on_floor(): # start a timer when last on the floor
		coyote_time.start()
		jumping = false

	# jump if coyote available and not currently jumping
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_time.time_left != 0) and !jumping:
		desiredJump = true
		if is_on_floor() == false:
			print("coyote")
			#velocity.y = 0

	
	# Horizontal Movement
	var direction := Input.get_axis("move_left", "move_right")
	move(direction, delta)
	flip(direction)
	if direction != 0 and is_on_floor(): # if not idle
		animated_sprite.play("running")
	else:
		animated_sprite.play("default")
	if Input.is_action_just_pressed("dash"):
		dash()
	timeSlow()
	move_and_slide()
	if Input.is_action_just_pressed("shoot"):
		shoot()
		emit_signal("shootSignal")
	
	if (desiredJump):
		doAJump()
		return


func doAJump():
	desiredJump = false
	jumpSpeed = sqrt(sqrt(abs(-2 * defaultGravity * gravityScale * jumpHeight)))
	if (velocity.y > 0): # if falling; ensures coyote jump is as high
		jumpSpeed += abs(velocity.y)
	velocity.y += -jumpSpeed
	jumping = true
	

func move(direction, delta):
	desiredVelocity = Vector2(direction, 0) * maxSpeed
	onGround = is_on_floor()
	acceleration = maxAcceleration if onGround else maxAirAcceleration
	deceleration = maxDeceleration if onGround else maxAirDeceleration
	turnSpeed = maxTurnSpeed if onGround else maxAirTurnSpeed
	if direction != 0:
		if (direction < 0 and velocity.x > 0) or (direction > 0 and velocity.x < 0): # if turning
			maxSpeedChange = turnSpeed * delta
		else: # if not turning
			maxSpeedChange = acceleration * delta
	else: 
		maxSpeedChange = deceleration * delta
		
	velocity.x = move_toward(velocity.x, desiredVelocity.x, maxSpeedChange)


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

func dash():
	if dashing == false:# only play the dash animation the first time its pressed
		animated_sprite.play("dash")
		emit_signal("dashSignal")
	dashing = true
	velocity.x = animated_sprite.scale.x * dashSpeed # by using scale.x player still dashes in the direction they are facing when standing still
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
	
func grapple(nodePosition):
	if grapple_cooldown_timer.time_left != 0:
		return
	#grappling = true
	var directionVector = nodePosition - global_position
	velocity += directionVector.normalized() * grappleSpeed
	grapple_cooldown_timer.start()
