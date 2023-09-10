extends RigidBody2D

var velocity = Vector2.ZERO  # The player's movement vector.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y += 1
	position += velocity 

func _on_body_entered(body):
	velocity.y -= 100
	position += velocity 
	print("Hello")


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	velocity.y -= 100
	position += velocity 
	print("Hello")
