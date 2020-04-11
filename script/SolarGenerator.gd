extends KinematicBody2D



# Light to turn on if the generator has power
onready var self_light = get_node("CollectionLight")

# Variable that dictates if the generator has power
var has_power = false



# Allow children to see if the generator has power
func is_powered() -> bool:
    return has_power


# Do kinematics
# (Actually, just check if there is any light shining on it
func _physics_process(delta):
    
    if Input.is_action_pressed("debug_key"):
        has_power = true
        self_light.enabled = true
    else:
        has_power = false
        self_light.enabled = false
        
