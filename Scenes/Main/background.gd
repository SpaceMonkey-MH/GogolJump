extends Node2D


@export var offset = Vector2(0, 0)
@export var duration = 0
@export var dark_mode = false
var number_of_dark = 8	# The number of dark background sprites. An error can cause a crash.
						# I don't think it is worth fixing.

# Called when the node enters the scene tree for the first time.
func _ready():
	start_tween()
	var sprite_types = $AnimatableBody2D/AnimatedSprite2D.sprite_frames.get_animation_names()
#	$AnimatableBody2D/AnimatedSprite2D.play(sprite_types[randi() % sprite_types.size()])
#	$AnimatableBody2D/AnimatedSprite2D.play(sprite_types[3])

	# This is the simplest way I could find. A regex might be better, but naaah.
	if dark_mode:
		$AnimatableBody2D/AnimatedSprite2D.play(sprite_types[randi_range(0, number_of_dark - 1)])
	else:
		$AnimatableBody2D/AnimatedSprite2D.play(sprite_types[
			randi_range(number_of_dark, sprite_types.size() - 1)])
	$PlatformDurationTimer.wait_time = duration
	$PlatformDurationTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print(get_parent().game_ended)
	if get_parent().game_ended:	# This isn't very elegant, but I can't find another solution.
		queue_free()



func start_tween():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	# tween.set_loops().set_parallel(false)
	tween.tween_property($AnimatableBody2D, "position", offset, duration)


func _on_platform_duration_timer_timeout():
	queue_free()
