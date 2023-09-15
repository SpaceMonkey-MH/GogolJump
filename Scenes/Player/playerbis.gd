extends RigidBody2D

signal on_moving_platform

var thrust = Vector2(0, -15000)
var lateral_thrust = Vector2(0, -400)
# var torque = 20000
var jump1 = false	# Whether the Player is on the floor (platforms and moving ones only).
var jump2 = false	# Whether the key to start jumping has been pressed.
var on_moving_platform_count = 0

@export var start_pressed = false

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
func _process(_delta):
	if Input.is_action_pressed("start_jumping"):
		start_pressed = true
		jump2 = true


func _on_body_entered(body):
	# print("hello")
	if body.is_in_group("platforms"):	
		# print("hi")
		jump1 = true
	if body.is_in_group("moving_platforms"):
		# print("hi2")
		jump1 = true
		on_moving_platform_count += 1
		if on_moving_platform_count == 1:	# This is to prevent a crash in main (queue free on a null value).
			on_moving_platform.emit()
			# print("on_moving_platform for the first time")

# Another way to do this could be to use something like is_on_ground().
# Apparently you can't with a RigidBody2D.

func _on_body_exited(_body):
	# print("goodbye")
	# await get_tree().create_timer(0.3).timeout	# This causes error when the character isn't jumping or maybe is on ground
	jump1 = false


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false	# Not sure if these do anything.


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	# print("player_freed")
