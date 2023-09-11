extends RigidBody2D

var thrust = Vector2(0, -2000)
var lateral_thrust = Vector2(0, -400)
var torque = 20000
var jump1 = false
var jump2 = false

func _integrate_forces(state):
	# if Input.is_action_pressed("ui_up"):
	if jump1 and jump2:
		state.apply_central_force(thrust)
	else:
		state.apply_force(Vector2())
	var rotation_direction = 0
	if Input.is_action_pressed("ui_right"):
		rotation_direction += 1
		state.apply_central_force(lateral_thrust.rotated(rotation_direction * PI / 2))  # This is done here to prevent it from being always active.
	if Input.is_action_pressed("ui_left"):
		rotation_direction -= 1
		state.apply_central_force(lateral_thrust.rotated(rotation_direction * PI / 2))
	# state.apply_torque(rotation_direction * torque)


# Called when the node enters the scene tree for the first time.
func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(1000)  # Au pif value, to be changed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("start"):
		jump2 = true


func _on_body_entered(body):
	print("hello")
	jump1 = true
	


func _on_body_exited(body):
	print("goodbye")
	await get_tree().create_timer(0.3).timeout
	jump1 = false
