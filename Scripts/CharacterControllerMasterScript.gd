extends CollisionShape

signal isAirborn
signal isGrounded

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
onready var _controller= get_node("CharacterController/LeftHandController")
var customDelta

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
	connect("button_pressed", self, "button_pressed")

func _process(delta):
	customDelta=delta
	if(self.get_transform().origin.y<-20):
		self.translate(Vector3(self.get_transform().origin.x,self.get_transform().origin.y+50,self.get_transform().origin.z))
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
		self.global_transform.origin=Vector3(self.get_global_transform().origin.x,_groundCast.get_collision_point().y+CONTROLLER_HEIGHT,self.get_global_transform().origin.z)
		falling_velocity=1
	print(str("Collision=",self.get_transform().origin.y-_groundCast.get_collision_point().y," Falling Velocity: ",falling_velocity))


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_W:
			self.translate(Vector3(0,0,-MOVEMENT_SPEED*2*customDelta))
				
		if event.pressed and event.scancode == KEY_S:
			self.translate(Vector3(0,0,MOVEMENT_SPEED*2*customDelta))

	
func handle_joyStickInput(delta):
	var joystick_vector = Vector2(-_controller.get_joystick_axis(0), _controller.get_joystick_axis(1))
	if (abs(joystick_vector.x)>CONTROLLER_MOVEMENT_DEADZONE || abs(joystick_vector.y)>CONTROLLER_MOVEMENT_DEADZONE) && _controller.controller_id==ControllerIDs.left_Hand:
		#print(str(controller_id,joystick_vector))
		self.translate(Vector3(-joystick_vector.x*MOVEMENT_SPEED*delta,0,-joystick_vector.y*MOVEMENT_SPEED*delta))
	
	if(abs(joystick_vector.x)>CONTROLLER_TURNING_DEADZONE || abs(joystick_vector.y)>CONTROLLER_TURNING_DEADZONE) && _controller.controller_id==ControllerIDs.right_Hand:
		#print(str(controller_id,joystick_vector))
		self.rotate_y(joystick_vector.x/10)
		

func button_pressed(button_index):
	if(_controller.controller_id==1):
		# LEFT HAND
		print(str("LEFT HAND: ",button_index))
		
	else:
		# RIGHT HAND
		print(str("RIGHT HAND: ",button_index))
