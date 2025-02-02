# ByteBound ChangeLog

## 1/31/2025: Jachin Minyard
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

### MovableSquare: (new)
This movable square is a Rigidbody2D as such it is effected by the physics engine.
This works by using the physics layer and physics mask to allow the player and the boxes to interact.
Since the player is considered a Kinematic body by default it cant push them so we added a script for more predictable behavior
#### TODO: 
Allow the player to not just push but drag the square as well

### ExitDoor: (new)
The ExitDoor represents the object the player must reach in order to proceed to the next level. This Sprite can be changed to whatever we want in the future
Emits a signal when the players hitbox enters its area. A signal is then processed by the scene manager to load the next scene

### GameNode: (new)
currently attached to the Main scene. This is a simple script that allows for the loading and clearing of different levels and scenes.
This is a rudimentary implementation and can be improved.


## 2/1/2025: Jachin Minyard
### StateMachine (new)
The StateMachine is a powerful abstraction that can be used to manage different behaviors of actors across the game. \
The current implementation was designed to be used with the player. \
However it should be abstracted enough due to the State nodes that it can be applied to a wide range of actors. \
The State machine needs to be given to a CharacterBody2D. In the script of the CharacterBody2D call
```
init(body : CharacterBody2D, sprite: AnimatedSprite2D, input: InputComponent, movement : MoveStats)
```
This will pass the references needed to control the CharacterBody2D to StateMachine which will give those references to the States themselves \
The only job of the StateMachine is to manage the State Nodes that are children of it.

### State (new)
The State class is built to be used in tandem with the StateMachine. DO NOT USE ON ITS OWN.\
To use the State Class you need to create a new script that inherits from the State Class. \
The states you create should be in charge of doing only a single thing. \
for example the idle state should not have any jumping logic all that should be in the jump state
You can override the following functions of State to create your own state: \
Swapping Functions: \
I feel these functions should not need much explanation these are called when the state is entered or exited. \
call super() in these functions to get the base State behavior which for enter is to play the animation given in the inspector
```
func enter() -> void:
func exit() -> void:
```

Processing Functions: \
These functions are similar to the regular node processing functions but are used instead to avoid calling state functions each time \
Process Frame is for non physics based transitions. \
Process Physics is for physics based checks \
Process Input checks for input from the player. \
Not all of these have to be used for each state
```
func process_frame(delta: float) -> State:
func process_physics(delta: float) -> State:
func process_input(event: InputEvent) -> State:
```

Input Functions: \
These functions are used to determine if input is received. \
I got a little confused on how to implement this as the state have a reference to an input component but not all actors will take input directly from the user. \
One solution would be to abstract the InputComponent to work off of things that aren't player inputs.
```
func get_movement_input() -> bool:
func get_jump_input() -> bool:
func get_fastfall_input() -> bool:
func get_dash_input() -> bool:
```

### Player (modified)
I changed the design of the player to fit with the new StateMachine and State Nodes.
Character Structure:
- CharacterBody2D 
  - AnimatedSprite2D
  - CollisionShape2D (Physical Body)
  - InputComponent
  - Area2D (Hitbox)
	- CollisionShape2D
  - StateMachine
	- Move
	- Idle
	- Fall
	- Jump
	- Dash
	- Crouch
These are just the actual nodes. The player also uses a MoveStat Resource that determines all the stats that effect how something moves. 

### MoveStat (modified)
I Changed the MoveStat resource. Originally I had messed with it being a replacement for the MoveComponent which only handled horizontal movement. \
But now the MoveStat is a resource that hold all the info about movement from speed, acceleration, and  deceleration to jump height and dash duration. \
This new MoveStat also has the ability to toggle different kinds of movement such as allowing an actor to multi-jump or dash.\
On top of this it has an option to turn on or off advanced movement. This advanced movement takes into account the acceleration and deceleration when moving. \
