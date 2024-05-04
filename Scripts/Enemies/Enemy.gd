extends CharacterBody2D
class_name Enemy

@export var hp = 1
@export var points_rewarded  = 500
@export var explosion_scene:PackedScene = preload("res://Objects/BadnikExplosion.tscn")
@export var explosion_offset = Vector2(0,-24);
@export_enum("Left:-1", "Right:1") var direction = -1;
@export var animation:AnimatedSprite2D

func _ready():
	face_direction();

func face_direction():
	if is_instance_valid(animation):
		animation.scale.x=abs(animation.scale.x)*direction

func _physics_process(_delta):
	if is_on_floor():
		floor_snap_length=16
	else:
		floor_snap_length=0;
		 
func take_damage():
	var instance = explosion_scene.instantiate()
	var spawn_position = position
	$"..".add_child(instance);
	instance.position = spawn_position + explosion_offset
	Global.score+=points_rewarded
	queue_free()
	pass

