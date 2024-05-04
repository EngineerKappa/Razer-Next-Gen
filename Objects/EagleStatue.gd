extends Node2D
@export var activated = false;
@onready var animation_player = $AnimationPlayer
@onready var sfx_activate = $SfxActivate

@export var platform_container:Node

func activate_platforms():
	if is_instance_valid(platform_container):
		for i in platform_container.get_children():
			if i is WindPlatform:
				i.activate();

func _on_area_2d_body_entered(body):
	if body is Player && body.spinning && !activated:
		animation_player.play("activate")
		activated=true
		activate_platforms();
		body.item_bounce();
		sfx_activate.play();
	pass # Replace with function body.
