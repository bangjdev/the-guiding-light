extends Node2D

export (int) var natural_beam_length = 4000
export (int) var max_number_of_reflections = 30

onready var light_beam_line = get_node("LightBeamLine")
onready var light_ray_cast = get_node("LightRayCast")

var child_light_beam_ref: NodePath
var previous_light_acceptor_ref: NodePath

# keeps track of which beam I am
var beam_number: int = 0 

func _ready():
    add_collision_ignore(self)
    
    
func add_collision_ignore(object_to_ignore):
    
    if beam_number > 0:
        print(object_to_ignore.get_name())
    light_ray_cast.add_exception_rid(object_to_ignore)
    

func disable_light_beam():
    light_ray_cast.enabled = false
    light_beam_line.visible = false
    unreference_light_acceptor_with_notify()
    destroy_child_light_beam()
    
    
func enable_light_beam():
    light_ray_cast.enabled = true
    light_beam_line.visible = true


func is_reflective(obj: Object) -> bool:
    if obj.has_method("i_am_reflective"):
        return obj.i_am_reflective()
    else:
        return false

func is_light_acceptor(obj: Object) -> bool:
    if obj.has_method("notify_light_acceptor_hit"):
        return true
    else:
        return false
        
        
func update_child_light_beam(child_global_position: Vector2, source_direction: Vector2, normal_vector: Vector2):
    
    # Instance ref
    var child_light_beam: Node2D = get_node(child_light_beam_ref)
    
    # set translation
    child_light_beam.global_position = child_global_position
    
    # Compute reflection direction
    source_direction = -(source_direction.normalized())
    var child_light_beam_direction = -source_direction + 2 * normal_vector * (source_direction.dot(normal_vector))
    
    var angle_to_x_axis = child_light_beam_direction.angle()
    
    child_light_beam.global_rotation = angle_to_x_axis


func make_child_light_beam(collision_object_to_ignore):
    
    # Do not exceed the maximum number of reflections!
    if beam_number < max_number_of_reflections:
    
        var light_beam_scene = load("res://LightBeam.tscn")
        var child_light_beam = light_beam_scene.instance()
        
        # Do this first for debugging
        child_light_beam.beam_number = beam_number + 1
        
        # Doing this calls "_ready()"
        self.add_child(child_light_beam)
        
        # Then we can do these things!
        child_light_beam.set_name("LightBeam")
        child_light_beam.add_collision_ignore(collision_object_to_ignore)
        
        # Get reference to the create beam
        child_light_beam_ref = child_light_beam.get_path();
    
    
func destroy_child_light_beam():
    
    # if the LightBeam has a child
    if not child_light_beam_ref.is_empty():
        
        # Dereference object
        var child_light_beam = get_node(child_light_beam_ref)    
    
        # do this just for safety
        if is_instance_valid(child_light_beam):
    
            # Destroy child of light beam
            child_light_beam.destroy_child_light_beam()
            child_light_beam.unreference_light_acceptor_with_notify()
            
            # Remove child from self
            self.remove_child(child_light_beam)
            
            # Destroy object
            child_light_beam.queue_free()
            
            child_light_beam_ref = NodePath("")


func unreference_light_acceptor_with_notify():
    
    if not previous_light_acceptor_ref.is_empty():
        
        var previous_light_acceptor = get_node(previous_light_acceptor_ref)
        
        if is_instance_valid(previous_light_acceptor):
            
            # tell the light acceptor it isn't being hit with light anymore
            previous_light_acceptor.notify_light_acceptor_unhit()
            
            # Unset the reference
            previous_light_acceptor_ref = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):

    # we are trying to solve for the length of the light beam
    var light_beam_length = 0 # assume zero at start

    # Get collision at the end of the beam of light
    light_ray_cast.force_raycast_update()
    
    var collision_object = light_ray_cast.get_collider()

    if collision_object:
        
        # we now know where the light beam ends
        var collision_position = light_ray_cast.get_collision_point()
        var light_path_vector = collision_position - self.global_position
        light_beam_length = light_path_vector.length()
        
        # If it is a mirror, then reflect
        if is_reflective(collision_object):
            
            if child_light_beam_ref.is_empty():
                make_child_light_beam(collision_object)
            
            update_child_light_beam(collision_position, light_path_vector, light_ray_cast.get_collision_normal())
            
        else:
            # destroy child if not mirror
            destroy_child_light_beam()
            
            
            
        # If we hit something like a SolarGenerator or LightCollector
        if is_light_acceptor(collision_object):
            
            # Notify object it was hit
            collision_object.notify_light_acceptor_hit()
            
            # Set reference to light acceptor
            if previous_light_acceptor_ref != collision_object.get_path():
                # if not hitting the SAME light acceptor
                
                # unref the old one
                unreference_light_acceptor_with_notify()
                
                # reference the new one
                previous_light_acceptor_ref = collision_object.get_path()
            
            else:
                # if we weren't hitting a light acceptor
                previous_light_acceptor_ref = collision_object.get_path()
                
            
        else:
            
            # if not a light object, and valid reference
            unreference_light_acceptor_with_notify()
        
        
    else:
        # Propagate to 1000
        light_beam_length = natural_beam_length
        
        # destroy child, if any
        destroy_child_light_beam()
        
        # unreference light acceptor, if any
        unreference_light_acceptor_with_notify()

    # Draw the light beam
    # Right now I just have a line, but we can add whatever we want!
    var local_end_position = Vector2.RIGHT * light_beam_length
    light_beam_line.set_point_position(0, Vector2.ZERO)
    light_beam_line.set_point_position(1, local_end_position)
