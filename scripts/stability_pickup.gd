extends Area2D
class_name stabilityPickup
var defaultAmount = 5
var pickedUp = false
@onready var sfx = $SFX
@export var pickupAmount: float = defaultAmount
signal stabilityPickup
func _ready():
	scale = scale*sqrt(pickupAmount/defaultAmount)

func _on_body_entered(body):
	if body.has_method("player") and pickedUp == false:
		pickedUp = true
		emit_signal("stabilityPickup", pickupAmount)
		sfx.play()
		visible = false
		await get_tree().create_timer(0.4).timeout # wait for pickup noise to play before deleting
		queue_free()
