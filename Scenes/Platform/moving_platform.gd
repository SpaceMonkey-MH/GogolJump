extends Node2D

signal scored

var offset = Vector2(0, 771)	# Screen size + starter offset + 20 more
var duration = 15.0


# Called when the node enters the scene tree for the first time.
func _ready():
	start_tween()
	var platform_types = get_sprite_types()
	$AnimatableBody2D/AnimatedSprite2D.play(platform_types[randi() % platform_types.size()])



func start_tween():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property($AnimatableBody2D, "position", offset, duration)


# Function used to withdraw the end animation from the regular ones.
func get_sprite_types():
	var types = $AnimatableBody2D/AnimatedSprite2D.sprite_frames.get_animation_names()
	var types2 = []
	for type in types:
		if type != "explosion":
			types2.append(type)
	return types2



func _on_visible_on_screen_notifier_2d_screen_exited():	# This works
	scored.emit()
	# WARNING: this has an ugly result because the explosion animation isn't properly cut out!
	$AnimatableBody2D/AnimatedSprite2D.play("explosion")
	await get_tree().create_timer(1.0).timeout
	queue_free()
