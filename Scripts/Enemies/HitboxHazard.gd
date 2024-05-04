extends Area2D
class_name HitboxHazard

@export var hazard_object:Node = null
@export_enum("Badnik", "Spikes", "GunnerBullet") var damage_type: String

func spin_damage():
	if is_instance_valid(hazard_object):
		hazard_object.take_damage();

func neutral_collision(_area):
	if damage_type=="Badnik" && is_instance_valid(hazard_object):
		hazard_object.take_damage();
	pass;
