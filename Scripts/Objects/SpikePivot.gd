extends Node2D
@export var scene_to_spawn:PackedScene
@export var amount_of_instances:int = 1
@export var spin_radius:float = 32
@export var spin_speed:float = 180
@export_range(0, 360) var start_angle:float
@export var silent:bool = false;
@export var invisible_pivot:bool = false;
var angle = start_angle
var instance_list:Array

func _draw():
	if Engine.is_editor_hint():
		draw_arc(Vector2(0,0),spin_radius,0,360,16,Color.WHITE)
		queue_redraw()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	angle = start_angle
	var instance
	for i in range(amount_of_instances):
		instance = scene_to_spawn.instantiate() 
		add_child(instance)
		instance_list.append(instance)
		
	update_instance_positions();
	if invisible_pivot:
		$SpritePivot.visible = false;
		$SpritePivot.queue_free();
	if silent:
		$SfxSwing.stop()
		$SfxSwing.queue_free()
	
func update_instance_positions():
	var instance_angle
	var angle_rad
	var list_size = instance_list.size();
	for i in list_size:
		instance_angle = angle+float(i)*(360/float(list_size))
		angle_rad = deg_to_rad(instance_angle)
		if is_instance_valid(instance_list[i]):
			instance_list[i].position=Vector2(spin_radius,0).rotated(angle_rad)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	angle += spin_speed*delta
	update_instance_positions();
	pass
