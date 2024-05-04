extends Node2D

@export var impulse_velocity:Vector2 = Vector2(300,-120)
@export var impulse_position:Vector2 = position;
@export_node_path("CPUParticles2D") var particle_effect;
@export_node_path("Area2D") var aftershock_area;
func _ready():
	get_node(particle_effect).restart();
	for i in get_children():
		if i is RigidBody2D:
			i.apply_impulse(impulse_velocity+Vector2(randf_range(-60,60),randf_range(-60,60)),position-impulse_position)

func _on_timer_disappear_timeout():
	queue_free()
	pass # Replace with function body.


func _on_aftershock_body_entered(body):
	if body is RigidBodyProjectile:
		body.apply_impulse(impulse_velocity*.5,position-impulse_position)
		
	pass # Replace with function body.
