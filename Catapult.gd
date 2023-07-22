extends VehicleBody3D

@export var overshoot_rot := 0.0
@export var min_rot := -30.0
@export var max_rot := -85.0

var _tension:float = 0.0

@onready var arm := $Arm

func _ready():
	_tension = 0.0
	arm.rotation_degrees.x = min_rot
	
func add_tension():
	print("adding tension ", _tension)
	_tension = min(_tension + 0.1,1.0)
	arm.rotation_degrees.x = _tension*max_rot+(1-_tension)*min_rot
	apply_force(transform.basis*Vector3(0,-100,0), Vector3(0,0,-1.0))

func release_tension():
	print("releasing tension")
	arm.rotation_degrees.x = min_rot
	apply_force(transform.basis*_tension*Vector3(0,-400,600))
	_tension = 0.0

func _unhandled_input(event):
	if event.is_action_pressed("ui_up"):
		add_tension()
	if event.is_action_pressed("ui_down"):
		release_tension()
