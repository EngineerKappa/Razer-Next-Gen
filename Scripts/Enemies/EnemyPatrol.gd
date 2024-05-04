extends State

@export var move_speed = 120;
@export var gravity:Gravity
@export var animation:AnimatedSprite2D
@export var raycast_left:RayCast2D
@export var raycast_right:RayCast2D
var raycast_enabled=true;
func enter():
	if !(is_instance_valid(raycast_left) && is_instance_valid(raycast_left)):
		raycast_enabled=false
	else:
		raycast_left.enabled=true;
		raycast_right.enabled=true;

func physics_update(delta):
		
	gravity.apply(delta);
	if parent.is_on_wall():
		parent.direction=-parent.direction
	floor_raycast_check();
	parent.velocity.x=parent.direction*move_speed
	animation.scale.x=abs(animation.scale.x)*parent.direction
	parent.move_and_slide();

func exit():
	raycast_left.enabled=false;
	raycast_right.enabled=false;

func floor_raycast_check():
	if !raycast_enabled:
		return;
	if !parent.is_on_floor():
		return;
	if !raycast_left.is_colliding():
		parent.direction=1
	if !raycast_right.is_colliding():
		parent.direction=-1
