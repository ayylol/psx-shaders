extends RigidBody3D

var mouse_input = Vector2()
var update = false

@export var view_sensitivity: float = 10.0
@export var max_speed: float = 8.0
@export var acceleration: float = 200.0
@export var accel_dir_factor: Curve
@export var max_accel_force: float = 150.0
@export var max_accel_dir_factor: Curve

func _ready():
	pass
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float)-> void:
	update = true
	#eyes.rotation_degrees.x -= mouse_input.y * view_sensitivity * delta;
	#eyes.rotation_degrees.x = clamp(eyes.rotation_degrees.x,-80,80)
	#head.rotation_degrees.y -= mouse_input.x * view_sensitivity * delta;
	mouse_input = Vector2.ZERO
	# Movement
	var move_input = Input.get_vector("left","right","backward","forward")
	var dir = Vector3()
	dir += move_input.x*Vector3(1,0,0)#*head.global_transform.basis.x
	dir -= move_input.y*Vector3(0,0,1)#*head.global_transform.basis.z
	var goal_vel = dir*max_speed
	var ground_vel=Vector3(linear_velocity.x,0.0,linear_velocity.z)
	var vel_dot = linear_velocity.normalized().dot(dir)
	var needed_accel = ((goal_vel-ground_vel)*acceleration*delta).limit_length(max_accel_force)*accel_dir_factor.sample((vel_dot+1)/2.0)
	apply_central_force(needed_accel)
	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_input = event.relative
