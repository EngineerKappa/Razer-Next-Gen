extends CharacterBody2D
class_name Player
#region Variables

@export var schmovement = true;
@export var dropped_ring_scene:PackedScene = null;
@export var walljump:Node
@export var roll:Node 

@export var animations:AnimatedSprite2D
@export var camera:Camera2D

const SPEED = 360.0
const JUMP_VELOCITY = -520.0
const acceleration_ground = 1800;
const acceleration_air = 1500;
const friction_ground = 1200;
const friction_air  = 600;
const friction_roll = 300;
const friction_spindash = 500;
const jump_release_gravity = 1200;
const jump_buffer_time = .25;
const roll_buffer_time = .15;
const coyote_jump_buffer_time = .15;
const damage_invincibility_time = 1;
const max_velocity_y = 780;

const bounce_rebound_velocity = -590;
const bounce_downward_velocity = 600;
const spindash_velocity_max = 830;
const spindash_velocity_min = 200;
const spindash_increase_rate = 2000;
const thok_velocity = 550;


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_buffer = 0;
var roll_buffer = 0;
var coyote_jump_buffer = coyote_jump_buffer_time;
var jumping = false;
var on_floor = true;
var position_start = global_position;
var position_previous = position;
var input_axis = 0;
var damage_invincibility = 0;
var state = "normal"
var state_timer = 0;
var bounce_velocity = 0;
var spindash_velocity = 0;
var spinning=false;

var boundary_bottom = 480;
var boundary_top = 0;
var horizontal_control_lock = 0;
var thok_used=false;
var level_clear=false;
#endregion

func _ready():
	position_start = global_position;
	Global.can_pause=true;
	Global.player=self;
	get_level_boundaries();
		
	if Global.checkpoint_name!="":
		position=Global.checkpoint_position
	pass

func _physics_process(delta):
	
	player_timer_count(delta);
	get_level_boundaries();
	match state:
		"normal":
			player_state_normal(delta)
		"hurt":
			player_state_hurt(delta)
		"death":
			player_state_death(delta)
		"bounce_attack":
			player_state_bounce(delta);
		"roll":
			roll.state(delta);
		"spindash":
			player_state_spindash(delta);
		"walljump":
			walljump.state(delta);
		"thok":
			player_state_thok(delta);
		"victory":
			player_state_victory(delta);
		_:
			print("Invalid Player State: "+state)
			state="normal"
	
	player_pit_check();
	position_previous=position
	pass;

#Player States
func player_state_normal(delta):
	player_floor_check(delta);
	player_accelerate(delta);
	player_thok_check();
	walljump.check(delta);
	roll.check();
	player_spindash_check();
	player_jump_check(delta);
	player_bounce_check(delta);
	player_animate();
	move_and_slide();
	pass;

func player_state_hurt(delta):
	player_gravity(delta);
	move_and_slide();
	$Animations.play("Hurt");
	spinning=false
	if is_on_floor():
		on_floor=true;
		state="normal"
		state_timer=0;
		velocity=Vector2(0,0)
		
		damage_invincibility=damage_invincibility_time
	pass

func player_state_bounce(delta):
	var bounced=false;
	$Animations.play("Roll");
	spinning=true;
	
	if velocity.y!=0:
		bounce_velocity=velocity.y
	player_friction(delta);
	
	var collision = move_and_collide(velocity * delta);
	if collision:
		var collider = collision.get_collider()
		if collider is RigidBodyProjectile:
			collider.take_damage(velocity*.5,position-Vector2(0,-24));
		else:
			if collision.get_angle()<floor_max_angle:
				bounced=true;
			velocity = velocity.slide(collision.get_normal())
	
	if bounced or velocity.y<0:
		$SFX/SfxBounce.play();
		$ParticleBounce.restart()
		on_floor=false;
		state="normal"
		state_timer=0;
		thok_used=false;
		if velocity.y>bounce_rebound_velocity:
			velocity.y=bounce_rebound_velocity
	player_gravity(delta)

func player_state_spindash(delta):
	var _uncurl=false;
	coyote_jump_buffer = coyote_jump_buffer_time
	spinning=true
	spindash_velocity = move_toward(spindash_velocity,spindash_velocity_max,spindash_increase_rate*delta)
	$Animations.play("Spindash");
	$ParticleJumpDash.emitting=true;
	player_friction(delta);
	move_and_slide()
	input_axis = Input.get_axis("move_left", "move_right")
	if input_axis !=0:
		$Animations.scale.x=sign(input_axis);
	
	if !is_on_floor():
		on_floor=false;
		_uncurl=true;
	if _uncurl:
		state="normal"
		state_timer=0;
		$SFX/SfxSpindash.stop()
		$Animations.play("Roll");
	if !Input.is_action_pressed("attack"):
		state="roll"
		$SFX/SfxSpindash.stop()
		$SFX/SfxSpindashRelease.play();
		velocity.x=spindash_velocity*sign($Animations.scale.x)
	pass

func player_state_thok(delta):
	var _end_thok
	var ignore_wall = false
	
	var collision = move_and_collide(velocity * delta);
	if collision:
		var collider = collision.get_collider()
		if collider is RigidBodyProjectile:
			collider.take_damage(velocity,position-Vector2(0,-24));
			ignore_wall=true;
			walljump.stick_timer=0;
			item_bounce();
		else:
			velocity = velocity.slide(collision.get_normal())
		
	if velocity.x!=0:
		input_axis=sign(velocity.x)
	
	if !ignore_wall:
		walljump.check(delta);
	if state_timer>.12:
		_end_thok=true;
	if velocity.x==0:
		_end_thok=true;
		
	if _end_thok==true:
		state_timer=0;
		jump_buffer=0;
		state="normal"
		$ParticleJumpDash.emitting=false;
	pass;

func player_state_victory(delta):
	player_friction(delta)
	player_gravity(delta)
	if is_on_floor():
		$Animations.play("Idle");
	else:
		$Animations.play("Roll");
	move_and_slide()
	
	pass;

func player_state_death(delta):
	$Animations.play("Death");
	spinning=false
	player_gravity(delta);
	position.y+=velocity.y*delta
	if state_timer>=1.5:
		$CanvasLayer/DeathFade.enabled = true;

#Shared Player Methods
func player_floor_check(delta):
	if is_on_floor():
		if !on_floor:
			$SFX/SfxLand.play();
			on_floor = true;
			spinning=false
			$ParticleJumpDash.emitting=false
			velocity.y=0;
		jumping=false;
		coyote_jump_buffer = coyote_jump_buffer_time
		floor_snap_length = 8 * (60*delta);
	else:
		on_floor = false;  
		player_gravity(delta);
		floor_snap_length = 0;
	pass

func player_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = min(velocity.y,max_velocity_y)
	pass

func player_accelerate(delta):
	if horizontal_control_lock==0:
		input_axis = Input.get_axis("move_left", "move_right");
	
	var _acceleration = acceleration_ground
	var _anim_run = false
	if !on_floor:
		_acceleration = acceleration_air
	
	if input_axis !=0:
		if sign(velocity.x)!=sign(input_axis):
			_acceleration*=2;
		if on_floor:
			_anim_run=true;
		$Animations.scale.x=sign(input_axis);
		
		if abs(velocity.x)<=SPEED:
			velocity.x = move_toward(velocity.x, input_axis*SPEED, _acceleration*delta)
		else:
			player_friction(delta);
	else:
		player_friction(delta);
		
	if abs(velocity.x)>0 && on_floor:
		_anim_run=true;		
	if _anim_run:
		$Animations.play("Run");
	pass
	
func player_friction(delta):
	var _friction = friction_ground
	if !on_floor:
		_friction = friction_air	
	if state=="roll":
		_friction = friction_roll
	if state=="spindash":
		_friction = friction_spindash
	velocity.x = move_toward(velocity.x, 0, _friction*delta)
	pass

func player_jump_check(delta):	
	if Input.is_action_just_pressed("jump"):
		jump_buffer = jump_buffer_time;
		
	if jump_buffer > 0 && coyote_jump_buffer > 0:
			player_jump();
			
	if jumping:
		if !Input.is_action_pressed("jump") && velocity.y < 0 :
			velocity.y += jump_release_gravity * delta
	pass;




func player_thok_check():
	if on_floor:
		thok_used=false;
	
	if !schmovement:
		return
	
	if Input.is_action_just_pressed("jump") && !on_floor && coyote_jump_buffer==0 && !thok_used:
		$SFX/SfxThok.play();
		$ParticleThok.restart();
		$ParticleJumpDash.emitting=true;
		velocity.x=thok_velocity*sign($Animations.scale.x)
		velocity.y=0;
		thok_used=true;
		state_timer=0
		horizontal_control_lock = .20
		state="thok"
		spinning=true;
		$Animations.play("Roll")
	pass;

func player_spindash_check():
	if !schmovement:
		return;
	if Input.is_action_just_pressed("attack") && on_floor: 
		state="spindash"
		spindash_velocity=spindash_velocity_min;
		$SFX/SfxSpindash.play();
	pass
	
func player_bounce_check(_delta):
	if !schmovement:
		return
		
	if Input.is_action_just_pressed("attack") && !on_floor:
		velocity.y=bounce_downward_velocity
		velocity.x/=2;
		jumping=false;
		$ParticleJumpDash.emitting=true
		state_timer=0
		state="bounce_attack"
	pass

func player_jump():
	jump_buffer = 0;
	jumping = true;
	spinning = true;
	on_floor = false;
	state="normal"
	coyote_jump_buffer = 0;
	velocity.y = JUMP_VELOCITY
	
	$SFX/SfxJump.play();
	$Animations.play("Roll");
	$ParticleJumpDash.emitting=false
	
func player_timer_count(delta):
	jump_buffer = move_toward(jump_buffer, 0, delta)
	coyote_jump_buffer = move_toward(coyote_jump_buffer, 0, delta)
	damage_invincibility = move_toward(damage_invincibility, 0, delta)
	roll_buffer = move_toward(roll_buffer, 0, delta)
	horizontal_control_lock = move_toward(horizontal_control_lock, 0, delta)
	state_timer+=delta;
	
	if  fmod(damage_invincibility, .10):
		$Animations.visible=!$Animations.visible
	if damage_invincibility == 0:
		$Animations.visible=true;
	
	pass;
	
func player_animate():
	if abs(velocity.x)==0 && on_floor && input_axis==0:
			$Animations.play("Idle");
	pass;

func player_take_damage(damage_type):
	if damage_invincibility>0:
		return;
	if state=="hurt":
		return;
	if state=="death":
		return;
	if level_clear:
		return;
		
	$ParticleJumpDash.emitting=false
	if Global.rings>0:
		$SFX/SfxRingLoss.play();
		
		state="hurt"
		spinning=false
		state_timer=0;
		velocity.y=-280
		velocity.x=200*-sign($Animations.scale.x)
		position.y-=1
		on_floor=false;
		player_drop_rings();
	else:
		player_die(damage_type);
	pass

func player_drop_rings():
	if dropped_ring_scene == null:
		print("Dropped rings not found")
		return;
		
	var rings_dropped = min(Global.rings,5)
	var angle: float = 0;
	var angle_start = randf_range(0,360);
	var spawn_speed = 400
	var spawn_velocity = Vector2(0,0)
	var spawn_radius = 16.0;
	var spawn_position = position
	var position_offset = Vector2(0,0)
	for r in range(rings_dropped):
		angle = angle_start + (float(r) * 2 * PI / float(rings_dropped)) + deg_to_rad(90)
		position_offset = Vector2(spawn_radius * cos(angle),spawn_radius * sin(angle))
		spawn_velocity = Vector2(spawn_speed * cos(angle),spawn_speed * sin(angle))
		
		var instance = dropped_ring_scene.instantiate()
		$"..".add_child(instance);
		instance.position = spawn_position+position_offset+Vector2(0,-20)
		instance.velocity = spawn_velocity; 
	Global.rings=0;

func player_pit_check():
	if position.y>boundary_bottom+32:
		player_die("pit")
	
func player_die(damage_type):
	if level_clear:
		return;
	if state=="death":
		return;
	$ParticleJumpDash.emitting=false
	
	if damage_type == "Spikes":
		$SFX/SfxSpiked.play();
	else:
		$SFX/SfxDeath.play();
	state="death"
	velocity.y=-480;
	velocity.x=0;
	state_timer=0;
	Global.can_pause=false
	pass

func death_reset():
	Global.rings=0;
	Global.score=0;
	if is_instance_valid(Global.level):
		Global.level.load_room();
	else:
		get_tree().reload_current_scene()
	pass	

func goal_touched():
	state="victory"
	state_timer = 0;
	level_clear=true;
	velocity.x/=2;
	$ParticleJumpDash.emitting=false;

func item_bounce():
	if state=="Death":
		return;
	if !on_floor:
		velocity.y=min(-400,-velocity.y)
		jumping=false
		thok_used=false

func curl():
	jumping=false;
	spinning=true;
	animations.play("Roll");

func state_change(_state):
	state = _state
	state_timer=0;
	
func get_level_boundaries():
	if is_instance_valid(Global.room):
		boundary_bottom=Global.room.limit_bottom;
		boundary_top=Global.room.limit_top;
		
		camera.limit_left=Global.room.limit_left;
		camera.limit_bottom=Global.room.limit_bottom;
		camera.limit_top=Global.room.limit_top;
		camera.limit_right=Global.room.limit_right;

#Signals
func _on_hurtbox_hazard_collision(area):
	if is_instance_valid(area):
		if spinning && area.damage_type=="Badnik":
			area.spin_damage()
			item_bounce()
		else:
			player_take_damage(area.damage_type);
	pass # Replace with function body.

func _on_death_fade_fade_finish():
	death_reset();
	pass # Replace with function body.
