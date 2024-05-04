extends Area2D
class_name PlayerHurtbox

@export var player_object:Node = null
signal hazard_collision(area:Area2D)

func _process(_delta):
	for n in get_overlapping_areas():
		if n is HitboxHazard:
			hazard_collision.emit(n);
	pass;
