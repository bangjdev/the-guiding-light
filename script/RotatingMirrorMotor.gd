extends KinematicBody2D



# rotation speed
export (float) var rotation_speed = 0.5 # radians per second
export (float) var starting_angle = 0

# Game object that powers the motor
export (NodePath) var power_source_reference

export (bool) var clockwise_rotation = true;

# Child object to rotate
onready var rotating_mirror = get_node("Mirror")

# Object that provides power
onready var power_source = get_node(power_source_reference)

func _ready():
	rotating_mirror.set_rotation(deg2rad(starting_angle))

# Do kinematics
func _physics_process(delta):
	
	if power_source.is_powered():
		if clockwise_rotation:
			rotating_mirror.rotate(rotation_speed * delta)
		else:
			rotating_mirror.rotate(rotation_speed * delta * -1)
