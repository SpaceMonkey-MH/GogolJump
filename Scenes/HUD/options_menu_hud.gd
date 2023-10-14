extends CanvasLayer

signal closed	# Signal for when the CloseButton has been pressed.
var fast_start = false	# Whether or not there are platforms close to the ground at the start.
var dark_mode = false	# Whether or not the moving background is dark.
var play_intro = false	# Whether or not the intro is played.
var sound_enabled = false	# Whether or not sound is played in the game.
const SETTINGS_FILE_PATH = "user://config.cfg"	# Path to where the options are saved.

# Called when the node enters the scene tree for the first time.
func _ready():
	read_config()
	if fast_start == null:	# This is so there is a default value to the variables.
		fast_start = false	# There is sometimes an issue with a null value.
							# In effect, this is useless, because new_config.get_value()
							# is set to default to false
	$FastStartCheckBox.button_pressed = fast_start
	if dark_mode == null:	# This is so there is a default value to the variables.
		dark_mode = false
	$DarkModeCheckBox.button_pressed = dark_mode
#	print(play_intro)
	if play_intro == null:	# This is so there is a default value to the variables.
		play_intro = false
	$PlayIntroCheckBox.button_pressed = play_intro
#	print(play_intro)
#	print(sound_enabled)
	if sound_enabled == null:	# This is so there is a default value to the variables.
		sound_enabled = false
	$ToggleSoundCheckBox.button_pressed = sound_enabled
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# This setup is temporary as this doesn't scale well with the number of options. Meh it's fine.
# This is used to save the options (variables) values to the config file
func save_config():
	var new_config = ConfigFile.new()	# Creating a new config.
	# Setting the values of the variables to the config sections and keys.
	new_config.set_value("OPTIONS_MENU_SECTION", "FAST_START_VALUE", fast_start)
	new_config.set_value("OPTIONS_MENU_SECTION", "DARK_MODE_VALUE", dark_mode)
	new_config.set_value("OPTIONS_MENU_SECTION", "PLAY_INTRO_VALUE", play_intro)
	new_config.set_value("OPTIONS_MENU_SECTION", "SOUND_ENABLED_VALUE", sound_enabled)
	new_config.save(SETTINGS_FILE_PATH)	# Saving the config to the file.


# This setup is temporary as this doesn't scale well with the number of options. Meh it's fine.
# This is used to extract the information from the config file.
func read_config():
	var new_config = ConfigFile.new()	# Creating a new config.
	var err = new_config.load(SETTINGS_FILE_PATH)	# Loading the file to the config.
	# Returning nothing if the loading failed (the file doesn't exist for instance).
	if err != OK: 
		print("opening config file failed " +str(err))
		return 
	else:
		# Reading the config file and extracting the variable values.
		# The "false" at the end is the default value, it prevents a crash,
		# which happened when adding a new otpion to the list,
		# because there is no error thrown in the above code if there is a line missing.
		fast_start = new_config.get_value("OPTIONS_MENU_SECTION", "FAST_START_VALUE", false)
		dark_mode = new_config.get_value("OPTIONS_MENU_SECTION", "DARK_MODE_VALUE", false)
		play_intro = new_config.get_value("OPTIONS_MENU_SECTION", "PLAY_INTRO_VALUE", false)
		sound_enabled = new_config.get_value("OPTIONS_MENU_SECTION", "SOUND_ENABLED_VALUE", false)
#		print(sound_enabled)
		return


# When the options are closed.
func _on_close_button_pressed():
	closed.emit()	# Emit the signal to change hide the options. Maybe this could be done here, idk.
	save_config()	# Saving the options to the config file.


# When the CheckBox is toggled, change the corresponding variable's value.
func _on_fast_start_check_box_toggled(button_pressed):
	fast_start = button_pressed
#	save_config()	# Maybe this should go in _on_close_button_pressed(), idk. Yes.


# When the CheckBox is toggled, change the corresponding variable's value.
func _on_dark_mode_check_box_toggled(button_pressed):
	dark_mode = button_pressed
#	save_config()	# Maybe this should go in _on_close_button_pressed(), idk. Yes.


# When the CheckBox is toggled, change the corresponding variable's value.
func _on_play_intro_check_box_toggled(button_pressed):
	play_intro = button_pressed
#	pass


# When the CheckBox is toggled, change the corresponding variable's value.
func _on_toggle_sound_check_box_toggled(button_pressed):
	sound_enabled = button_pressed
