extends Node2D
class_name Level

@export_file var initial_scene_path = null;
@export_file var next_scene_path = null;
@export var bgm_player:AudioStreamPlayer = null;
@export var screen_fade : ScreenFade = null;
var current_scene_path;
var working_scene : PackedScene;
var room_instance : Node2D
var level_clear = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.level=self;
	current_scene_path = initial_scene_path;
	load_room();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !level_clear:
		Global.time_level += delta;

func room_loaded():
	if is_instance_valid(screen_fade):
		screen_fade.start();

func bgm_stop():
	if is_instance_valid(bgm_player):
		bgm_player.stop();
	
func unload_room():
	if is_instance_valid(room_instance):
		room_instance.queue_free();
	working_scene=null
	room_instance=null;

func instantiate_room():
	working_scene = load(current_scene_path)
	room_instance=working_scene.instantiate();
	if room_instance is Level:
		print("WHY THE HELL ARE YOU TRYING TO LOAD A LEVEL FROM WITHIN A LEVEL")
		return;
	call_deferred("add_child", room_instance);
	room_loaded();
	
func load_room():
	unload_room();
	instantiate_room()

func exit():
	if next_scene_path!=null:
		get_tree().change_scene_to_packed(load(next_scene_path));

func change_room(new_scene):
	current_scene_path=new_scene
	load_room();
