extends KinematicBody2D



# Light to turn on if the generator has power
onready var self_light = get_node("Light")

# Variable that dictates if the generator has power
var has_power = false



# Allow children to see if the generator has power
func is_powered() -> bool:
	return has_power


func _ready():
	pass
	

# Do kinematics
# (Actually, just check if there is any light shining on it
func _physics_process(delta):
	if Input.is_action_just_pressed("debug_key"):
		has_power = not has_power
		if has_power:
			self_light.turn_on()
		else:
			self_light.turn_off()
		
