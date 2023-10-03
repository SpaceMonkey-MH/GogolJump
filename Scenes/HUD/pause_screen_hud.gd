extends CanvasLayer

signal game_ended	# Signal used when the EndButton is pressed.


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#func _on_pause_button_pressed():
#	print("hello")
#	# This method changing scene does not seem to work since changing scenes appears to be reloading it.
#	get_tree().paused = false
#	hide()
##	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")


func _on_end_button_pressed():
	# This method does not save the score (I think).
#	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")

	game_ended.emit()
	get_tree().paused = false
