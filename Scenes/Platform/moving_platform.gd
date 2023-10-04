extends Node2D

signal scored

@export var offset = Vector2(0, 771)	# Screen size + starter offset + 20 more
@export var duration = 15.0


# Called when the node enters the scene tree for the first time.
func _ready():
	start_tween()
#	$AnimatableBody2D/AnimatedSprite2D.animation = "platform1"
	var platform_types = get_sprite_types()
	$AnimatableBody2D/AnimatedSprite2D.play(platform_types[randi() % platform_types.size()])
	# print(platform_types)
#	print(position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	if $AnimatableBody2D.position.y >= 720:
#		# queue_free()	# Not working, might be an issue if the platforms overload the engine.
		# A workaround is bellow.
#		# print("moving_platform_freed")
#		print($AnimatableBody2D.position.y)


func start_tween():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	# tween.set_loops().set_parallel(false)
	tween.tween_property($AnimatableBody2D, "position", offset, duration)
#	print("hello")


# Function used to withdraw the end animation from the regular ones.
func get_sprite_types():
	var types = $AnimatableBody2D/AnimatedSprite2D.sprite_frames.get_animation_names()
	var types2 = []
	for type in types:
		if type != "sparks" and type != "explosion" and type != "explosion2":
			types2.append(type)
	return types2



func _on_visible_on_screen_notifier_2d_screen_exited():	# This works
	scored.emit()
	# $AnimatableBody2D/AnimatedSprite2D.animation = "sparks"
#	$AnimatableBody2D/AnimatedSprite2D.play("sparks")
	# WARNING: this has an ugly result because the explosion animation isn't properly cut out!
	$AnimatableBody2D/AnimatedSprite2D.play("explosion2")
	await get_tree().create_timer(1.0).timeout
	queue_free()
	# print("moving_platform_freed")
