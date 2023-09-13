extends Node


@export var platform_scene: PackedScene
var score
var platform_duration = 15.0


# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_down"):	# This is just a test.
		get_tree().reload_current_scene()


func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$Player.show()


func game_over():
	$Player.hide()




func _on_platform_timer_timeout():
	print("platform_timer_timeout")
	# Create a new instance of the Platform scene.
	var platform = platform_scene.instantiate()
	platform.duration = platform_duration
	print(platform.duration)
	
	# Choose a random location on Path2D.
	var platform_spawn_location = get_node("PlatformSpawnPath/PlatformSpawnLocation")
	platform_spawn_location.progress_ratio = randi()
	
	# Set the platform's direction perpendicular to the path direction.
	var direction = platform_spawn_location.rotation + PI / 2
	
	# Set the platform's position to a random location.
	print(platform_spawn_location.position)
	platform.position = platform_spawn_location.position	# I don't understand why this doesn't spawn 
	# on the correct location. It does now, and I know why (the platform wasn't centered in the platform scene).
	
	# Add some randomness the direction.
	# direction += randf_range(-PI / 4, PI / 4)
	# platform.rotation = direction
	
	# Choose the velocity for the platform.
	# var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	# platform.linear_velocity = velocity.rotated(direction)
	
	# Spawn the platform by adding it to the Main scene.
	print(platform.position)
	add_child(platform)




func _on_death_zone_body_entered(body):	# Triggered when the player enters the dead zone aka exits the screen (bottom)
	if body.is_in_group("player"):
		print("dead")
		# $Player.hide()
		game_over()


func _on_player_on_moving_platform():
	$Ground.queue_free()


func _on_meta_game_timer_timeout():	# Reduces the delai between two platforms and accelerates the platforms animations on a fixed timer.
	$PlatformTimer.wait_time -= 0.25
	platform_duration -= 1
	print(platform_duration, " ", $PlatformTimer.wait_time)
