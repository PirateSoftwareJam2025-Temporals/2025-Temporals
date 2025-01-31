extends Node2D

signal death
@onready var time_till_death = $timeTillDeath
@onready var sprite_2d = $Sprite2D
var timerLength
var dashPercent = 0.10
var shootPercent = 0.05
func _ready():
	timerLength = time_till_death.wait_time

func _process(delta):
	scale.x = time_till_death.time_left/timerLength

func _on_time_till_death_timeout():
	emit_signal("death")

func dash():
	time_till_death.time_left -= timerLength * dashPercent

func shoot():
	time_till_death.time_left -= timerLength * shootPercent
