extends Area2D
@export var max_launch_speed=-800;
@onready var sfx = $SfxBounce
@onready var animation = $AnimatedSprite2D
var touched = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in get_overlapping_bodies():
		if i is Player:
			if i.state!="death" && i.velocity.y>=0:
				i.jumping=false;
				i.thok_used=false
				i.state="normal"
				i.velocity.y=clamp(-abs(i.velocity.y)-200, max_launch_speed,-400)
				i.curl();
				sfx.play();
				animation.play("Bounce")


func _on_animated_sprite_2d_animation_finished():
	animation.play("Default")
	pass # Replace with function body.
