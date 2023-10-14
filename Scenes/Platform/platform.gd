extends AnimatableBody2D


var falls = true	# Idk what this is used for.
var disabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$CollisionShape2D.disabled = disabled	# This is used to make the ground disappear.
	

func start(pos):	# Handles what happens to the ground at the beginning of a game.
	position = pos
	show()
