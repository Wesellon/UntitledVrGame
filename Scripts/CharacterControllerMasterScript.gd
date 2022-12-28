extends CollisionShape

export var CONTROLLER_TURNING_DEADZONE=0.1
export var CONTROLLER_MOVEMENT_DEADZONE=0.1
export var MAX_FALLING_VELOCITY = 20
export var CONTROLLER_HEIGHT = 2
export var GROUNDCAST_LEVEL_HEIGHT = 2.1
export var FALLING_ACCELERATION = 1.1
export var MOVEMENT_SPEED = 5
export var AIRBORN_HORIZONTAL_DECELERATION = 0.1
onready var _groundCast=get_node("CharacterController/GroundCast")
onready var falling_velocity=1
onready var airborn_horizontal_speed=1
onready var _controller_LEFT= get_node("CharacterController/LeftHandController")
onready var _controller_RIGHT= get_node("CharacterController/RightHandController")
onready var _camera= get_node("CharacterController/ARVRCamera")
var customDelta=1

var mouse_sens = 0.3
var camera_anglev=0

const ControllerIDs = {
		# Controller
		left_Hand=1,
		right_Hand=2,

		# Buttons
		button_AX=7,
		button_BY=1,
		button_AX_touch=5,
		button_BY_touch=6,
	
		# Control Stick
		controlStick_touch=12,
		controlStick_click=14,
		controlStick_X_Axis=0,
		controlStick_Y_Axis=1,
	
		#Triggers
		analog_button_Trigger=15,
		analog_button_Back=2,
}

func _ready():
	_controller_LEFT.connect("button_pressed", self, "button_pressed_LEFT")
	_controller_RIGHT.connect("button_pressed", self, "button_pressed_RIGHT")

func _process(delta):
	customDelta=delta
	if(self.get_transform().origin.y<-20):
		self.transform.origin=Vector3(0,7,0)
		print("LOW HEIGHT")


func _physics_process(delta):
	handle_falling_physics(delta)
	handle_joyStickInput(delta)


func handle_falling_physics(delta):
	if self.get_transform().origin.y-_groundCast.get_collision_point().y>GROUNDCAST_LEVEL_HEIGHT||_groundCast.get_collider()==null:
		self.translate(Vector3(0,-falling_velocity*delta,0))
		if falling_velocity<MAX_FALLING_VELOCITY:
			falling_velocity*=FALLING_ACCELERATION
		else:
			falling_velocity=MAX_FALLING_VELOCITY
	else:
		self.global_transform.origin=Vector3(self.get_global_transform().origin.x,_groundCast.get_collision_point().y+CONTROLLER_HEIGHT,self.get_global_transform().origin.z)
		falling_velocity=1

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_W:
			self.translate(Vector3(0,0,-MOVEMENT_SPEED*2*customDelta).rotated(Vector3.UP,_camera.get_rotation().y))
				
		if event.pressed and event.scancode == KEY_S:
			self.translate(Vector3(0,0,MOVEMENT_SPEED*2*customDelta).rotated(Vector3.UP,_camera.get_rotation().y))

		if event.pressed and event.scancode == KEY_A:
			self.translate(Vector3(-MOVEMENT_SPEED*2*customDelta,0,0).rotated(Vector3.UP,_camera.get_rotation().y))
				
		if event.pressed and event.scancode == KEY_D:
			self.translate(Vector3(MOVEMENT_SPEED*2*customDelta,0,0).rotated(Vector3.UP,_camera.get_rotation().y))

func _input(event):         
	if event is InputEventMouseMotion:
		_camera.rotate_y(deg2rad(-event.relative.x*mouse_sens))

func handle_joyStickInput(delta):
	var joystick_LEFT = Vector2(-_controller_LEFT.get_joystick_axis(0), _controller_LEFT.get_joystick_axis(1))
	var joystick_RIGHT = Vector2(-_controller_RIGHT.get_joystick_axis(0), _controller_RIGHT.get_joystick_axis(1))

	# MOVEMENT CONTROLLER - LEFT
	if (abs(joystick_LEFT.x)>CONTROLLER_MOVEMENT_DEADZONE || abs(joystick_LEFT.y)>CONTROLLER_MOVEMENT_DEADZONE):
		#print(str("CONTROLLSTICK LEFT"))
		self.translate(Vector3(-joystick_LEFT.x*MOVEMENT_SPEED*delta,0,-joystick_LEFT.y*MOVEMENT_SPEED*delta).rotated(Vector3.UP,_camera.get_rotation().y))
	
	# TURNING CONTROLLER - RIGHT
	if(abs(joystick_RIGHT.x)>CONTROLLER_TURNING_DEADZONE):
		#print(str("CONTROLLSTICK RIGHT"))
		self.rotate_y(joystick_RIGHT.x/20)

func button_pressed_LEFT(button_index):
	# LEFT HAND
	print(str("LEFT HAND: ",button_index))

func button_pressed_RIGHT(button_index):
	# RIGHT HAND
	print(str("RIGHT HAND: ",button_index))

