extends KinematicBody2D

export (int) var run_speed = 400
export (int) var jump_speed = -800
export (int) var gravity = 2400

var velocity = Vector2()
var jumping = false

var mouse_speed = 0

# Function to get mouse speed input
func _input(event):
    if event is InputEventMouseMotion:
        mouse_speed = Input.get_last_mouse_speed();
        


# FUnction to get Keyboard inputs
func get_keyboard_input():
    
    # Get player input movement
    velocity.x = 0
    var right = Input.is_action_pressed('p1_right')
    var left = Input.is_action_pressed('p1_left')
    var jump = Input.is_action_just_pressed('p1_jump')
    
    # Quit game
    if Input.is_action_pressed('ui_cancel'):
        get_tree().quit()

    # Move and Jump
    if jump and is_on_floor():
        jumping = true
        velocity.y = jump_speed
    if right:
        velocity.x += run_speed
    if left:
        velocity.x -= run_speed



# Function to process motion
func _physics_process(delta):
    
    # Do character motion
    get_keyboard_input()
    velocity.y += gravity * delta
    if jumping and is_on_floor():
        jumping = false
    velocity = move_and_slide(velocity, Vector2(0, -1))
    
    # Do Mirror motion


