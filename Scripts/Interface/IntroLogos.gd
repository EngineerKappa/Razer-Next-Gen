extends Control

@export_file var next_scene_path
var current_logo = 0;
var fade_finished = false;

signal exited;

func _on_screen_fade_in_fade_finish():
	if current_logo == 0:
		$SfxSegaSonic.play();
		$Refade.start();
	if current_logo == 1:
		$SfxEngineerKappa.play();
		$Refade.start();
	current_logo += 1;

func _on_screen_fade_out_fade_finish():
	if current_logo == 2:
		$EngineerKappa.visible=false;
		if fade_finished == false:
			fade_finished = true;
			exited.emit();
			if next_scene_path!=null:
				get_tree().change_scene_to_packed(load(next_scene_path))

func _on_refade_timeout():
	$ScreenFadeOut.start();

func _on_screen_fade_out_hang_time_start():
	if current_logo == 1:
		$SegaSonic.visible=false;
		$EngineerKappa.visible=true;
		$ScreenFadeIn.start();
	pass # Replace with function body.
