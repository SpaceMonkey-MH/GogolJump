extends Node


@export var platform_scene: PackedScene
# @export var ground_scene: PackedScene
@export var player_scene: PackedScene
@export var background_scene: PackedScene
var score = 0
var score_started = false
var platform_duration = 15.0
var platform_positions	# Can't initialize it now because the nodes aren't ready.
var background_duration = 10	# Time for a background sprite to reach the bottom; reverse of speed.
var background_height = 93	# Height of a background sprite.
var background_offset = Vector2(0, 720 + 100)	# Height of the screen + 100.
# Rate for the appearance of the background sprites. t = h * T / H.
var background_rate = background_height * background_duration / background_offset.y
var score_goal = 2	# Score to reach to start the moving background.
var score_reached = false	# Whether the score need to start the moving background has been reached.


# Called when the node enters the scene tree for the first time.
func _ready():
	$Ground.hide()
	$PauseScreenHUD.hide()
	$OptionsMenuHUD.hide()
	$HUD.update_highscore(score)
	get_window().title = "Gogol Jump"
	platform_positions = $PlatformPositions.get_children()
#	platform_positions = [$PlatformPositions/PlatformPos1]
#	print(platform_positions)
	# new_game()
	print(background_rate)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if score >= score_goal and not score_reached:
		$BackgroundTimer.wait_time = background_rate
		$BackgroundTimer.start()
		score_reached = true
#		print("hello")
		
		
#	if Input.is_action_just_pressed("start_jumping"):	# Testing.
#		get_tree().paused = true
#	if Input.is_action_just_pressed("ui_down"):	# Does not work because _process is not called during pause.
#		get_tree().paused = false
#		print("hello")
#	if Input.is_action_just_pressed("ui_down"):	# This is just a test.
#		get_tree().reload_current_scene()
#	if Input.is_action_just_pressed("ui_up"):
#		new_game()


func new_game():
	# Resetting the values for a new game.
	score = 0
	score_reached = false
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
	# player.connect("start_pressed", on_start_pressed)
	add_child(player)
	
	$HUD.update_score(score)
	$HUD.show_message("Don't fall!")
	# $HUD.show_message("Press Space \nto start jumping")
	
	if $OptionsMenuHUD.fast_start:
		for pos in platform_positions:
	#		print(pos)
			place_platform(pos.position)
	



func place_platform(pos):
	var platform = platform_scene.instantiate()
	# Trying to fix the end animation for the starting platforms. It works!!
	var offsetY = platform.offset.y - (pos.y + 31)
	var offset = Vector2(0, offsetY)
#	print(pos)
	# Trying to fix the end animation for the starting platforms
	platform.duration = (offsetY / 720) * platform_duration
#	print(platform.position)
	platform.position = pos
	# Trying to fix the end animation for the starting platforms
	platform.offset = offset
	
	platform.connect("scored", on_scored)
	add_child(platform)
#	print(platform.position.y, " ", platform.offset)


func game_over():
	$HUD.show_game_over()
	$PlatformTimer.stop()
	$MetaGameTimer.stop()
	$BackgroundTimer.stop()
	get_tree().call_group("moving_platforms", "queue_free")
#	print($Player)	# I don't know why it works this way, but it does, so heh.
	$Player.queue_free()	# Without this using the EndButton would duplicate the Player.
	$Ground.hide()
	# $HUD.start_pressed = false
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




func _on_death_zone_body_entered(body):	# Triggered when the player enters the death zone.
	# aka exits the screen (bottom)
	if body.is_in_group("player"):
		# print("dead : ", score)
		game_over()


func on_scored():	# Connected to scored signal in moving_platform.
	if score_started:	# This is to prevent score abusing by not jumping.
		score += 1
		# Changes the color of the score label to GOLD for 0.5 second.
		$HUD/ScoreLabel.set("theme_override_colors/font_color", Color.GOLD)
		$HUD.update_score(score)
		await get_tree().create_timer(0.5).timeout
		$HUD/ScoreLabel.set("theme_override_colors/font_color", Color.BLACK)
	

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


#func on_start_pressed():	# Connected via code.
#	$HUD.start_pressed = true



func _on_hud_instructions():	# Connected to the instructions button.
	$InstructionsHUD.show()


func _on_instructions_hud_close_instructions():	# Connected to the close instructions button.
	$HUD.show()


func _on_hud_paused():
	$PauseScreenHUD.show()
#	pass
#	get_tree().change_scene_to_file("res://Scenes/HUD/pause_screen_hud.tscn")


func _on_hud_unpaused():
	$PauseScreenHUD.hide()


func _on_hud_options():
	$OptionsMenuHUD.show()


func _on_options_menu_hud_closed():
	$OptionsMenuHUD.hide()


func _on_pause_screen_hud_game_ended():
	game_over()
	$PauseScreenHUD.hide()


func animate_background():
	var background = background_scene.instantiate()
	background.position = $BackgroundStartPos.position
	background.duration = background_duration
	background.offset = background_offset
	add_child(background)


func _on_background_timer_timeout():
	animate_background()
#	print("hello")
	
