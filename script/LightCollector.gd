extends KinematicBody2D


onready var child_light_beam = get_node("LightBeam")
onready var self_light = get_node("SelfLight")

var has_power: bool = false


func _ready():
    child_light_beam.add_collision_ignore(self)
    self_light.enabled = false


func notify_light_acceptor_hit():
    has_power = true
    
func notify_light_acceptor_unhit():
    has_power = false


func _physics_process(_delta):

    if has_power:
        child_light_beam.enable_light_beam()
        self_light.enabled = true
    else:
        child_light_beam.disable_light_beam()
        self_light.enabled = false
