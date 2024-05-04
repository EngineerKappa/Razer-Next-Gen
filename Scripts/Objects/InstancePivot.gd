
extends Node2D
class_name InstancePivot
@export var rotation_speed:float = 2
var editor_circle:CircleShape2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Engine.is_editor_hint():
		return;
	
	for i in get_children():
		if i is Node2D:
			i.position=i.position.rotated(rotation_speed * delta)
