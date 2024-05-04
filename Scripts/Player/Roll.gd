extends Node

@export_category("Dependencies")
@export var parent:Player
@export var animations:AnimatedSprite2D
@export var jumpdash_trail:CPUParticles2D
@export var roll_sound:AudioStreamPlayer
@onready var physics_damage = $"../../RollPhysicsDamage"
@onready var physics_damage_offset
func _ready():
	physics_damage_offset = physics_damage.position
	
func state(delta):
	var _uncurl=false;
	jumpdash_trail.emitting=true;
	parent.curl()
	parent.player_gravity(delta);
	parent.player_friction(delta);
	parent.floor_snap_length = 16 * (60*delta);
	parent.player_jump_check(delta)
	parent.move_and_slide()
	parent.coyote_jump_buffer = parent.coyote_jump_buffer_time
	parent.player_spindash_check()
	if !parent.is_on_floor():
		parent.on_floor=false;
		_uncurl=true;
	
	if abs(parent.velocity.x)<60:
		_uncurl=true;
		
	if _uncurl:
		if parent.is_on_floor():
			parent.spinning=false
			jumpdash_trail.emitting=false;
		parent.state_change("normal")
	pass;

func _process(_delta):
	physics_damage.position=physics_damage_offset+(parent.velocity/30)
	
	pass

func check():
	if Input.is_action_just_pressed("move_down"):
		parent.roll_buffer=parent.roll_buffer_time;
		
	if parent.roll_buffer>0 && parent.on_floor && abs(parent.velocity.x)>60:
		roll_sound.play();
		parent.state_change("roll")
		parent.roll_buffer=0;
	pass


func _on_roll_physics_damage_body_entered(body):
	var can_break = false
	
	#Ground roll
	if abs(parent.velocity.x)>200 && parent.is_on_floor():
		can_break = true;
	
	if abs(parent.velocity.x)>=parent.SPEED+120 && !parent.is_on_floor():
		can_break = true;
	
	if !parent.spinning: #If we're not curled up, don't bother
		can_break = false 
	#Thok and Bounce handle these, we're only concerned with rolling
	if parent.state != "normal" && parent.state!="roll": 
		can_break = false
	
	if parent.state == "spindash": 
		can_break = true
	
	if body is RigidBodyProjectile && can_break:
		body.take_damage(parent.velocity,parent.position+Vector2(0,-24))
		parent.item_bounce();
	pass # Replace with function body.
