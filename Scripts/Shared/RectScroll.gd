extends TextureRect
@export var scroll_size = Vector2(32,32)
@export var offset = Vector2(0,0)
@export var scroll_speed = Vector2(0,0)
var start_position = position;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	offset.x=wrapf(offset.x+(scroll_speed.x)*delta,0,scroll_size.x)
	offset.y=wrapf(offset.y+(scroll_speed.y)*delta,0,scroll_size.y)
	position=start_position+offset;
	pass
