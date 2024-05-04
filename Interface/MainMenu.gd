extends Control
@export_file var adventure_scene
@export var first_button:Button;
var exit_label="adventure"
var selected=false;
# Called when the node enters the scene tree for the first time.
func _ready():
	first_button.grab_focus()
	first_button.grab_click_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func adventure_mode():
	get_tree().change_scene_to_packed(load(adventure_scene))

func fade_out():
	$FadeOut.visible=true
	$FadeOut.start();
	$SfxSelect.play()
	selected=true;

func _on_adventure_mode_pressed():
	if selected:
		return
	exit_label="adventure"
	$BGM.stop();
	$AnimationPlayer.play("MenuDisappear")
	fade_out();
	pass # Replace with function body.


func _on_trial_mode_pressed():
	if selected:
		return
	exit_label="adventure"
	$BGM.stop();
	$AnimationPlayer.play("MenuDisappear")
	fade_out();
	pass # Replace with function body.

func _on_fade_out_fade_finish():
	match exit_label:
		"adventure": 
			adventure_mode(); 
	pass # Replace with function body.


