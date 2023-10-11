extends CanvasLayer

# Notifies `Main` scene that the StartButton has been pressed.
signal start_game	# Signal for when the StartButton is pressed.
signal instructions	# Signal for when the InstructionsButton is pressed.
signal paused	# Signal for when the PauseButton is pressed.
signal unpaused	# Signal for when the UnpauseButton (pause again) is pressed.
signal options	# Signal for when the OptionsButton is pressed.

# var start_pressed = false	# Whether the start jumping button has been pressed (space bar).
var score_hud	# Needed to get the score in this script.
const HIGHSCORE_FILE = "user://highscore.dat"

# Called when the node enters the scene tree for the first time.
func _ready():
	$PauseButton.hide()
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Function used to display some text in the Message label.
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()


# Function used to display the game-over message and reset the HUD to the start game state.
func show_game_over():
	$PauseButton.hide()
	show_message("Game Over")
	# Wait until the MessageTimer has counted down. // Wait a fixed timer instead (no).
	# await get_tree().create_timer(2.0).timeout
	await $MessageTimer.timeout
	
	$Message.text = "Gogol Jump"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$InstructionsButton.show()
	$OptionsButton.show()
#	print("show_game_over")
	update_highscore(score_hud)


func update_score(score):
	score_hud = score
	$ScoreLabel.text = "Score: %s" % score
	
	
# WARNING: NOT HANDLING THE CASE WHERE THE FILE IS EMPTY. // I think it does now.
# Function used to keep the highscore up to date, both in the HUD and in the save file.
func update_highscore(score):
	var highscore_string = load_from_file()	# Highscore in the form of a string, the way it is in the file.
	var highscore	# Highscore in the form of an int, used for comparisons.
	if highscore_string == "":	# Testing if the string is empty before changing its type to int.
		highscore = 0	# Default value
	else:
		highscore = highscore_string.to_int()	# Casting to an int.
#	print(highscore, " ", score)

	# Taking the max between the score and the highscore.
	highscore_string = str(max(highscore, score))	
	
	# This could probably be optimized.
	if highscore < score:
		highscore_string = str(score)
		new_highscore_animation()
	else:
		highscore_string = str(highscore)
#	print(highscore_string)
	save_to_file(highscore_string)	# Saving highscore.
	$HighScoreLabel.text = "Highscore: " + highscore_string	# Displaying highscore.
#	print("hello")
	

# Could be more complex.
func new_highscore_animation():
	# Changes the color of the highscore label to GOLD for 0.5 second.
	$HighScoreLabel.set("theme_override_colors/font_color", Color.GOLD)
	await get_tree().create_timer(0.5).timeout
	$HighScoreLabel.set("theme_override_colors/font_color", Color.BLACK)



# Handles what happens when the StartButton is pressed.
func _on_start_button_pressed():
	$StartButton.hide()
	$InstructionsButton.hide()
	$OptionsButton.hide()
	$PauseButton.show()
	start_game.emit()	# Sends a signal to the main scene that the game should start.


func _on_message_timer_timeout():
	$Message.hide()
	
	
	
#	if start_pressed:
#		$Message.hide()
#	else:
#		$MessageTimer.start()	# Warning: this is very messy,
#								# as it creates many useless timers,
#								# might be an issue in the future.
#								# Possible fix: rework completely the message handling,
#								# have separate functions for the "press space" message.
#		# print("timemout")



# Function that saves content to a fixed file.
func save_to_file(content):
	var file = FileAccess.open(HIGHSCORE_FILE, FileAccess.WRITE)
	file.store_string(content)



# Function that returns the content loaded from a fixed file.
func load_from_file():
	var content = ""
	var file_exists = FileAccess.file_exists(HIGHSCORE_FILE)
	if file_exists:
		var file = FileAccess.open(HIGHSCORE_FILE, FileAccess.READ)
		content = file.get_as_text()
	# print("c: ", content)
	return content


func _on_instructions_button_pressed():
	hide()
	instructions.emit()


func _on_pause_button_pressed():
#	get_tree().paused = true
	get_tree().paused = not get_tree().paused
	if get_tree().paused:
		paused.emit()
		$PauseButton.text = "Unpause"
	else:
		unpaused.emit()
		$PauseButton.text = "Pause"
	# print(get_tree().paused)


func _on_options_button_pressed():
	options.emit()
