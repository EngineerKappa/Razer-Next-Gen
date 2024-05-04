extends Area2D
var collected=false;
@export var collectable = true;
@export var dropped = false;

func ring_collect():
	collected=true;
	Global.rings+=1;
	if !dropped:
		Global.score+=10;
	$Particle.restart()
	$Animations.visible=false;
	$SfxRing.play();
	pass

func _on_body_entered(body):
	if body.name=="Player" && !collected && collectable:
		ring_collect();
	pass # Replace with function body.

func _on_particle_finished():
	queue_free();
	pass # Replace with function body.


func _on_timer_disappear_grace_period_ended():
	collectable = true;
	pass # Replace with function body.
