extends KinematicBody2D



# Light to turn on if the generator has power
onready var self_light = get_node("SelfLight")

# Variable that dictates if the generator has power
var has_power = false


func notify_light_acceptor_hit():
    has_power = true
    
func notify_light_acceptor_unhit():
    has_power = false


# Allow children to see if the generator has power
func is_powered() -> bool:
    return has_power


# Do kinematics
# (Actually, just check if there is any light shining on it)
func _physics_process(_delta):
    
    if has_power:
        self_light.enabled = true
    else:
        self_light.enabled = false
