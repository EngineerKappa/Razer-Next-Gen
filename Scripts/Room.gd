extends Node2D
class_name Room
@export var limit_left = 0
@export var limit_top = 0
@export var limit_bottom = 480
@export var limit_right = 2000

func _ready():
	Global.room = self;
