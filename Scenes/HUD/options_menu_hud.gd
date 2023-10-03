extends CanvasLayer

signal closed	# Signal for when the CLoseButton has been pressed.
@export var fast_start = false	# Whether or not there are platforms close to the ground at the start.


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_close_button_pressed():
	closed.emit()


func _on_fast_start_check_box_toggled(button_pressed):
	fast_start = button_pressed
