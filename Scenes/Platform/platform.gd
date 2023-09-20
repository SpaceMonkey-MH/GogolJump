extends AnimatableBody2D


@export var falls = true
@export var disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CollisionShape2D.disabled = disabled	# This is used to make the ground disappear.
	

func start(pos):	# Handles what happens to the ground at the beginning of a game.
	position = pos
	show()


#func _physics_process(delta):
#	if falls:
#		velocity.y = 1
