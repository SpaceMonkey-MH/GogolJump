extends CanvasLayer

signal closed	# Signal for when the CloseButton has been pressed.
var fast_start = false	# Whether or not there are platforms close to the ground at the start.
var dark_mode = false	# Whether or not the moving background is dark.
var play_intro = false	# Whether or not the intro is played.
const SETTINGS_FILE_PATH = "user://config.cfg"

# Called when the node enters the scene tree for the first time.
func _ready():
	read_config()
	if not fast_start:	# This is so there is a default value to the variables.
		fast_start = false
	$FastStartCheckBox.button_pressed = fast_start
	if not dark_mode:	# This is so there is a default value to the variables.
		dark_mode = false
	$DarkModeCheckBox.button_pressed = dark_mode
#	print(play_intro)
	if not play_intro:	# This is so there is a default value to the variables.
		play_intro = false
	$PlayIntroCheckBox.button_pressed = play_intro
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# This setup is temporary as this doesn't scale well with the number of options. Meh it's fine.
func save_config():
	var new_config = ConfigFile.new()
	new_config.set_value("OPTIONS_MENU_SECTION", "FAST_START_VALUE", fast_start)
	new_config.set_value("OPTIONS_MENU_SECTION", "DARK_MODE_VALUE", dark_mode)
	new_config.set_value("OPTIONS_MENU_SECTION", "PLAY_INTRO_VALUE", play_intro)
	new_config.save(SETTINGS_FILE_PATH)


# This setup is temporary as this doesn't scale well with the number of options. Meh it's fine.
func read_config():
	var new_config = ConfigFile.new()
	var err = new_config.load(SETTINGS_FILE_PATH) 
	if err != OK: 
		print("opening config file failed " +str(err))
		return 
	else:
		fast_start = new_config.get_value("OPTIONS_MENU_SECTION", "FAST_START_VALUE")
		dark_mode = new_config.get_value("OPTIONS_MENU_SECTION", "DARK_MODE_VALUE")
		play_intro = new_config.get_value("OPTIONS_MENU_SECTION", "PLAY_INTRO_VALUE")
		return

func _on_close_button_pressed():
	closed.emit()
	save_config()


func _on_fast_start_check_box_toggled(button_pressed):
	fast_start = button_pressed
#	save_config()	# Maybe this should go in _on_close_button_pressed(), idk. Yes.



func _on_dark_mode_check_box_toggled(button_pressed):
	dark_mode = button_pressed
#	save_config()	# Maybe this should go in _on_close_button_pressed(), idk. Yes.



func _on_play_intro_check_box_toggled(button_pressed):
	play_intro = button_pressed
#	pass
