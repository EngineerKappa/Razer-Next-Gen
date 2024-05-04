extends Timer
class_name TimerDisappear

@export var disappearing_object:Node = null;
@export var flicker_time = 1;
@export var grace_period = .10;
var grace_period_over = false;
signal grace_period_ended

func _process(_delta):
	if is_instance_valid(disappearing_object):
		if time_left <= flicker_time:
			disappearing_object.visible=!disappearing_object.visible;
		
		if ((wait_time - time_left) > grace_period) && !grace_period_over:
			grace_period_over=true;
			grace_period_ended.emit();
	else:
		print("Disappearing object not set");
		queue_free();
	pass
