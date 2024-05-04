extends Node
class_name StateMachine

@export var parent:Node;
@export var default_state:State;
var state:State;

func _ready():
	state = default_state
	state.enter()
	pass
	
func _physics_process(delta):
	state.physics_update(delta);
