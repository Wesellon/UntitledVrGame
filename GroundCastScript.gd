extends RayCast

var _controller
export var ray_length = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	_controller = get_parent()
	set_cast_to(Vector3(0,-1* ray_length,0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if get_collider()!=null:
		print(str("CONTROLLER LOCATION: ",_controller.get_global_transform()))
		print(str("HIT LOCATION: ",get_collision_point().y, "\nHITTER:",get_collider()))
		_controller.global_transform.origin=Vector3(_controller.get_global_transform().origin.x,get_collision_point().y+2,_controller.get_global_transform().origin.z)

	
