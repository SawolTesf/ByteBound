# ByteBound ChangeLog

## 1/31/2025:
### Added a FoV and LoS check for the enemies:
The current system uses an Area2D and collision box to determine if the player is in range of the Area2D. 
If the player is in the range of the Area2D a ray is cast from the enemy origin to the player. using the scene state.
The scene state is like a snapshot of the game at a given time. If the ray can collide with the player meaning it is not blocked by another object,
The player will be considered seen by the enemy.
#### TODO:
Look into if there is a better way to render the fov_display so that if it hits another object it doesn't clip through it but stops. The idea is to give a more accurate display of what the enemy can actually see.

### Added two more levels:
These levels are very rudimentary and only serve as a PoC for the scene manager (currently called GameNode). 
It also serves to demo some simple gameplay mechanics. such as the LoS on the enemies and the movable objects

### MovableSquare:
This movable square is a Rigidbody2D as such it is effected by the physics engine.
This works by using the physics layer and physics mask to allow the player and the boxes to interact.
Since the player is considered a Kinematic body by default it cant push them so we added a script for more predictable behavior
#### TODO: 
Allow the player to not just push but drag the square as well

### ExitDoor:
The ExitDoor represents the object the player must reach in order to proceed to the next level. This Sprite can be changed to whatever we want in the future
Emits a signal when the players hitbox enters its area. A signal is then processed by the scene manager to load the next scene

### GameNode:
currently attached to the Main scene. This is a simple script that allows for the loading and clearing of different levels and scenes.
This is a rudimentary implementation and can be improved.
