extends RigidBody2D

signal on_moving_platform	# Connected via code in main (in new_game()).
# signal start_pressed

var thrust = Vector2(0, -15000)
var lateral_thrust = Vector2(0, -400)
var jump1 = false	# Whether the Player is on the floor (platforms and moving ones only).

# These are used to handle the bouncing on the walls and roof. // This is extremelly ugly.
var against_wall_left = false
var against_wall_right = false
var against_roof = false

var on_moving_platform_count = 0
var in_main = false
var sound_enabled = false	# Whether or not the sound has been enabled.


func _integrate_forces(state):
	if jump1:
		state.apply_central_force(thrust)
		if sound_enabled:
			$BoingSound.play()	# The sound is played 3 times or so, 
								# but it is ok because it is instant.
								# It would be ugly with polyphony.
	# Make it so the Player bounces off of the walls and roof.
	if against_roof:
		state.apply_central_force(thrust.rotated(PI) / 4)
		if sound_enabled:
			$BoingSound.play()	# The sound is played 3 times or so, 
								# but it is ok because it is instant.
								# It would be ugly with polyphony.
	if against_wall_left:
		state.apply_central_force(thrust.rotated(PI / 2) / 4)
		if sound_enabled:
			$BoingSound.play()	# The sound is played 3 times or so, 
								# but it is ok because it is instant.
								# It would be ugly with polyphony.
	if against_wall_right:
		state.apply_central_force(thrust.rotated(-PI / 2) / 4)
		if sound_enabled:
			$BoingSound.play()	# The sound is played 3 times or so, 
								# but it is ok because it is instant.
								# It would be ugly with polyphony.
	var rotation_direction = 0
	if Input.is_action_pressed("ui_right"):
		rotation_direction += 1
		state.apply_central_force(lateral_thrust.rotated(rotation_direction * PI / 2))  
		# This is done here to prevent it from being always active.
	if Input.is_action_pressed("ui_left"):
		rotation_direction -= 1
		state.apply_central_force(lateral_thrust.rotated(rotation_direction * PI / 2))


# Called when the node enters the scene tree for the first time.
func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(10000)  # Au pif value, to be changed!!!
	# This is extremely ugly.
	in_main = get_parent().name == "Main"



func _on_body_entered(body):
	
	if body.is_in_group("platforms") and in_main:	# Ugly.
		jump1 = true	# Means a thrust is applied to the player.
	if body.is_in_group("moving_platforms"):
		jump1 = true	# Means a thrust is applied to the player.
		
		# Sends a signal when the player starts jumping on moving platforms for the firest time
		# Allows the ground to disappear.
		on_moving_platform_count += 1
		if on_moving_platform_count == 1:	# This is to prevent a crash in main 
											# (queue free on a null value).
			on_moving_platform.emit()	# // I think this is irrelevant now.
	
	# Allows for the detection of collision with walls and roof (for the bouncing).
	if body.is_in_group("roof"):
		against_roof = true
	if body.is_in_group("wall_right"):
		against_wall_right = true
	if body.is_in_group("wall_left"):
		against_wall_left = true
	

# Another way to do this could be to use something like is_on_ground().
# Apparently you can't with a RigidBody2D.


# Used so that the jump stops after exiting the contact with a surface.
func _on_body_exited(_body):
	jump1 = false
	against_roof = false
	against_wall_left = false
	against_wall_right = false


# Used to make the player spawn on the correct location.
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false	# Not sure if these do anything.


# Used to destroy (queue free) the player when it exits the screen.
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
