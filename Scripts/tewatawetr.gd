extends CollisionShape

export var MAX_FALLING_VELOCITY = 20
export var CONTROLLER_HEIGHT = 2
export var GROUNDCAST_LEVEL_HEIGHT = 2.1
export var FALLING_ACCELERATION = 1.1
export var MOVEMENT_SPEED = 5
onready var _groundCast=get_node("CharacterController/GroundCast")
onready var falling_velocity
var customDelta

func _ready():
	falling_velocity=1

func _process(delta):
	customDelta=delta
	if(self.get_transform().origin.y<-20):
		self.translate(Vector3(self.get_transform().origin.x,self.get_transform().origin.y+50,self.get_transform().origin.z))
		print("LOW HEIGHT")

func _physics_process(delta):
	handle_falling_physics(delta)



func handle_falling_physics(delta):
	if self.get_transform().origin.y-_groundCast.get_collision_point().y>GROUNDCAST_LEVEL_HEIGHT||_groundCast.get_collider()==null:
		self.translate(Vector3(0,-falling_velocity*delta,0))
		if falling_velocity<MAX_FALLING_VELOCITY:
			falling_velocity*=FALLING_ACCELERATION
	else:
		self.global_transform.origin=Vector3(self.get_global_transform().origin.x,_groundCast.get_collision_point().y+CONTROLLER_HEIGHT,self.get_global_transform().origin.z)
		falling_velocity=1
	print(str("Collision=",self.get_transform().origin.y-_groundCast.get_collision_point().y," Falling Velocity: ",falling_velocity))


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_W:
			self.translate(Vector3(0,0,-MOVEMENT_SPEED*customDelta))
				
		if event.pressed and event.scancode == KEY_S:
			self.translate(Vector3(0,0,MOVEMENT_SPEED*customDelta))
