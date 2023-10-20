extends CanvasLayer


signal closed	# Signal for when the CloseCreditsButton has been pressed.

var credits_labels
var pane_count = 0

const CREDITS_FILE_PATH = "res://Credits.md"


# Called when the node enters the scene tree for the first time.
func _ready():
	# Welp, this is ugly but will have to do huh.
	hide()	# Hide the scene so it doesn't show on main screen.
	var file = FileAccess.open(CREDITS_FILE_PATH, FileAccess.READ)	# Open the credits file.
	var text = file.get_as_text()	# Extract text from file.
	var split_text = text.split("#")	# Split text.
	for split in split_text:	# For each splitted text in the whole text.
		var label = Label.new()	# Create a new label.
		label.text = split	# Give it the splitted text as text.
		label.add_theme_font_size_override("font_size", 10)	# Set size of text.
		label.set("theme_override_colors/font_color", Color.BLACK)	# Set color of text.
		label.hide()	# Hide the text
#		label.clip_text = true
		label.set_position(Vector2(10, 50))	# Set position.
#		label.set_size(Vector2(480, 500))
#		label.set("theme_override_fonts/font", "res://Fonts/Bonus Coffee.otf")
#		label.autowrap_mode = 3	# Autowrap word smart.
		label.horizontal_alignment = 1	# Centered.
		label.vertical_alignment = 1	# Centered.
		$CreditsLabels.add_child(label)	# Add label as a child of the node CreditsLabels.
	credits_labels = $CreditsLabels.get_children()
	credits_labels[pane_count].show()



func _on_next_button_pressed():
	credits_labels[pane_count].hide()
	pane_count += 1
	$PreviousButton.disabled = false
	if pane_count >= credits_labels.size() - 1:
		$NextButton.disabled = true
	credits_labels[pane_count].show()


func _on_previous_button_pressed():
	credits_labels[pane_count].hide()
	pane_count -= 1
	$NextButton.disabled = false
	if pane_count <= 0 :
		$PreviousButton.disabled = true
	credits_labels[pane_count].show()



func _on_close_credits_button_pressed():
	closed.emit()
	hide()
