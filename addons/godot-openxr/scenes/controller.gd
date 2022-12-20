extends ARVRController

signal activated
signal deactivated

export var hide_for_no_tracking_confidence = false

var A_button_down
var CONTROLLER_DEADZONE = 0.1
var MOVEMENT_SPEED=1
var directional_movement = false

const ControllerIDs = {
		# Controller
		const left_Hand=1,
		const right_Hand=2,

		# Buttons
		const button_AX=7,
		const button_BY=1,
		const button_AX_touch=5,
		const button_BY_touch=6,
	
		# Control Stick
		const controlStick_touch=12,
		const controlStick_click=14,
		const controlStick_X_Axis=0,
		const controlStick_Y_Axis=1,
	
		#Triggers
		const analog_button_Trigger=15,
		const analog_button_Back=2,
}

func _ready():
	connect("button_pressed", self, "button_pressed")
	connect("button_release", self, "button_released")
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
	
func handle_joyStickInput():
	var joystick_vector = Vector2(-get_joystick_axis(0), get_joystick_axis(1))
	if abs(joystick_vector.x)>CONTROLLER_DEADZONE || abs(joystick_vector.y)>CONTROLLER_DEADZONE:
		print(str(controller_id,joystick_vector))

func button_pressed(button_index):
	if(controller_id==1):
		# LEFT HAND
		print(str("LEFT HAND: ",button_index))
		
	
	else:
		# RIGHT HAND
		print(str("RIGHT HAND: ",button_index))
