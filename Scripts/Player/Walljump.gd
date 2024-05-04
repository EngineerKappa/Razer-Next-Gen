extends Node

@export var jump_velocity = Vector2(360,-520.0);
@export var slide_speed = 30;
@export var slide_speed_fast = 120;
@export var stick_threshold = .10;
@export_category("Dependencies")
@export var parent:Player
@export var animations:AnimatedSprite2D
@export var jumpdash_trail:CPUParticles2D
@export var jump_sound:AudioStreamPlayer
@export var grab_sound:AudioStreamPlayer

var velocity_previous = 0;
var stick_timer = 0;

func state(_delta):
	var leave_wall=false;
	
	animations.play("Walljump");
	parent.spinning=false;
	
	parent.player_gravity(_delta);
	parent.velocity.x=-30*animations.scale.x
	parent.velocity.y=min(parent.velocity.y,slide_speed)
	if Input.is_action_pressed("move_down"):
		parent.velocity.y=slide_speed_fast;
	
	if Input.is_action_just_pressed("jump"):
		leave_wall=true;
		parent.velocity.x=animations.scale.x*jump_velocity.x
		parent.velocity.y=jump_velocity.y
		parent.curl();
		jump_sound.play();
		parent.horizontal_control_lock = .3
		parent.input_axis=sign(parent.velocity.x)
	
	parent.player_bounce_check(_delta);
	parent.move_and_slide()
	
	if parent.is_on_floor():
		leave_wall=true;
	if !parent.is_on_wall():
		animations.play("Roll");
		leave_wall=true;
	if leave_wall:
		parent.state="normal"
		parent.state_timer=0;
	pass

func check(delta):
	if parent.velocity.x!=0:
		velocity_previous=parent.velocity.x;
	if velocity_previous==0:
		velocity_previous=animations.scale.x;
	
	if parent.input_axis!=0 && !parent.on_floor && parent.is_on_wall():
		stick_timer+=delta;
		if parent.horizontal_control_lock>0:
			stick_timer=stick_threshold;
		
	if parent.position.y < parent.boundary_top:
		stick_timer = 0;
	
	if stick_timer>=stick_threshold:
		stick_timer=0;
		jumpdash_trail.emitting=false
		parent.state_change("walljump")
		parent.velocity.y/=2;
		parent.velocity.x=0;
		animations.scale.x=-sign(velocity_previous)
		grab_sound.play();
	pass;
