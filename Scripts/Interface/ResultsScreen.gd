extends CanvasLayer

@onready var label_score = $ResultsScoreRight
@onready var label_time = $ResultsTimeRight
@onready var label_rings = $ResultsRingsRight
@onready var label_time_bonus = $ResultsTimeBonusRight
@onready var label_total = $ResultsTotalRight


var results_tallying = false
var total_score_drawn = 0;
var time_bonus_drawn = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	total_score_drawn = Global.score;
	time_bonus_drawn = Global.time_bonus;
	
	var seconds:float = fmod(Global.time_level , 60.0)
	var minutes:int   =  int(Global.time_level / 60.0) % 60
	var hhmmss_string:String = "%02d:%05.2f" % [minutes, seconds]
	
	label_time.text = str(hhmmss_string)
	label_score.text=str(Global.score)
	label_rings.text = str(Global.rings)
	label_time_bonus.text = str(time_bonus_drawn)
	label_total.text = str(total_score_drawn)
	
	results_appear();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var tally_finished = false
	
	if results_tallying:
		time_bonus_drawn = max(0, time_bonus_drawn-100)
		total_score_drawn = min(Global.score_total, total_score_drawn+100)
		
		if Input.is_action_pressed("ui_accept"):
			total_score_drawn = Global.score_total;
		
		if total_score_drawn >= Global.score_total:
			time_bonus_drawn = 0;
			total_score_drawn = Global.score_total;
			tally_finished = true;
		$SfxBeep.play();
		label_time_bonus.text = str(time_bonus_drawn)
		label_total.text = str(total_score_drawn)
	pass
	
	if results_tallying && tally_finished:
		results_tallying=false
		$SfxTallyFinished.play();
		$BeginFade.start();
	pass
	
func results_appear():
	visible=true;
	$AnimationPlayer.play("results_appear")
	pass

func results_tally_begin():
	results_tallying=true;
	pass

func _on_exit_fade_fade_finish():
	Global.init_level();
	if is_instance_valid(Global.level):
		Global.level.exit();
	else:
		get_tree().reload_current_scene();
	pass # Replace with function body.

func _on_begin_fade_timeout():
	$ExitFade.start();
	pass # Replace with function body.
