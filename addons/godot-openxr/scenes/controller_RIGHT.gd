extends ARVRController

signal activated
signal deactivated

export var hide_for_no_tracking_confidence = false

var A_button_down
var CONTROLLER_DEADZONE = 0.1
var MOVEMENT_SPEED=1
var directional_movement = false

const ControllerIDsRIGHT = {
	# Buttons
	button_A=7,
	button_B=1,
	button_A_touch=5,
	button_B_touch=6,

	# Control Stick
	R_controlStick_touch=12,
	R_controlStick_click=14,
	R_controlStick_X=0,
	R_controlStick_Y=1,

	#Triggers
	R_analog_button_Trigger=15,
	R_analog_button_Back=2,
}

func _ready():
	connect("button_pressed", self, "button_pressed")
	connect("button_release", self, "button_released")
	print("READY RIGHT")

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
		
	var joystick_vector = Vector2(-get_joystick_axis(0), get_joystick_axis(1))
	if joystick_vector!=Vector2(-0,0):
		print(str("Right: ",joystick_vector))



func button_pressed(button_index):
	print(button_index)
	if button_index == 15:
		_on_button_pressed_A()
			
	if button_index == 2:
		_on_button_pressed_B()

func _on_button_pressed_A():
	print("ASDASD")

func _on_button_pressed_B():
	print("BSDBSD")


	

