extends CanvasLayer

signal close_instructions

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	# Trying to have the font size scale with window size. 
#	$Instructions.add_theme_font_size_override("font_size", 16)	# Normal font size!
	var font_size = int((float(abs(get_window().size.y)) / 720) * 16)
#	print(font_size)
	$Instructions.add_theme_font_size_override("font_size", font_size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	if Input.is_action_just_pressed("ui_cancel"):	# Testing.
#		print("oui")




func _on_close_instructions_button_pressed():
	hide()
	close_instructions.emit()
