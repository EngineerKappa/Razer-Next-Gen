extends Control

@export var press_start_allowed = false
@export var next_scene:PackedScene = null;
var leaving = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if press_start_allowed && Input.is_action_just_pressed("pause") && !leaving:
		$SfxPressed.play()
		$BGM.stop();
		leaving=true;
		$FadeOut.start();
	pass


func _on_fade_out_fade_finish():
	get_tree().change_scene_to_packed(next_scene)
	pass # Replace with function body.
