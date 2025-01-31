extends Area2D
@onready var ability: Area2D = $"."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if PlayerInfo.grappleHook:
		ability.queue_free();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		PlayerInfo.grappleHook = true;
		ability.queue_free();
