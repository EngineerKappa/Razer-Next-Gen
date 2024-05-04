extends Area2D
class_name AreaTransition
@export_file var target_scene = null;
var touched = false;

func _process(_delta):
	for i in get_overlapping_bodies():
		if i is Player && !touched:
			touched = true;
			Global.checkpoint_name=""
			Global.level.change_room(target_scene);
