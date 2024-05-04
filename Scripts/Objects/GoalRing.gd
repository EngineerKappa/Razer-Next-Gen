extends Area2D
class_name GoalRing;

var collected = false
var results_screen = preload("res://Objects/ResultsScreen.tscn")

func _ready():
	$AnimationPlayer.play("Idle")
	pass
	
func create_results_screen():
	$"..".add_child(results_screen.instantiate())
	pass;


func _on_body_entered(body):
	if body is Player && !collected:
		body.goal_touched();
		collected=true;
		$AnimationPlayer.play("Collected")
		Global.calculate_total_score();
		Global.can_pause=false;
		if is_instance_valid(Global.level):
			Global.level.bgm_stop();
			Global.level.level_clear=true;
	pass # Replace with function body.
