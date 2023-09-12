extends Node2D


@export var offset = Vector2(0, 820)
@export var duration = 15.0

# Called when the node enters the scene tree for the first time.
func _ready():
	start_tween()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.y == 720:
		queue_free()	# Not working, might be an issue if the platforms overload the engine.
		print("moving_platform_freed")


func start_tween():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	# tween.set_loops().set_parallel(false)
	tween.tween_property($AnimatableBody2D, "position", offset, duration)
