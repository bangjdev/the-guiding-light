extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var light_collector = get_node("LightCollector")
onready var finish_sprite   = get_node("Sprite")

# Called when the node enters the scene tree for the first time.
func _ready():
	finish_sprite.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if light_collector.has_power:
		finish_sprite.visible = true
