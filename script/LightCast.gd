extends Light2D

func turn_on():
	enabled = true
	for ray in get_children():
		ray.enabled = true

func turn_off():
	enabled = false
	for ray in get_children():
		ray.enabled = false

func _ready():
	pass

func _process(delta):
	var hit = false
	for ray in get_children():
		if ray.is_colliding():
			print("Hit " + ray.get_collider().name)
			hit = true
			

	if not hit:
		print("hit nothing")
