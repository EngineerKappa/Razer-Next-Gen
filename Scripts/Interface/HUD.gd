extends CanvasLayer

@onready var label_rings = $LabelRings
@onready var label_score = $LabelScore
@onready var label_time = $LabelTime
var ring_flash_time = 0

func _process(delta):
	var seconds:float = fmod(Global.time_level , 60.0)
	var minutes:int   =  int(Global.time_level / 60.0) % 60
	var hhmmss_string:String = "%02d:%05.2f" % [minutes, seconds]
	label_time.text = str(hhmmss_string)
	ring_flash_time = wrap(ring_flash_time+delta,0,1)
	label_rings.text = str(Global.rings)
	
	label_score.text = str(Global.score)
	
	if Global.rings == 0 && ring_flash_time<.5:
		label_rings.set_modulate(Color("RED"))
	else:
		label_rings.set_modulate(Color("WHITE"))
	pass
	
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			$SfxUnpause.play();
			get_tree().paused=false
			$PauseScreen.visible =false
		elif Global.can_pause:
			$SfxPause.play();
			get_tree().paused=true
			$PauseScreen.visible=true
			
