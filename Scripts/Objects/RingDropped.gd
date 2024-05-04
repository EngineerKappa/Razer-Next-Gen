extends CharacterBody2D


const SPEED = 300.0
const friction = 150;

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var ring_object:Node = null
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var velocity_bounce = 0


func _physics_process(delta):
	if velocity.y != 0:
		velocity_bounce = velocity.y;
		
	if !is_on_floor():
		velocity.y += gravity * delta
		
	if is_on_floor() && velocity.y>=0:
		velocity.y = min(-velocity_bounce*.9,-200)
		
	velocity.x = move_toward(velocity.x, 0, friction*delta)
		
	if !is_instance_valid(ring_object):
		queue_free();
		
	move_and_slide()
	pass

func _on_timer_disappear_timeout():
	queue_free();
	pass # Replace with function body.
