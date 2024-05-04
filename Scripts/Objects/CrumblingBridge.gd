extends RigidBody2D

var crumbling=false
var falling = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if crumbling:
		$Platform1.offset.y=randi_range(-2,2)
		$Platform2.offset.y=randi_range(-2,2)
		$Platform3.offset.y=randi_range(-2,2)
	pass


func crumble_start():
	if !crumbling && !falling:
		crumbling=true
		$FallingDebris.restart();
		$Dust.restart();
		$SfxCrack.play();
		$CrumbleTimer.start();
	pass # Replace with function body.

func _on_crumble_check_body_entered(body):
	if body is Player:
		crumble_start();
	pass # Replace with function body.


func _on_crumble_timer_timeout():
	crumbling=false
	falling=true;
	$SfxCrumble.play();
	$Platform1.offset.y=0;
	$Platform2.offset.y=0;
	$Platform3.offset.y=0;
	$FallingDebris.emitting=false;
	freeze=false;
	pass # Replace with function body.
