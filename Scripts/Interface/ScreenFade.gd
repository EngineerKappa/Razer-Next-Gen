extends ColorRect
class_name ScreenFade

@export var target_color:Color = Color("BLACK");
@export var start_color:Color = Color(0,0,0,0);
@export var time_to_fade:float = .5; 
@export var enabled = true;
@export var hang_time = .5;
@export var invisible_on_finish = false;
@export var free_on_finish:bool = false;
var fade_time:float = 0;
var fade_has_finished = false;
var hang_time_started = false;
var hang_time_timer = 0;
var resolution=Vector2(640,480)

signal fade_finish
signal hang_time_start

func _ready():
	color = start_color.lerp(target_color, (fade_time/time_to_fade));
	position = Vector2(-640,-480)
	anchor_left = -resolution.x
	anchor_right = resolution.x*2
	anchor_top = -resolution.y
	anchor_bottom = resolution.y*2
	

func start():
	fade_time = 0;
	enabled=true;
	fade_has_finished=false
	hang_time_timer=0;
	hang_time_started=false;
	visible=true;
	color = start_color.lerp(target_color, (fade_time/time_to_fade));
	pass

func _process(delta):
	if !enabled:
		return;
		
	if !fade_has_finished:
		if fade_time == time_to_fade && hang_time_timer == hang_time:
			fade_has_finished=true;
			fade_finish.emit();
			if invisible_on_finish:
				visible=false;
			if free_on_finish:
				queue_free();
		elif hang_time > 0 && fade_time >= time_to_fade:
			if !hang_time_started:
				hang_time_start.emit()
				hang_time_started=true;
			hang_time_timer=min(hang_time_timer+delta,hang_time)
	
	color = start_color.lerp(target_color, (fade_time/time_to_fade));
	fade_time=min(fade_time+delta,time_to_fade)
	
	

	
	
	pass;
