extends CanvasLayer

# Notifies `Main` node that the StartButton has been pressed.
signal start_game

var score_hud	# Needed to get the score in this script.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout
	
	$Message.text = "Gogol Jump"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	print("show_game_over")
	update_highscore(score_hud)


func update_score(score):
	score_hud = score
	$ScoreLabel.text = "Score: " + str(score)
	
	
# WARNING: NOT HANDLING THE CASE WHERE THE FILE IS EMPTY. // I think it does now.
func update_highscore(score):
	var highscore_string = load_from_file()
	var highscore
	if highscore_string == "":
		highscore = 0
	else:
		highscore = int(highscore_string)
	print(highscore, " ", score)
	highscore_string = str(max(highscore, score))
	save_to_file(highscore_string)
	$HighScoreLabel.text = "Highscore: " + highscore_string
	

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout():
	$Message.hide()


# Function that saves content to a fixed file.
func save_to_file(content):
	var file = FileAccess.open("user://highscore.dat", FileAccess.WRITE)
	file.store_string(content)

# Function that returns the content loaded from a fixed file.
func load_from_file():
	var content = ""
	var file = FileAccess.open("user://highscore.dat", FileAccess.READ)
	var file_exists = FileAccess.file_exists("user://highscore.dat")
	if file_exists:
		content = file.get_as_text()
	print("c: ", content)
	return content
