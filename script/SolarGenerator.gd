extends StaticBody2D


var has_power = false


# Allow children to see if the generator has power
func is_powered() -> bool:
    return has_power


# Do kinematics
# (Actually, just check if there is any light shining on it
func _physics_process(delta):
    
    if Input.is_action_pressed("debug_key"):
        has_power = true
    else:
        has_power = false
