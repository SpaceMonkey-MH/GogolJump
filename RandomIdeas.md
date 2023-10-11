- Flip animation left and right. // Obsolete.

- Boost upwards when player touches a platform (tp for starters (not)). // Done.

- For the character sprite to go through the platforms from below, we could check 
	the relative vertical position of the two, and toggle the tangibility of the platform. // Obsolete

- Instead of having the character portal through the other side when touching an edge, 
	we could have a wall blocking the way on both sides. // Done.

- Animation when a platform exits the screen. There should be a way to show this is how the points are obtained.
	This could be a mere spark on the spot the platform disappears from. This seems a bit complicated.
	This could be done with the animation part: Change the animation to a spark sprite. // Done but ugly.

- The whole "press space to start jumping" stuff could be deleted as it serves no real purpose. // Done.

- Make the character into a circle so that it is easier to control (on bounces). // Maybe.

- For the bouncing on walls and roof, check collisions of Player and then check if it is wall left, right or roof
	and give the player a push in the corresponding direction. // Done.


- It could be done that the background sprites disappear at game over,
	so that they don't remain after the end of the game, possibly until the next one starts.
