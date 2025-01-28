extends Node2D
@onready var alarm_light_timer = $AlarmLight
@onready var alarm_light = $Anchor/AlarmLight
@onready var static_body_2d = $StaticBody2D
@onready var gate = $Gate
@onready var anchor = $Anchor
var newBody
var entered = false
var alternate = false
var isTimeSlow = false
func _ready(): 
	await get_tree().create_timer(0.1).timeout # wait a second for the other assets to load in
	static_body_2d.position.y = -33
	gate.speed_scale = 1
	gate.play("default")
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

func _on_area_2d_body_entered(body): # used _body because body is not used within the method
	#static_body_2d.position.y = 0 # bring gate down
	gate.speed_scale = -1 # play the animation in reverse to close the gate
	gate.play("default") # play animations
	newBody = body
	entered = true
	# turn light on; start initial timer
	alarm_light.enabled = true
	alarm_light_timer.start()
	
func _on_area_2d_body_exited(_body):
	#static_body_2d.position.y = -33 # raise gate y direction is positive going down
	gate.speed_scale = 1 # play animations
	gate.play("default")
	entered = false
	alarm_light_timer.stop()
	alarm_light.enabled = false

func _process(delta):	
	if entered == true:
		anchor.look_at(newBody.position)

func _physics_process(delta):
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
