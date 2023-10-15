extends Node


# Needed to instantiate the scenes
@export var platform_scene: PackedScene
@export var player_scene: PackedScene
@export var background_scene: PackedScene
@export var intro_animation: PackedScene



var game_ended = false	# Whether the game has ended or not (game over reached).
var score = 0
var score_started = false	# Whether the player has started jumping on moving platforms.
var platform_duration
@onready var platform_positions = $PlatformPositions.get_children()	# Initializing it now.
# Time for a background sprite to reach the bottom; reverse of speed.
var background_duration = 15	
var background_height = 108	# Height of a background sprite.
var background_offset = Vector2(0, 720 + 120)	# Height of the screen + 120.
# Cooldown for the appearance of the background sprites. t = h * T / H.
# Apparently this doesn't work well, so I added a magic number.
var background_cooldown = background_height * background_duration / background_offset.y - 0.1
var score_goal = 10	# Score to reach to start the moving background.
# Whether the score need to start the moving background has been reached.
var score_reached = false	


# Called when the node enters the scene tree for the first time.
func _ready():
	# Hides things we don't want on the main screen.
	$Ground.hide()
	$PauseScreenHUD.hide()
	$OptionsMenuHUD.hide()
	$HUD.update_highscore(score)	# So that the highscore is shown on the main screen.
	get_window().title = "Gogol Jump"



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if score >= score_goal and not score_reached:
		$BackgroundTimer.wait_time = background_cooldown
		$BackgroundTimer.start()
		score_reached = true
		
		

func new_game():
	# Resetting the values for a new game.
	score = 0
	score_reached = false
	score_started = false
	game_ended = false
	platform_duration = 15.0	# In V1.0 it's 15.0
	$PlatformTimer.wait_time = 2.0	# In V1.0 it's 3.0
	
	
	
	if $OptionsMenuHUD.play_intro:		
		# This seems to work.
		var anim = intro_animation.instantiate()	# Instantiate scene.
		anim.play("Intro1")							# Play Intro1 animation.
		add_child(anim)								# Add instance as a child.
		await get_tree().create_timer(anim.animation_duration).timeout	# Wait 1 second.
		anim.queue_free()							# Destroy scene.
	
	
	
	$Ground.start($GroundPosition.position)	# Set position of Ground.
	$PlatformTimer.start()
	$MetaGameTimer.start()
	$Ground.show()
	$Ground.disabled = false
	var player = player_scene.instantiate()	# Instantiate scene.
	player.start($StartPosition.position)	# Set position.
	# Connect the signal via code (signal in PlayerBis
	player.connect("on_moving_platform", _on_player_on_moving_platform)
	# Transmitting the sound option to the player scene.
	player.sound_enabled = $OptionsMenuHUD.sound_enabled
	add_child(player)
	
	$HUD.update_score(score)
	$HUD.show_message("Don't fall!")
	
	if $OptionsMenuHUD.fast_start:
		for pos in platform_positions:
			place_platform(pos.position)
	



func place_platform(pos):
	var platform = platform_scene.instantiate()
	# Trying to fix the end animation for the starting platforms. It works!!
	# Otherwise the explosion is played out of the screen. This is beacause of how
	# the explosion animation works, as it is an animation of the platform,
	# so it plays at the position of the platform.
	# This fix makes sure the platforms end their course near the edge of the screen.
	var offsetY = platform.offset.y - (pos.y + 31)
	var offset = Vector2(0, offsetY)
	# Trying to fix the end animation for the starting platforms
	platform.duration = (offsetY / 720) * platform_duration
	platform.position = pos
	# Trying to fix the end animation for the starting platforms
	platform.offset = offset
	
	platform.connect("scored", on_scored)
	add_child(platform)


# Called when the player loses (exits the screen) or clicks the end game button.
func game_over():
	# Calls the show_game_over() function of the HUD scene (cf HUD code).
	$HUD.show_game_over()
	# Stops all the timers running.
	$PlatformTimer.stop()
	$MetaGameTimer.stop()
	$BackgroundTimer.stop()
	# Destroy (queue free) all the moving platforms.
	get_tree().call_group("moving_platforms", "queue_free")
	$Player.queue_free()	# Without this using the EndButton would duplicate the Player.
	$Ground.hide()
	if $OptionsMenuHUD.sound_enabled:	# If the sound is enabled,
		$GameOverSound.play()			# Play the game over sound.
										# This sound might be better if done by mouth.
	
	game_ended = true



func _on_platform_timer_timeout():
	# Create a new instance of the Platform scene.
	var platform = platform_scene.instantiate()
	platform.duration = platform_duration
	
	# Choose a random location on Path2D.
	var platform_spawn_location = get_node("PlatformSpawnPath/PlatformSpawnLocation")
	platform_spawn_location.progress_ratio = randi()

	# I don't understand why this doesn't spawn on the correct location.
	# It does now, and I know why (the platform wasn't centered in the platform scene).
	platform.position = platform_spawn_location.position
	

	platform.connect("scored", on_scored)
	add_child(platform)




func _on_death_zone_body_entered(body):	# Triggered when the player enters the death zone.
										# aka exits the screen (bottom)
	if body.is_in_group("player"):
		game_over()


func on_scored():	# Connected to scored signal in moving_platform.
	if $OptionsMenuHUD.sound_enabled:	# If the sound is enabled,
		$PlatformExplosionSound.play()	# plays the sound of an explosion.
	if score_started:	# This is to prevent score abusing by not jumping.
		score += 1
		# Changes the color of the score label to GOLD for 0.5 second.
		$HUD/ScoreLabel.set("theme_override_colors/font_color", Color.GOLD)
		$HUD.update_score(score)
		await get_tree().create_timer(0.5).timeout
		$HUD/ScoreLabel.set("theme_override_colors/font_color", Color.BLACK)
	

func _on_player_on_moving_platform():	# Connected via code.
	score_started = true
	$Ground.hide()
	$Ground.disabled = true	# Works!

func _on_meta_game_timer_timeout():	# Reduces the delai between two platforms and accelerates 
									# the platforms movement animations on a fixed timer.
#	$PlatformTimer.wait_time -= 0.25	# V1.0
	platform_duration -= 1
	# Setting a maximum for the platform speed, 6.0 is possible but very hard.
	platform_duration = max(platform_duration, 7.0)	# V1.1





func _on_hud_instructions():	# Connected to the instructions button.
	$InstructionsHUD.show()


func _on_instructions_hud_close_instructions():	# Connected to the close instructions button.
	$HUD.show()


func _on_hud_paused():
	$PauseScreenHUD.show()

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
	var background = background_scene.instantiate()	# Creates instance of background sprite.
	background.position = $BackgroundStartPos.position	# Sets up position.
	background.duration = background_duration	# Sets up duration (reverse of speed).
	background.offset = background_offset	# Sets up offset (movement vector).
	background.dark_mode = $OptionsMenuHUD.dark_mode	# Sets up dark mode.
	add_child(background)	# Adds instance as a child.


func _on_background_timer_timeout():
	animate_background()
	
