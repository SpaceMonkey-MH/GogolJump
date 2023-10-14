extends CanvasLayer

signal close_instructions

var instructions
var pane_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	# Trying to have the font size scale with window size. This doesn't work very well...
#	$Instructions.add_theme_font_size_override("font_size", 16)	# Normal font size!
	var font_size = int((float(abs(get_window().size.y)) / 720) * 16)
	instructions = $Instructions.get_children()
	for instruction in instructions:
		instruction.add_theme_font_size_override("font_size", font_size)	# Maybe useless.
		instruction.hide()
	
	$PreviousButton.disabled = true
	instructions[pane_count].show()
	


func _on_close_instructions_button_pressed():
	hide()
	close_instructions.emit()


func _on_next_button_pressed():
	instructions[pane_count].hide()
	pane_count += 1
	$PreviousButton.disabled = false
	if pane_count >= instructions.size() - 1:
		$NextButton.disabled = true
	instructions[pane_count].show()


func _on_previous_button_pressed():
	instructions[pane_count].hide()
	pane_count -= 1
	$NextButton.disabled = false
	if pane_count <= 0 :
		$PreviousButton.disabled = true
	instructions[pane_count].show()
