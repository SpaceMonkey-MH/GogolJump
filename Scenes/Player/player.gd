extends CharacterBody2D


'''This is not used, it was an alternative to the RigidBody2D but wasn't the tech of choice.'''
#var velocity = Vector2(0, 250)  # The player's movement vector.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	'''var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.normal)'''
	pass

func _integrate_forces(state):
	#apply_central_force(Vector2(0, -1000))
	pass

func _on_body_entered(body):
	velocity.y -= 100
	position += velocity 
	print("Hello")

