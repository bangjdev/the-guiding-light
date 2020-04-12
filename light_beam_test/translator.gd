extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var down = false
var speed = 0


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func _physics_process(delta):
    
    if self.global_position.y < 0:
        down = true
    
    if self.global_position.y > 600:
        down = false
        
    if down:
        var translate_vector = Vector2.DOWN * delta * speed
        self.translate(translate_vector)
    else:
        var translate_vector = Vector2.UP * delta * speed
        self.translate(translate_vector)
