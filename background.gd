extends Node2D


@export var offset = Vector2(0, 0)
@export var duration = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	start_tween()
	var sprite_types = $AnimatableBody2D/AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatableBody2D/AnimatedSprite2D.play(sprite_types[randi() % sprite_types.size()])
	$PlatformDurationTimer.wait_time = duration
	$PlatformDurationTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func start_tween():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	# tween.set_loops().set_parallel(false)
	tween.tween_property($AnimatableBody2D, "position", offset, duration)


func _on_platform_duration_timer_timeout():
	queue_free()
