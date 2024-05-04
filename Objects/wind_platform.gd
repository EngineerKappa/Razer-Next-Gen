extends AnimatableBody2D
class_name WindPlatform
@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $CollisionShape2D

func activate():
	animation_player.play("appear")
	collision_shape_2d.set_deferred("disabled", false);
