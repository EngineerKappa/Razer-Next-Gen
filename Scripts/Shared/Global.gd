extends Node

var rings = 0;
var time_level = 0;
var time_bonus_base = 10000
var time_bonus_increment = 20
var time_bonus_cutoff = 60
var time_bonus = 0;
var score = 0;
var score_total = 0;
var paused = false;
var checkpoint_id = 0;
var checkpoint_name = "";
var level: Level = null;
var room: Room = null;
var player: Player = null;
var checkpoint_position:Vector2 = Vector2(0,0);

var can_pause = true;

func init_level():
	rings = 0;
	time_level = 0;
	score = 0;
	paused = false;
	checkpoint_name = "";
	checkpoint_id = 0;
	checkpoint_position = Vector2(0,0);

func calculate_total_score():
	var time_bonus_difference = 0
	if time_level > time_bonus_cutoff:
		time_bonus_difference = floor(time_level - time_bonus_cutoff)
	time_bonus = max(0, time_bonus_base - (time_bonus_increment * time_bonus_difference))
	score_total = score + time_bonus
	pass
	
func reload_current_room():
	if is_instance_valid(room):
		room.reload_current_scene();
	else:
		print("Invalid room")
pass
