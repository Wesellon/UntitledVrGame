extends ARVRController

signal activated
signal deactivated

export var hide_for_no_tracking_confidence = false
export var MOVEMENT_SPEED = 5

var A_button_down
const CONTROLLER_MOVEMENT_DEADZONE = 0.2
const CONTROLLER_TURNING_DEADZONE = 0.4
var directional_movement = false

onready var _controller = get_parent()
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
	#connect("button_release", self, "button_released")
	
	print("READY")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var should_be_visible = true
	if get_is_active():
		if hide_for_no_tracking_confidence:
			# Get the tracking confidence
			var configuration = get_node("../Configuration")
			if configuration:
				var tracking_confidence = configuration.get_tracking_confidence(controller_id)
				if tracking_confidence == 0:
					should_be_visible = false
	else:
		should_be_visible = false

	if visible != should_be_visible:
		visible = should_be_visible
		if should_be_visible:
			print("Activated " + name)
			emit_signal("activated")
		else:
			print("Deactivated " + name)
			emit_signal("deactivated")
	
	handle_joyStickInput()
	customDelta=delta

	


	
func handle_joyStickInput():
	var joystick_vector = Vector2(-get_joystick_axis(0), get_joystick_axis(1))
	if (abs(joystick_vector.x)>CONTROLLER_MOVEMENT_DEADZONE || abs(joystick_vector.y)>CONTROLLER_MOVEMENT_DEADZONE) && controller_id==ControllerIDs.left_Hand:
		print(str(controller_id,joystick_vector))
		_controller.translate(Vector3(-joystick_vector.x*MOVEMENT_SPEED*customDelta,0,-joystick_vector.y*MOVEMENT_SPEED*customDelta))
	
	if(abs(joystick_vector.x)>CONTROLLER_TURNING_DEADZONE || abs(joystick_vector.y)>CONTROLLER_TURNING_DEADZONE) && controller_id==ControllerIDs.right_Hand:
		print(str(controller_id,joystick_vector))
		_controller.rotate_y(joystick_vector.x/10)
		

func button_pressed(button_index):
	if(controller_id==1):
		# LEFT HAND
		print(str("LEFT HAND: ",button_index))
		
	
	else:
		# RIGHT HAND
		print(str("RIGHT HAND: ",button_index))


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_W:
			_controller.translate(Vector3(0,0,-MOVEMENT_SPEED*customDelta))
		if event.pressed and event.scancode == KEY_S:
			_controller.translate(Vector3(0,0,MOVEMENT_SPEED*customDelta))
			
			
