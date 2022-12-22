extends RayCast

var _controller
export var ray_length = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	_controller = get_parent()
	set_cast_to(Vector3(0,-1* ray_length,0))
