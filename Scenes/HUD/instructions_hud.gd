extends CanvasLayer

signal close_instructions

var instructions
#var max_panes = 6
var pane_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	# Trying to have the font size scale with window size. This doesn't work very well...
#	$Instructions.add_theme_font_size_override("font_size", 16)	# Normal font size!
	var font_size = int((float(abs(get_window().size.y)) / 720) * 16)
##	print(font_size)
#	$Instructions/Instructions.add_theme_font_size_override("font_size", font_size)
	instructions = $Instructions.get_children()
	for instruction in instructions:
		instruction.add_theme_font_size_override("font_size", font_size)	# Maybe useless.
		instruction.hide()
	
	$PreviousButton.disabled = true
	instructions[pane_count].show()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	if Input.is_action_just_pressed("ui_cancel"):	# Testing.
#		print("oui")


'''Text of the instructions (2023/10/07):
	In this game, 
you control a round character that jumps automatically.

You can use the left and right arrow keys to move 
the character. This might prove trickier than it looks,
because of how the inertia of the character works.

Moving platforms appear at the top of the screen,
and travel top to bottom to disappear at the bottom.

Once you start jumping on platforms, the ground disappears;
beware, for falling means game over!

The goal is to earn score points, which are obtained 
when a platform reaches the bottom of the screeen,
while avoiding falling.

You cannot exit the screen by the top nor the sides,
you bounce on them.

Note: you can press Enter instead of clicking 
on the Start Game Button, as well as P for the Pause!

This is it for the instructions, now good luck and have fun!'''



func _on_close_instructions_button_pressed():
	hide()
	close_instructions.emit()


func _on_next_button_pressed():
	instructions[pane_count].hide()
	pane_count += 1
	$PreviousButton.disabled = false
	if pane_count >= instructions.size() - 1:
		$NextButton.disabled = true
#	print("next :", pane_count)
	instructions[pane_count].show()


func _on_previous_button_pressed():
	instructions[pane_count].hide()
	pane_count -= 1
	$NextButton.disabled = false
	if pane_count <= 0 :
		$PreviousButton.disabled = true
#	print("previous :", pane_count)
	instructions[pane_count].show()
