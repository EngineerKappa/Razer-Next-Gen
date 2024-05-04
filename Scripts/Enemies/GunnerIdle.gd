extends State
@export var jet_particles:CPUParticles2D
@export var gravity:Gravity;
@export var circular_movement:CircularMovement;
@export var bullet_scene:PackedScene;
@export var gun_sprite:Sprite2D;
@export var bullet_marker:Marker2D;
@export var shot_count = 3;
var shots_fired = 0;

func enter():
	update_particles();
	parent.face_direction();

func shoot():
	$"../../SpriteGunner/SpriteGun/ParticleMuzzleflash".restart();
	$"../../SfxShoot".play()
	shots_fired+=1;
	
	if shots_fired>=shot_count:
		shots_fired=0;
		$"../../SfxCock".play();
		$"../../TimerStart".start();
	else:
		$"../../TimerRefire".start();
	
	var bullet_instance = bullet_scene.instantiate()
	var bullet_velocity = Vector2(bullet_instance.movement_speed,0)
	var bullet_rotation = gun_sprite.rotation
	bullet_instance.position = bullet_marker.global_position
	bullet_instance.scale.x = parent.direction
	bullet_instance.velocity = bullet_velocity.rotated(bullet_rotation) * Vector2(parent.direction,1)
	bullet_instance.velocity.y+=randf_range(-60,60)
	parent.get_parent().add_child(bullet_instance)
	

func physics_update(delta):
	update_particles();
	if !parent.hovering:
		gravity.apply(delta);
		parent.move_and_slide();
	elif is_instance_valid(circular_movement):
		circular_movement.move(delta);
		

func update_particles():
	jet_particles.direction.x=-parent.direction
	if parent.hovering == false:
		jet_particles.emitting=false;
	else:
		jet_particles.emitting=true;

func _on_timer_start_timeout():
	shoot();
	pass # Replace with function body.

func _on_timer_refire_timeout():
	shoot();
	pass # Replace with function body.
