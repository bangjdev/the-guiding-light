extends KinematicBody2D

export (int) var run_speed = 400
export (int) var jump_speed = -800
export (int) var gravity = 2400

var velocity = Vector2()
var jumping = false
var need_flip = false

onready var mirror_node = get_node("PlayerMirror")
onready var animated_sprite = get_node("AnimatedSprite")



# FUnction to get Keyboard inputs
func get_keyboard_input():
	
	# Get player input movement
	velocity.x = 0
	var right = Input.is_action_pressed('p1_right')
	var left = Input.is_action_pressed('p1_left')
	var jump = Input.is_action_just_pressed('p1_jump')
	
	var mirror_right = Input.is_action_pressed("p1_mirror_right")
	var mirror_left = Input.is_action_pressed("p1_mirror_left")

	# Check direction
	if left:
		need_flip = true
	
	if right:
		need_flip = false
	
	$AnimatedSprite.flip_h = need_flip
	
	# Quit game
	if Input.is_action_pressed('ui_cancel'):
		get_tree().quit()
	
	# Move and Jump
	if jump and is_on_floor():
		jumping = true
		velocity.y = jump_speed
		animated_sprite.play("jump")
	
	elif right:
		velocity.x += run_speed
		if not jumping:
			animated_sprite.play("run")
	
	elif left:
		velocity.x -= run_speed
		if not jumping:
			animated_sprite.play("run")
		
	elif is_on_floor():
		animated_sprite.play("idle")
	
	# Do mirror motion
	if mirror_right:
		mirror_node.set_rotation_direction(1)
	elif mirror_left:
		mirror_node.set_rotation_direction(-1)
	else:
		mirror_node.set_rotation_direction(0)



# Function to process motion
func _physics_process(delta):
	
	# Get input
	get_keyboard_input()
	
	# Do character motion
	velocity.y += gravity * delta	
	velocity = move_and_slide(velocity, Vector2(0, -1))
	if jumping and is_on_floor():
		jumping = false
	
	
	# Mirror rotation is handled in PlayerMirror's own script


