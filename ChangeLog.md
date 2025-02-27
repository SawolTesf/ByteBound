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

## 2/5/2025 Jachin Minyard
### Movable Crate (modified)
The movable create can now be pushed around without it clipping through the terrain. To modify how it moves you need to change the rigidbody physics properties such as gravity,friction and mass.

### Re-Styled Tile Sets
Simple swap of the forest tiles to the mechanical ship tile sets. I also added a new sprite animation for the level doors. 


## 2/24/2025 Jachin Minyard
### SignalHub
The SignalHub is a autoloads meaning it can be accessed by all other nodes in a scene tree. This allows for a centralized component that handles all custom signals. This helps to massively reduce the amount of coupling between game objects as instead of having to have a reference to any other object one object can simply call the SignalHub to emit a signal that other objects can connect to. Allows one object to emit a signal and have multiple other object react to the signal.

### Globals
Globals is an auto load that should be used as rarely as possible and mostly for type definitions and constants. It was added to store the enums that define what type of buttons and lasers exits.

### Buttons
I added functionality for both button types those being Pedestals and Pressure Plates. Since they are both buttons the both inherit from a class I made called TriggerButton (Button is a built in so I couldn't call it that). The TriggerButton class handles the set up of all buttons this includes 
- Getting the Animated sprite
- Adding any derivatives to the button group
- Setting up the body_entered signal (all buttons should react to the player entering its area)
- Defines a signal_emiter() function to be implemented by sub-classes

#### Pressure Plates
Pressure Plates are a type of temporary TriggerButton that react not just to the player entering its area but also leaving. As such the PressurePlate class Inherits from TriggerButton with the following additional functions
- Adds all pressure plates to the PressurePlate group
- Set up the on_body_exited signal
- Defines the signal_emiter() to emit pressure plate related signals based on the plate color
TODO: allow other object to trigger it.

#### Pedestals
Pedestals are a permanent type of TriggerButton, meaning once activated the object it activates stays in a deactivated state. Since Pedestals don't respond to the player leaving the area the only thing this class adds is the implementation of the signal_emiter() to emit pedestal signals based on the color 

### Hazards
Hazards are different objects that has consequences when a player interacts with them such as resetting the level. 

#### Lasers
Laser are a simple type of hazards that are tied to the button. By activating the right button you can activate or deactivate different lasers. The base Laser class handles the following:
- Setting up the animated sprite.
- Setting up the on_body_entered/exited signals 
  
The sub-classes are for each type of laser and connect to the button color specific signals in the SignalHub.

