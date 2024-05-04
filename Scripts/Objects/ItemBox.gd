extends Node2D
@export_enum("5 Rings", "10 Rings") var item_type: String = "5 Rings"
var card_spin = 0;
var collected = false;
@onready var sprite_card = $SpriteCard
@onready var sfx_item = $SfxItem
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	match item_type:
		"5 Rings":sprite_card.play("5 Rings")
		"10 Rings":sprite_card.play("10 Rings")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !collected:
		var _speed = 3
		if sprite_card.scale.x<.4:
			_speed = 6;
		card_spin+=delta*_speed
		sprite_card.scale.x = .5+(sin(card_spin)*.5)
	pass

func _on_area_2d_body_entered(body):
	if body is Player && !collected:
		body.item_bounce();
		collected = true;
		reward_item()
		sfx_item.play()
		sprite_card.scale.x=1
		animation_player.play("collect")

func reward_5ring():
	Global.rings+=5
	Global.score+=100

func reward_10ring():
	Global.rings+=10
	Global.score+=500

func reward_item():
	match item_type:
		"5 Rings": reward_5ring()
		"10 Rings":reward_10ring()
func destroy():
	queue_free();
