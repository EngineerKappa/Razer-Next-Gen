extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$YellowExplosion.emitting=true;
	$RedExplosion.emitting=true;
	pass # Replace with function body.


func _on_timer_timeout():
	queue_free();
	pass # Replace with function body.
