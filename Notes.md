- The Player is a RigidBody2D, which has pros and cons.
	=> Pros: 
		* Gravity is already there, we just have to apply it. 
		* This makes for an interesting "jump" with funny physics.
	=> Cons: 
		* The Player can't really bounce because it would create a bad interaction with the jumping,
		and RigidBody2D doesn't allow for velocity control.
		* The player can't be moved manually, so it has to be queue freed and re-instatiated to reset the scene.
		
		
- The scaling of the size of the text does not work well, it is kinda shitty. I don't know how to fix this.


- For the instructions, too much text and hard to read because of background. 
	I could be separated into small tutorial parts (in a Carrousel with a background, possibly with videos)

- Corner of buttons
- Different font
- Change background
- Make background dynamically scroll with platforms. 
	Procedural Google searches (generate, add, delete). Try both high and low pixellisation.
- Make platform edges round.
- Change animation of platforms exploding (steal from the Internet)
- Add animation for speed.
- 15th October



- Class inheritance!!!