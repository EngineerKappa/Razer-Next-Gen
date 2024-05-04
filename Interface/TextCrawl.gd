extends Label


func _process(delta):
	var scroll_speed = 20
	
	if Input.is_action_pressed("ui_down"):
		scroll_speed = -180
	
	if Input.is_action_pressed("ui_up"):
		scroll_speed = 180
	
	position.y-=scroll_speed*delta
