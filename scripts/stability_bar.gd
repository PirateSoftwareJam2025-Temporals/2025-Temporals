extends Node2D

signal death
@onready var time_till_death = $timeTillDeath
@onready var sprite_2d = $Sprite2D
var timerLength
var dashPercent = 0.10
var shootPercent = 0.05
var maxStability = 30
var currentStability
var incrementLength = 0.01
var playerAlive = true
func _ready():
    #timerLength = time_till_death.wait_time
    currentStability = maxStability
    decayStability()
    #sprite_2d.region_rect = Rect2(10.987, 10, 2.035, 34.319)

func decayStability():
    while currentStability > 0 and playerAlive: # loops repeatedly every incrementLength until health = 0
        currentStability -= incrementLength
        scale.x = currentStability/maxStability
        await get_tree().create_timer(incrementLength).timeout
    emit_signal("death") #	when stop looping emit the signal
#func _process(delta):
    #scale.x = time_till_death.time_left/timerLength

func stabilityPickup(pickupAmount):
    var newStability = currentStability + pickupAmount
    if newStability > maxStability:
        currentStability = maxStability
    else:
        currentStability = newStability

func dash():
    currentStability -= maxStability * dashPercent

func shoot():
    currentStability -= maxStability * shootPercent
func _on_time_till_death_timeout():
    emit_signal("death")
