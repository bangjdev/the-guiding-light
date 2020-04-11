extends StaticBody2D



# Game object that powers the collector
export (NodePath) var power_source_reference

# Object that provides power
onready var power_source = get_node(power_source_reference)

func _physics_process(delta):
	
	if power_source.is_powered():
		#If light collector is powered, change scene to the next level
		get_tree().change_scene("res://Title.tscn")
