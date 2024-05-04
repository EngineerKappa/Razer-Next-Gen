extends Node2D
class_name CircularMovement
@export var parent:Node2D; 
@export var radius = 32;
@export var angle = 0;
@export var rotation_speed = 5;
@export var moving = false;
var position_start = global_position

func _ready():
	position_start = global_position

func _process(delta):
	if moving:
		move(delta)

func move(delta):
	angle+=rotation_speed*delta
	parent.position = position_start+Vector2(0,radius).rotated(angle);
