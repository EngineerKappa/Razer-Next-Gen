extends CharacterBody2D
class_name Projectile

@export var movement_speed = 400
@export var raycast:RayCast2D
@onready var particle_bullet = $ParticleBullet
@onready var hitbox_hazard = $HitboxHazard
var disappeared = false

func _ready():
	pass

func _process(delta):
	var collision = move_and_collide(velocity*delta)
	if collision:
		disappear();
	position+=velocity*delta
	pass;

func disappear():
	if disappeared:
		return
	disappeared=true;
	hitbox_hazard.queue_free();
	$SpriteBullet.queue_free()
	$TimerCleanup.start()
	$ParticleBullet.emitting=false;
	velocity=Vector2(0,0)

func _on_timer_disappear_timeout():
	disappear()

func _on_timer_cleanup_timeout():
	queue_free()
	pass # Replace with function body.
