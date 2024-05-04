extends Area2D
@export var launch_force = 1000;
@export var control_lock_time = .10
@onready var animation = $AnimationPlayer
@onready var particles = $CPUParticles2D
@onready var sfx = $SfxChime
@export var touched =false


func _on_body_entered(body):
	if body is Player:
		if body.state!="death" && body.state!="hurt" && !touched:
			sfx.play();
			animation.play("launch");
			particles.restart();
			touched=true;
			body.velocity=Vector2(launch_force,0).rotated(rotation)
			body.curl();
			body.horizontal_control_lock=control_lock_time
			body.input_axis = sign(body.velocity.x);
			body.jumping=false
			body.position = position;
			body.on_floor=false;
	pass # Replace with function body.
