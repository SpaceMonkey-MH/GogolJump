extends CanvasLayer

signal game_ended	# Signal used when the EndButton is pressed.


func _on_end_button_pressed():	
	# This does show a game over, which is fine.
	game_ended.emit()
	get_tree().paused = false
