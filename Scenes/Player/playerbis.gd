extends RigidBody2D

var thrust = Vector2(0, -1000)
var torque = 20000

func _integrate_forces(state):
	if Input.is_action_pressed("ui_up"):
		state.apply_central_force(thrust)
	else:
		state.apply_force(Vector2())
	var rotation_direction = 0
	if Input.is_action_pressed("ui_right"):
		rotation_direction += 1
		state.apply_central_force(thrust.rotated(rotation_direction * PI / 2))  # This is done here to prevent it from being always active.
	if Input.is_action_pressed("ui_left"):
		rotation_direction -= 1
		state.apply_central_force(thrust.rotated(rotation_direction * PI / 2))
	# state.apply_torque(rotation_direction * torque)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
