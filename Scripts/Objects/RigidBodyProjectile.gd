extends RigidBody2D
class_name RigidBodyProjectile
@export var debris_scene:PackedScene

func take_damage(_velocity,_position):
	var instance = debris_scene.instantiate();
	instance.impulse_velocity = _velocity
	instance.impulse_position = _position
	instance.rotation = rotation
	instance.position = position
	instance.scale = scale
	$"..".call_deferred("add_child",instance)
	
	queue_free()


func _on_hitbox_neutral_body_entered(body):
	if body is Player:
		call_deferred("take_damage",body.velocity,body.position)
