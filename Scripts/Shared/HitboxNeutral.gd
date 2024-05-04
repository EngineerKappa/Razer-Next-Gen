extends Area2D
class_name HitboxNeutral
@export var hazard_object:Node = null
@export_enum("Badnik", "Spikes", "GunnerBullet", "Physics") var damage_type: String

func _process(_delta):
	for i in get_overlapping_areas():
		if i is HitboxHazard:
			i.neutral_collision(self);

