extends Area2D

@export var checkpoint_name:String = "Checkpoint";
@export var checkpoint_id:int = 0
@export var animation_player:AnimationPlayer
@export var animated_sprite:AnimatedSprite2D
@export var activate_sound:AudioStreamPlayer
var active = false;

func _ready():
	if Global.checkpoint_id>checkpoint_id:
		animation_finished();
		active=true;
	if Global.checkpoint_name==checkpoint_name:
		active=true
		animation_player.play("activate")

func _on_body_entered(body):
	if body is Player && !active:
		active=true
		animation_player.play("activate")
		activate_sound.play();
		Global.checkpoint_name=checkpoint_name
		Global.checkpoint_id=max(Global.checkpoint_id,checkpoint_id)
		Global.checkpoint_position=position

func animation_finished():
	animated_sprite.play("active")
