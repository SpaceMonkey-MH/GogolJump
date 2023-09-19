extends Node


@export var platform_scene: PackedScene
# @export var ground_scene: PackedScene
@export var player_scene: PackedScene
var score = 0
var score_started = false
var platform_duration = 15.0


# Called when the node enters the scene tree for the first time.
func _ready():
	$Ground.hide()
	$HUD.update_highscore(score)
	# new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
#	if Input.is_action_just_pressed("ui_down"):	# This is just a test.
#		get_tree().reload_current_scene()
#	if Input.is_action_just_pressed("ui_up"):
#		new_game()


func new_game():
	# Resetting the values for a new game.
	score = 0
	score_started = false
	platform_duration = 15.0
	$PlatformTimer.wait_time = 3.0
	var player = player_scene.instantiate()
	player.start($StartPosition.position)
	$Ground.start($GroundPosition.position)
	player.show()
	$PlatformTimer.start()
	$MetaGameTimer.start()
	$Ground.show()
	$Ground.disabled = false
	player.connect("on_moving_platform", _on_player_on_moving_platform)
	player.connect("start_pressed", on_start_pressed)
	add_child(player)
	
	$HUD.update_score(score)
	$HUD.show_message("Press Space \nto start jumping")


func game_over():
	$HUD.show_game_over()
	$PlatformTimer.stop()
	$MetaGameTimer.stop()
	get_tree().call_group("moving_platforms", "queue_free")
	$HUD.start_pressed = false
	# $Player.hide()
	# get_tree().reload_current_scene()



func _on_platform_timer_timeout():
	# print("platform_timer_timeout")
	# Create a new instance of the Platform scene.
	var platform = platform_scene.instantiate()
	platform.duration = platform_duration
	# print(platform.duration)
	
	# Choose a random location on Path2D.
	var platform_spawn_location = get_node("PlatformSpawnPath/PlatformSpawnLocation")
	platform_spawn_location.progress_ratio = randi()
	
	# Set the platform's direction perpendicular to the path direction.
	var direction = platform_spawn_location.rotation + PI / 2
	
	# Set the platform's position to a random location.
	# print(platform_spawn_location.position)
	platform.position = platform_spawn_location.position	# I don't understand why this doesn't spawn 
	# on the correct location. It does now, and I know why (the platform wasn't centered in the platform scene).
	
	# Add some randomness the direction.
	# direction += randf_range(-PI / 4, PI / 4)
	# platform.rotation = direction
	
	# Choose the velocity for the platform.
	# var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	# platform.linear_velocity = velocity.rotated(direction)
	
	# Spawn the platform by adding it to the Main scene.
	# print(platform.position)
	platform.connect("scored", on_scored)
	add_child(platform)




func _on_death_zone_body_entered(body):	# Triggered when the player enters the death zone 
	# aka exits the screen (bottom)
	if body.is_in_group("player"):
		# print("dead : ", score)
		game_over()


func on_scored():
	if score_started:
		score += 1
		$HUD.update_score(score)
	

func _on_player_on_moving_platform():	# Connected via code.
	# $Ground.queue_free()
	# $Ground.PROCESS_MODE_DISABLED	# Does not work!
	score_started = true
	$Ground.hide()
	$Ground.disabled = true	# Works!

func _on_meta_game_timer_timeout():	# Reduces the delai between two platforms and accelerates 
	# the platforms animations on a fixed timer.
	$PlatformTimer.wait_time -= 0.25
	platform_duration -= 1
	# print(platform_duration, " ", $PlatformTimer.wait_time)


func on_start_pressed():	# Connected via code.
	$HUD.start_pressed = true



func _on_hud_instructions():	# Connected to the instructions button.
	$InstructionsHUD.show()


func _on_instructions_hud_close_instructions():
	$HUD.show()
