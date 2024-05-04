extends Node
class_name Gravity
@export var parent:CharacterBody2D
@export var maximum_vertical_speed = 780
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func apply(_delta):
	if !parent.is_on_floor():
		parent.velocity.y += gravity * _delta
		parent.velocity.y = min(parent.velocity.y,maximum_vertical_speed)
