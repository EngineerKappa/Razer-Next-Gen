extends Area2D

@export var launch_force = 750;
@export var control_lock_time = .10
@export var momentum_lock = false;
@export var sound:AudioStreamPlayer
@export var animation:AnimationPlayer
@export var timer:Timer
@export var touched = false;

func _process(_delta):
	for i in get_overlapping_bodies():
		if i is Player:
			if i.state!="death" && i.state!="hurt" && !touched:
				sound.play();
				i.state="normal"
				touched = true;
				if momentum_lock:
					i.velocity = Vector2(0,-launch_force).rotated(rotation)
				else:
					i.velocity.x += Vector2(0,-launch_force).rotated(rotation).x
					i.velocity.y = Vector2(0,-launch_force).rotated(rotation).y
				i.horizontal_control_lock=control_lock_time
				i.input_axis = 0;
				i.jumping=false
				i.on_floor=false;
				i.curl();
				i.move_and_slide();
				animation.play("launch")
				timer.start();


func _on_bounce_cooldown_timeout():
	touched=false;
