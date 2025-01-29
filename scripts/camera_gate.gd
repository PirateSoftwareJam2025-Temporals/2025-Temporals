extends Node2D
@onready var alarm_light_timer = $AlarmLight
@onready var alarm_light = $Anchor/AlarmLight
@onready var static_body_2d = $StaticBody2D
@onready var gate_sprite = $Gate
@onready var anchor = $Anchor
var newBody
var entered = false
var alternate = false
var isTimeSlow = false
var disabled = false
func _ready(): 
	await get_tree().create_timer(0.1).timeout # wait a second for the other assets to load in
	static_body_2d.position.y = -33
	gate_sprite.speed_scale = 1
	gate_sprite.play("default")
	entered = false
	
# need to turn off after player leaves body
func _on_alarm_light_length_timeout():
	if alternate == false:
		alarm_light.enabled = false # turn light off
		alternate = true
		alarm_light_timer.start()
	elif alternate == true:
		alarm_light.enabled = true # turn light on
		alternate = false
		alarm_light_timer.start()

# bring gate down
func _on_area_2d_body_entered(body): # used _body because body is not used within the method
	if !body.has_method("player") or disabled: # don't alarm if not player
		return
	gate_sprite.speed_scale = -1 # play the animation in reverse to close the gate
	gate_sprite.play("default") # play animations
	newBody = body
	entered = true
	# turn light on; start initial timer
	alarm_light.enabled = true
	alarm_light_timer.start()
# raise the gate
func _on_area_2d_body_exited(_body):
	if disabled:
		return
	# play animations
	gate_sprite.speed_scale = 1 
	gate_sprite.play("default")
	entered = false
	alarm_light_timer.stop() # disable alarm
	alarm_light.enabled = false

func _process(delta):	
	if entered == true and !disabled:
		anchor.look_at(newBody.position)

func _physics_process(delta):
	if disabled:
		changeGateState(1)
		return
	if entered == true:
		changeGateState(-1)
	elif entered == false:
		changeGateState(1)
		

func changeGateState(direction): # direction is positive for up or negative for down
	var perTickAmount = 0.02 * Engine.time_scale
	if static_body_2d.scale.y > 0.2 && direction > 0:
		static_body_2d.scale.y  -= perTickAmount * 0.5
	elif static_body_2d.scale.y < 1:
		static_body_2d.scale.y  += perTickAmount * 0.5
		

func disable():
	disabled = true
	gate_sprite.speed_scale = 1
	gate_sprite.play("default")
	alarm_light_timer.stop() # disable alarm
	alarm_light.enabled = false
	
	# play a disabled animation of sorts; perhaps it short circuits
