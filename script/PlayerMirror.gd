extends KinematicBody2D

export (int) var rotation_speed = 2
var rotation_direction = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func i_am_reflective() -> bool:
	return true


# Allow other scripts to update the rotation direction
func set_rotation_direction(rotation_dir):
	rotation_direction = rotation_dir


# Function to process motion
func _physics_process(delta):
	
	#rotation += rotation_direction * rotation_speed * delta
	rotate(rotation_direction * rotation_speed * delta)
