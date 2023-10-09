extends CanvasLayer

signal closed	# Signal for when the CloseButton has been pressed.
@export var fast_start = false	# Whether or not there are platforms close to the ground at the start.
const SETTINGS_FILE_PATH = "res://config.cfg"

# Called when the node enters the scene tree for the first time.
func _ready():
	read_config()
	$FastStartCheckBox.button_pressed = fast_start


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# This setup is temporary as this doesn't scale well with the number of options.
func save_config(value):
	var new_config = ConfigFile.new()
	new_config.set_value("OPTIONS_MENU_SECTION", "FAST_START_VALUE", value)
	new_config.save(SETTINGS_FILE_PATH)


# This setup is temporary as this doesn't scale well with the number of options.
func read_config():
	var new_config = ConfigFile.new()
	var err = new_config.load(SETTINGS_FILE_PATH) 
	if err != OK: 
		print("opening config file failed " +str(err))
		return 
	else:
		fast_start = new_config.get_value("OPTIONS_MENU_SECTION", "FAST_START_VALUE")
		return

func _on_close_button_pressed():
	closed.emit()


func _on_fast_start_check_box_toggled(button_pressed):
	fast_start = button_pressed
	save_config(fast_start)
