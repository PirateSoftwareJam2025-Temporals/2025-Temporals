extends Area2D

var defaultAmount = 5
@export var pickupAmount: float = defaultAmount

func _ready():
	scale = scale*sqrt(pickupAmount/5)
