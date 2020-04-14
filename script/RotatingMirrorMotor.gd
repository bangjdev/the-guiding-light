extends KinematicBody2D



# rotation speed
export (int) var rotation_speed = 2 # radians per second

# Game object that powers the motor
export (NodePath) var power_source_reference

# Child object to rotate
onready var rotating_mirror = get_node("Mirror")

# Object that provides power
onready var power_source = get_node(power_source_reference)


# Do kinematics
func _physics_process(delta):
	
	if power_source.is_powered():
		rotating_mirror.rotate(rotation_speed * delta)
