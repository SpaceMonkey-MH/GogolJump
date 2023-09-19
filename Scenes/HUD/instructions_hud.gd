extends CanvasLayer

signal close_instructions

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_close_instructions_button_pressed():
	hide()
	close_instructions.emit()
